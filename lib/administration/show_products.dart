import 'package:flutter/material.dart';
import 'package:marketplace/common_widgets/allProduct_list_tile.dart';
import 'package:marketplace/models/user.dart';
import 'package:marketplace/sell/add_edit_product.dart';
import 'package:marketplace/common_widgets/empty_content.dart';
import 'package:marketplace/models/product.dart';
import 'package:marketplace/services/database.dart';
import 'package:marketplace/theme/color.dart';
import 'package:provider/provider.dart';


class ShowProducts extends StatelessWidget {
  ShowProducts({Key key, @required this.database, this.product})
      : super(key: key);
  final Database database;
  final SingleProduct product;

  static Future<void> show(BuildContext context,
      {SingleProduct product}) async {
    final database = Provider.of<Database>(context);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShowProducts(

          database: database,
          product: product,
        ),
        fullscreenDialog: true,
      ),
    );
  }




  Future<void> _delete(BuildContext context, SingleProduct product) async {
    try{
      final database = Provider.of<Database>(context);
      await database.deleteProduct(product);

    }catch(e){
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Product Deletion Failed'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });

    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => AddEditProduct.show(context),
      ),
      body: _buildContents(context),
    );
  }


  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0)),
      child: Container(
          height: 100,
          width: width,
          decoration: BoxDecoration(
            color: LightColor.brighter,
          ),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
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
                  top: 50,
                  left: 0,
                  child: Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Manage Products",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500),
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

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    final user = Provider.of<User>(context);
    return Column(
      children: <Widget>[
        _header(context),
        Padding(
          padding: const EdgeInsets.only(top:30.0),
          child: Text(
            'My Products',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        Container(
          height: 200,
          child: Column(
            children: <Widget>[
              Flexible(
                child: StreamBuilder<List<SingleProduct>>(
                  stream: database.myProductsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final myProducts = snapshot.data;
                      if(myProducts.isNotEmpty) {
                        final children = myProducts
                            .map((product) => Dismissible(
                          key: Key('product-${product.id}'),
                          background: Container(color: Colors.red,),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) => _delete(context , product),
                          child: AllProductTile(
                            imageUrl:"assets/product.gif",
                            product: product,
                            onTap: () => AddEditProduct.show(context, product: product),
                          ),
                        ))
                            .toList();
                        return ListView(children: children);
                      }
                      return EmptyContent();
                    }
                    if (snapshot.hasError) {
                      return EmptyContent(
                        title:'Something went wrong' ,
                        message: 'Can\'t load items right now',
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top:30.0),
          child: Text(
            'All Products',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        Container(
          height: 250,
          child: Column(
            children: <Widget>[
              Flexible(
                child: StreamBuilder<List<SingleProduct>>(
                  stream: database.allProductsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final myProducts = snapshot.data;
                      if(myProducts.isNotEmpty) {
                        final children = myProducts
                            .map((product) => Dismissible(
                          key: Key('product-${product.id}'),
                          background: Container(color: Colors.red,),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) => _delete(context , product),
                          child: AllProductTile(
                            imageUrl:"assets/product.gif",
                            product: product,
                            onTap: () => AddEditProduct.show(context, product: product),
                          ),
                        ))
                            .toList();
                        return ListView(children: children);
                      }
                      return EmptyContent();
                    }
                    if (snapshot.hasError) {
                      return EmptyContent(
                        title:'Something went wrong' ,
                        message: 'Can\'t load items right now',
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


}
