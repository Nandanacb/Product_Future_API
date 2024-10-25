import 'package:flutter/material.dart';
import 'package:product_future_api/datamodel.dart';

class ApiDemo extends StatelessWidget {
  final Product product;
  const ApiDemo({required this.product});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details API "),
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(product.thumbnail),
            Text("Name:${product.title}"),
            Text('price:\$${product.price.toString()}'),
          ],
        ),
      ),
    );
  }
}
