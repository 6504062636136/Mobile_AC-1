import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<dynamic> _orders = [];
  String _selectedShippingMethod = 'Standard';
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCartItems(); // เรียกใช้ฟังก์ชัน fetchCartItems อย่างถูกต้อง
  }

  // ดึงข้อมูล Cart จาก API
  Future<void> fetchCartItems() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5002/api/cart'));

      if (response.statusCode == 200) {
        // แปลงข้อมูล JSON ที่ได้รับจาก API
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _orders = data;  // เก็บข้อมูลคำสั่งซื้อใน _orders
        });
      } else {
        print('Failed to load cart items: ${response.statusCode}');
        // สามารถแสดงข้อความข้อผิดพลาดที่นี่
      }
    } catch (e) {
      print('Error: $e');
      // สามารถแสดงข้อความข้อผิดพลาดกรณีไม่สามารถเชื่อมต่อกับ API ได้
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Address form
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Shipping method dropdown
            DropdownButtonFormField<String>(
              value: _selectedShippingMethod,
              items: ['Standard', 'Express', 'Next Day']
                  .map((method) => DropdownMenuItem(
                value: method,
                child: Text(method),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedShippingMethod = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Shipping Method',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Orders list
            Expanded(
              child: _orders.isEmpty
                  ? Center(child: CircularProgressIndicator()) // กำลังโหลด
                  : ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Order ID: ${order['_id']}'),
                          Text('Total: \$${order['total'].toStringAsFixed(2)}'),
                          // Display product images
                          if (order['items'] != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Items:'),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: [
                                    for (var item in order['items'])
                                      Image.network(
                                        item['image'],
                                        width: 50,
                                        height: 50,
                                        errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.error),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
