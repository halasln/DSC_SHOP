import 'package:dsc_shop/models/product.dart';
import 'package:dsc_shop/providers/cart.dart';
import 'package:dsc_shop/providers/favorite.dart';
import 'package:dsc_shop/providers/products.dart';
import 'package:dsc_shop/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  final FirestoreDatabase database =
      FirestoreDatabase(uid: FirebaseAuth.instance.currentUser!.uid);
  final Product productselec;
  ProductScreen({required this.productselec});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Color(0xff040316),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                color: Colors.grey,
                                iconSize: 30.0,
                                onPressed: () => Navigator.pop(context),
                              ),
                              Consumer<Favorite>(
                                builder: (context, fav, child) {
                                  return IconButton(
                                    icon: Icon(Icons.favorite),
                                    color: fav.favoriteProducts.contains(
                                            Provider.of<Products>(context)
                                                .allProducts[
                                                    productselec.id - 1]
                                                .id)
                                        ? Colors.red
                                        : Colors.grey[350],
                                    iconSize: 28.0,
                                    onPressed: () async {
                                      fav.toggleFavorite(Provider.of<Products>(
                                              context,
                                              listen: false)
                                          .allProducts[productselec.id - 1]
                                          .id);
                                      await database.updateUserFavorite({
                                        'user favorite': Provider.of<Favorite>(
                                                context,
                                                listen: false)
                                            .favoriteProducts
                                      });
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            margin: EdgeInsets.all(20.0),
                            child: Hero(
                              tag: productselec.image,
                              child: Image.network(
                                '${productselec.image}',
                                width: MediaQuery.of(context).size.width,
                                height: 220.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      ElevatedButton(
                        child: Text(
                          "More Details",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Color(0xff040316),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  scrollable: true,
                                  title: Text(
                                    'description',
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${productselec.description}',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .color,
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      child: Text(
                                        "close",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        primary: Theme.of(context).buttonColor,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '${productselec.title}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${productselec.price}',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Provider.of<Cart>(context)
                                    .productsInCart
                                    .contains(productselec.id)
                                ? Container(
                                    margin: EdgeInsets.only(right: 20.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40.0),
                                      color: Colors.orange,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  )
                                : ElevatedButton(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'Add to Cart',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: Color(0xffff8900),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    onPressed: () async {
                                      Provider.of<Cart>(context, listen: false)
                                          .addToCart(productselec.id);
                                      await database.updateUserCart({
                                        'user cart': Provider.of<Cart>(context,
                                                listen: false)
                                            .productsInCart
                                      });
                                      await database.updateProductsQuantity({
                                        'quantity': Provider.of<Cart>(context,
                                                listen: false)
                                            .productsQuantity,
                                      });
                                    },
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
