import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Ordering App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryButton('All', Icons.fastfood, selectedCategory == 'All'),
                _buildCategoryButton('Makanan', Icons.lunch_dining, selectedCategory == 'Makanan'),
                _buildCategoryButton('Minuman', Icons.local_drink, selectedCategory == 'Minuman'),
                _buildCategoryButton('Anak hilang', Icons.child_care, selectedCategory == 'Anak hilang'),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: (screenWidth / 2) / 250,
              children: _getFilteredProducts(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Orders',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String text, IconData icon, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedCategory = text;
            });
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
              size: 30,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  List<Widget> _getFilteredProducts() {
    List<Map<String, String>> allProducts = [
      {'name': 'Burger King Medium', 'price': 'Rp. 50.000,00', 'image': 'assets/burger.png', 'category': 'Makanan'},
      {'name': 'Teh Botol', 'price': 'Rp. 4.000,00', 'image': 'assets/teh_botol.png', 'category': 'Minuman'},
      {'name': 'Anak 5 tahun', 'price': 'Rp. 400.000,00', 'image': 'assets/anak.png', 'category': 'Anak hilang'},
    ];

    List<Map<String, String>> filteredProducts = selectedCategory == 'All'
        ? allProducts
        : allProducts.where((product) => product['category'] == selectedCategory).toList();

    return filteredProducts.map((product) => _buildProductCard(
      product['name']!,
      product['price']!,
      product['image']!,
    )).toList();
  }

  Widget _buildProductCard(String name, String price, String imagePath) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(price),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(Icons.add_circle, color: Colors.green),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}