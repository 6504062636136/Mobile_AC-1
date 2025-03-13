import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavoriteItem {
  final String id;
  final String name;
  final double price;
  final String image;
  final String details;
  final double rating; // เพิ่มฟิลด์ rating
  final int reviews; // เพิ่มฟิลด์ reviews

  FavoriteItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.details,
    required this.rating,
    required this.reviews,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['_id'],
      name: json['name'],
      price: json['price'].toDouble(),
      image: json['image'],
      details: json['details'],
      rating: json['rating'].toDouble(), // รับค่า rating จาก JSON
      reviews: json['reviews'], // รับค่า reviews จาก JSON
    );
  }
}

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<FavoriteItem> favoriteItems = [];

  @override
  void initState() {
    super.initState();
    fetchFavoriteItems();
  }

  Future<void> fetchFavoriteItems() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:5002/api/favorite'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          favoriteItems =
              data.map((item) => FavoriteItem.fromJson(item)).toList();
        });
      } else {
        print('Failed to load favorite items: ${response.statusCode}');
        // แสดง SnackBar หรือ Dialog แจ้งข้อผิดพลาด
      }
    } catch (e) {
      print('Error fetching favorite items: $e');
      // แสดง SnackBar หรือ Dialog แจ้งข้อผิดพลาด
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorite'),
        backgroundColor: Colors.purple[100],
      ),
      body: favoriteItems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final item = favoriteItems[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(item.image,
                            width: 80, height: 80, fit: BoxFit.cover),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.details,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text('${item.price.toStringAsFixed(2)} Bath',
                                  style: const TextStyle(fontSize: 16)),
                              Text('Rating: ${item.rating}'), // แสดงผล rating
                              Text(
                                  'Reviews: ${item.reviews}'), // แสดงผล reviews
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.pink),
                          onPressed: () {
                            // ลบรายการที่ถูกกดจาก favoriteItems
                            setState(() {
                              favoriteItems.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
