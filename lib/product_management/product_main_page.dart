import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'product_form_page/product_edit_page.dart';
import 'product_form_page/product_create_page.dart';
import 'product_model/product_data_model.dart';

class ProductMainPage extends StatefulWidget {
  const ProductMainPage({super.key});

  @override
  State<ProductMainPage> createState() => _ProductMainPageState();
}

class _ProductMainPageState extends State<ProductMainPage> {
  bool isLoaded = true;
  List<Product> product = [];

  Future<void> fetchData() async {
    try {
      var response =
          await http.get(Uri.parse('http://localhost:8001/products'));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        setState(() {
          product = jsonList.map((item) => Product.fromJson(item)).toList();
          isLoaded = true;
        });
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey[900],
      ),
      backgroundColor: Colors.grey[200],
      body: isLoaded
          ? ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: product.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey,
                      child: Text(
                        product[index].id.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      ' ${product[index].name}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${product[index].description}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '฿${product[index].price}',
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.grey),
                          onPressed: () async {
                            bool? isUpdated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductEditPage(
                                    productId: product[index].id.toString()),
                              ),
                            );
                            if (isUpdated == true) {
                              fetchData();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              })
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? isUpdated = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductFormPage()),
          );
          if (isUpdated == true) {
            fetchData();
          }
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
