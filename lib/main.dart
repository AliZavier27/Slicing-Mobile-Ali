import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'Food Ordering App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainMenuScreen(),
    );
  }
}

class Item {
  final String name;
  final int price;
  final String image;
  int quantity;

  Item({required this.name, required this.price, required this.image, this.quantity = 1});
}

class Order {
  final List<Item> items;
  final int total;

  Order({required this.items, required this.total});
}

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final List<Item> foodItems = [
    Item(name: 'Burger King Medium', price: 30000, image: 'assets/burger.png'),
    Item(name: 'Kentang', price: 12000, image: 'assets/kentang.png'),
    Item(name: 'kentucky', price: 170000, image: 'assets/kentucky.png'),
    Item(name: 'Spaghetti', price: 20000, image: 'assets/spag.png'),
  ];

  final List<Item> drinkItems = [
    Item(name: 'Teh Botol', price: 5000, image: 'assets/teh_botol.png'),
    Item(name: 'Americano', price: 10000, image: 'assets/americano.png'),
    Item(name: 'Cappucino', price: 12000, image: 'assets/cappucino.png'),
    Item(name: 'Tea', price: 8000, image: 'assets/lontea.png'),
  ];

  final List<Item> cartItems = [];
  final List<Order> orderHistory = [];

  String selectedCategory = 'All';

  void _addToCart(Item item) {
    setState(() {
      final existingItem = cartItems.firstWhere(
        (cartItem) => cartItem.name == item.name,
        orElse: () => Item(name: '', price: 0, image: ''),
      );
      if (existingItem.name.isEmpty) {
        cartItems.add(Item(name: item.name, price: item.price, image: item.image));
      } else {
        existingItem.quantity++;
      }
    });
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(
          cartItems: cartItems,
          onCheckout: _checkout,
        ),
      ),
    );
  }

  void _navigateToOrderHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderHistoryScreen(orderHistory: orderHistory),
      ),
    );
  }

  void _checkout() {
    final total = cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
    orderHistory.add(Order(items: List.from(cartItems), total: total));
    cartItems.clear();
    setState(() {});
    Navigator.pop(context); // Close cart screen after checkout
  }

  @override
  Widget build(BuildContext context) {
    List<Item> displayedItems = selectedCategory == 'Food'
        ? foodItems
        : selectedCategory == 'Drink'
            ? drinkItems
            : [...foodItems, ...drinkItems];

    return Scaffold(
      appBar: AppBar(title: Text('Menu')),
      body: Column(
        children: [
          // Category Selection
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCategoryButton('All', Icons.fastfood),
                SizedBox(width: 10),
                _buildCategoryButton('Food', Icons.lunch_dining),
                SizedBox(width: 10),
                _buildCategoryButton('Drink', Icons.local_drink),
              ],
            ),
          ),
          // Food/Drink Items Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
              ),
              itemCount: displayedItems.length,
              itemBuilder: (context, index) {
                final item = displayedItems[index];
                return Card(
                  child: Column(
                    children: [
                      Image.asset(item.image, height: 200, fit: BoxFit.cover),
                      Text(item.name),
                      Text('Rp. ${item.price}'),
                      IconButton(
                        icon: Icon(Icons.add_circle, color: Colors.lightBlue),
                        onPressed: () => _addToCart(item),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 1) _navigateToCart();
          if (index == 2) _navigateToOrderHistory();
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Order History'),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category, IconData icon) {
    bool isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.black),
            SizedBox(width: 8),
            Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  final List<Item> cartItems;
  final VoidCallback onCheckout;

  CartScreen({required this.cartItems, required this.onCheckout});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _incrementQuantity(Item item) {
    setState(() {
      item.quantity++;
    });
  }

  void _decrementQuantity(Item item) {
    setState(() {
      if (item.quantity > 1) {
        item.quantity--;
      }
    });
  }

  void _removeItem(Item item) {
    setState(() {
      widget.cartItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    double total = widget.cartItems.fold(
        0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return ListTile(
                  leading: Image.asset(item.image, width: 50),
                  title: Text(item.name),
                  subtitle: Text('Rp. ${item.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => _decrementQuantity(item),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => _incrementQuantity(item),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeItem(item),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              children: [
                Text('Total: Rp. $total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 12), // Jarak antara teks total dan tombol
                SizedBox(
                  width: double.infinity,
                  height: 60, // Tinggi tombol yang lebih besar
                  child: ElevatedButton(
                    onPressed: widget.onCheckout,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 255, 247, 247), backgroundColor: Colors.blue, // Warna teks tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Membuat tombol dengan sudut melengkung
                      ),
                    ),
                    child: Text(
                      'Checkout',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class OrderHistoryScreen extends StatelessWidget {
  final List<Order> orderHistory;

  OrderHistoryScreen({required this.orderHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order History')),
      body: ListView.builder(
        itemCount: orderHistory.length,
        itemBuilder: (context, index) {
          final order = orderHistory[index];
          return ListTile(
            title: Text('Order ${index + 1}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: order.items.map((item) {
                return Text('${item.name} x${item.quantity}');
              }).toList(),
            ),
            trailing: Text('Rp. ${order.total}'),
          );
        },
      ),
    );
  }
}
