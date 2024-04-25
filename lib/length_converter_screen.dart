import 'dart:ffi';

import 'package:flutter/material.dart';

class LengthConverterScreen extends StatefulWidget {
  @override
  _LengthConverterScreenState createState() => _LengthConverterScreenState();
}

class _LengthConverterScreenState extends State<LengthConverterScreen> {
  TextEditingController _firstValueController = TextEditingController();
  TextEditingController _secondValueController = TextEditingController();

  List<String> metricUnits = [
    'Meters',
    'Centimeters',
    'Kilometers',
    'Milimeters'
  ];
  List<String> imperialUnits = ['Feet', 'Inches', 'Miles', 'Yards'];
  Map<String, double> metricUnitsMap = {
    'Meters': 1,
    'Centimeters': 0.01,
    'Kilometers': 1000,
    'Milimeters': 0.001
  };
  Map<String, double> imperialUnitsMap = {
    'Feet': 3.2808,
    'Inches': 39.3700787,
    'Miles': 0.000621371192,
    'Yards': 1.0936133
  };
  String fromUnit = 'Meters';
  String toUnit = 'Feet';
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
    double inputValue = double.tryParse(_firstValueController.text) ?? 0.0;
    double inputUnit = metricUnitsMap[fromUnit]!;
    double outputUnit = imperialUnitsMap[toUnit]!;

    if (reverse) {
      double calculatedOutputValue = inputValue * inputUnit * outputUnit;
      calculatedOutputValue = 1 / calculatedOutputValue;
      _secondValueController.text = calculatedOutputValue.toStringAsFixed(2);
    } else {
      double calculatedOutputValue = inputValue * inputUnit * outputUnit;
      _secondValueController.text = calculatedOutputValue.toStringAsFixed(2);
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
        title: Text('Length Converter'),
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
                      controller: _firstValueController,
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
                    controller: _secondValueController,
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
