import 'package:dsc_shop/providers/cart.dart';
import 'package:dsc_shop/providers/products.dart';
import 'package:dsc_shop/screens/product_screen.dart';
import 'package:dsc_shop/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dsc_shop/providers/favorite.dart';

class FavoritScreen extends StatelessWidget {
  final FirestoreDatabase database =
      FirestoreDatabase(uid: FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<Favorite>(
        builder: (context, favoriteModel, child) {
          return ListView.builder(
              itemCount: favoriteModel.favoriteCount,
              itemBuilder: (context, index) {
                int id = favoriteModel.favoriteProducts[index];
                // Product product = pro.allProducts.elementAt(id - 1);
                return Consumer<Products>(
                  builder: (context, pro, child) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductScreen(
                              productselec: pro.allProducts.elementAt(id - 1),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 2.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image(
                                      height: 90.0,
                                      width: 90.0,
                                      image: NetworkImage(
                                        '${pro.allProducts.elementAt(id - 1).image}',
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${pro.allProducts.elementAt(id - 1).title}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: true,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          Text(
                                            '\$${pro.allProducts.elementAt(id - 1).price}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    Provider.of<Cart>(context, listen: false)
                                        .addToCart(id);
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
                                  child: Provider.of<Cart>(context)
                                          .productsInCart
                                          .contains(pro.allProducts
                                              .elementAt(id - 1)
                                              .id)
                                      ? Container(
                                          margin: EdgeInsets.only(right: 20.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                            color: Colors.orange,
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          'buy',
                                          style:
                                              TextStyle(color: Colors.orange),
                                        ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    favoriteModel.removeFavorite(id);
                                    await database.updateUserFavorite({
                                      'user favorite':
                                          favoriteModel.favoriteProducts
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              });
        },
      ),
    );
  }
}
