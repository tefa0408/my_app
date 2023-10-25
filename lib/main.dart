import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyCalculator(),
      title: 'my_app',
    );
  }
}

class MyCalculator extends StatefulWidget {
  @override
  _MyCalculatorState createState() => _MyCalculatorState();
}

class _MyCalculatorState extends State<MyCalculator> {
  String _output = '0';
  String _input = '';
  double _num1 = 0;
  String _operator = '';
  bool _operatorClicked = false;
  String _currentOperation = ''; // Variable para mantener la operación actual

  List<String> _history = []; // Lista para almacenar el historial

  void _updateUI() {
    setState(() {
      _output = _output;
      _input = _input; // Actualizar el input
    });
  }

  void _onNumberClick(String value) {
    if (_operatorClicked) {
      _output = value;
      _operatorClicked = false;
    } else {
      if (_output == '0') {
        _output = value;
      } else {
        _output += value;
      }
    }
    // Actualizar el input en la parte inferior
    _input += value;
    _updateUI();
  }

  void _onOperatorClick(String value) {
    if (_operatorClicked) {
      _operator = value;
    } else {
      _num1 = double.parse(_output);
      _operator = value;
      _operatorClicked = true;
    }
    // Actualizar el input en la parte inferior
    _input += ' $value ';
    _updateUI();
  }

  void _onEqualsClick() {
    if (_operator.isNotEmpty) {
      double result = 0.0;
      switch (_operator) {
        case '+':
          result = _num1 + double.parse(_output);
          break;
        case '-':
          result = _num1 - double.parse(_output);
          break;
        case '*':
          result = _num1 * double.parse(_output);
          break;
        case '/':
          result = _num1 / double.parse(_output);
          break;
      }

      _output =
          result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 2);

      // Agregar la operación al historial
      String operation = '$_currentOperation $result';
      _history.add(operation);

      // Establecer la operación actual para el siguiente cálculo
      _currentOperation = '$_num1 $_operator ${double.parse(_output)}';

      _operatorClicked = false;
      _operator = '';
    }
    _updateUI();
  }

  void _onClearClick() {
    _output = '0';
    _operatorClicked = false;
    _num1 = 0;
    _operator = '';
    _currentOperation = '';
    // Limpiar el input
    _input = '';
    _updateUI();
  }

  void _onBackClick() {
    if (_output.isNotEmpty) {
      _output = _output.substring(0, _output.length - 1);
      if (_output.isEmpty) {
        _output = '0';
      }
      // Eliminar el último carácter del input
      _input = _input.substring(0, _input.length - 1);
      _updateUI();
    }
  }

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Historial de Operaciones'),
          content: SingleChildScrollView(
            child: Column(
              children: _history.map((operation) {
                return ListTile(
                  title: Text(operation),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _showHistoryDialog,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.bottomRight,
            child: Text(
              _input,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.centerRight,
            child: Text(
              _output,
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              buildButton("%"),
              buildButton("C"),
              buildButton("CE"),
              buildIconButton("back", Icons.backspace),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton("1/x"),
              buildButton("x²"),
              buildButton("√x"),
              buildButton("/"),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton("7"),
              buildButton("8"),
              buildButton("9"),
              buildButton("*"),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton("4"),
              buildButton("5"),
              buildButton("6"),
              buildButton("-"),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton("1"),
              buildButton("2"),
              buildButton("3"),
              buildButton("+"),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton("+/-"),
              buildButton("0"),
              buildButton("."),
              buildButton("="),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(String value) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(2.0),
        child: ElevatedButton(
          onPressed: () {
            if (value == 'C') {
              _onClearClick();
            } else if (value == '=') {
              _onEqualsClick();
            } else if (value == '+' ||
                value == '-' ||
                value == '*' ||
                value == '/') {
              _onOperatorClick(value);
            } else {
              _onNumberClick(value);
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.grey[300], // Fondo de color más claro
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0), // Bordes casi cuadrados
            ),
            padding: EdgeInsets.all(20.0), // Espacio reducido
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black, // Color de texto negro
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIconButton(String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(2.0),
        child: ElevatedButton(
          onPressed: () {
            if (value == 'back') {
              _onBackClick();
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.grey[300], // Fondo de color más claro
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0), // Bordes casi cuadrados
            ),
            padding: EdgeInsets.all(20.0), // Espacio reducido
          ),
          child: Icon(
            icon,
            size: 24.0,
            color: Colors.black, // Color de ícono negro
          ),
        ),
      ),
    );
  }
}
