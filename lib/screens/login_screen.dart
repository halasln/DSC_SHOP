import 'package:dsc_shop/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dsc_shop/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _email;
  late String _password;
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
                          'Login',
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
                                _email = value;
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
                              hintText: "enter your email",
                              hintStyle: TextStyle(color: Colors.grey),
                              labelText: "E-mail",
                              labelStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Color(0xff040316),
                              ),
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
                              hintText: "enter your password",
                              hintStyle: TextStyle(color: Colors.grey),
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
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: Color(0xffff8900),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () async {
                              try {
                                await auth.signInWithEmailAndPassword(
                                    email: _email, password: _password);
                              } on FirebaseAuthException catch (e) {
                                print(e.message);
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: Text(e.message.toString()),
                                        ));
                                return null;
                              }

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'LOG IN',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'do not have an account ?',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterScreen()));
                                },
                                child: Text(
                                  'Sign up',
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
