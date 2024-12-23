import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_summary.dart';

class CartPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalAmount = ref.read(cartProvider.notifier).getTotalAmount();

    return Scaffold(
      appBar: AppBar(
        title: Text('Sepetim'),
        backgroundColor: const Color.fromARGB(255, 194, 3, 67),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: cartItems.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: Image.asset(item.imageUrl, width: 50, height: 50),
                  title: Text(item.name),
                  subtitle: Text(
                      '${item.weightInKg.toStringAsFixed(2)} kg - ₺${item.price.toStringAsFixed(2)}'),
                  trailing: Text(
                    '₺${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                );
              },
            ),
          ),
          CartSummary(totalAmount: totalAmount),
        ],
      ),
    );
  }
}
