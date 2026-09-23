import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:remote_data_kit/remote_data_kit.dart';

import 'models/product.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'remote_data_kit example',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: const ProductsPage(),
    );
  }
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final DioGetClient _client;

  List<Product> _products = [];
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _client = DioGetClient(Dio());
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final result = await _client.get<List<Product>>(
      'https://fakestoreapi.com/products',
      mapper: (data) => asJsonList(data).map((product) => Product.fromJson(product)).toList(),
    );

    if (!mounted) {
      return;
    }

    switch (result) {
      case Success<List<Product>>(:final value):
        setState(() {
          _products = value;
          _error = null;
          _isLoading = false;
        });

      case Failure<List<Product>>(:final message):
        setState(() {
          _error = message;
          _isLoading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(_error!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _isLoading = true);
                    _loadProducts();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Image.network(
                    product.image,
                    width: 90,
                    height: 90,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        width: 90,
                        height: 90,
                        child: Icon(Icons.image_not_supported_outlined, size: 40),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('\$${product.price.toStringAsFixed(2)}'),
                        Text(product.category),
                        Text('⭐ ${product.rating.rate} (${product.rating.count})'),
                      ],
                    ),
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
