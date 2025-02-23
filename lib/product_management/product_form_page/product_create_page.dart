import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Future<void> createProduct() async {
    try {
      var response =
          await http.post(Uri.parse("http://localhost:8001/products"),
              headers: {
                "Content-Type": "application/json",
              },
              body: jsonEncode({
                "name": nameController.text,
                "description": descriptionController.text,
                "price": priceController.text
              }));
      if (response.statusCode == 201) {
        // Handle success if needed
      } else {
        throw Exception("Failed to load products");
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
          'Create Product',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                'Product :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 3),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                label: Text(
                  'Product Name',
                  style: TextStyle(color: Color.fromARGB(92, 0, 0, 0)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                // floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                'Description :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 3),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                label: Text(
                  'Description',
                  style: TextStyle(color: Color.fromARGB(92, 0, 0, 0)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                //floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                'Price :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 3),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                label: Text(
                  'Price',
                  style: TextStyle(color: Color.fromARGB(92, 0, 0, 0)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                //floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            Container(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: () async {
                  await createProduct();
                  Navigator.pop(context, true);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Create Success!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 119, 170, 113), // Fresh Green
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, color: Colors.white), // Checkmark Icon
                    SizedBox(width: 3),
                    Text(
                      'Create',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
