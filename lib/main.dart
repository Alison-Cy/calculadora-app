import 'package:flutter/material.dart';
import 'dart:math'; 

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = "0";
  String _input = "";

  void _updateInput(String value) {
    setState(() {
      if (_input == "0") {
        _input = value;
      } else {
        _input += value;
      }
    });
  }


  void _calculate() {
    try {
      final result = _evaluateExpression(_input);
      setState(() {
        _output = result.toString();
        _input = "";
      });
    } catch (e) {
      setState(() {
        _output = "Error";
      });
    }
  }
  double _evaluateExpression(String expression) {
    try {
      final result = _evaluateSimpleExpression(expression);
      return result;
    } catch (e) {
      throw FormatException('Error al evaluar la expresión');
    }
  }

  double _evaluateSimpleExpression(String expression) {
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
    final result = _parseMathExpression(expression);
    return result;
  }

  double _parseMathExpression(String expression) {
    final regExp = RegExp(r"(\d+)([\+\-\*/])(\d+)");
    final match = regExp.firstMatch(expression);
    if (match != null) {
      double num1 = double.parse(match.group(1)!);
      double num2 = double.parse(match.group(3)!);
      String operator = match.group(2)!;

      switch (operator) {
        case '+':
          return num1 + num2;
        case '-':
          return num1 - num2;
        case '*':
          return num1 * num2;
        case '/':
          return num1 / num2;
        default:
          throw FormatException('Operador no soportado');
      }
    }
    return 0.0;
  }
  void _clear() {
    setState(() {
      _input = "";
      _output = "0";
    });
  }

  void _backspace() {
    setState(() {
      if (_input.isNotEmpty) {
        _input = _input.substring(0, _input.length - 1);
      }
      if (_input.isEmpty) {
        _input = "0";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora Básica'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Pantalla de salida
              Text(
                _output,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Pantalla de entrada
              Text(
                _input,
                style: TextStyle(fontSize: 28),
              ),
              SizedBox(height: 20),
              // Fila de botones
              GridView.builder(
                shrinkWrap: true,
                itemCount: 20,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (index < 9) {
                        _updateInput((index + 1).toString());
                      } else if (index == 9) {
                        _updateInput("0");
                      } else if (index == 10) {
                        _updateInput("+");
                      } else if (index == 11) {
                        _updateInput("-");
                      } else if (index == 12) {
                        _updateInput("*");
                      } else if (index == 13) {
                        _updateInput("/");
                      } else if (index == 14) {
                        _clear();
                      } else if (index == 15) {
                        _backspace();
                      } else if (index == 16) {
                        _calculate();
                      }
                    },
                    child: Text(
                      _getButtonLabel(index),
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getButtonLabel(int index) {
    if (index < 9) {
      return (index + 1).toString();
    } else if (index == 9) {
      return "0";
    } else if (index == 10) {
      return "+";
    } else if (index == 11) {
      return "-";
    } else if (index == 12) {
      return "*";
    } else if (index == 13) {
      return "/";
    } else if (index == 14) {
      return "C"; 
    } else if (index == 15) {
      return "←"; 
    } else if (index == 16) {
      return "="; 
    } else {
      return "";
    }
  }
}
