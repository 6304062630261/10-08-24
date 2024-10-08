import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // เพิ่ม import นี้

class TransactionList extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;

  TransactionList({required this.transactions});

  @override
  Widget build(BuildContext context) {
    // คำนวณยอดรวมของรายจ่ายและรายรับ
    double totalIncome = 0;
    double totalExpense = 0;

    for (var item in transactions) {
      if (item['type_transaction'] == 'IC') {
        totalIncome += item['amount_transaction'];
      } else {
        totalExpense += item['amount_transaction'];
      }
    }

    return Column(
      children: [
        // แสดงยอดรวมของรายจ่ายและรายรับ
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                color: Colors.green[50], // กำหนดสีพื้นหลังสำหรับยอดรวมรายรับ
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16), // กำหนดความห่าง
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // จัดเรียงแบบ SpaceBetween
                  children: [
                    Text(
                      'Total Income', // แสดงข้อความ Total Income
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${totalIncome.toStringAsFixed(2)}', // แสดงยอดรวมรายรับ
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0), // เพิ่มระยะห่างระหว่างยอดรวม
              Container(
                color: Colors.red[50], // กำหนดสีพื้นหลังสำหรับยอดรวมรายจ่าย
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16), // กำหนดความห่าง
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // จัดเรียงแบบ SpaceBetween
                  children: [
                    Text(
                      'Total Expense', // แสดงข้อความ Total Expense
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '- ${totalExpense.toStringAsFixed(2)}', // แสดงยอดรวมรายจ่าย
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // แสดงรายการธุรกรรม
        Expanded(
          child: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final item = transactions[index];

              // แปลงวันที่เป็นรูปแบบที่ต้องการ
              DateTime date = DateTime.parse(item['date_user']);
              String formattedDate = DateFormat('d MMM yyyy').format(date);

              // เลือกรูปภาพตามประเภทของธุรกรรม
              String imagePath;
              if (item['type_transaction'] == 'IC') {
                imagePath = 'assets/money.png'; // รูปภาพสำหรับรายรับ
              } else if (item['type_transaction'] == 'Electricity bill') {
                imagePath = 'assets/electricity_bill.png';
              } else if (item['type_transaction'] == 'Food') {
                imagePath = 'assets/food.png';
              } else if (item['type_transaction'] == 'Travel expenses') {
                imagePath = 'assets/travel_expenses.png';
              } else if (item['type_transaction'] == 'Water bill') {
                imagePath = 'assets/water_bill.png';
              } else if (item['type_transaction'] == 'House cost') {
                imagePath = 'assets/house.png';
              } else if (item['type_transaction'] == 'Car fare') {
                imagePath = 'assets/car.png';
              } else if (item['type_transaction'] == 'Gasoline cost') {
                imagePath = 'assets/gasoline_cost.png';
              } else if (item['type_transaction'] == 'Medical expenses') {
                imagePath = 'assets/medical.png';
              } else if (item['type_transaction'] == 'Beauty expenses') {
                imagePath = 'assets/beauty.png';
              } else {
                imagePath = 'assets/other.png'; // รูปภาพสำหรับกรณีที่ไม่ตรงกับเงื่อนไขที่ระบุไว้
              }

              Color amountColor = item['type_transaction'] == 'IC' ? Colors.green : Colors.red;

              return ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // เพิ่ม padding
                leading: Image.asset(
                  imagePath,
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, size: 50, color: Colors.red);
                  },
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // จัดเรียงให้มีพื้นที่ระหว่าง
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$formattedDate'), // แสดงวันที่ที่แปลงแล้ว
                          Text('${item['type_transaction'] == 'IC' ? 'Income' : item['type_transaction']}'),
                        ],
                      ),
                    ),
                    // แสดงจำนวนเงินทางขวาสุด โดยกำหนดสี
                    Text(
                      '\$${item['amount_transaction'].toStringAsFixed(2)}',
                      style: TextStyle(color: amountColor),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
