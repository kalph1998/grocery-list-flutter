import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/models/grocery_item.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your groceries'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (context, index) =>
              GroceryListItem(groceryItem: groceryItems[index]),
        ),
      ),
    );
  }
}

class GroceryListItem extends StatelessWidget {
  final GroceryItem groceryItem;
  const GroceryListItem({super.key, required this.groceryItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: groceryItem.category.color,
          ),
          const SizedBox(width: 20),
          Text(
            groceryItem.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(
            groceryItem.quantity.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
