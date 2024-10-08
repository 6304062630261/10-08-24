// pie_chart_widget.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // สำหรับ format currency

class PieChartWidget extends StatelessWidget {
  final Map<String, double> dataMap;

  PieChartWidget({required this.dataMap});

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> pieChartSections = _createPieChartSections();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
            Column(
              children: [
                Container(
                  height: 300,
                  child: PieChart(
                    PieChartData(
                      sections: pieChartSections,
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                _buildIndicator(pieChartSections),
              ],
            ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
  final Map<String, Color> typeToColor = {
    'Food': Colors.blueAccent,
    'Travel expenses': Colors.lightGreenAccent,
    'Water bill': Colors.lightBlueAccent,
    'Electricity bill': Colors.yellow,
    'House cost': Colors.deepOrangeAccent,
    'Car fare': Colors.deepPurpleAccent,
    'Gasoline cost': Colors.orangeAccent,
    'Medical expenses': Colors.indigo,
    'Beauty expenses': Colors.black,
    'Cost of equipment': Colors.blue.shade100,
    'Other': Colors.teal.shade400,


  };
  List<PieChartSectionData> _createPieChartSections() {
    return dataMap.entries.map((entry) {
      return PieChartSectionData(
        //color: Colors.primaries[dataMap.keys.toList().indexOf(entry.key) % Colors.primaries.length],
        color: typeToColor[entry.key] ?? Colors.grey, // ใช้สีจาก typeToColor
        value: entry.value,
        title: entry.key,
        radius: 50,
        showTitle: false,
      );
    }).toList();
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chart',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Show Expenses',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(List<PieChartSectionData> pieChartSections) {
    return Column(
      children: pieChartSections.map((section) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: section.color,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '${section.title.split('\n')[0]}: ${NumberFormat.simpleCurrency().format(section.value)}', // ใช้ NumberFormat สำหรับ currency
              style: TextStyle(fontSize: 16),
            ),
          ],
        );
      }).toList(),
    );
  }
}
