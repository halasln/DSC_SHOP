class Product {
  final int id;
  final String title;
  final dynamic price;
  final String description;
  final String category;
  final String image;
  Product(
      {required this.id,
      required this.title,
      required this.price,
      required this.description,
      required this.category,
      required this.image});
  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    return Product(
        id: parsedJson["id"],
        title: parsedJson["title"],
        price: parsedJson["price"],
        description: parsedJson["description"],
        category: parsedJson["category"],
        image: parsedJson["image"]);
  }
}
