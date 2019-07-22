
import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:formvalidation/src/providers/productos_provider.dart' as prefix0;
import 'package:formvalidation/src/util/utils.dart' as utils;

class ProductoPage extends StatefulWidget {

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {

  final formKey = GlobalKey<FormState>();
  final productoProvider = new prefix0.ProductosProvider();
  
  ProductoModel producto = new ProductoModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.photo_size_select_actual ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon( Icons.camera_alt ),
            onPressed: () {},
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
      onPressed: _submit,
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

  void _submit() {

    if ( !formKey.currentState.validate() )  return;

    formKey.currentState.save();

    print('Todo ok');
    print( producto. titulo );
    print( producto.valor );
    print( producto.disponible );

    productoProvider.crearProducto(producto);

  }

}