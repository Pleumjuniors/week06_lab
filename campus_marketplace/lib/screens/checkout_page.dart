import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: cart.items.isEmpty
          ? const Center(child: Text('ตะกร้ายังว่าง'))
          : Column(children: [
              Expanded(child: ListView.builder(itemCount: cart.items.length, itemBuilder: (_, index) {
                final item = cart.items[index];
                return ListTile(
                  leading: Image.network(item.imageUrl, width: 48, errorBuilder: (_, __, ___) => const Icon(Icons.image)),
                  title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                  trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => context.read<CartModel>().removeAt(index)),
                );
              })),
              SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('รวม \$${cart.totalPrice.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
                FilledButton(onPressed: () { cart.clear(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('สั่งซื้อสำเร็จ (ตัวอย่าง)'))); }, child: const Text('ยืนยัน')),
              ]))),
            ]),
    );
  }
}

