import 'dart:convert';
import 'models/item.dart';

void main() {
  const rawJson = '''{"id":1,"title":"Fjallraven Backpack","price":109.95,"description":"Everyday backpack","category":"men's clothing","image":"https://example.com/image.jpg"}''';
  final item = Item.fromJson(jsonDecode(rawJson) as Map<String, dynamic>);
  print('id: ${item.id}');
  print('title: ${item.title}');
  print('price: ${item.price}');
  print('description: ${item.description}');
  print('category: ${item.category}');
  print('imageUrl: ${item.imageUrl}');
}

