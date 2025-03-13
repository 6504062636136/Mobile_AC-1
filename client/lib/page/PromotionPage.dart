import 'package:flutter/material.dart';
import 'ProductPage.dart';  // นำเข้าหน้า ProductPage

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PromotionsPage(),
    );
  }
}

class PromotionsPage extends StatelessWidget {
  final List<String> promotions = [
    "Get 3 Free 1",
    "Get 20% OFF on your first purchase!",
    "Skincare Set: Buy 3, Save 30%!"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF77407F),
      appBar: AppBar(
        backgroundColor: Color(0xFF77407F),
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.sunny, size: 28, color: Colors.white),
            SizedBox(width: 10),
            Text(
              "Promotions",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(  // ใช้ ListView แทน Column
          children: promotions
              .map((promo) => _buildPromoCard(context, promo))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildPromoCard(BuildContext context, String text) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          // เมื่อกดที่โปรโมชั่นนี้ จะไปหน้า ProductPage พร้อมส่งข้อมูลโปรโมชั่นไป
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(promotion: text),
            ),
          );
        },
      ),
    );
  }
}
