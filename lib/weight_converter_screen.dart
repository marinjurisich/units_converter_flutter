import 'dart:ffi';

import 'package:flutter/material.dart';

class WeightConverterScreen extends StatefulWidget {
  @override
  _WeightConverterScreenState createState() => _WeightConverterScreenState();
}

class _WeightConverterScreenState extends State<WeightConverterScreen> {
  TextEditingController _inputValueController = TextEditingController();
  TextEditingController _outputValueController = TextEditingController();

  List<String> metricUnits = ['Kilograms', 'Decagrams', 'Tons', 'Grams'];
  List<String> imperialUnits = [
    'Pounds',
    'Ounces',
    'Stone',
  ];
  Map<String, double> metricUnitsMap = {
    'Kilograms': 1,
    'Decagrams': 0.01,
    'Tons': 1000,
    'Grams': 0.001
  };
  Map<String, double> imperialUnitsMap = {
    'Pounds': 2.20462262,
    'Ounces': 35.2739619,
    'Stone': 0.157473044
  };
  String fromUnit = 'Kilograms';
  String toUnit = 'Pounds';
  bool reverse = false;

  void switchUnits() {
    setState(() {
      if (reverse) {
        reverse = false;
      } else {
        reverse = true;
      }
    });
  }

  void calculate() {
    double inputValue = double.tryParse(_inputValueController.text) ?? 0.0;
    double inputUnit = metricUnitsMap[fromUnit]!;
    double outputUnit = imperialUnitsMap[toUnit]!;

    if (reverse) {
      double calculatedOutputValue = inputValue * inputUnit * outputUnit;
      calculatedOutputValue = 1 / calculatedOutputValue;
      _outputValueController.text = calculatedOutputValue.toStringAsFixed(2);
    } else {
      double calculatedOutputValue = inputValue * inputUnit * outputUnit;
      _outputValueController.text = calculatedOutputValue.toStringAsFixed(2);
    }
  }

  Widget metricDropdown() {
    return Expanded(
      child: Container(
        child: DropdownButton<String>(
          padding: EdgeInsets.only(top: 42),
          value: fromUnit,
          onChanged: (String? newValue) {
            setState(() {
              fromUnit = newValue!;
            });
          },
          items: metricUnits.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget imperialDropdown() {
    return Expanded(
      child: DropdownButton<String>(
        padding: EdgeInsets.only(top: 42),
        value: toUnit,
        onChanged: (String? newValue) {
          setState(() {
            toUnit = newValue!;
          });
        },
        items: imperialUnits.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Converter'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Convert:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: _inputValueController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Value',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                reverse ? imperialDropdown() : metricDropdown()
              ],
            ),
            SizedBox(height: 20),
            Text('To:'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _outputValueController,
                    readOnly: true,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Result',
                    ),
                  ),
                ),
                SizedBox(width: 20),
                reverse ? metricDropdown() : imperialDropdown()
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: calculate,
                  child: Text('Calculate'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: switchUnits,
                  child: Text('Switch Units'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
