import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final String url = "https://fakestoreapi.com/products";

  Future getData() async {
    var jsonData = await http.get(Uri.parse(url));
    if (jsonData.statusCode == 200) {
      String data = jsonData.body;
      return jsonDecode(data);
    } else {
      print(jsonData.statusCode);
    }
  }
}
