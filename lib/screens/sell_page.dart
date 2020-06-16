import 'package:flutter/material.dart';
import 'package:marketplace/sell/add_edit_product.dart';
import 'package:marketplace/common_widgets/empty_content.dart';
import 'package:marketplace/common_widgets/product_list_tile.dart';
import 'package:marketplace/models/product.dart';
import 'package:marketplace/services/database.dart';
import 'package:provider/provider.dart';


class MyProducts extends StatelessWidget {

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
      appBar: AppBar(
        centerTitle: true,
        title: Text('My Products'),

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => AddEditProduct.show(context),
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<SingleProduct>>(
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
              child: ProductTile(
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
    );
  }


}
