import 'package:dsc_shop/models/product.dart';
import 'package:dsc_shop/providers/cart.dart';
import 'package:dsc_shop/providers/favorite.dart';
import 'package:dsc_shop/providers/products.dart';
import 'package:dsc_shop/screens/product_screen.dart';
import 'package:dsc_shop/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsListView extends StatelessWidget {
  final FirestoreDatabase database =
      FirestoreDatabase(uid: FirebaseAuth.instance.currentUser!.uid);
  final String? categoryName;
  ProductsListView({this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<Products>(
        builder: (context, pro, child) {
          List<Product> categoryProducts = [];
          pro.allProducts.forEach((element) {
            if (categoryName == element.category) categoryProducts.add(element);
          });
          if (categoryProducts.isEmpty) {
            categoryProducts = pro.allProducts;
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 0.75,
            ),
            itemCount: categoryProducts.length,
            itemBuilder: (context, index) {
              int id = categoryProducts[index].id;
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductScreen(
                        productselec: categoryProducts[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(4),
                  padding: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).accentColor,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Stack(
                              children: [
                                Image.network(
                                  '${categoryProducts[index].image}',
                                  width: 100,
                                  height: 90,
                                ),
                                Positioned(
                                  top: -8,
                                  right: -8,
                                  child: Consumer<Favorite>(
                                    builder: (context, fav, child) {
                                      return IconButton(
                                        icon: Icon(Icons.favorite),
                                        color: fav.favoriteProducts.contains(
                                                categoryProducts[index].id)
                                            ? Colors.red
                                            : Colors.grey,
                                        iconSize: 26.0,
                                        onPressed: () {
                                          fav.toggleFavorite(
                                              categoryProducts[index].id);
                                          database.updateUserFavorite({
                                            'user favorite':
                                                fav.favoriteProducts,
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 15, right: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${categoryProducts[index].title}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '\$${categoryProducts[index].price}',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline6!
                                                  .color,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: SizedBox(
                                          height: 29,
                                          child: Provider.of<Cart>(context)
                                                  .productsInCart
                                                  .contains(
                                                      categoryProducts[index]
                                                          .id)
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      right: 20.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    color: Colors.orange,
                                                  ),
                                                  child: Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : ElevatedButton(
                                                  onPressed: () async {
                                                    Provider.of<Cart>(context,
                                                            listen: false)
                                                        .addToCart(id);
                                                    await database
                                                        .updateUserCart({
                                                      'user cart':
                                                          Provider.of<Cart>(
                                                                  context,
                                                                  listen: false)
                                                              .productsInCart,
                                                    });
                                                    await database
                                                        .updateProductsQuantity({
                                                      'quantity':
                                                          Provider.of<Cart>(
                                                                  context,
                                                                  listen: false)
                                                              .productsQuantity,
                                                    });
                                                  },
                                                  child: Text(
                                                    'Add to Cart',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    primary: Color(0xffff8900),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    // side: BorderSide(
                                                    //     width: 2, color: Colors.grey),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
