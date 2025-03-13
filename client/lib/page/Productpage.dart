import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatelessWidget {
  final String promotion;

  const ProductPage({Key? key, required this.promotion}) : super(key: key);

  Future<List<dynamic>> fetchProducts() async {
    final responseProduct =
        await http.get(Uri.parse('http://localhost:5002/api/product'));
    final responseSkincare =
        await http.get(Uri.parse('http://localhost:5002/api/skincare'));

    if (responseProduct.statusCode == 200 &&
        responseSkincare.statusCode == 200) {
      final products = json.decode(responseProduct.body);
      final skincare = json.decode(responseSkincare.body);
      final allProducts = [...products, ...skincare];
      allProducts.shuffle();
      return allProducts;
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product for $promotion'),
        backgroundColor: Color(0xFF77407F),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available'));
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        child: Container(
                          height: 160.0, // เพิ่มขนาดภาพ
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Image.network(
                            products[index]['image'],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // ชื่อสินค้า
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          products[index]['name'],
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 5),
                      // ราคา
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '${products[index]['price']}B',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
