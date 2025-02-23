import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductEditPage extends StatefulWidget {
  final String productId;

  const ProductEditPage({super.key, required this.productId});

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProduct();
  }

  Future<void> loadProduct() async {
    try {
      var response = await http.get(
        Uri.parse("http://localhost:8001/products/${widget.productId}"),
      );

      if (response.statusCode == 200) {
        var productData = jsonDecode(response.body);
        setState(() {
          nameController.text = productData["name"];
          descriptionController.text = productData["description"];
          priceController.text = productData["price"].toString();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load product");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateProduct() async {
    try {
      var response = await http.put(
        Uri.parse("http://localhost:8001/products/${widget.productId}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": nameController.text,
          "description": descriptionController.text,
          "price": double.tryParse(priceController.text) ?? 0.0,
        }),
      );

      if (response.statusCode == 200) {
        // Handle success
      } else {
        throw Exception("Failed to update product");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteProduct() async {
    try {
      var response = await http.delete(
        Uri.parse("http://localhost:8001/products/${widget.productId}"),
      );

      if (response.statusCode == 200) {
        // Handle success
      } else {
        throw Exception("Failed to delete product");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Product',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[900], // Soft Blue
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Product :',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 3),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Description :',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 3),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Price :',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 3),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 130,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                            await updateProduct();
                            Navigator.pop(context, true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Update Success!'),
                                backgroundColor:
                                    Color(0xFF62ACDB), // Light Blue
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF94CFFF), // Light Blue
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upgrade,
                                color: Colors.white,
                                size: 20,
                              ),
                              Text(
                                "Update",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 130,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text(
                                  'Confirm Deletion',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                                content: const Text(
                                    'Are you sure you want to delete this product?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'Cancel');
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await deleteProduct();
                                      Navigator.pop(context); // Close Dialog
                                      Navigator.pop(context, true); // Go back
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Delete Success!'),
                                          backgroundColor:
                                              Color(0xFFDC0000), // Red
                                        ),
                                      );
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 2),
                              Text(
                                "Delete",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
