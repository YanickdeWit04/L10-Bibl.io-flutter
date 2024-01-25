import 'package:flutter/material.dart';

void main() => runApp(const CatalogApp());

class CatalogApp extends StatelessWidget {
  const CatalogApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CatalogPage(),
    );
  }
}

class CatalogPage extends StatelessWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog Page'),
      ),
      body: ListView.builder(
        itemCount: catalog.length,
        itemBuilder: (context, index) {
          final item = catalog[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
            onTap: () {
              // You can add navigation or other actions when an item is tapped
              print('Item ${item.name} tapped');
            },
          );
        },
      ),
    );
  }
}

class CatalogItem {
  final String name;
  final double price;

  CatalogItem({required this.name, required this.price});
}

final List<CatalogItem> catalog = [
  CatalogItem(name: 'Item 1', price: 19.99),
  CatalogItem(name: 'Item 2', price: 29.99),
  CatalogItem(name: 'Item 3', price: 39.99),
  CatalogItem(name: 'Item 4', price: 49.99),
  CatalogItem(name: 'Item 5', price: 59.99),
];
