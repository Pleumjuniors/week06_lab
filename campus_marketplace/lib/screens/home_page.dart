import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../models/item.dart';
import '../repositories/item_repository.dart';
import 'checkout_page.dart';

class HomePage extends StatefulWidget {
  final ItemRepository repository;
  const HomePage({super.key, required this.repository});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Item>> _itemsFuture;
  @override
  void initState() { super.initState(); _itemsFuture = widget.repository.getItems(); }
  void _retry() => setState(() => _itemsFuture = widget.repository.getItems());

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Campus Marketplace'), actions: [
      IconButton(
        icon: Badge(label: Text('${context.watch<CartModel>().itemCount}'), child: const Icon(Icons.shopping_cart)),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutPage())),
      ),
    ]),
    body: FutureBuilder<List<Item>>(
      future: _itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('${snapshot.error}'.replaceFirst('Exception: ', '')), const SizedBox(height: 8),
          FilledButton(onPressed: _retry, child: const Text('ลองใหม่')),
        ]));
        final items = snapshot.data ?? [];
        if (items.isEmpty) return const Center(child: Text('ไม่พบสินค้า'));
        return ListView.builder(
          padding: const EdgeInsets.all(12), itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [
              SizedBox(width: 80, height: 80, child: Image.network(item.imageUrl, fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(item.category), Text('\$${item.price.toStringAsFixed(2)}'),
                Align(alignment: Alignment.centerRight, child: FilledButton.icon(
                  onPressed: () { context.read<CartModel>().add(item); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('เพิ่มลงตะกร้าแล้ว'))); },
                  icon: const Icon(Icons.add_shopping_cart), label: const Text('เพิ่มลงตะกร้า'),
                )),
              ])),
            ])));
          },
        );
      },
    ),
  );
}

