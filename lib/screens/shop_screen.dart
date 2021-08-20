import 'package:dsc_shop/services/database.dart';
import 'package:dsc_shop/widgets/TabBarPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  final FirestoreDatabase database =
      FirestoreDatabase(uid: FirebaseAuth.instance.currentUser!.uid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: 11, top: 12),
              alignment: Alignment.centerLeft,
              child: ListView(
                children: [
                  Text(
                    'Find your ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline6!.color,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'match ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).textTheme.headline6!.color,
                      ),
                      children: [
                        TextSpan(
                          text: 'style!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).textTheme.headline6!.color,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: TabBarPage(),
          ),
        ],
      ),
    );
  }
}
