import 'package:flutter/material.dart';
import 'package:untitled5/services/api_service.dart';
import 'package:untitled5/page/attraction_detail_screen.dart'; // Import หน้ารายละเอียดสินค้า
import 'package:untitled5/page/HomePage.dart'; // Import HomePage

class BestSellersPage extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF69376D),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage1()),
                    );
                  },
                ),
                Text(
                  'Best Sellers',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 48), // Placeholder to balance the row
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: ApiService.fetchBestSeller(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No bestsellers available'));
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      return _buildBestSellerItem(
                        context: context,
                        id: item['_id'].toString(),  // แก้ไขการส่ง id
                        image: item['image'] ?? 'https://via.placeholder.com/150',
                        name: item['name'] ?? 'No Brand',
                        details: item['details'] ?? 'No Description',
                        rating: item['rating']?.toDouble() ?? 0.0,
                        reviews: item['reviews']?.toInt() ?? 0,
                        price: item['price']?.toDouble() ?? 0.0,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestSellerItem({
    required BuildContext context,
    required String id,
    required String image,
    required String name,
    required String details,
    required double rating,
    required int reviews,
    required double price,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AttractionDetailScreen(id: id),  // ส่ง id ไปที่ ProductDetailPage
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(image, width: 60, height: 80),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    details,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('$rating', style: TextStyle(fontSize: 14)),
                      Icon(Icons.star, color: Colors.yellow, size: 16),
                      Text(' $reviews Reviews', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    '$price Bath',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Icon(Icons.favorite_border),
          ],
        ),
      ),
    );
  }
}