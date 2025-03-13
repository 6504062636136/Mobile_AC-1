import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Order.dart'; // Import the OrderPage

class CartItem {
  final String productName;
  final int quantity;
  final String imageUrl;
  final String id;
  final double price;

  CartItem({
    required this.productName,
    required this.quantity,
    required this.imageUrl,
    required this.id,
    required this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productName: json['name'],
      quantity: json['quantity'],
      imageUrl: json['image'],
      id: json['_id'],
      price: json['price'],
    );
  }
}

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final response =
        await http.get(Uri.parse('http://localhost:5002/api/cart'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        cartItems = data.map((item) => CartItem.fromJson(item)).toList();
      });
    } else {
      print('Failed to load cart items');
    }
  }

  Future<void> removeFromCart(String id) async {
    final response =
        await http.delete(Uri.parse('http://localhost:5002/api/cart/$id'));

    if (response.statusCode == 200) {
      setState(() {
        cartItems.removeWhere((item) => item.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product removed from cart')),
      );
    } else {
      print('Failed to remove product from cart');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove product from cart')),
      );
    }
  }

  double get totalPrice {
    return cartItems.fold(
        0, (total, item) => total + item.price * item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.pink[100], // สีชมพูอ่อน
      ),
      body: cartItems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Image.network(cartItems[index].imageUrl,
                                  width: 80, height: 80, fit: BoxFit.cover),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(cartItems[index].productName,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        'Quantity: ${cartItems[index].quantity}',
                                        style: const TextStyle(fontSize: 16)),
                                    Text(
                                        'Price: ${cartItems[index].price} Bath',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  removeFromCart(cartItems[index].id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total: ${totalPrice.toStringAsFixed(2)} Bath',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink[400],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                        child: const Text('Check Out',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}