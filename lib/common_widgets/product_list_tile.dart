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
    return Container(
      height: height,
      width: width,
      child: Card(
        child: ListTile(
          title: Text(
            product.name,
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            'Price: ${product.price}',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        ),
      ),
    );
  }
}

