import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<dynamic>> fetchBestSeller() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5002/api/bestseller'));
      if (response.statusCode == 200) {
        return json.decode(response.body); // Parse ข้อมูลที่ได้รับ
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Error fetching data: $e'); // ส่ง error ออกไป
    }
  }
  static Future<List<dynamic>> fetchBeautyTips() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5002/api/tips'));
      if (response.statusCode == 200) {
        return json.decode(response.body); // Parse the received data
      } else {
        throw Exception('Failed to load beauty tips');
      }
    } catch (e) {
      print('Error fetching beauty tips: $e');
      throw Exception('Error fetching beauty tips: $e'); // Send error out
    }
  }
    static Future<List<dynamic>> fetchCart() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5002/api/cart'));
      if (response.statusCode == 200) {
        return json.decode(response.body); // Parse the received data
      } else {
        throw Exception('Failed to load beauty tips');
      }
    } catch (e) {
      print('Error fetching beauty tips: $e');
      throw Exception('Error fetching beauty tips: $e'); // Send error out
    }
  }

      static Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5002/api/product'));
      if (response.statusCode == 200) {
        return json.decode(response.body); // Parse the received data
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      print('Error fetching beauty tips: $e');
      throw Exception('Error fetching: $e'); // Send error out
    }
  }



  static Future<List<dynamic>> searchProduct(String query) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5002/api/search?query=$query'));
      if (response.statusCode == 200) {
        return json.decode(response.body); // Parse ข้อมูลที่ได้รับ
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Error fetching data: $e'); // ส่ง error ออกไป
    }
  }
  

  static Future<List<dynamic>> fetchMakeupProducts() async {
    final response = await http.get(Uri.parse('http://localhost:5002/api/product'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load makeup products');
    }
  
  }
  
  static const String baseUrl = 'http://localhost:5002/api/product';
  // ฟังก์ชันค้นหาผลิตภัณฑ์จากคำค้นหา
  static Future<List<dynamic>> searchProducts(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search?query=$query'));
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }


}