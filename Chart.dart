import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vongola/database/db_manage.dart'; // ปรับให้เข้ากับโปรเจคของคุณ
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Donut_Chart.dart'; // ปรับให้เข้ากับโปรเจคของคุณ
import 'Custom.dart'; // นำเข้าไฟล์ CustomDatePicker

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}
class _ChartPageState extends State<ChartPage> {
  String selectedPeriod = 'Day';
  DateTime currentDate = DateTime.now();
  String? selectedDate;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentDate();
    });
  }

  void _scrollToCurrentDate() {
    // เลื่อนตำแหน่งไปที่วันปัจจุบัน
    if (selectedPeriod == 'Day') {
      _scrollController.animateTo(
        100.0 * 14, // ขนาดของแต่ละ item * index ของวันที่ปัจจุบัน
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (selectedPeriod == 'Month') {
      _scrollController.animateTo(
        100.0 * 11, // ขนาดของแต่ละ item * index ของเดือนปัจจุบัน
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (selectedPeriod == 'Year') {
      _scrollController.animateTo(
        100.0 * 4, // ขนาดของแต่ละ item * index ของปีปัจจุบัน
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Chart')),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) async {
              if (value == 'Costom') {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomDatePicker(
                      onDateSelected: (startDate, endDate) {
                        setState(() {
                          selectedStartDate = startDate;
                          selectedEndDate = endDate;
                          selectedDate =
                          '${DateFormat('yyyy-MM-dd').format(startDate)} - ${DateFormat('yyyy-MM-dd').format(endDate)}';
                        });
                      },
                    ),
                  ),
                );
              } else {
                setState(() {
                  selectedPeriod = value;
                  selectedDate = null;
                  if (selectedPeriod == 'Day') {
                    selectedDate = DateFormat('yyyy-MM-dd').format(currentDate);
                  } else if (selectedPeriod == 'Month') {
                    selectedDate =
                        DateFormat('yyyy-MM').format(DateTime(currentDate.year, currentDate.month));
                  } else if (selectedPeriod == 'Year') {
                    selectedDate = currentDate.year.toString();
                  }
                });
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: 'Day', child: Text('Day')),
                PopupMenuItem(value: 'Month', child: Text('Month')),
                PopupMenuItem(value: 'Year', child: Text('Year')),
                //PopupMenuItem(value: 'Costom', child: Text('Custom')),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (selectedPeriod == 'Day') ...[
            Container(
              height: 80,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: 15, // 14 days before + 1 current day
                itemBuilder: (context, index) {
                  DateTime date = currentDate.subtract(Duration(days: 14 - index));
                  bool isSelected = selectedDate == DateFormat('yyyy-MM-dd').format(date);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = DateFormat('yyyy-MM-dd').format(date);
                      });
                    },
                    child: Container(
                      width: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected ? Colors.pink[200] : Colors.pink[300],
                      ),
                      child: Text(
                        DateFormat('MMM d').format(date),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else if (selectedPeriod == 'Month') ...[
            Container(
              height: 80,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: 15, // 14 เดือนที่ผ่านมา + 1 เดือนปัจจุบัน
                itemBuilder: (context, index) {
                  DateTime monthDate = DateTime(currentDate.year, currentDate.month - (14 - index));
                  bool isSelected = selectedDate == DateFormat('yyyy-MM').format(monthDate);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = DateFormat('yyyy-MM').format(monthDate);
                      });
                    },
                    child: Container(
                      width: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected ? Colors.greenAccent : Colors.green,
                      ),
                      child: Text(
                        DateFormat('MMM yyyy').format(monthDate),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
        ] else if (selectedPeriod == 'Year') ...[
            Container(
              height: 80,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  int year = currentDate.year - (4 - index);
                  bool isSelected = selectedDate == year.toString();
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = year.toString();
                      });
                    },
                    child: Container(
                      width: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected ? Colors.pink : Colors.pinkAccent,
                      ),
                      child: Text(
                        year.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data found'));
                }
                Map<String, double> dataMap = {};
                for (var item in snapshot.data!) {
                  String type = item['type_transaction'];
                  double amount = item['amount_transaction'];
                  if (dataMap.containsKey(type)) {
                    dataMap[type] = dataMap[type]! + amount;
                  } else {
                    dataMap[type] = amount;
                  }
                }
                return PieChartWidget(dataMap: dataMap);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final db = await openDatabase('transaction.db');
    List<Map<String, dynamic>> results;

    if (selectedPeriod == 'Costom' && selectedStartDate != null && selectedEndDate != null) {
      results = await db.rawQuery(
        'SELECT Transactions.date_user, Transactions.amount_transaction, Type_transaction.type_transaction '
            'FROM Transactions '
            'JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction '
            'WHERE Transactions.date_user BETWEEN ? AND ? AND Transactions.type_expense = 1',
        [
          DateFormat('yyyy-MM-dd').format(selectedStartDate!),
          DateFormat('yyyy-MM-dd').format(selectedEndDate!),
        ],
      );
    } else if (selectedPeriod == 'Day' && selectedDate != null) {
      results = await db.rawQuery(
        'SELECT Transactions.date_user, Transactions.amount_transaction, Type_transaction.type_transaction '
            'FROM Transactions '
            'JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction '
            'WHERE Transactions.date_user LIKE ? AND Transactions.type_expense = 1',
        ['${selectedDate}%'],
      );
    } else if (selectedPeriod == 'Month' && selectedDate != null) {
      results = await db.rawQuery(
        'SELECT Transactions.date_user, Transactions.amount_transaction, Type_transaction.type_transaction '
            'FROM Transactions '
            'JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction '
            'WHERE Transactions.date_user LIKE ? AND Transactions.type_expense = 1',
        ['${selectedDate}%'],
      );
    } else if (selectedPeriod == 'Year' && selectedDate != null) {
      results = await db.rawQuery(
        'SELECT Transactions.date_user, Transactions.amount_transaction, Type_transaction.type_transaction '
            'FROM Transactions '
            'JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction '
            'WHERE strftime("%Y", Transactions.date_user) = ? AND Transactions.type_expense = 1',
        [selectedDate],
      );
    } else {
      results = [];
    }

    return results;
  }
}
