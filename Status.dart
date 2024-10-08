import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vongola/database/db_manage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Transaction_list.dart';

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  String selectedPeriod = 'Day'; // ตัวแปรสำหรับเก็บค่าตัวเลือก
  DateTime currentDate = DateTime.now(); // วันที่ปัจจุบัน
  String? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateFormat('yyyy-MM-dd').format(currentDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('RECORD')),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                selectedPeriod = value;
                selectedDate = null; // รีเซ็ต selectedDate
                // เซ็ตให้เลือกปุ่มแรกของ GestureDetector
                if (selectedPeriod == 'Day') {
                  selectedDate = DateFormat('yyyy-MM-dd').format(currentDate); // ตั้งค่าเป็นวันที่ปัจจุบัน
                } else if (selectedPeriod == 'Month') {
                  selectedDate = DateFormat('yyyy-MM').format(DateTime(currentDate.year, currentDate.month)); // ตั้งค่าเป็นเดือนปัจจุบัน
                } else if (selectedPeriod == 'Year') {
                  selectedDate = currentDate.year.toString(); // ตั้งค่าเป็นปีปัจจุบัน
                }
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: 'Day', child: Text('Day')),
                PopupMenuItem(value: 'Month', child: Text('Month')),
                PopupMenuItem(value: 'Year', child: Text('Year')),
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
                scrollDirection: Axis.horizontal,
                itemCount: 14,
                reverse: true, // เพิ่มการเลื่อนจากขวาไปซ้าย
                itemBuilder: (context, index) {
                  DateTime date = currentDate.subtract(Duration(days: index));
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
                scrollDirection: Axis.horizontal,
                itemCount: 36,
                reverse: true, // เพิ่มการเลื่อนจากขวาไปซ้าย
                itemBuilder: (context, index) {
                  DateTime monthDate = DateTime(currentDate.year, currentDate.month - index);
                  bool isSelected = selectedDate == DateFormat('yyyy-MM').format(monthDate);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = DateFormat('yyyy-MM').format(monthDate);  // เก็บเดือนที่เลือก
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
                scrollDirection: Axis.horizontal,
                itemCount: 5, // จำนวนปีย้อนหลัง 5 ปี
                reverse: true, // เพิ่มการเลื่อนจากขวาไปซ้าย
                itemBuilder: (context, index) {
                  int year = currentDate.year - index;
                  bool isSelected = selectedDate == year.toString();
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = year.toString(); // เก็บปีที่เลือก
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
                return TransactionList(transactions: snapshot.data!);
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
    print('Selected Date: $selectedDate');

    if (selectedPeriod == 'Day' && selectedDate != null) {
      results = await db.rawQuery(
          'SELECT Transactions.*, Type_transaction.type_transaction '
              'FROM Transactions '
              'JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction '
              'WHERE Transactions.date_user LIKE ?',
          ['${selectedDate}%'] // ใช้ LIKE เพื่อรวมเวลา
      );
    } else if (selectedPeriod == 'Month' && selectedDate != null) {
      results = await db.rawQuery(
          'SELECT Transactions.*, Type_transaction.type_transaction '
              'FROM Transactions '
              'JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction '
              'WHERE Transactions.date_user LIKE ?',
          ['${selectedDate}%']
      );
    } else if (selectedPeriod == 'Year' && selectedDate != null) {
      results = await db.rawQuery(
          'SELECT Transactions.*, Type_transaction.type_transaction '
              'FROM Transactions '
              'JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction '
              'WHERE strftime("%Y", Transactions.date_user) = ?',
          [selectedDate]
      );
    } else {
      results = []; // คืนค่าลิสต์ว่างถ้าไม่มีการเลือก
    }

    for (var row in results) {
      print('Transaction: ${row['ID_type_transaction']}, Date: ${row['date_user']}, Amount: ${row['total_amount']}, Type: ${row['type_transaction']}');
      print('Amount: ${row['amount_transaction'] != null ? row['amount_transaction'] : 0}');
    }
    print(results);
    return results; // คืนค่าผลลัพธ์ที่ได้
  }
}
