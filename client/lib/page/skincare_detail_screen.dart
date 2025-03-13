import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SkincareDetailScreen extends StatefulWidget {
  final String id;

  const SkincareDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<SkincareDetailScreen> createState() => _SkincareDetailScreenState();
}

class _SkincareDetailScreenState extends State<SkincareDetailScreen> {
  Map<String, dynamic>? _skincareDetail;
  bool _isLoading = true;
  int _quantity = 1;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchSkincareDetail();
  }

  Future<void> _fetchSkincareDetail() async {
    final String apiUrl = "http://localhost:5002/api/skincare/${widget.id}";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          _skincareDetail = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        print('❌ Failed to load skincare details.');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addToCart() async {
    final String apiUrl = "http://localhost:5002/api/cart/create";
    final Map<String, dynamic> cartItem = {
      'name': _skincareDetail!['name'],
      'quantity': _quantity,
      'price': _skincareDetail!['price'],
      'type': _skincareDetail!['type'],
      'image': _skincareDetail!['image'],
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(cartItem),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added to cart')),
        );
      } else {
        print('❌ Failed to add to cart.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add product to cart')),
        );
      }
    } catch (e) {
      print('❌ Error adding to cart: $e');
    }
  }

  Future<void> _addToFavorites() async {
    final String apiUrl = "http://localhost:5002/api/favorite/create";
    final Map<String, dynamic> favoriteItem = {
      'name': _skincareDetail!['name'],
      'price': _skincareDetail!['price'],
      'type': _skincareDetail!['type'],
      'image': _skincareDetail!['image'],
      'details': _skincareDetail!['details'],
      'rating': _skincareDetail!['rating'],
      'reviews': _skincareDetail!['reviews'],
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(favoriteItem),
      );

      if (response.statusCode == 201) {
        setState(() {
          _isFavorite = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to favorites')),
        );
      }
    } catch (e) {
      print('❌ Error adding to favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            _skincareDetail?['name'] ?? 'Product Detail',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          backgroundColor: Colors.pink[100],
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : null,
              ),
              onPressed: _addToFavorites,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: _skincareDetail?['image'] != null
                          ? Image.network(
                        _skincareDetail!['image'],
                        height: 250,
                        width: 250,
                        fit: BoxFit.contain,
                      )
                          : const SizedBox(
                        height: 250,
                        width: 250,
                        child: Center(
                            child: Icon(Icons.image_not_supported,
                                size: 50, color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _skincareDetail?['name'] ?? 'No Name',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text('Details: ${_skincareDetail?['details'] ?? 'N/A'}', textAlign: TextAlign.center),
                  Text('Type: ${_skincareDetail?['type'] ?? 'N/A'}', textAlign: TextAlign.center),
                  if (_skincareDetail?['rating'] != null)
                    Text('Rating: ${_skincareDetail!['rating']}', textAlign: TextAlign.center),
                  if (_skincareDetail?['reviews'] != null)
                    Text('Reviews: ${_skincareDetail!['reviews']}', textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (_quantity > 1) _quantity--;
                          });
                        },
                      ),
                      Text('$_quantity', style: const TextStyle(fontSize: 20)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _addToCart,
                    child: const Text('Add to Cart'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}