import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AttractionDetailScreen extends StatefulWidget {
  final String id;

  const AttractionDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<AttractionDetailScreen> createState() => _AttractionDetailScreenState();
}

class _AttractionDetailScreenState extends State<AttractionDetailScreen> {
  Map<String, dynamic>? _productDetail;
  bool _isLoading = true;
  int _quantity = 1;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchProductDetail();
  }

  Future<void> _fetchProductDetail() async {
    final String apiUrl = "http://localhost:5002/api/product/${widget.id}";
    print("📢 Fetching product details from: $apiUrl");

    try {
      final response = await http.get(Uri.parse(apiUrl));
      print("📢 Response status: ${response.statusCode}");
      print("📢 Response body: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          _productDetail = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        print(
            '❌ Failed to load product detail. Status Code: ${response.statusCode}');
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
      'name': _productDetail!['name'],
      'quantity': _quantity,
      'price': _productDetail!['price'],
      'type': _productDetail!['type'],
      'image': _productDetail!['image'],
    };

    try {
      print("🛒 Sending to Cart API: $cartItem");

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
        print(
            '❌ Failed to add product to cart. Status Code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add product to cart')),
        );
      }
    } catch (e) {
      print('❌ Error adding product to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding product to cart')),
      );
    }
  }

  Future<void> _addToFavorites() async {
    final String apiUrl = "http://localhost:5002/api/favorite/create";

    final Map<String, dynamic> favoriteItem = {
      'name': _productDetail!['name'],
      'price': _productDetail!['price'],
      'type': _productDetail!['type'],
      'image': _productDetail!['image'],
      'details': _productDetail!['details'],
      'rating': _productDetail!['rating'],
      'reviews': _productDetail!['reviews'],
    };

    try {
      print("❤️ Sending to Favorites API: $favoriteItem");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(favoriteItem),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added to favorites')),
        );
        setState(() {
          _isFavorite = true;
        });
      } else {
        print(
            '❌ Failed to add product to favorites. Status Code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add product to favorites')),
        );
      }
    } catch (e) {
      print('❌ Error adding product to favorites: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding product to favorites')),
      );
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
            _productDetail != null
                ? _productDetail!['name'] ?? 'Product Detail'
                : 'Product Detail',
            style: const TextStyle(
              fontFamily: 'Arial',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.pink[100],
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: _isFavorite ? Colors.red : null,
              ),
              onPressed: _addToFavorites,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                ),
              )
            : _productDetail == null
                ? const Center(
                    child: Text("⚠️ Product not found",
                        style: TextStyle(fontSize: 18)))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Ensure image exists before using it
                              if (_productDetail!['image'] != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      _productDetail!['image'],
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error),
                                      height: 250,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 20),

                              // Ensure name exists
                              Text(
                                _productDetail!['name'] ?? 'No Name',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Arial',
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Ensure details and type exist
                              Text(
                                'Details: ${_productDetail!['details'] ?? 'N/A'}\nType: ${_productDetail!['type'] ?? 'N/A'}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Arial',
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Display rating and reviews
                              if (_productDetail!['rating'] != null &&
                                  _productDetail!['reviews'] != null)
                                Column(
                                  children: [
                                    RatingBarIndicator(
                                      rating: _productDetail!['rating']?.toDouble() ?? 0.0,
                                      itemBuilder: (context, index) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 24.0,
                                      direction: Axis.horizontal,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Reviews: ${_productDetail!['reviews']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Arial',
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),

                        // Ensure price exists before showing it
                        if (_productDetail!['price'] != null)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              '${_productDetail!['price']?.toString() ?? '0.00'} B',
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'Roboto',
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                        // Quantity selector
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
                            Text(
                              '$_quantity',
                              style: const TextStyle(fontSize: 20),
                            ),
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

                        // Add to cart button
                        ElevatedButton(
                          onPressed: _addToCart,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.pink[100],
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Add to Cart'),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
