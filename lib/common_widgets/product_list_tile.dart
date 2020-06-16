import 'package:flutter/material.dart';
import 'package:marketplace/models/product.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({Key key, @required this.product, this.onTap , this.height , this.width})
      : super(key: key);
  final double height;
  final double width;
  final SingleProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: height,
          width: width,
          child: GestureDetector(
            onTap: onTap,
              child: my_card ('assets/display1.jpg', product.name)),
        ),
      ],
    );
  }
}


Widget my_card (String my_img, String my_txt) {
  return Container(
    margin: EdgeInsets.only( top: 9.0),
    constraints: new BoxConstraints.expand(
      height: 150.0,
      width: 80,
    ),
    alignment: Alignment.center,
    decoration: new BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.8),
          spreadRadius: 1,
          blurRadius: 9,
          offset: Offset(0, 7), // changes position of shadow
        ),
      ],
      image: new DecorationImage(
        image: new AssetImage(my_img),
        fit: BoxFit.cover,
      ),
    ),
    child: Center(
      child: new Text(my_txt,
          style: new TextStyle(
            fontSize: 25.0,
            color: Colors.white,
          )),
    ),
  );
}


