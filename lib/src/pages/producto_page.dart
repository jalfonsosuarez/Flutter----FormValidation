
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:formvalidation/src/util/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productoProvider = new ProductosProvider();
  
  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {

    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;

    if ( prodData != null ) {
      producto = prodData;
    }
    
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.photo_size_select_actual ),
            onPressed: () {_procesarImagen( ImageSource.gallery );},
          ),
          IconButton(
            icon: Icon( Icons.camera_alt ),
            onPressed: () {_procesarImagen( ImageSource.camera ); } ,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre( context ),
                _creaPrecio( context ),
                _crearDisponible( context ),
                _crearBoton( context )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre( BuildContext context ) {

    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: ( value ) => producto.titulo = value,
      validator: ( value ) {
        if ( value.length < 3 ) {
          return 'Introduzca nombre producto';
        } else {
          return null;
        }
      },
    );

  }

  Widget _creaPrecio( BuildContext context ) {

    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions( decimal: true ) ,
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: ( value ) => producto.valor = double.parse( value ),
      validator: ( value ) {
        if ( utils.isNumeric( value ) ) {
          return null;
        } else {
          return 'Solo números';
        }
      },
    );

  }

  Widget _crearBoton( BuildContext context ) {

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon( Icons.save ),
      onPressed: (_guardando ) ? null : _submit,
    );

  }

  Widget _crearDisponible( BuildContext context ) {

    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: ( value ) => setState((){
        producto.disponible = value;
      }),
    );

  }

  void _submit() async {

    if ( !formKey.currentState.validate() )  return;

    formKey.currentState.save();

    setState(() { _guardando = true; });

    if ( foto != null ){
      producto.fotoUrl = await productoProvider.subirImagen( foto );
    }

    if ( producto.id == null ) {
      productoProvider.crearProducto(producto);
    } else {
      productoProvider.editarProducto(producto);
    }

    // setState(() { _guardando = false; });

    mostrarSnackBar( 'Registro guardado.' );

    Navigator.pop(context);

  }

  void mostrarSnackBar( String mensaje ) {

    final snackBar = SnackBar(
      content: Text( mensaje ),
      duration: Duration( milliseconds: 1500 ),
    );

    scaffoldKey.currentState.showSnackBar(snackBar);

  }

  Widget _mostrarFoto() {

    if ( producto.fotoUrl != null ) {
      // POR HACER: Hacer visor foto
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        width: double.infinity,
        fit: BoxFit.contain
      );
    } else {
      return Image(
        image: AssetImage( foto?.path ?? 'assets/no-image.png' ),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }

  }

  _procesarImagen( ImageSource tipo ) async {

    foto = await ImagePicker.pickImage(
      source: tipo
    );

    if ( foto != null ) {
      producto.fotoUrl = null;
    }

    setState(() {});

  }

}