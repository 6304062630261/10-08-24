import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vongola/database/db_manage.dart';
import 'package:intl/intl.dart';
import 'package:vongola/window/Page1/pageAddLog.dart';
import 'package:vongola/window/Page2/Chart.dart';
import 'package:vongola/window/Page2/Compare.dart';
import 'package:vongola/window/Page2/Status.dart';
import 'Compare.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<Map<String, dynamic>> selectedDateExpenses = [];
  DateTime? selectedDate;
  Set<DateTime> markedDates = {};
  DateTime? currentSelectedDate;
  final Map<String, String> typeImage = {
    'Food': 'assets/food.png',
    'Travel expenses': 'assets/travel_expenses.png',
    'Water bill': 'assets/water_bill.png',
    'Electricity bill': 'assets/electricity_bill.png',
    'House cost': 'assets/house.png',
    'Car fare': 'assets/car.png',
    'Gasoline cost': 'assets/gasoline_cost.png',
    'Medical expenses': 'assets/medical.png',
    'Beauty expenses': 'assets/beauty.png',
    'Other': 'assets/other.png',
    'IC': 'assets/money.png'
  };


  @override
  void initState() {
    super.initState();
    _fetch_Mark_Dates();
  }

  Future<void> _fetch_Mark_Dates() async {
    final List<Map<String, dynamic>> result = await DatabaseManagement.instance.rawQuery(
        '''
      SELECT DISTINCT DATE(date_user) as date_user 
      FROM Transactions
        '''
    );
    setState(() {
      markedDates =
          result.map((data) => DateTime.parse(data['date_user'])).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text('Dashboard'),
        ),
        elevation: 1.0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: const Color.fromARGB(255, 217, 217, 217),
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.utc(2100, 1, 1),
                  focusedDay: DateTime.now(),
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month'
                  },
                  selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      selectedDate = selectedDay;
                      print("________[ s e l e c t  d a y ]__________");
                      print(selectedDay);
                      DateTime dateOnly = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                      print("Selected date dateonly: $dateOnly");
                      _showDateDetailsDialog(dateOnly);
                    });
                  },

                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      // ตรวจวันที่มีข้อมูล marke
                      if (markedDates.any((markedDate) => markedDate.year == date.year &&
                          markedDate.month == date.month && markedDate.day == date.day)) {
                        return Positioned(
                          bottom: 1,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color.fromARGB(255, 91, 92, 91),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: const Color.fromARGB(255, 90, 216, 255),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 137, 176),
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle: TextStyle(
                      fontSize: 15.0,
                    ),
                    weekendTextStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.red,
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    weekendStyle: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChartPage()), // แก้ชื่อคลาสที่ถูกต้อง
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue, // สีของขอบ
                                  width: 2.0, // ความกว้างของขอบ
                                ),
                                borderRadius: BorderRadius.circular(10), // กำหนดขอบโค้งมน
                              ),
                              padding: EdgeInsets.all(8), // ระยะห่างระหว่างขอบและเนื้อหา
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/pie-chart.png', // ชื่อไฟล์รูปภาพ
                                    width: 80, // ปรับขนาดตามที่ต้องการ
                                    height: 60,
                                  ),
                                  SizedBox(height: 5), // ระยะห่างระหว่างรูปภาพกับข้อความ
                                  Text('CHART'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),


                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Status()), // แก้ชื่อคลาสที่ถูกต้อง
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue, // สีของขอบ
                                  width: 2.0, // ความกว้างของขอบ
                                ),
                                borderRadius: BorderRadius.circular(10), // กำหนดขอบโค้งมน
                              ),
                              padding: EdgeInsets.all(8), // ระยะห่างระหว่างขอบและเนื้อหา
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/notes.png', // ชื่อไฟล์รูปภาพ
                                    width: 80, // ปรับขนาดตามที่ต้องการ
                                    height: 60,
                                  ),
                                  SizedBox(height: 5), // ระยะห่างระหว่างรูปภาพกับข้อความ
                                  Text('RECORD'),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),

                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ComparePage()), // แก้ชื่อคลาสที่ถูกต้อง
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue, // สีของขอบ
                                  width: 2.0, // ความกว้างของขอบ
                                ),
                                borderRadius: BorderRadius.circular(10), // กำหนดขอบโค้งมน
                              ),
                              padding: EdgeInsets.all(8), // ระยะห่างระหว่างขอบและเนื้อหา
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/compare.png', // ชื่อไฟล์รูปภาพ
                                    width: 80, // ปรับขนาดตามที่ต้องการ
                                    height: 60,
                                  ),
                                  SizedBox(height: 5), // ระยะห่างระหว่างรูปภาพกับข้อความ
                                  Text('COMPARE'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )


                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showDateDetailsDialog(DateTime date) async {
    currentSelectedDate = date;
    String dateString = date.toIso8601String().split('T')[0];
    await _fetchcalendarDay(dateString);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height; // เอาความสูงของหน้าจอมาใช้
        return AlertDialog(
          title: Text(DateFormat('dd MMM yyyy').format(date.toLocal())),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: screenHeight *
                  0.7, // จำกัดความสูงของ Dialog
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedDateExpenses.isEmpty)
                      Column(
                        children: [
                          Image.asset(
                            'assets/Zzz.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          Text('No records for this day', style: TextStyle(
                              fontSize: 16)),
                        ],
                      )
                    else
                      ...selectedDateExpenses.map((expense) {
                        String imagetype = 'assets/other.png';
                        if (expense['incomeexpense'] == 0) {
                          imagetype = 'assets/wallet_color.png';
                        } else if (expense['type'] == 'Food' &&
                            expense['incomeexpense'] == 1) {
                          imagetype = 'assets/food.png';
                        } else if (expense['type'] == 'Travel expenses' &&
                            expense['incomeexpense'] == 1) {
                          imagetype = 'assets/travel_expenses.png';
                        } else if (expense['type'] == 'Water bill' &&
                            expense['incomeexpense'] == 1) {
                          imagetype = 'assets/water_bill.png';
                        } else if (expense['type'] == 'Electricity bill' &&
                            expense['incomeexpense'] == 1) {
                          imagetype = 'assets/electricity_bill.png';
                        } else if (expense['type'] == 'House cost' &&
                            expense['incomeexpense'] == 1) {
                          imagetype = 'assets/house.png';
                        } else if (expense['type'] == 'Car fare' &&
                            expense['incomeexpense'] == 1) {
                          imagetype = 'assets/car.png';
                        } else if (expense['type'] == 'Gasoline cost' &&
                            expense['incomeexpense'] == 1) {
                          imagetype = 'assets/gasoline_cost.png';
                        } else if (expense['type'] == 'Medical expenses' &&
                            expense['incomeexpense'] == 1) {
                          imagetype = 'assets/medical.png';
                        } else if (expense['type'] == 'Beauty expenses' &&
                          expense['incomeexpense'] == 1) {
                          imagetype = 'assets/beauty.png';
                        }
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  imagetype,
                                  height: 50,
                                  width: 50,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        expense['incomeexpense'].toString() ==
                                            '0'
                                            ? 'Income'
                                            : '${expense['type']}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Amount: ${
                                            expense['amount']}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Memo: ${expense['memo']}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.edit_note,
                                            color: Colors.blue),
                                        iconSize: 20,
                                        padding: EdgeInsets.all(0),
                                        constraints: BoxConstraints(
                                          minWidth: 30,
                                          minHeight: 30,
                                        ),
                                        onPressed: () {
                                          _showEditExpenseDialog(
                                              expense['ID_transaction_Primary'],
                                                  (amount, memo) {
                                                _updateExpense(
                                                    expense['ID_transaction_Primary'],
                                                    amount, memo);
                                              });
                                        },
                                      ),
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.close_rounded, color: Colors.red),
                                        iconSize: 20,
                                        padding: EdgeInsets.all(0),
                                        constraints: BoxConstraints(
                                          minWidth: 30,
                                          minHeight: 30,
                                        ),
                                        onPressed: () {
                                          _deleteExpense(
                                              expense['ID_transaction_Primary']);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: 10),

                            Divider(
                              color: Colors.grey, // สีเส้นแบ่ง
                              thickness: 0.5,
                            ),


                          ],
                        );
                      }).toList(),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog
              },
              child: Text('ปิด'),
            ),
          ],
        );
      },
    );
  }


  void _showEditExpenseDialog(int id, Function(double, String) onSave) {
    TextEditingController amountController = TextEditingController();
    TextEditingController memoController = TextEditingController();

    var expense = selectedDateExpenses.firstWhere((expense) => expense['ID_transaction_Primary'] == id);
    amountController.text = expense['amount'].toString();
    memoController.text = expense['memo'].toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: memoController,
                decoration: InputDecoration(labelText: 'Memo'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog โดยไม่แก้ไขอะไร
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // อัพเดตข้อมูล expense
                onSave(double.parse(amountController.text),
                    memoController.text); // เรียก onSaveส่งค่ากลับ
                Navigator.of(context).pop();
                Future.delayed(Duration(milliseconds: 100), () {
                  _showDateDetailsDialog(currentSelectedDate!);
                  Navigator.of(context).pop();
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }


  Future<void> _updateExpense(int id, double amount, String memo) async {
    Map<String, dynamic> updatedRow = {
      'ID_transaction': id, // ID ของการทำธุรกรรม
      'amount_transaction': amount, // จำนวนเงินใหม่
      'memo_transaction': memo, //
    };

    await DatabaseManagement.instance.updateTransaction(updatedRow);
    setState(() {
      selectedDateExpenses = selectedDateExpenses.map((expense) {
        if (expense['ID_transaction_Primary'] == id) {
          return {
            ...expense,
            'amount': amount,
            'memo': memo,
          };
        }
        return expense;
      }).toList();
    });
    await _fetch_Mark_Dates();

  }

  Future<void> _deleteExpense(int id) async {
    int deletedCount = await DatabaseManagement.instance.deleteTransaction(id);
    if (deletedCount > 0) {
      print('Deleted successfully!');
      setState(() {
        selectedDateExpenses.removeWhere((expense) => expense['ID'] == id);
      });
      await _fetch_Mark_Dates();
      Navigator.of(context).pop();
      _showDateDetailsDialog(currentSelectedDate!);
    } else {
      print('No data deleted.');
    }
    print('delete ID---------------: $id');
    print(deletedCount);
  }


  Future<void> _fetchcalendarDay(String date) async {
    print("Fetching data for date: $date");
    DateTime startDate = DateTime.parse(date);
    print('startDate');
    print(startDate);
    print('date *********************');
    print(date);

    final List<Map<String, dynamic>> result = await DatabaseManagement.instance
        .rawQuery(
      '''
    SELECT *
      FROM Transactions
      JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction
      WHERE DATE(Transactions.date_user) = '${startDate.year}-${startDate.month
          .toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(
          2, '0')}'
      ''',
    );
    print("__________________");
    print('${startDate.year}-${startDate.month}-${startDate.day}');
    print("__________________");
    print("________result__________");
    print(result);
    setState(() {
      selectedDateExpenses = result.map((data) {
        return {
          'type': data['type_transaction'] ?? '-',
          'amount': data['amount_transaction'] ?? 0.0,
          'memo': data['memo_transaction'] ?? '-',
          'ID': data['ID_type_transaction'] ?? '-',
          'incomeexpense': data['type_expense'] ?? '-',
          'ID_transaction_Primary': data['ID_transaction'] ?? '-',
        };
      }).toList();
    });
  }
}

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:vongola/database/db_manage.dart';
// import 'package:intl/intl.dart';

// class Page2 extends StatefulWidget {
//   @override
//   _Page2State createState() => _Page2State();
// }

// class _Page2State extends State<Page2> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//   String selectedButton = 'Day';
//   String selectedIcon = 'CHART';
//   double totalIncome = 0.0;
//   double totalExpense = 0.0;
//   List<PieChartSectionData> pieChartSections = [];
//   List<Map<String, dynamic>> statusExpenses = [];
//   List<Map<String, dynamic>> selectedDateExpenses = [];
//   DateTime? selectedDate;
//   Set<DateTime> markedDates = {};
//   DateTime? currentSelectedDate;

//   final Map<String, Color> typeToColor = {
//     'Food': Colors.red,
//     'Travel expenses': Colors.lightGreenAccent,
//     'Water bill': Colors.lightBlueAccent,
//     'Electricity bill': Colors.yellow,
//     'House cost': Colors.deepOrangeAccent,
//     'Car fare': Colors.deepPurpleAccent,
//     'Gasoline cost': Colors.orangeAccent,
//     'Medical expenses': Colors.indigo,
//     'Beauty expenses': Colors.pinkAccent,
//     'Cost of equipment': Colors.blue.shade100,
//     'Other': Colors.teal.shade400,
//   };


//   final Map<String, String> typeImage = {
//     'Food': 'assets/food.png',
//     'Travel expenses': 'assets/travel_expenses.png',
//     'Water bill': 'assets/water_bill.png',
//     'Electricity bill': 'assets/electricity_bill.png',
//     'House cost': 'assets/house.png',
//     'Car fare': 'assets/car.png',
//     'Gasoline cost': 'assets/gasoline_cost.png',
//     'Medical expenses': 'assets/medical.png',
//     'Beauty expenses': 'assets/beauty.png',
//     'Other': 'assets/other.png',
//     'IC': 'assets/money.png'
//   };

//   String formatCurrency(double value) {
//     if (value >= 1e6) {
//       return '${(value / 1e6).toStringAsFixed(1)}M'; // Format for millions
//     } else if (value >= 1e3) {
//       return '${(value / 1e3).toStringAsFixed(1)}k'; // Format for thousands
//     }
//     return value.toString(); // Return as is for values less than a thousand
//   }

//   @override
//   void initState() {
//     super.initState();
//     selectedButton = 'Day'; // เริ่มต้นที่ Day
//     selectedIcon = 'CHART'; // เริ่มต้นที่ Pie Chart
//     _show_DonutChart(context); // เรียกใช้ Pie Chart สำหรับ Day
//     _fetch_Mark_Dates();


//   }

//   Future<void> _fetch_Mark_Dates() async {
//     // ดึงข้อมูลวันที่ที่มีการบันทึกจากฐานข้อมูล
//     final List<Map<String, dynamic>> result = await DatabaseManagement.instance
//         .rawQuery(
//         '''
//       SELECT DISTINCT DATE(date_user) as date_user 
//       FROM Transactions
//       '''
//     );

//     setState(() {
//       markedDates =
//           result.map((data) => DateTime.parse(data['date_user'])).toSet();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         title: Center(
//           child: Text('Dashboard'),
//         ),
//         elevation: 1.0,
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(1.0),
//           child: Container(
//             color: const Color.fromARGB(255, 217, 217, 217),
//             height: 1.0,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             children: [
//               SizedBox(height: 5),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 // เพิ่ม Padding ซ้ายและขวา
//                 child: TableCalendar(
//                   firstDay: DateTime.utc(2023, 1, 1),
//                   lastDay: DateTime.utc(2100, 1, 1),
//                   focusedDay: DateTime.now(),
//                   availableCalendarFormats: const {
//                     CalendarFormat.month: 'Month'
//                   },
//                   selectedDayPredicate: (day) => isSameDay(selectedDate, day),
//                   onDaySelected: (selectedDay, focusedDay) {
//                     setState(() {
//                       selectedDate = selectedDay;
//                       print("________[ s e l e c t  d a y ]__________");
//                       print(selectedDay);
//                       DateTime dateOnly = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
//                       print("Selected date dateonly: $dateOnly");
//                       _showDateDetailsDialog(dateOnly);
//                     });
//                   },
//                   // ใช้ CalendarBuilders ในการกำหนดวันที่มีการบันทึก
//                   calendarBuilders: CalendarBuilders(
//                     markerBuilder: (context, date, events) {
//                       // ตรวจสอบวันที่มีข้อมูลใน markedDates
//                       if (markedDates.any((markedDate) =>
//                       markedDate.year == date.year &&
//                           markedDate.month == date.month &&
//                           markedDate.day == date.day)) {
//                         return Positioned(
//                           bottom: 1,
//                           child: Container(
//                             width: 8,
//                             height: 8,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: const Color.fromARGB(255, 91, 92, 91),
//                             ),
//                           ),
//                         );
//                       }
//                       return null; // ถ้าไม่มีข้อมูลในวันนั้น ไม่แสดงสัญลักษณ์
//                     },
//                   ),
//                   headerStyle: HeaderStyle(
//                     formatButtonVisible: false,
//                     titleCentered: true, // ทำให้ชื่อเดือนปีอยู่ตรงกลาง
//                     titleTextStyle: TextStyle(
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   calendarStyle: CalendarStyle(
//                     todayDecoration: BoxDecoration(
//                       color: const Color.fromARGB(255, 90, 216, 255),
//                       shape: BoxShape.circle,
//                     ),
//                     selectedDecoration: BoxDecoration(
//                       color: const Color.fromARGB(255, 255, 137, 176),
//                       shape: BoxShape.circle,
//                     ),
//                     defaultTextStyle: TextStyle(
//                       fontSize: 15.0,
//                     ),
//                     weekendTextStyle: TextStyle(
//                       fontSize: 14.0,
//                       color: Colors.red,
//                     ),
//                   ),
//                   daysOfWeekStyle: DaysOfWeekStyle(
//                     weekdayStyle: TextStyle(
//                       fontSize: 14.0,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                     weekendStyle: TextStyle(
//                       fontSize: 14.0,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),

//               Padding(
//                 padding: const EdgeInsets.only(left: 35, right: 35, top: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildIconButton(
//                       Image.asset(
//                           'assets/pie-chart.png', width: 45, height: 45),
//                       'CHART',
//                       const Color.fromARGB(255, 104, 255, 247),
//                       _show_DonutChart,
//                     ),
//                     _buildIconButton(
//                       Image.asset('assets/notes.png', width: 45, height: 45),
//                       'RECORD',
//                       const Color.fromARGB(255, 142, 255, 134),
//                       _show_Status_Expense,
//                     ),
//                     _buildIconButton(
//                       Image.asset('assets/compare.png', width: 45, height: 45),
//                       'COMPARE',
//                       const Color.fromARGB(255, 255, 188, 88),
//                       _show_BarChart,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),


//               Padding(
//                 padding: const EdgeInsets.only(right: 20.0),
//                 // กำหนดให้ห่างจากขอบขวา 20
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end, // จัดปุ่มไปทางขวา
//                   children: [
//                     _buildPeriodButton('Day'),
//                     SizedBox(width: 0),
//                     // ระยะห่างระหว่างปุ่ม
//                     _buildPeriodButton('Month'),
//                     SizedBox(width: 0), // ระยะห่างระหว่างปุ่ม
//                     _buildPeriodButton('Year'),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 20),
//               if (selectedIcon == 'CHART') _build_DonutChart(),
//               if (selectedIcon == 'RECORD') _build_StatusList(),
//               if (selectedIcon == 'COMPARE') _build_BarChart(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildIconButton(Widget iconWidget, String iconType, Color color, Function onPressed) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedIcon = iconType;
//         });
//         onPressed(context);
//       },
//       child: Container(
//         width: 85,
//         height: 100,
//         decoration: BoxDecoration(
//           color: selectedIcon == iconType ? color.withOpacity(0.2) : Colors.transparent,
//           border: Border.all(color: Colors.black26, width: 1.5),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center, // จัดกลางในแนวตั้ง
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               iconType,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//               ),
//               textAlign: TextAlign.center, // จัดกลางข้อความ
//             ),
//             SizedBox(height: 8),
//             iconWidget,
//         ],
//         ),
//       ),
//     );
//   }


//   TextButton _buildPeriodButton(String label) {
//     return TextButton(
//       onPressed: () {
//         setState(() {
//           selectedButton = label;
//           print(label);
//           print(selectedIcon);
//         });
//         if (selectedIcon == 'CHART') {
//           _show_DonutChart(context);
//         } else if (selectedIcon == 'RECORD') {
//           _show_Status_Expense(context);
//         } else if (selectedIcon == 'COMPARE') {
//           _show_BarChart(context);
//         }
//       },
//       child: Text(
//         label,
//         style: TextStyle(
//           color: selectedButton == label ? Colors.blue : Colors.black,
//           fontWeight: selectedButton == label ? FontWeight.bold : FontWeight.normal, // เพิ่มความหนาของตัวอักษรเมื่อถูกเลือก
//         ),
//       ),

//     );
//   }

//   Widget _buildIndicator() {
//     return Column(
//       children: pieChartSections.map((section) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Container(
//               width: 20,
//               height: 20,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: section.color,
//               ),
//             ),
//             SizedBox(width: 8),
//             Text(
//               '${section.title.split('\n')[0]}: ${formatCurrency(
//                   section.value)}', // แสดงชื่อและมูลค่า
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         );
//       }).toList(),
//     );
//   }

//   Widget _build_DonutChart() {
//     // ข้อความ Chart และ Show Expenses อยู่ด้านบนก่อน if
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       // กำหนดระยะห่างจากขอบซ้ายและขวา 20
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [

//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Chart',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold, // ทำให้ตัวหนา
//                 ),
//               ),
//               Text(
//                 'Show Expenses',
//                 style: TextStyle(
//                   fontSize: 14, // ขนาดตัวอักษรเล็กกว่า
//                 ),
//               ),
//             ],
//           ),
          
//           if (pieChartSections.isEmpty)
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 50), // เพิ่มระยะห่างจากข้างบน
//                   Image.asset(
//                     'assets/Zzz.png', // ใส่ path รูปภาพที่คุณต้องการ
//                     width: 100,
//                     height: 100,
//                     fit: BoxFit.cover,
//                   ),
//                 ],
//               ),
//             )
//           else
//             Column(
//               children: [
//                 Container(
//                   height: 300,
//                   child: PieChart(
//                     PieChartData(
//                       sections: pieChartSections,
//                       centerSpaceRadius: 40,
//                       sectionsSpace: 2,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 5),
//                 _buildIndicator(), // แสดง Indicator ใต้ Pie Chart
//               ],
//             ),
//           SizedBox(height: 30),
//         ],
//       ),
//     );
//   }

//   Widget _build_BarChart() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Compare',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 'Show Expenses & Income',
//                 style: TextStyle(
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 30),
//           if (totalIncome == 0.0 && totalExpense == 0.0)
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 50),
//                   Image.asset(
//                     'assets/Zzz.png',
//                     width: 100,
//                     height: 100,
//                     fit: BoxFit.cover,
//                   ),
//                 ],
//               ),
//             )
//           else
//             Column(
//               children: [
//                 Container(
//                   height: 300,
//                   width: 300,
//                   child: BarChart(
//                     BarChartData(
//                       borderData: FlBorderData(
//                         show: true,
//                         border: Border(
//                           bottom: BorderSide(color: Colors.black, width: 1),
//                           left: BorderSide(color: Colors.transparent, width: 0),
//                           right: BorderSide(color: Colors.transparent, width: 0),
//                           top: BorderSide(color: Colors.transparent, width: 10),
//                         ),
//                       ),
//                       barGroups: [
//                         BarChartGroupData(
//                           x: 1,
//                           barRods: [
//                             BarChartRodData(
//                               toY: totalExpense,
//                               width: 30,
//                               color: Colors.red,
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(10),
//                                 topRight: Radius.circular(10),
//                                 bottomLeft: Radius.circular(0),
//                                 bottomRight: Radius.circular(0),
//                               ),
//                             ),
//                           ],
//                         ),
//                         BarChartGroupData(
//                           x: 0,
//                           barRods: [
//                             BarChartRodData(
//                               toY: totalIncome,
//                               width: 30,
//                               color: Colors.green,
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(10),
//                                 topRight: Radius.circular(10),
//                                 bottomLeft: Radius.circular(0),
//                                 bottomRight: Radius.circular(0),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: '- ${formatCurrency(totalExpense)}฿',
//                             style: TextStyle(fontSize: 20, color: Colors.red),
//                           ),
//                         ],
//                       ),
//                     ),
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: '+ ${formatCurrency(totalIncome)}฿',
//                             style: TextStyle(fontSize: 20, color: Colors.green),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           SizedBox(height: 30),
//         ],
//       ),
//     );
//   }

//   Widget _build_StatusList() {
//     double totalIncome_Status = 0;
//     double totalExpense_Status = 0;

//     // คำนวณรายรับและรายจ่ายทั้งหมด
//     statusExpenses.forEach((transaction) {
//       if (transaction['isExpense']) {
//         totalExpense_Status += transaction['amount'];
//       } else {
//         totalIncome_Status += transaction['amount'];
//       }
//     });

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Record',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 'Show Income And Expense Records',
//                 style: TextStyle(
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 20),

//           // ส่วนแสดงยอดรวม Income และ Expenses
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Income', style: TextStyle(color: Colors.green)),
//               Text('${formatCurrency(totalIncome_Status)} THB', style: TextStyle(color: Colors.green)),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Expenses', style: TextStyle(color: Colors.red)),
//               Text('${formatCurrency(totalExpense_Status)} THB', style: TextStyle(color: Colors.red)),
//             ],
//           ),
//           SizedBox(height: 30),

//           if (statusExpenses.isEmpty)
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 50),
//                   Image.asset(
//                     'assets/Zzz.png',
//                     width: 100,
//                     height: 100,
//                     fit: BoxFit.cover,
//                   ),
//                 ],
//               ),
//             )
//           else
//             ListView.builder(
//               shrinkWrap: true,
//               itemCount: statusExpenses.length,
//               itemBuilder: (context, index) {
//                 final transaction = statusExpenses[index];
//                 final type = transaction['type'];
//                 final imagePath = typeImage[type] ?? 'assets/other.png';
//                 final amount = formatCurrency(transaction['amount']);
//                 final isExpense = transaction['isExpense'];
//                 final amountText = isExpense ? '-$amount THB' : '+$amount THB';
//                 final amountColor = isExpense ? Colors.red : Colors.green;

//                 return ListTile(
//                   leading: Image.asset(
//                     imagePath,
//                     width: 35,
//                     height: 35,
//                     fit: BoxFit.cover,
//                   ),
//                   title: Text(type == 'IC' ? 'Income' : type),
//                   trailing: Text(
//                     amountText,
//                     style: TextStyle(
//                       color: amountColor,
//                       fontSize: 14,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           SizedBox(height: 30),
//         ],
//       ),
//     );
//   }

//   void _showDateDetailsDialog(DateTime date) async {
//     currentSelectedDate = date;
//     String dateString = date.toIso8601String().split('T')[0];


//     await _fetchcalendarDay(dateString);
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         final screenHeight = MediaQuery
//             .of(context)
//             .size
//             .height; // เอาความสูงของหน้าจอมาใช้
//         return AlertDialog(
//           title: Text(DateFormat('dd MMM yyyy').format(date.toLocal())),
//           content: ConstrainedBox(
//             constraints: BoxConstraints(
//               maxHeight: screenHeight *
//                   0.7, // จำกัดความสูงของ Dialog ไม่เกิน 70% ของหน้าจอ
//             ),
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10.0),
//                 // ระยะห่างแนวตั้ง
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (selectedDateExpenses.isEmpty)
//                       Column(
//                         children: [
//                           Image.asset(
//                             'assets/Zzz.png',
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ),
//                           Text('No records for this day', style: TextStyle(
//                               fontSize: 16)),
//                         ],
//                       )
//                     else
//                       ...selectedDateExpenses.map((expense) {
//                         String imagetype = 'assets/other.png';

//                         // เลือกภาพที่เหมาะสมตามประเภท
//                         if (expense['incomeexpense'] == 0) {
//                           imagetype =
//                           'assets/wallet_color.png'; // สำหรับ income
//                         } else if (expense['type'] == 'Food' &&
//                             expense['incomeexpense'] == 1) {
//                           imagetype =
//                           'assets/food.png'; // สำหรับ expense ประเภท Food
//                         } else if (expense['type'] == 'Travel expenses' &&
//                             expense['incomeexpense'] == 1) {
//                           imagetype = 'assets/travel_expenses.png';
//                         } else if (expense['type'] == 'Water bill' &&
//                             expense['incomeexpense'] == 1) {
//                           imagetype = 'assets/water_bill.png';
//                         } else if (expense['type'] == 'Electricity bill' &&
//                             expense['incomeexpense'] == 1) {
//                           imagetype = 'assets/electricity_bill.png';
//                         } else if (expense['type'] == 'House cost' &&
//                             expense['incomeexpense'] == 1) {
//                           imagetype = 'assets/house.png';
//                         } else if (expense['type'] == 'Car fare' &&
//                             expense['incomeexpense'] == 1) {
//                           imagetype = 'assets/car.png';
//                         } else if (expense['type'] == 'Gasoline cost' &&
//                             expense['incomeexpense'] == 1) {
//                           imagetype = 'assets/gasoline_cost.png';
//                         } else if (expense['type'] == 'Medical expenses' &&
//                             expense['incomeexpense'] == 1) {
//                           imagetype = 'assets/medical.png';
//                         }
//                         return Column(
//                           children: [
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               // ทำให้ข้อมูลอยู่กึ่งกลางระหว่างไอคอน
//                               children: [
//                                 // รูปภาพประเภท
//                                 Image.asset(
//                                   imagetype,
//                                   height: 50,
//                                   width: 50,
//                                 ),
//                                 SizedBox(width: 10),
//                                 // ระยะห่างระหว่างรูปกับข้อมูล

//                                 // ข้อมูลรายการ
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment
//                                         .start,
//                                     children: [
//                                       Text(
//                                         expense['incomeexpense'].toString() ==
//                                             '0'
//                                             ? 'Income'
//                                             : '${expense['type']}',
//                                         maxLines: 1,
//                                         // จำกัดบรรทัดให้แสดงได้ไม่เกิน 1 บรรทัด
//                                         overflow: TextOverflow
//                                             .ellipsis, // ถ้ายาวเกิน จะแสดง ...
//                                       ),
//                                       Text(
//                                         'Amount: ${formatCurrency(
//                                             expense['amount'])}',
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                       Text(
//                                         'Memo: ${expense['memo']}',
//                                         maxLines: 2,
//                                         // จำกัดบรรทัดให้อยู่ใน 2 บรรทัด
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ],
//                                   ),
//                                 ),

//                                 // ไอคอนแก้ไขและลบ
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   // จัดแนวกลางในแนวตั้ง
//                                   children: [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.blue.withOpacity(0.1),
//                                         // กำหนดสีพื้นหลัง พร้อมปรับความโปร่งใส
//                                         shape: BoxShape
//                                             .circle, // ทำให้เป็นรูปวงกลม
//                                       ),
//                                       child: IconButton(
//                                         icon: Icon(Icons.edit_note,
//                                             color: Colors.blue),
//                                         iconSize: 20,
//                                         padding: EdgeInsets.all(0),
//                                         constraints: BoxConstraints(
//                                           minWidth: 30,
//                                           minHeight: 30,
//                                         ),
//                                         onPressed: () {
//                                           _showEditExpenseDialog(
//                                               expense['ID_transaction_Primary'], (
//                                               amount, memo) {
//                                             _updateExpense(
//                                                 expense['ID_transaction_Primary'],
//                                                 amount, memo);
//                                           });
//                                         },
//                                       ),
//                                     ),

//                                     Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.red.withOpacity(0.1),
//                                         // กำหนดสีพื้นหลัง (โปร่งใส)
//                                         shape: BoxShape
//                                             .circle, // ทำให้เป็นรูปวงกลม
//                                       ),
//                                       child: IconButton(
//                                         icon: Icon(Icons.close_rounded,
//                                             color: Colors.red),
//                                         iconSize: 20,
//                                         // ลดขนาดของไอคอน
//                                         padding: EdgeInsets.all(0),
//                                         // กำหนด padding ของปุ่มให้เป็นศูนย์
//                                         constraints: BoxConstraints(
//                                           minWidth: 30, // กำหนดความกว้างขั้นต่ำ
//                                           minHeight: 30, // กำหนดความสูงขั้นต่ำ
//                                         ),
//                                         onPressed: () {
//                                           _deleteExpense(
//                                               expense['ID_transaction_Primary']);
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),

//                             // เพิ่มระยะห่างระหว่างข้อมูลและเส้นแบ่ง
//                             SizedBox(height: 10),
//                             // ระยะห่างระหว่างข้อมูลและเส้นแบ่ง

//                             // เส้นแบ่งระหว่างแต่ละรายการ
//                             Divider(
//                               color: Colors.grey, // สีของเส้นแบ่ง
//                               thickness: 0.5, // ความหนาของเส้น
//                             ),


//                           ],
//                         );
//                       }).toList(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // ปิด Dialog
//               },
//               child: Text('ปิด'),
//             ),
//           ],
//         );
//       },
//     );
//   }


//   void _showEditExpenseDialog(int id, Function(double, String) onSave) {
//     TextEditingController amountController = TextEditingController();
//     TextEditingController memoController = TextEditingController();

//     // ดึงข้อมูลปัจจุบันเพื่อแสดงใน Dialog
//     var expense = selectedDateExpenses.firstWhere((expense) => expense['ID_transaction_Primary'] == id);
//     amountController.text = expense['amount'].toString();
//     memoController.text = expense['memo'].toString();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Edit Expense'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: amountController,
//                 decoration: InputDecoration(labelText: 'Amount'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: memoController,
//                 decoration: InputDecoration(labelText: 'Memo'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // ปิด Dialog โดยไม่แก้ไขอะไร
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // อัพเดตข้อมูล expense ในฐานข้อมูล
//                 onSave(double.parse(amountController.text),
//                     memoController.text); // เรียก onSave เพื่อส่งค่ากลับ
//                 Navigator.of(context).pop(); // ปิด Dialog หลังแก้ไขข้อมูลเสร็จ
//                 // เปิด dialog ใหม่เพื่อแสดงข้อมูลอัพเดต
//                 Future.delayed(Duration(milliseconds: 100), () {
//                   _showDateDetailsDialog(currentSelectedDate!);
//                   Navigator.of(context).pop();
//                 });
//               },
//               child: Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }


//   Future<void> _updateExpense(int id, double amount, String memo) async {
//     Map<String, dynamic> updatedRow = {
//       'ID_transaction': id, // ID ของการทำธุรกรรม
//       'amount_transaction': amount, // จำนวนเงินใหม่
//       'memo_transaction': memo, // หมายเหตุใหม่
//     };

//     await DatabaseManagement.instance.updateTransaction(
//         updatedRow); // เรียกใช้งานอัปเดตด้วย Map
//     setState(() {
//       // อัปเดตข้อมูลในแอพ
//       selectedDateExpenses = selectedDateExpenses.map((expense) {
//         if (expense['ID_transaction_Primary'] ==
//             id) { // ใช้ ID_transaction_Primary แทน
//           return {
//             ...expense,
//             'amount': amount,
//             'memo': memo,
//           };
//         }
//         return expense;
//       }).toList();
//     });
//     await _fetch_Mark_Dates();
//     await _fetch_DonutChart_Day();
//     await _fetch_DonutChart_Month();
//     await _fetch_DonutChart_Year();
//     await _fetch_BarChart_Day();
//     await _fetch_BarChart_Month();
//     await _fetch_BarChart_Year();
//     await _fetch_Status_Day();
//     await _fetch_Status_Month();
//     await _fetch_Status_Year();
//   }

//   Future<void> _deleteExpense(int id) async {
//     int deletedCount = await DatabaseManagement.instance.deleteTransaction(id);

//     if (deletedCount > 0) {
//       print('Deleted successfully!');

//       // อัปเดตลิสต์ selectedDateExpenses
//       setState(() {
//         selectedDateExpenses.removeWhere((expense) => expense['ID'] == id);
//       });
//       await _fetch_Mark_Dates();
//       await _fetch_DonutChart_Day();
//       await _fetch_DonutChart_Month();
//       await _fetch_DonutChart_Year();
//       await _fetch_BarChart_Day();
//       await _fetch_BarChart_Month();
//       await _fetch_BarChart_Year();
//       await _fetch_Status_Day();
//       await _fetch_Status_Month();
//       await _fetch_Status_Year();

//       // ปิด dialog
//       Navigator.of(context).pop();

//       // เปิด dialog ใหม่พร้อมข้อมูลที่อัปเดตแล้ว
//       _showDateDetailsDialog(currentSelectedDate!);
//     } else {
//       print('No data deleted.');
//     }

//     print('Attempting to delete ID---------------: $id');
//     print(deletedCount);
//   }


//   Future<void> _fetchcalendarDay(String date) async {
//     print("Fetching data for date: $date");
//     DateTime startDate = DateTime.parse(date);
//     print('startDate');
//     print(startDate);
//     print('date *********************');
//     print(date);

//     final List<Map<String, dynamic>> result = await DatabaseManagement.instance
//         .rawQuery(
//       '''
//     SELECT *
//       FROM Transactions
//       JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction
//       WHERE DATE(Transactions.date_user) = '${startDate.year}-${startDate.month
//           .toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(
//           2, '0')}'
//       ''',
//     );
//     print("__________________");
//     print('${startDate.year}-${startDate.month}-${startDate.day}');
//     print("__________________");
//     print("________result__________");
//     print(result);
//     setState(() {
//       selectedDateExpenses = result.map((data) {
//         return {
//           'type': data['type_transaction'] ?? '-',
//           'amount': data['amount_transaction'] ?? 0.0,
//           'memo': data['memo_transaction'] ?? '-',
//           'ID': data['ID_type_transaction'] ?? '-',
//           'incomeexpense': data['type_expense'] ?? '-',
//           'ID_transaction_Primary': data['ID_transaction'] ?? '-',
//         };
//       }).toList();
//     });
//   }

//   Future<void> _fetch_DonutChart_Day() async {
//     final List<Map<String, dynamic>> result = await DatabaseManagement.instance
//         .rawQuery(
//         '''
//     SELECT Transactions.ID_type_transaction,
//            SUM(Transactions.amount_transaction) AS total_amount_Pie,
//            Type_transaction.type_transaction
//     FROM Transactions
//     JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction
//     WHERE Transactions.type_expense = 1
//     AND DATE(Transactions.date_user) = DATE("now","localtime")  
//     GROUP BY Transactions.ID_type_transaction
//     '''
//     );
//     // double total = 0.0;
//     // for(var r in result){
//     //   total += r['total_amount_Pie'] as double;
//     // }
//     //print(total);
//     print(result.isEmpty);
//     print('Result from database day(donut): $result'); // ตรวจสอบผลลัพธ์ที่ได้
//     setState(() {
//       pieChartSections = result.map((data) {
//         final color = typeToColor[data['type_transaction']] ?? Colors.grey;
//         // final percentage = (data['total_amount_Pie'].toDouble()/ total * 100).toStringAsFixed(1);
//         return PieChartSectionData(
//           value: data['total_amount_Pie'].toDouble(),
//           title: data['type_transaction'],
//           //+' ${percentage}%',
//           color: color,
//           radius: 50,
//           showTitle: false,
//         );
//       }).toList();
//     });
//   }

//   Future<void> _fetch_DonutChart_Month() async {
//     final List<Map<String, dynamic>> result = await DatabaseManagement.instance
//         .rawQuery(
//         '''
//       SELECT Transactions.ID_type_transaction, SUM(Transactions.amount_transaction) AS total_amount_Pie, Type_transaction.type_transaction
//       FROM Transactions
//       JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction
//       WHERE Transactions.type_expense = 1
//       AND strftime('%Y-%m', Transactions.date_user) = strftime('%Y-%m', 'now',"localtime")
//       GROUP BY Transactions.ID_type_transaction
//     ''');
//     print('Result from database month: $result');
//     setState(() {
//       pieChartSections = result.map((data) {
//         final color = typeToColor[data['type_transaction']] ?? Colors.grey;
//         return PieChartSectionData(
//           value: data['total_amount_Pie'].toDouble(),
//           title: data['type_transaction'],
//           color: color,
//           radius: 50,
//           showTitle: false,
//         );
//       }).toList();
//     });
//   }

//   Future<void> _fetch_DonutChart_Year() async {
//     final List<Map<String, dynamic>> result = await DatabaseManagement.instance
//         .rawQuery(
//         '''
//       SELECT Transactions.ID_type_transaction, SUM(Transactions.amount_transaction) AS total_amount_Pie, Type_transaction.type_transaction
//       FROM Transactions
//       JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction
//       WHERE Transactions.type_expense = 1
//       AND strftime('%Y', Transactions.date_user) = strftime('%Y', 'now','localtime')
//       GROUP BY Transactions.ID_type_transaction
//     ''');
//     print('Result from year  : $result');
//     setState(() {
//       pieChartSections = result.map((data) {
//         final color = typeToColor[data['type_transaction']] ?? Colors.grey;
//         return PieChartSectionData(
//           value: data['total_amount_Pie'].toDouble(),
//           title: data['type_transaction'],
//           color: color,
//           radius: 50,
//           showTitle: false,
//         );
//       }).toList();
//     });
//   }

//   Future<void> _fetch_Status_Day() async {
//     final List<Map<String, dynamic>> result = await DatabaseManagement.instance
//         .rawQuery(
//         '''
//     SELECT Transactions.ID_type_transaction, SUM(Transactions.amount_transaction) AS total_amount,
//            Transactions.type_expense, Type_transaction.type_transaction
//     FROM Transactions
//     JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction
//     WHERE DATE(Transactions.date_user) = DATE("now", "localtime")
//     GROUP BY Transactions.ID_type_transaction, Transactions.type_expense
//     '''
//     );
//     print('Status for today (RECORD): $result');
//     setState(() {
//       statusExpenses = result.map((data) {
//         return {
//           'type': data['type_transaction'],
//           'amount': data['total_amount'] ?? 0.0,
//           // ตั้งค่าเริ่มต้นเป็น 0.0 ถ้าเป็น null
//           'isExpense': data['type_expense'] == 1,
//         };
//       }).toList();
//     });
//   }

//   Future<void> _fetch_Status_Month() async {
//     final List<Map<String, dynamic>> result = await DatabaseManagement.instance
//         .rawQuery(
//         '''
//     SELECT Transactions.ID_type_transaction, SUM(Transactions.amount_transaction) AS total_amount,
//            Transactions.type_expense, Type_transaction.type_transaction
//     FROM Transactions
//     JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction
//     WHERE strftime('%Y-%m', Transactions.date_user) = strftime('%Y-%m', 'now','localtime')  
//     GROUP BY Transactions.ID_type_transaction, Transactions.type_expense
//     '''
//     );
//     // ตรวจสอบผลลัพธ์ที่ได้จากฐานข้อมูล
//     print('Status for this month: $result');

//     // กำหนดค่าแสดงผล หรือ อัพเดท state ที่ต้องการแสดงบน UI
//     setState(() {
//       statusExpenses = result.map((data) {
//         return {
//           'type': data['type_transaction'],
//           'amount': data['total_amount'] ?? 0.0,
//           // ตั้งค่าเริ่มต้นเป็น 0.0 ถ้าเป็น null
//           'isExpense': data['type_expense'] == 1,
//           // ระบุว่าเป็นรายจ่ายหรือรายรับ
//         };
//       }).toList();
//     });
//   }

//   Future<void> _fetch_Status_Year() async {
//     final List<Map<String, dynamic>> result = await DatabaseManagement.instance
//         .rawQuery(
//         '''
//     SELECT Transactions.ID_type_transaction, SUM(Transactions.amount_transaction) AS total_amount,
//            Transactions.type_expense, Type_transaction.type_transaction
//     FROM Transactions
//     JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction
//     WHERE strftime('%Y', Transactions.date_user) = strftime('%Y', 'now','localtime') 
//     GROUP BY Transactions.ID_type_transaction, Transactions.type_expense
//     '''
//     );
//     // ตรวจสอบผลลัพธ์ที่ได้จากฐานข้อมูล
//     print('Status for this year: $result');

//     // อัพเดทข้อมูลใน UI
//     setState(() {
//       statusExpenses = result.map((data) {
//         return {
//           'type': data['type_transaction'],
//           'amount': data['total_amount'] ?? 0.0,
//           // ตั้งค่าเริ่มต้นเป็น 0.0 ถ้าเป็น null
//           'isExpense': data['type_expense'] == 1,
//           // ระบุว่าเป็นรายจ่ายหรือรายรับ
//         };
//       }).toList();
//     });
//   }

//   Future<void> _fetch_BarChart_Day() async {
//     final List<Map<String, dynamic>> incomeResult = await DatabaseManagement
//         .instance.rawQuery(
//       'SELECT SUM(amount_transaction) AS total_income FROM transactions WHERE type_expense = 0 AND DATE(date_user) = DATE("now","localtime")',
//     );

//     final List<Map<String, dynamic>> expenseResult = await DatabaseManagement
//         .instance.rawQuery(
//       'SELECT SUM(amount_transaction) AS total_expense FROM transactions WHERE type_expense = 1 AND DATE(date_user) = DATE("now","localtime")',
//     );

//     setState(() {
//       totalIncome =
//       incomeResult.isNotEmpty && incomeResult[0]['total_income'] != null
//           ? incomeResult[0]['total_income'].toDouble()
//           : 0.0;
//       totalExpense =
//       expenseResult.isNotEmpty && expenseResult[0]['total_expense'] != null
//           ? expenseResult[0]['total_expense'].toDouble()
//           : 0.0;
//     });
//     print('***** DAY Compare');
//     print('incomeResult-----------');
//     print(incomeResult);
//     print('expenseResult-----------');
//     print(expenseResult);
//     print('*****-----------');
//     print('รายจ่าย-----------');
//     print(totalExpense);
//     print('รายรับ-----------');
//     print(totalIncome);
//     print('*****-----------');
//   }

//   Future<void> _fetch_BarChart_Month() async {
//     final List<Map<String, dynamic>> incomeResult = await DatabaseManagement
//         .instance.rawQuery(
//         'SELECT SUM(amount_transaction) AS total_income FROM transactions WHERE type_expense = 0 AND strftime("%m", date_user) = strftime("%m", "now", "localtime") AND strftime("%Y", date_user) = strftime("%Y", "now", "localtime")'
//     );

//     final List<Map<String, dynamic>> expenseResult = await DatabaseManagement
//         .instance.rawQuery(
//         'SELECT SUM(amount_transaction) AS total_expense FROM transactions WHERE type_expense = 1 AND strftime("%m", date_user) = strftime("%m", "now","localtime") AND strftime("%Y", date_user) = strftime("%Y", "now","localtime")'
//     );

//     setState(() {
//       totalIncome =
//       incomeResult.isNotEmpty && incomeResult[0]['total_income'] != null
//           ? incomeResult[0]['total_income'].toDouble()
//           : 0.0;
//       totalExpense =
//       expenseResult.isNotEmpty && expenseResult[0]['total_expense'] != null
//           ? expenseResult[0]['total_expense'].toDouble()
//           : 0.0;
//     });
//     print('*****Month Compare-----------');
//     print('incomeResult-----------');
//     print(incomeResult);
//     print('expenseResult-----------');
//     print(expenseResult);
//     print('*****-----------');
//     print('รายจ่าย-----------');
//     print(totalExpense);
//     print('รายรับ-----------');
//     print(totalIncome);
//     print('*****-----------');
//   }

//   Future<void> _fetch_BarChart_Year() async {
//     final List<Map<String, dynamic>> incomeResult = await DatabaseManagement
//         .instance.rawQuery(
//         'SELECT SUM(amount_transaction) AS total_income '
//             'FROM transactions '
//             'WHERE type_expense = 0 '
//             'AND strftime("%Y", date_user) = strftime("%Y", "now","localtime")'
//     );

//     final List<Map<String, dynamic>> expenseResult = await DatabaseManagement
//         .instance.rawQuery(
//         'SELECT SUM(amount_transaction) AS total_expense '
//             'FROM transactions '
//             'WHERE type_expense = 1 '
//             'AND strftime("%Y", date_user) = strftime("%Y", "now","localtime")'
//     );

//     setState(() {
//       totalIncome =
//       incomeResult.isNotEmpty && incomeResult[0]['total_income'] != null
//           ? incomeResult[0]['total_income'].toDouble()
//           : 0.0;
//       totalExpense =
//       expenseResult.isNotEmpty && expenseResult[0]['total_expense'] != null
//           ? expenseResult[0]['total_expense'].toDouble()
//           : 0.0;
//     });
//     print('*****Year Compare-----------');
//     print('incomeResult-----------');
//     print(incomeResult);
//     print('expenseResult-----------');
//     print(expenseResult);
//     print('*****-----------');
//     print('รายจ่าย-----------');
//     print(totalExpense);
//     print('รายรับ-----------');
//     print(totalIncome);
//     print('*****-----------');
//   }

//   void _show_DonutChart(BuildContext context) {
//     setState(() {
//       if (selectedButton == 'Day') {
//         _fetch_DonutChart_Day();
//       } else if (selectedButton == 'Month') {
//         _fetch_DonutChart_Month();
//       } else if (selectedButton == 'Year') {
//         _fetch_DonutChart_Year();
//       }
//     });
//   }

//   void _show_Status_Expense(BuildContext context) {
//     setState(() {
//       if (selectedButton == 'Day') {
//         _fetch_Status_Day();
//       } else if (selectedButton == 'Month') {
//         _fetch_Status_Month();
//       } else if (selectedButton == 'Year') {
//         _fetch_Status_Year();
//       }
//     });
//   }

//   void _show_BarChart(BuildContext context) {
//     setState(() {
//       if (selectedButton == 'Day') {
//         _fetch_BarChart_Day();
//       } else if (selectedButton == 'Month') {
//         _fetch_BarChart_Month();
//       } else if (selectedButton == 'Year') {
//         _fetch_BarChart_Year();
//       }
//     });
//   }
// }