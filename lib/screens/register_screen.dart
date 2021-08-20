import 'package:dsc_shop/screens/home_screen.dart';
import 'package:dsc_shop/screens/login_screen.dart';
import 'package:dsc_shop/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late String _email;
  late String _password;
  late String _name;
  bool _isObscure = true;

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Container(
            alignment: Alignment.center,
            color: Color(0xff040316),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 36.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Sign up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 46.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                _name = value;
                              });
                            },
                            style: TextStyle(color: Colors.black),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.orange),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: "enter your user name",
                              labelText: "User name",
                              labelStyle: TextStyle(color: Colors.grey),
                              prefixIcon:
                                  Icon(Icons.person, color: Color(0xff040316)),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                _email = value;
                              });
                            },
                            style: TextStyle(color: Colors.black),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.orange),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: "enter your email",
                              labelText: "E-mail",
                              labelStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.email,
                                  // color: Color(0xfffbabb1),
                                  color: Color(0xff040316)),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                _password = value;
                              });
                            },
                            style: TextStyle(color: Colors.black),
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.orange),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: "enter your password",
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Color(0xff040316),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                await auth.createUserWithEmailAndPassword(
                                    email: _email, password: _password);
                                FirestoreDatabase database = FirestoreDatabase(
                                    uid:
                                        FirebaseAuth.instance.currentUser!.uid);
                                await database.setUserData({
                                  'email': auth.currentUser!.email,
                                  'name': _name
                                });
                                await database
                                    .updateUserCart({'user cart': []});
                                await database
                                    .updateUserFavorite({'user favorite': []});
                                await database
                                    .updateProductsQuantity({'quantity': []});
                              } catch (e) {
                                print(e);
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: Text('$e'),
                                        ));
                                return null;
                              }

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: Color(0xffff8900),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(
                              'Sign up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'have an account already ?',
                                style: TextStyle(color: Colors.black87),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text(
                                  'Log in',
                                  style: TextStyle(
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
