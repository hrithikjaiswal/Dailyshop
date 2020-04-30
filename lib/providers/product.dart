import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    this.isFavorite = false,
    @required this.price,
  });

  void _setfavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
    throw HttpException('Could not Toggle Favorite Status');
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final url =
        'https://"enteryourdatabaseurl"/userFavorites/$userId/$id.json?auth=$token';
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    // try {
    final response = await http.put(
      url,
      body: json.encode(isFavorite),
    );
    if (response.statusCode >= 400) {
      _setfavValue(oldStatus);
    }
    // } catch (error) {
    //   _setfavValue(oldStatus);
    // }
  }
}
