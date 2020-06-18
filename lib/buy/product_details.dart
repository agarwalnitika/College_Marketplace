import 'package:flutter/material.dart';
import 'package:marketplace/models/product.dart';
import 'package:marketplace/services/database.dart';
import 'package:marketplace/theme/color.dart';

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
  String _owner;
  int _contact;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _name = widget.product.name;
      _price = widget.product.price;
      _description = widget.product.description;
      _owner = widget.product.owner;
      _contact = widget.product.contact;
    }
  }

  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0)),
      child: Container(
          height: 80,
          width: width,
          decoration: BoxDecoration(
            color: LightColor.brighter,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                top: 40,
                left: 50,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: null,
                ),
              ),
              Positioned(
                top: 10,
                right: -120,
                child: _circularContainer(200, LightColor.lightBlue),
              ),
              Positioned(
                  top: -60,
                  left: -65,
                  child: _circularContainer(width * .5, LightColor.darkBlue)),
              Positioned(
                  top: -230,
                  right: -30,
                  child: _circularContainer(width * .7, Colors.transparent,
                      borderColor: Colors.white38)),
              Positioned(
                  top: 25,
                  left: 0,
                  child: Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 9.0),
                                child: Text(
                                  "Product Details",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                ),
                              ))
                        ],
                      ))),
            ],
          )),
    );
  }

  Widget _circularContainer(double height, Color color,
      {Color borderColor = Colors.transparent, double borderWidth = 2}) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _header(context),
          Container(
            height: 200,
            color: Colors.black,
            child: GridTile(
              child: Image.network(
                  "https://images-eu.ssl-images-amazon.com/images/I/51W0eIsy7bL._SR600%2C315_PIWhiteStrip%2CBottomLeft%2C0%2C35_SCLZZZZZZZ_.jpg"),
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
          Divider(),
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: ListTile(
                  title: Text(
                    '      Owner:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ListTile(
                  title: Text(
                    widget.product.owner,
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
                    '      Contact:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ListTile(
                  title: Text(
                    '${widget.product.contact}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}

/*

*/
