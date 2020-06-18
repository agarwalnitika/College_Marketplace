import 'package:flutter/material.dart';
import 'package:marketplace/buy/product_details.dart';
import 'package:marketplace/common_widgets/category_list_tile.dart';
import 'package:marketplace/common_widgets/empty_content.dart';
import 'package:marketplace/common_widgets/product_list_tile.dart';
import 'package:marketplace/common_widgets/quad_clipper.dart';
import 'package:marketplace/models/category.dart';
import 'package:marketplace/models/product.dart';
import 'package:marketplace/services/database.dart';
import 'package:marketplace/theme/color.dart';
import 'package:provider/provider.dart';
import 'package:carousel_pro/carousel_pro.dart';

class Buy extends StatelessWidget {
  Widget image_carousel = new Container(
    height: 200,
    child: Carousel(
      boxFit: BoxFit.cover,
      images: [
        AssetImage('assets/display1.jpg'),
        AssetImage('assets/display2.jpeg'),
        AssetImage('assets/display3.jpg'),
        AssetImage('assets/display4.webp'),
        AssetImage('assets/display5.jpg'),
      ],
      animationCurve: Curves.fastOutSlowIn,
      autoplay: true,
      animationDuration: Duration(milliseconds: 1000),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: _buildContents(context),
    );
  }

  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0)),
      child: Container(
          height: 90,
          width: width,
          decoration: BoxDecoration(
            color: LightColor.brighter,
          ),
          child: SafeArea(
            child: Stack(
              fit: StackFit.loose,
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
                    top: 20,
                    left: 0,
                    child: Container(
                        width: width,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "College MarketPlace",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                ))
                          ],
                        ))),
              ],
            ),
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
    return Column(
      children: <Widget>[
        _header(context),
        image_carousel,
        Container(
          height: 150,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: StreamBuilder<List<Category>>(
                  stream: database.allCategoriesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final allCategories = snapshot.data;
                      if (allCategories.isNotEmpty) {
                        final children = allCategories
                            .map(
                              (category) => GestureDetector(
                                onTap: () => null,
                                child: _card(
                                    primary: Colors.white,
                                    chipColor: LightColor.lightBlue,
                                    backWidget: _decorationContainerE(
                                      LightColor.lightBlue,
                                      90,
                                      -40,
                                      secondary: LightColor.lightseeBlue,
                                    ),
                                    chipText1: category.name,
                                    chipText2: 'view',
                                    imgPath:
                                        "https://img.icons8.com/clouds/2x/buy.png"),
                              ),
                            )
                            .toList();
                        return ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: children,
                        );
                      }
                      return EmptyContent();
                    }
                    if (snapshot.hasError) {
                      return EmptyContent(
                        title: 'Something went wrong',
                        message: 'Can\'t load items right now',
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              )
            ],
          ),
        ),
        Container(
          height: 180,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'All Products',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: StreamBuilder<List<SingleProduct>>(
                  stream: database.allProductsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final allProducts = snapshot.data;
                      if (allProducts.isNotEmpty) {
                        final children = allProducts
                            .map(
                              (product) => GestureDetector(
                                onTap: () => Product_Details.show(
                                  context,
                                  product: product,
                                ),
                                child: _card(
                                    primary: LightColor.lightBlue,
                                    backWidget: _decorationContainerA(
                                        LightColor.brighter, 50, -30),
                                    chipColor: LightColor.blue,
                                    chipText1: product.name,
                                    chipText2: 'Rs. ${product.price}',
                                    isPrimaryCard: true,
                                    imgPath:
                                        "https://thumbs.gfycat.com/ImpureCoarseHorsemouse-small.gif"),
                              ),
                            )
                            .toList();
                        return ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: children,
                        );
                      }
                      return EmptyContent(
                        title: 'Nothing Here',
                        message: 'No products to show',
                      );
                    }
                    if (snapshot.hasError) {
                      return EmptyContent(
                        title: 'Something went wrong',
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
        Container(
          height: 150,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'My Products',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: StreamBuilder<List<SingleProduct>>(
                  stream: database.myProductsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final myProducts = snapshot.data;
                      if (myProducts.isNotEmpty) {
                        final children = myProducts
                            .map(
                              (product) => GestureDetector(
                                onTap: () => Product_Details.show(
                                  context,
                                  product: product,
                                ),
                                child: _card(
                                    primary: LightColor.lightBlue,
                                    backWidget: _decorationContainerA(
                                        LightColor.brighter, 50, -30),
                                    chipColor: LightColor.blue,
                                    chipText1: product.name,
                                    chipText2: 'Rs. ${product.price}',
                                    isPrimaryCard: true,
                                    imgPath:
                                        "https://cdn.dribbble.com/users/1623266/screenshots/5090685/j.gif"),
                              ),
                            )
                            .toList();
                        return ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: children,
                        );
                      }
                      return EmptyContent(
                        title: 'Nothing Here',
                        message: 'Add products to show',
                      );
                    }
                    if (snapshot.hasError) {
                      return EmptyContent(
                        title: 'Something went wrong',
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

  Widget _decorationContainerA(Color primary, double top, double left) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: CircleAvatar(
            radius: 100,
            backgroundColor: primary.withAlpha(255),
          ),
        ),
        _smallContainer(primary, 20, 40),
        Positioned(
          top: 20,
          right: -30,
          child: _circularContainer(80, Colors.transparent,
              borderColor: Colors.white),
        )
      ],
    );
  }

  Widget _decorationContainerE(Color primary, double top, double left,
      {Color secondary}) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: -105,
          left: -35,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: primary.withAlpha(100),
          ),
        ),
        Positioned(
            top: 40,
            right: -25,
            child: ClipRect(
                clipper: QuadClipper(),
                child: CircleAvatar(backgroundColor: primary, radius: 40))),
        Positioned(
            top: 45,
            right: -50,
            child: ClipRect(
                clipper: QuadClipper(),
                child: CircleAvatar(backgroundColor: secondary, radius: 50))),
        _smallContainer(LightColor.yellow, 15, 90, radius: 5)
      ],
    );
  }

  Positioned _smallContainer(Color primary, double top, double left,
      {double radius = 10}) {
    return Positioned(
        top: top,
        left: left,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: primary.withAlpha(255),
        ));
  }

  Widget _card(
      {Color primary = LightColor.darkseeBlue,
      String imgPath,
      String chipText1 = '',
      String chipText2 = '',
      Widget backWidget,
      Color chipColor = LightColor.lightBlue,
      bool isPrimaryCard = false}) {
    return Container(
        height: isPrimaryCard ? 300 : 300,
        width: isPrimaryCard ? 600 * .32 : 400 * .32,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
            color: primary.withAlpha(200),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(0, 5),
                  blurRadius: 10,
                  color: LightColor.lightpurple.withAlpha(20))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            child: Stack(
              children: <Widget>[
                backWidget,
                Positioned(
                    top: 20,
                    left: 10,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: NetworkImage(imgPath),
                    )),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: _cardInfo(chipText1, chipText2,
                      LightColor.titleTextColor, chipColor,
                      isPrimaryCard: isPrimaryCard),
                )
              ],
            ),
          ),
        ));
  }

  Widget _cardInfo(String title, String courses, Color textColor, Color primary,
      {bool isPrimaryCard = false}) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10),
            width: 400 * .32,
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isPrimaryCard ? Colors.white : textColor),
              ),
            ),
          ),
          SizedBox(height: 5),
          _chip(courses, primary, height: 5, isPrimaryCard: isPrimaryCard)
        ],
      ),
    );
  }

  Widget _chip(String text, Color textColor,
      {double height = 0, bool isPrimaryCard = false}) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: textColor.withAlpha(isPrimaryCard ? 200 : 50),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: isPrimaryCard ? Colors.white : textColor, fontSize: 12),
      ),
    );
  }
}
