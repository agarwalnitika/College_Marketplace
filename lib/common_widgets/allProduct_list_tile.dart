import 'package:flutter/material.dart';
import 'package:marketplace/models/product.dart';

class AllProductTile extends StatelessWidget {
  const AllProductTile({Key key, @required this.product, this.onTap , this.height , this.width})
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListTile(
              leading: Image.asset('assets/display1.jpg',
                width: 100,
                height: 80,),
              title: Text(
                product.name,
                style: TextStyle(fontSize: 18),
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
          ],
        ),
      ),
    );
  }
}


