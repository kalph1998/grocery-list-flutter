import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item.dart';
import 'package:http/http.dart' as http;

typedef ItemCallBack = void Function(GroceryItem item);

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  bool _isLoading = true;
  String? _error;

  void navigateToAddScreen() async {
    final groceryItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (_) => const NewItem(),
      ),
    );
    if (groceryItem != null) {
      setState(() {
        _groceryItems.add(groceryItem);
        _isLoading = false;
      });
    }
  }

  void _loadItems() async {
    final url = Uri.parse(
      'https://flutter-shopping-list-c0010-default-rtdb.asia-southeast1.firebasedatabase.app/shopping-list.json',
    );

    try {
      final response = await http.get(
        url,
      );

      if (response.body == 'null') {
        setState(() {
          _groceryItems = [];
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final categoryMap = categories.entries.firstWhere(
            (catItem) => catItem.value.title == item.value['category']);
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: categoryMap.value,
          ),
        );
      }

      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      _error = 'something went wrong please try again later';
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadItems();
  }

  void deleteItem(GroceryItem item) async {
    int itemIndex = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    final url = Uri.parse(
      'https://flutter-shopping-list-c0010-default-rtdb.asia-southeast1.firebasedatabase.app/shopping-list/${item.id}.json',
    );
    try {
      await http.delete(url);
      _loadItems();
    } catch (error) {
      _groceryItems.insert(itemIndex, item);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No Item to show'),
    );

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) => GroceryListItem(
          groceryItem: _groceryItems[index],
          removeItem: (GroceryItem item) => deleteItem(item),
        ),
      );
    }

    if (_error != null) {
      print(_error);
      content = Center(
        child: Text(_error!),
      );
    }

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
        child: content,
      ),
    );
  }
}

class GroceryListItem extends StatelessWidget {
  final GroceryItem groceryItem;
  final ItemCallBack removeItem;

  const GroceryListItem({
    super.key,
    required this.groceryItem,
    required this.removeItem,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(groceryItem.id),
      background: Container(color: Colors.red),
      onDismissed: (direction) {
        removeItem(groceryItem);
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
