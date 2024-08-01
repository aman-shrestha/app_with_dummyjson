import 'dart:convert';
import 'package:app_with_dummyjson/task_3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskOne extends StatefulWidget {
  const TaskOne({super.key});

  @override
  State<TaskOne> createState() => _TaskOneState();
}

class _TaskOneState extends State<TaskOne> {
  // Map<String, dynamic> _data = {};
  // List<String> _dates = [];
  // List<String> _parameters = [];
  //
  // // FETCH CONTENTS FROM THE JSON FILE
  // Future<void> readJson() async {
  //   final String response = await rootBundle.loadString('assets/dummy_data.json');
  //   final Map<String, dynamic> data = json.decode(response);
  //   setState(() {
  //     _data = data;
  //     _dates = data.keys.toList();
  //     if (_dates.isNotEmpty) {
  //       _parameters = data[_dates[0]].keys.toList();
  //     }
  //   });
  // }
  Map<String, dynamic> _data = {};
  List<String> _dates = [];
  List<String> _parameters = [];

  Map<String, dynamic> _data2 = {};
  List<String> _dates2 = [];
  List<String> _parameters2 = [];

  // FETCH CONTENTS FROM THE JSON FILE
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/dummy_data.json');
    final Map<String, dynamic> data = json.decode(response);
    setState(() {
      _data = data;
      _dates = data.keys.toList();
      if (_dates.isNotEmpty) {
        _parameters = data[_dates[0]].keys.toList();
      }
    });
  }

  // CONVERT DATA TO NEW FORMAT
  Future<void> convertJson() async {
    if (_data.isEmpty) {
      print('No data to convert.');
      return;
    }

    // Extract dates and parameters
    final List<String> dates = _data.keys.toList();
    final List<String> parameters = _data[dates[0]].keys.toList();

    // Transform data
    final Map<String, dynamic> transformedData = {
      'dates': parameters,  // New list of dates
      'parameters': dates,  // New list of parameters
      'data': {
        for (var parameter in parameters)
          parameter: {
            for (var date in dates)
              date: _data[date][parameter]
          }
      }
    };

    setState(() {
      _data2 = transformedData;
      _dates2 = transformedData['dates'];
      _parameters2 = transformedData['parameters'];
    });

    print("Data converted and saved to _data2");
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
                        ..._dates.map((date) => TableCell(child: Center(child: Text(_data[date][parameter].toString())))),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskThree()),);},child: Text("CONVERT")),

        ],
      ),
    );
  }
}

