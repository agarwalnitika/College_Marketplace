import 'package:flutter/material.dart';
import 'package:marketplace/models/product.dart';
import 'package:marketplace/services/database.dart';

class Product_Details extends StatefulWidget {
  Product_Details({Key key, this.database, @required this.product})
      : super(key: key);
  final Database database;
  final SingleProduct product;

  static Future<void> show(BuildContext context,
      {SingleProduct product}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Product_Details(
          product: product,
        ),
        fullscreenDialog: false,
      ),
    );
  }

  @override
  _Product_DetailsState createState() => _Product_DetailsState();
}

class _Product_DetailsState extends State<Product_Details> {
  String _name;
  int _price;
  String _description;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _name = widget.product.name;
      _price = widget.product.price;
      _description = widget.product.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Product Name'),
      ),
      body: ListView(
        children: [
          Container(
            height: 200,
            color: Colors.black,
            child: GridTile(
              child: Container(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            child: ListTile(
              title: Center(
                  child: Text(
                _name,
                style: TextStyle(fontSize: 40),
              )),
            ),
          ),
          Divider(),

          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: ListTile(
                  title: Text(
                    '      Price:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ListTile(
                  title: Text(
                    ' $_price',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: ListTile(
                  title: Text(
                    '      Category:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ListTile(
                  title: Text(
                    ' ',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: ListTile(
                  title: Text(
                    '      Description:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ListTile(
                  title: Text(
                    ' $_description',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/*

*/
