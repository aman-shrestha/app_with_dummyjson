
import 'package:app_with_dummyjson/task_1.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("data"),
        ),
        body: Column(
          children: [
            // _items.isNotEmpty
            //     ?
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: _items.length,
            //     itemBuilder: (context, index) => Card(
            //       // key: ValueKey(_items[index]["id"]),
            //       child: ListTile(
            //         leading: Text(_items[index]["id"]),
            //         title: Text(_items[index]["name"]),
            //         subtitle: Text(_items[index]["description"]),
            //       ),
            //     ),
            //   ),
            // ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskOne()),);
              },
              child: Center(
                child: Text("LOAD JSON"),
              ),
            ),
          ],
        ));
  }
}
