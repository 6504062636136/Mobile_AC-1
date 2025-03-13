import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'attraction_detail_screen.dart'; // Make sure this exists and is correct
import 'HomePage.dart'; // Import HomePage

class ProductScreen extends StatefulWidget {
  final int id;

  const ProductScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProductScreenState();
  }
}

class _ProductScreenState extends State<ProductScreen> {
  List<dynamic> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final String apiUrl = "http://localhost:5002/api/product";

    try {
      print('⌚ Request start: ${DateTime.now()}');
      final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 10));
      print('⌚ Response received: ${DateTime.now()}');
      print(response.body);

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('application/json') == true) {
          final List<dynamic> jsonData = json.decode(response.body);
          setState(() {
            _products = jsonData;
            _isLoading = false;
          });
          print('⌚ UI updated: ${DateTime.now()}');
        } else {
          print('❌ Error: Content-Type is not application/json');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print('❌ Error: HTTP status code ${response.statusCode}');
        print('Response body: ${response.body}');
        setState(() {
          _isLoading = false;
        });
      }
    } on TimeoutException catch (e) {
      print('❌ Error: Timeout - $e');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error fetching data: ${e.toString()}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Makeup',
            style: TextStyle(fontFamily: 'Arial', fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.pink[100],
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage1()),
              );
            },
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.85,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];

                  String imageUrl = product['image'] ?? '';
                  String productName = product['name'] ?? 'Unknown Name';
                  double price = (product['price'] as num?)?.toDouble() ?? 0.0;
                  dynamic productId = product['_id'];

                  // All boxes will be white
                  const Color backgroundColor = Colors.white;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttractionDetailScreen(
                            id: productId.toString(), // Convert ID to string
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    width: 150, // Increased image size
                                    height: 150, // Increased image size
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 150, // Match error container size
                                      height: 150, // Match error container size
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.error, size: 40, color: Colors.grey),
                                    ),
                                  )
                                : Container(
                                    width: 150, // Match placeholder size
                                    height: 150, // Match placeholder size
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                                  ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            productName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Arial',
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${price.toStringAsFixed(2)}B',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}