import 'dart:io';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dsc_shop/providers/theme.dart';
import 'package:dsc_shop/screens/login_screen.dart';
import 'package:dsc_shop/screens/product_screen.dart';
import 'package:dsc_shop/services/database.dart';
import 'package:dsc_shop/services/networking.dart';
import 'package:dsc_shop/models/product.dart';
import 'package:dsc_shop/providers/products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dsc_shop/screens/shop_screen.dart';
import 'package:dsc_shop/screens/favorite_screen.dart';
import 'package:dsc_shop/screens/cart_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';
import 'package:dsc_shop/providers/cart.dart';
import 'package:dsc_shop/providers/favorite.dart';
import 'package:dsc_shop/widgets/counter_icon.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirestoreDatabase database =
      FirestoreDatabase(uid: FirebaseAuth.instance.currentUser!.uid);
  final ref = FirebaseStorage.instance
      .ref()
      .child('/user_image')
      .child(FirebaseAuth.instance.currentUser!.uid + '.jpg');
  Map<String, dynamic>? userData;
  int _selectedPageIndex = 0;
  bool isloading = true;
  bool isSearching = false;
  List<Product> matchedProducts = [];
  String imagePath = '';
  String imageUrl = '';
  final _picker = ImagePicker();
  late List<Widget> pages;

  search(String value) {
    setState(() {
      matchedProducts = [];
      Provider.of<Products>(context, listen: false)
          .allProducts
          .forEach((element) {
        if (element.title.toLowerCase().contains(value.toLowerCase()))
          matchedProducts.add(element);
      });
    });
    print(value);
    print(matchedProducts);
  }

  void getData() async {
    NetworkHelper networkHelper = NetworkHelper();
    var productsMap = await networkHelper.getData();
    List<Product> productsData = [];
    for (var u in productsMap) {
      Product product = Product.fromJson(u);
      productsData.add(product);
    }
    Provider.of<Products>(context, listen: false).setAllProducts(productsData);
    userData = await database.getUserData();
    imageUrl = userData!['url'] ?? '';
    Map<String, dynamic> userFavorite = await database.getUserfavorite();
    Provider.of<Favorite>(context, listen: false)
        .setFavoriteProducts(userFavorite['user favorite']);
    Map<String, dynamic> userCart = await database.getUsercart();
    Provider.of<Cart>(context, listen: false)
        .setCartProducts(userCart['user cart']);
    Map<String, dynamic> productsQuantity =
        await database.getProductsQuantity();
    List quantity = productsQuantity['quantity'];
    quantity.forEach((element) {
      element.toDouble();
    });
    Provider.of<Cart>(context, listen: false).setProductsQuantity(quantity);
    setState(() {
      isloading = false;
    });
  }

  void initState() {
    pages = [
      ShopScreen(),
      FavoritScreen(),
      CartScreen(),
    ];
    super.initState();
    getData();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
      isSearching = false;
    });
  }

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      drawer: Container(
        margin: EdgeInsets.all(40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(context).accentColor,
            width: 2.0,
          ),
          color: Theme.of(context).colorScheme.background,
        ),
        height: 480,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 20, 10, 20),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Color(0xffFDCF09),
                            child: imageUrl == ''
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      imageUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 1,
                            right: 0,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        margin: EdgeInsets.all(20),
                                        child: SimpleDialog(
                                          title: Text('photo'),
                                          children: [
                                            SimpleDialogOption(
                                              child: Text('Edit your photo'),
                                              onPressed: () async {
                                                // _showPicker(context);
                                                final pickedFile =
                                                    await _picker.pickImage(
                                                        source: ImageSource
                                                            .gallery);
                                                if (pickedFile != null) {
                                                  setState(() {
                                                    imagePath = pickedFile.path;
                                                  });
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: Image.file(
                                                              File(imagePath)),
                                                          actions: [
                                                            TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  int counter =
                                                                      0;
                                                                  userData =
                                                                      await database
                                                                          .getUserData();
                                                                  await ref.putFile(
                                                                      File(
                                                                          imagePath));
                                                                  imageUrl =
                                                                      await ref
                                                                          .getDownloadURL();
                                                                  await database
                                                                      .setUserData({
                                                                    'email':
                                                                        userData![
                                                                            'email'],
                                                                    'name': userData![
                                                                        'name'],
                                                                    'url':
                                                                        imageUrl
                                                                  });
                                                                  userData =
                                                                      await database
                                                                          .getUserData();

                                                                  Navigator.popUntil(
                                                                      context,
                                                                      (route) =>
                                                                          counter++ >=
                                                                          2);
                                                                  setState(() {
                                                                    imageUrl =
                                                                        userData!['url'] ??
                                                                            '';
                                                                  });
                                                                },
                                                                child: Text(
                                                                    'Save')),
                                                            TextButton(
                                                              onPressed: () {
                                                                int counter = 0;
                                                                Navigator.popUntil(
                                                                    context,
                                                                    (route) =>
                                                                        counter++ >=
                                                                        2);
                                                              },
                                                              child: Text(
                                                                'Cancel',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .orange),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                }
                                              },
                                            ),
                                            SimpleDialogOption(
                                              child: Text('Delete your photo'),
                                              onPressed: () async {
                                                userData = await database
                                                    .getUserData();
                                                ref.delete();
                                                await database.setUserData({
                                                  'email': userData!['email'],
                                                  'name': userData!['name'],
                                                });
                                                setState(() {
                                                  imageUrl = '';
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancel',
                                                  style: TextStyle(
                                                      color: Colors.orange)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 20, 10, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(userData == null ? 'your name' : userData!['name']),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                          userData == null ? 'your email' : userData!['email']),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            Column(
              children: [
                ListTileSwitch(
                  value: Provider.of<ThemeProvider>(context).isDarkMode,
                  leading: Icon(FontAwesomeIcons.solidMoon),
                  onChanged: (value) {
                    final provider =
                        Provider.of<ThemeProvider>(context, listen: false);
                    provider.toggleTheme(value);
                  },
                  visualDensity: VisualDensity.comfortable,
                  switchType: SwitchType.cupertino,
                  switchActiveColor: Colors.indigo,
                  title: const Text(
                    'Dark mode',
                    style: TextStyle(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await auth.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Container(
                  margin: EdgeInsets.all(9),
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'About',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.orange),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'halasliimen@gmail.com',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.headline6!.color),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        ' mohamed_afia2011@yahoo.com',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.headline6!.color),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: isSearching
            ? TextField(
                onChanged: search,
                autofocus: true,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.orange),
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  hintText: "Search product",
                ),
              )
            : Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.account_box_outlined,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      _globalKey.currentState!.openDrawer();
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 9),
                    child: Text(
                      _selectedPageIndex == 0
                          ? 'DSC Shop'
                          : _selectedPageIndex == 1
                              ? 'Favorite'
                              : 'Cart',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ],
              ),
        actions: [
          _selectedPageIndex == 0
              ? isSearching
                  ? IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        setState(() {
                          isSearching = false;
                          matchedProducts = [];
                        });
                      })
                  : IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        setState(() {
                          isSearching = true;
                        });
                      })
              : SizedBox(),
        ],
      ),
      body: isloading
          ? Center(
              child: SpinKitCircle(
              color: Colors.black,
            ))
          : Visibility(
              child: pages[_selectedPageIndex],
              visible: !isSearching,
              replacement: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  itemCount: matchedProducts.length,
                  itemBuilder: (context, index) {
                    int id = matchedProducts[index].id;
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductScreen(
                                        productselec: Provider.of<Products>(
                                                context,
                                                listen: false)
                                            .allProducts[id - 1])));
                          },
                          title: Text(
                            matchedProducts[index].title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: true,
                          ),
                          leading: Container(
                              color: Colors.white,
                              child: Image.network(
                                matchedProducts[index].image,
                                width: 50,
                                height: 50,
                              )),
                        ),
                        Divider(
                          color: Colors.grey,
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 32,
        selectedFontSize: 20,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.amber,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CounterIcon(
              iconData: Icons.favorite_border_outlined,
              count: Provider.of<Favorite>(context).favoriteCount,
            ),
            label: 'favorite',
          ),
          BottomNavigationBarItem(
            icon: CounterIcon(
              iconData: Icons.local_mall,
              count: Provider.of<Cart>(context).productsCountInCart,
            ),
            label: 'Cart',
          ),
        ],
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
      ),
    );
  }
}
