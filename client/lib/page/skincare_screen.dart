import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'skincare_detail_screen.dart'; // ตรวจสอบว่าไฟล์นี้มีอยู่จริง

class SkincareScreen extends StatefulWidget {
  const SkincareScreen({Key? key}) : super(key: key);

  @override
  State<SkincareScreen> createState() => _SkincareScreenState();
}

class _SkincareScreenState extends State<SkincareScreen> {
  List<dynamic> _skincareProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSkincareProducts();
  }

  Future<void> _fetchSkincareProducts() async {
    final String apiUrl =
        "http://localhost:5002/api/skincare"; // ใช้ API สกินแคร์

    try {
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 10));
      print('⌚ Response received: ${DateTime.now()}');
      print(response.body); // Debugging

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('application/json') ==
            true) {
          final List<dynamic> jsonData = json.decode(response.body);
          setState(() {
            _skincareProducts = jsonData;
            _isLoading = false;
          });
        } else {
          print('❌ Error: Content-Type is not application/json');
        }
      } else {
        print('❌ Error: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching data: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Skincare',
          style: TextStyle(fontFamily: 'Arial', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[100],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
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
              itemCount: _skincareProducts.length,
              itemBuilder: (context, index) {
                final product = _skincareProducts[index];

                String imageUrl = product['image'] ?? '';
                String productName = product['name'] ?? 'Unknown Name';
                double price = (product['price'] as num?)?.toDouble() ?? 0.0;
                dynamic productId = product['_id'];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SkincareDetailScreen(id: productId),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: 150,
                                    height: 150,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.error,
                                        size: 40, color: Colors.grey),
                                  ),
                                )
                              : Container(
                                  width: 150,
                                  height: 150,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_not_supported,
                                      size: 40, color: Colors.grey),
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
                            color: Colors.green[700],
                          ),
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
