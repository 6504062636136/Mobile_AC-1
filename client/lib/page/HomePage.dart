import 'package:flutter/material.dart';
import 'package:untitled5/page/MyProfile.dart';
import 'package:untitled5/page/AboutUsPage.dart';
import 'package:untitled5/page/BeautyTips.dart';
import 'package:untitled5/page/BestSeller.dart';
import 'package:untitled5/page/Categoties.dart';
import 'package:untitled5/page/Promotions.dart';
import 'package:untitled5/page/attraction_screen.dart';
import 'package:untitled5/page/search_page.dart';
import 'package:untitled5/page/attraction_detail_screen.dart'; // Import ProductDetailPage

import 'package:untitled5/services/api_service.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage1(),
    routes: {
      '/categories': (context) => CategoryPage(),
      '/promotions': (context) => PromotionsPage(),
      '/bestsellers': (context) => BestSellersPage(),
      '/beautytips': (context) => BeautyTipsPage(),
      '/about': (context) => AboutUsPage(),
      '/profile': (context) => MyProfilePage(),
    },
  ));
}

class HomePage1 extends StatefulWidget {
  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  final ApiService apiService = ApiService();
  Future<List<dynamic>>? bestSellers;
  Future<List<dynamic>>? makeupProducts;
  TextEditingController _searchController = TextEditingController();
  Future<List<dynamic>>? searchResults;

  @override
  void initState() {
    super.initState();
    bestSellers = ApiService.fetchBestSeller();
    makeupProducts = ApiService.fetchMakeupProducts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchResults = ApiService.searchProduct(_searchController.text);
    });
  }

  void _onSearch() {
    String query = _searchController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(), // ไม่ใช้ const []
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 202, 202, 1),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 248, 165, 198),
        iconTheme: IconThemeData(color: Colors.deepPurple[400]),
        title: Text(
          'GLAMORA',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple[400],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.deepPurple[400]),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFF2CACA)),
              child: Image.asset(
                'assets/images/logo2.png',
                fit: BoxFit.contain,
              ),
            ),
            _drawerItem(Icons.category, 'Categories', '/categories'),
            _drawerItem(Icons.local_offer, 'Promotions', '/promotions'),
            _drawerItem(Icons.star, 'Best Sellers', '/bestsellers'),
            _drawerItem(Icons.favorite, 'Beauty Tips', '/beautytips'),
            _drawerItem(Icons.info, 'About Us', '/about'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildBanner(),
              SizedBox(height: 20),
              _buildSearchBar(),
              SizedBox(height: 20),
              _buildBestSellersSection(),
              SizedBox(height: 20),
              _buildMakeupSection(),
              SizedBox(height: 20),
              _buildSearchResults(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/lisa_lipstick.webp',
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search Your Product',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onSubmitted: (value) => _onSearch(),
      ),
    );
  }

  Widget _buildBestSellersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Best Sellers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AttractionDetailScreen(id: 'best_sellers'),
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        FutureBuilder<List<dynamic>>(
          future: bestSellers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No bestsellers available'));
            } else {
              return SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return _buildProductItem(item);
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildMakeupSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Makeup',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductScreen(id: 1),
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        FutureBuilder<List<dynamic>>(
          future: makeupProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No makeup products available'));
            } else {
              return SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return _buildProductItem(item);
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildProductItem(dynamic item) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AttractionDetailScreen(id: item['_id']),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                item['image'] ?? 'https://via.placeholder.com/150',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item['name'] ?? 'No Name',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return FutureBuilder<List<dynamic>>(
      future: searchResults,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No results found'));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return ListTile(
                leading: Image.network(
                  item['image'] ?? 'https://via.placeholder.com/50',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(item['name'] ?? 'No Name'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AttractionDetailScreen(id: item['_id']),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  ListTile _drawerItem(IconData icon, String title, String routeName) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, routeName);
      },
    );
  }
}
