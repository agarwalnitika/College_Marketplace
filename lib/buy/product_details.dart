import 'package:flutter/material.dart';
import 'package:marketplace/models/product.dart';

class Product_Details extends StatefulWidget {
  Product_Details({Key key, @required this.product}) : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Product Name'),
      ),
        body:ListView(
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

          ],
        ),
    );
  }
}

/*
  ListTile(
              title: Center(child: Text(widget.product.name, style: TextStyle(fontSize: 50),)),
            ),
*/