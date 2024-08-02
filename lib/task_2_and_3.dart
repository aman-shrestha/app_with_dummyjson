import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskTwoAndThree extends StatefulWidget {
  const TaskTwoAndThree({super.key});

  @override
  State<TaskTwoAndThree> createState() => _TaskTwoAndThreeState();
}

class _TaskTwoAndThreeState extends State<TaskTwoAndThree> {
  Map<String, Map<String, String>> _data = {};
  List<String> _dates = [];
  List<String> _parameters = [];

  // Function to convert dummy_data.json format to dummy_data_2.json format
  Map<String, Map<String, String>> convertJson(List<dynamic> jsonData) {
    Map<String, Map<String, String>> convertedData = {};

    for (var item in jsonData) {
      String parameter = item['name'];
      for (var entry in item['data']) {
        String date = entry['time'];
        String value = entry['value'];

        if (!convertedData.containsKey(date)) {
          convertedData[date] = {};
        }
        convertedData[date]![parameter] = value;
      }
    }

    return convertedData;
  }

  // FETCH CONTENTS FROM THE JSON FILE
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/dummy_data.json');
    final List<dynamic> jsonData = json.decode(response);

    // Convert the JSON data to the desired format
    Map<String, Map<String, String>> parsedData = convertJson(jsonData);
    List<String> dates = parsedData.keys.toList();
    List<String> parameters = jsonData.map((item) => item['name'] as String).toList();

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
        title: Text("Task 2 and 3"),
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
                    // Header Row (dates as first row)
                    TableRow(
                      children: [
                        TableCell(child: Center(child: Text("Date", style: TextStyle(fontWeight: FontWeight.bold)))),
                        ..._parameters.map((parameter) => TableCell(child: Center(child: Text(parameter, style: TextStyle(fontWeight: FontWeight.bold))))),
                      ],
                    ),
                    // Data Rows (each date and its values)
                    ..._dates.map((date) => TableRow(
                      children: [
                        TableCell(child: Center(child: Text(date))),
                        ..._parameters.map((parameter) => TableCell(child: Center(child: Text(_data[date]?[parameter] ?? '-')))),
                      ],
                    )),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
