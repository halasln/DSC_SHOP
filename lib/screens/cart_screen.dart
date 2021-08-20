import 'package:dsc_shop/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dsc_shop/providers/cart.dart';
import 'package:dsc_shop/providers/products.dart';
import 'package:dsc_shop/screens/product_screen.dart';

class CartScreen extends StatelessWidget {
  final FirestoreDatabase database =
      FirestoreDatabase(uid: FirebaseAuth.instance.currentUser!.uid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Consumer<Cart>(
              builder: (context, cartModel, child) {
                return ListView.builder(
                  itemCount: cartModel.productsCountInCart,
                  itemBuilder: (context, index) {
                    int id = cartModel.productsInCart[index];
                    return Consumer<Products>(
                      builder: (context, pro, child) {
                        double quantity = cartModel.productsQuantity[index];

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductScreen(
                                  productselec:
                                      pro.allProducts.elementAt(id - 1),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.all(9),
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
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: Image(
                                          height: 100.0,
                                          width: 100.0,
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
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                softWrap: true,
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                '\$${pro.allProducts.elementAt(id - 1).price}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 9,
                                              ),
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.arrow_back_ios,
                                                        color: Colors.grey,
                                                        size: 18,
                                                      ),
                                                      onPressed: () async {
                                                        if (cartModel
                                                                    .productsQuantity[
                                                                index] >
                                                            1) {
                                                          cartModel
                                                              .decreaseQuantity(
                                                                  index);
                                                          await database
                                                              .updateProductsQuantity({
                                                            'quantity': Provider.of<
                                                                        Cart>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .productsQuantity,
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    Text(
                                                      '${quantity.toInt()}',
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: Colors.grey,
                                                        size: 18,
                                                      ),
                                                      onPressed: () async {
                                                        cartModel
                                                            .increaseQuantity(
                                                                index);
                                                        await database
                                                            .updateProductsQuantity({
                                                          'quantity': Provider
                                                                  .of<Cart>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .productsQuantity,
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        cartModel.removeFromCart(id);
                                        await FirestoreDatabase(
                                                uid: FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            .updateUserCart({
                                          'user cart': cartModel.productsInCart
                                        });
                                        await FirestoreDatabase(
                                                uid: FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            .updateProductsQuantity({
                                          'quantity': cartModel.productsQuantity
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
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Consumer<Cart>(builder: (context, cartModel, child) {
        return Container(
          height: 80,
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Text.rich(
                TextSpan(
                  text: 'Total : \n ',
                  children: [
                    TextSpan(
                      text: cartModel.calculateTotalPrice(
                          Provider.of<Products>(context).allProducts),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6!.color,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Color(0xffff8900),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: true,
                          title: Text(
                            'Check out',
                            style: TextStyle(
                              color: Colors.orange,
                            ),
                          ),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Successful',
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
                                "Close",
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
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text('Check Out'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
