import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

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
              decoration: InputDecoration(hintText: 'Örn: 500 gram'),
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
                  imageUrl: imageUrl,
                );
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
