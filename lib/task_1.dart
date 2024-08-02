import 'dart:convert';
import 'package:app_with_dummyjson/task_2_and_3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskOne extends StatefulWidget {
  const TaskOne({super.key});

  @override
  State<TaskOne> createState() => _TaskOneState();
}

class _TaskOneState extends State<TaskOne> {
  Map<String, Map<String, String>> _data = {};
  List<String> _dates = [];
  List<String> _parameters = [];

  // FETCH CONTENTS FROM THE JSON FILE
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/dummy_data.json');
    final List<dynamic> jsonData = json.decode(response);

    Map<String, Map<String, String>> parsedData = {};
    List<String> dates = [];
    List<String> parameters = [];

    for (var item in jsonData) {
      String parameter = item['name'];
      parameters.add(parameter);
      for (var entry in item['data']) {
        String date = entry['time'];
        String value = entry['value'];

        if (!dates.contains(date)) {
          dates.add(date);
        }

        if (!parsedData.containsKey(date)) {
          parsedData[date] = {};
        }
        parsedData[date]![parameter] = value;
      }
    }

    setState(() {
      _data = parsedData;
      _dates = dates;
      _parameters = parameters;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task 1"),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              readJson();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "SHOW DATA",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (_data.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  border: TableBorder.all(),
                  defaultColumnWidth: IntrinsicColumnWidth(),
                  children: [
                    // Header Row
                    TableRow(
                      children: [
                        TableCell(child: Center(child: Text("Parameter", style: TextStyle(fontWeight: FontWeight.bold)))),
                        ..._dates.map((date) => TableCell(child: Center(child: Text(date, style: TextStyle(fontWeight: FontWeight.bold))))),
                      ],
                    ),
                    // Data Rows
                    ..._parameters.map((parameter) => TableRow(
                      children: [
                        TableCell(child: Center(child: Text(parameter))),
                        ..._dates.map((date) => TableCell(child: Center(child: Text(_data[date]?[parameter] ?? '-')))),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TaskTwoAndThree()));
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "TASK TWO AND THREE",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
