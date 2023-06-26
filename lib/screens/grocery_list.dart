import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item.dart';
import 'package:http/http.dart' as http;

typedef IndexCallBack = void Function(int id);

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  void navigateToAddScreen() async {
    final groceryItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (_) => const NewItem(),
      ),
    );
    if (groceryItem != null) {
      setState(() {
        _groceryItems.add(groceryItem);
      });
    }
  }

  void removeItem(index) {
    setState(() {
      _groceryItems.removeAt(index);
    });
  }

  void _loadItems() async {
    final url = Uri.parse(
      'https://flutter-shopping-list-c0010-default-rtdb.asia-southeast1.firebasedatabase.app/shopping-list.json',
    );
    final response = await http.get(
      url,
    );
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    for (final item in listData.entries) {
      final cat = categories.entries.firstWhere(
          (catItem) => catItem.value.title == item.value['category']);

      loadedItems.add(
        GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: cat.value),
      );
    }

    setState(() {
      _groceryItems = loadedItems;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your groceries'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddScreen,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: _groceryItems.isEmpty
            ? const Center(
                child: Text('No Item to show'),
              )
            : ListView.builder(
                itemCount: _groceryItems.length,
                itemBuilder: (context, index) => GroceryListItem(
                  groceryItem: _groceryItems[index],
                  itemIndex: index,
                  deletedItemIndex: (id) => removeItem(id),
                ),
              ),
      ),
    );
  }
}

class GroceryListItem extends StatelessWidget {
  final GroceryItem groceryItem;
  final int itemIndex;
  final IndexCallBack deletedItemIndex;

  const GroceryListItem(
      {super.key,
      required this.groceryItem,
      required this.itemIndex,
      required this.deletedItemIndex});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(itemIndex.toString()),
      background: Container(color: Colors.red),
      onDismissed: (direction) {
        deletedItemIndex(itemIndex);
      },
      child: Padding(
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
      ),
    );
  }
}
