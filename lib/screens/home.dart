import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your groceries'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.amber,
                ),
                SizedBox(width: 20),
                Text(
                  'Milk',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  '1',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
