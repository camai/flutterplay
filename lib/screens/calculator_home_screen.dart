
import 'package:flutter/material.dart';

void main() => runApp(Calculator());

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

typedef BufferFunc = void Function(String key);
const List<String> OPERATORS = ['+', '-', '*', '/'];

class CalculatorScreen extends StatefulWidget {
  @override
  State<CalculatorScreen> createState() => CalculatorState();
}

class CalculatorState extends State<CalculatorScreen> {
  double text = 0;
  String buffer = '';
  double op1 = 0;
  double op2 = 0;
  String operator = '';

  void numberPressed(String key) {
    if (key == 'C') {
      buffer = '';
      showResult(0);
    } else if (OPERATORS.contains(key)) {
      op1 = double.parse(buffer);
      operator = key;
      buffer = '';
    } else if (key == '=') {
      op2 = double.parse(buffer);
      calculate(op1, op2, operator);
      buffer = '';
    } else {
      buffer += key;
    }
  }

  void calculate(double op1, double op2, String operator) {
    double res = 0.0;
    if (operator == "+") res = op1 + op2;
    if (operator == "-") res = op1 - op2;
    if (operator == '*') res = op1 * op2;
    if (operator == '/') res = op1 / op2;
    showResult(res);
  }

  void showResult(double num) {
    setState(() {
      text = num;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계산기'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 결과 표시
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                text.toString(),
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(height: 20),
            
            // 버튼 그리드
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  CalcButton('7', numberPressed),
                  CalcButton('8', numberPressed),
                  CalcButton('9', numberPressed),
                  FuncButton('+', numberPressed),
                  
                  CalcButton('4', numberPressed),
                  CalcButton('5', numberPressed),
                  CalcButton('6', numberPressed),
                  FuncButton('-', numberPressed),
                  
                  CalcButton('1', numberPressed),
                  CalcButton('2', numberPressed),
                  CalcButton('3', numberPressed),
                  FuncButton('*', numberPressed),
                  
                  CalcButton('C', numberPressed),
                  CalcButton('0', numberPressed),
                  CalcButton('=', numberPressed),
                  FuncButton('/', numberPressed),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalcButton extends StatelessWidget {
  final String buttonKey;
  final BufferFunc func;

  const CalcButton(this.buttonKey, this.func, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => func(buttonKey),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        buttonKey,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class FuncButton extends StatelessWidget {
  final String buttonKey;
  final BufferFunc func;

  const FuncButton(this.buttonKey, this.func, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => func(buttonKey),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        buttonKey,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}