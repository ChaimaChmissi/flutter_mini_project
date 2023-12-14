import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrdersPage extends StatefulWidget {
  final List<dynamic> orders;

  const OrdersPage({Key? key, required this.orders}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: widget.orders.isEmpty
          ? Center(child: Text('No orders for this profile.'))
          : ListView.builder(
              itemCount: widget.orders.length,
              itemBuilder: (context, index) {
                final order = widget.orders[index];

                if (order is List) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: order
                        .map<Widget>((item) => _buildOrderItemTile(item))
                        .toList(),
                  );
                } else {
                  return _buildOrderItemTile(order);
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddOrderForm(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildOrderItemTile(Map<String, dynamic> item) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(item['name']),
        subtitle: Text('Quantity: ${item['quantity']}'),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            item['photo'],
            width: 56.0,
            height: 56.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _showAddOrderForm(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    TextEditingController photoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Order'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: photoController,
                decoration: InputDecoration(labelText: 'Photo URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    quantityController.text.isEmpty ||
                    photoController.text.isEmpty) {
                  return; // Show an error message or handle validation as needed
                }

                Map<String, dynamic> newOrder = {
                  'name': nameController.text,
                  'quantity': int.parse(quantityController.text),
                  'photo': photoController.text,
                };

                await _addOrder(newOrder);

                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addOrder(Map<String, dynamic> newOrder) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newOrder),
    );

    if (response.statusCode == 201) {
    } else {
      print('Failed to add order. Status code: ${response.statusCode}');
    }
  }
}
