import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_future_api/datamodel.dart';
import 'package:product_future_api/details.dart';
import 'package:product_future_api/whislist.dart';

class Api extends StatefulWidget {
  const Api({super.key});
  @override
  State<Api> createState() => _ApiState();
}

class _ApiState extends State<Api> {
  late Future<ProductmodelApi?> futureData;
  @override
  void initState() {
    super.initState();
    futureData = getData();
  }

  Future<ProductmodelApi?> getData() async {
    try {
      String url = "https://dummyjson.com/products";
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        return ProductmodelApi.fromJson(json.decode(res.body));
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product API Examples"),
      ),
      body: FutureBuilder<ProductmodelApi?>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error:${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data != null) {
              final products = snapshot.data!.products;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ApiDemo(
                                        product: product,
                                      )));
                        },
                        child: Container(
                          height: 600,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromARGB(255, 70, 8, 3))),
                          child: Center(
                            child: Column(
                              children: [
                                Image.network(product.thumbnail,
                                    width: double.infinity, height: 62),
                                Text(product.title),
                                Text("\$${product.price.toString()}"),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WhishlistDemo(
                                                        product: product,
                                                      )));
                                        },
                                        child: Icon(
                                            Icons.favorite_border_outlined))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return Center(child: Text("No data available"));
            }
          }),
    );
  }
}
