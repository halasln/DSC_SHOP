import 'package:dsc_shop/providers/theme.dart';
import 'package:dsc_shop/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:dsc_shop/screens/splash_screen.dart';
import 'package:dsc_shop/screens/login_screen.dart';
import 'package:dsc_shop/providers/products.dart';
import 'package:dsc_shop/providers/favorite.dart';
import 'package:dsc_shop/providers/cart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Splash(),
          );
        } else {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => Products()),
              ChangeNotifierProvider(create: (context) => Favorite()),
              ChangeNotifierProvider(create: (context) => Cart()),
              ChangeNotifierProvider(create: (context) => ThemeProvider()),
            ],
            builder: (context, child) {
              final themeProvider = Provider.of<ThemeProvider>(context);
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                themeMode: themeProvider.themeMode,
                theme: MyThemes.lightTheme,
                darkTheme: MyThemes.darkTheme,
                title: 'DSC Shop',
                home: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Splash();
                    }
                    User? user = snapshot.data;
                    if (user == null) {
                      return LoginScreen();
                    } else {
                      print('you are logged in as ${user.email}');
                      return HomeScreen();
                    }
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
