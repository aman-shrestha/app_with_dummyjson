import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskThree extends StatefulWidget {
  const TaskThree({super.key});

  @override
  State<TaskThree> createState() => _TaskThreeState();
}

class _TaskThreeState extends State<TaskThree> {
  Map<String, dynamic> _data = {};
  List<String> _dates = [];
  List<String> _parameters = [];

  Map<String, dynamic> _data2 = {};
  List<String> _dates2 = [];
  List<String> _parameters2 = [];

  // FETCH CONTENTS FROM THE JSON FILE
  Future<void> readJson() async {
    try {
      final String response = await rootBundle.loadString('assets/dummy_data.json');
      final Map<String, dynamic> data = json.decode(response);

      setState(() {
        _data = data;
        _dates = data.keys.toList();
        if (_dates.isNotEmpty) {
          _parameters = data[_dates[0]].keys.toList();
        }
      });
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

  // CONVERT DATA TO NEW FORMAT
  Future<void> convertJson() async {
    if (_data.isEmpty) {
      print('No data to convert.');
      return;
    }

    try {
      final List<String> dates = _data.keys.toList();
      final List<String> parameters = _data[dates[0]]?.keys.toList() ?? [];

      final Map<String, dynamic> transformedData = {
        'dates': parameters,  // New list of dates (old parameters)
        'parameters': dates,  // New list of parameters (old dates)
        'data': {
          for (var parameter in parameters)
            parameter: {
              for (var date in dates)
                date: _data[date][parameter] ?? 'N/A'  // Handle missing data
            }
        }
      };

      setState(() {
        _data2 = transformedData;
        _dates2 = transformedData['dates'] ?? [];
        _parameters2 = transformedData['parameters'] ?? [];
      });

      print("Data converted and saved to _data2");
    } catch (e) {
      print("Error converting data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task 3"),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              await readJson();
              await convertJson();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "SHOW DATA",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (_data2.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
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
                          ..._dates2.map((date) => TableCell(child: Center(child: Text(date, style: TextStyle(fontWeight: FontWeight.bold))))),
                        ],
                      ),
                      // Data Rows
                      ..._parameters2.map((parameter) {
                        return TableRow(
                          children: [
                            TableCell(child: Center(child: Text(parameter))),
                            ..._dates2.map((date) {
                              return TableCell(child: Center(child: Text(_data2['data'][parameter]?[date]?.toString() ?? 'N/A')));
                            }),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
