import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Butcher Shop',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePage(),
    );
  }
}

// Define the cart provider
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
    (ref) => CartNotifier());

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(CartItem item) {
    state = [...state, item];
  }

  double getTotalAmount() {
    return state.fold(0.0, (total, item) => total + item.price);
  }
}

class CartItem {
  final String name;
  final double weightInKg;
  final double price;

  CartItem({required this.name, required this.weightInKg, required this.price});
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kasap Uygulaması'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProductButton(
            title: 'Tavuk',
            image: 'images/tavuk.png',
            targetPage: ProductCategoryPage(
              products: chickenProducts,
              category: 'Tavuk',
            ),
          ),
          ProductButton(
            title: 'Kırmızı Et',
            image: 'images/kırmızı_et.jpg',
            targetPage: ProductCategoryPage(
              products: redMeatProducts,
              category: 'Kırmızı Et',
            ),
          ),
        ],
      ),
    );
  }
}

class ProductButton extends StatelessWidget {
  final String title;
  final String image;
  final Widget targetPage;

  ProductButton({
    required this.title,
    required this.image,
    required this.targetPage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => targetPage));
      },
      child: Container(
        margin: EdgeInsets.all(20),
        height: 280,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// Example product data
final chickenProducts = [
  {'name': 'Tavuk Göğsü', 'pricePerKg': 50.0, 'image': 'images/göğüs.jpeg'},
  {'name': 'Tavuk Kanadı', 'pricePerKg': 40.0, 'image': 'images/kanat.jpeg'},
];

final redMeatProducts = [
  {
    'name': 'Dana Antrikot',
    'pricePerKg': 120.0,
    'image': 'images/antrikot.jpeg'
  },
  {'name': 'Kuzu Pirzola', 'pricePerKg': 140.0, 'image': 'images/pirzola.jpeg'},
];

class ProductCategoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final String category;

  ProductCategoryPage({required this.products, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CartPage()));
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    productName: product['name'],
                    pricePerKg: product['pricePerKg'],
                    imageUrl: product['image'],
                  ),
                ),
              );
            },
            child: Card(
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.asset(product['image'], fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(product['name'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('₺${product['pricePerKg']} / kg'),
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

class ProductDetailPage extends ConsumerWidget {
  final String productName;
  final double pricePerKg;
  final String imageUrl;

  ProductDetailPage({
    required this.productName,
    required this.pricePerKg,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController weightController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(imageUrl, height: 200, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text(productName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('₺$pricePerKg / kg', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Ağırlık Gir (gram cinsinden):'),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Örn: 500'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final weightInKg = double.parse(weightController.text) / 1000;
                final totalPrice = weightInKg * pricePerKg;
                final cartItem = CartItem(
                  name: productName,
                  weightInKg: weightInKg,
                  price: totalPrice,
                );
                // Using ref to add to cart
                ref.read(cartProvider.notifier).addToCart(cartItem);
                Navigator.pop(context);
              },
              child: Text('Sepete Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalAmount = ref.read(cartProvider.notifier).getTotalAmount();

    return Scaffold(
      appBar: AppBar(
        title: Text('Sepetim'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                      '${item.weightInKg.toStringAsFixed(2)} kg - ₺${item.price.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              children: [
                Text('Toplam Tutar: ₺${totalAmount.toStringAsFixed(2)}'),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Sepeti onayla işlemi
                  },
                  child: Text('Sepeti Onayla'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
