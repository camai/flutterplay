import 'package:flutter/foundation.dart';

typedef ButtonCallback = void Function(String key);
const List<String> operators = ['+', '-', '*', '/'];

class CalculatorViewModel extends ChangeNotifier {
  String _display = '0';
  String _buffer = '';
  double _operand1 = 0;
  double _operand2 = 0;
  String _operator = '';
  bool _waitingForOperand = false;
  bool _hasError = false;

  String get display => _display;
  bool get hasError => _hasError;
  String get operator => _operator;
  bool get waitingForOperand => _waitingForOperand;
  double get operand1 => _operand1;

  void onButtonPressed(String key) {
    if (key == 'AC') {
      _clearAll();
    } else if (key == 'C') {
      _clearEntry();
    } else if (operators.contains(key)) {
      _handleOperator(key);
    } else if (key == '=') {
      _calculateResult();
    } else if (key == '.') {
      _handleDecimal();
    } else {
      _handleNumber(key);
    }
    notifyListeners();
  }

  void _clearAll() {
    _display = '0';
    _buffer = '';
    _operand1 = 0;
    _operand2 = 0;
    _operator = '';
    _waitingForOperand = false;
    _hasError = false;
  }

  void _clearEntry() {
    if (_hasError) {
      _clearAll();
    } else {
      _display = '0';
      _buffer = '';
    }
  }

  void _handleNumber(String number) {
    if (_hasError || _display == 'Error') {
      _clearAll();
    }
    
    if (_waitingForOperand) {
      _display = number;
      _buffer = number;
      _waitingForOperand = false;
    } else {
      if (_display == '0') {
        _display = number;
        _buffer = number;
      } else {
        _display += number;
        _buffer += number;
      }
    }
  }

  void _handleDecimal() {
    if (_hasError) {
      _clearAll();
    }
    
    if (_waitingForOperand) {
      _display = '0.';
      _buffer = '0.';
      _waitingForOperand = false;
    } else if (!_display.contains('.')) {
      _display += '.';
      _buffer += '.';
    }
  }

  void _handleOperator(String op) {
    if (_hasError) return;
    
    if (_buffer.isNotEmpty) {
      double? value = double.tryParse(_buffer);
      if (value == null) return;
      
      if (_operator.isNotEmpty && !_waitingForOperand) {
        _operand2 = value;
        double? result = _performCalculation();
        if (result == null) return;
        
        _operand1 = result;
        _display = _formatNumber(result);
      } else {
        _operand1 = value;
      }
    }
    
    _operator = op;
    _waitingForOperand = true;
    _buffer = '';
  }

  void _calculateResult() {
    if (_hasError || _operator.isEmpty || _buffer.isEmpty) return;
    
    double? value = double.tryParse(_buffer);
    if (value == null) return;
    
    _operand2 = value;
    double? result = _performCalculation();
    if (result == null) return;
    
    _display = _formatNumber(result);
    _buffer = result.toString();
    _operator = '';
    _waitingForOperand = true;
  }

  double? _performCalculation() {
    double result = 0.0;
    
    switch (_operator) {
      case '+':
        result = _operand1 + _operand2;
        break;
      case '-':
        result = _operand1 - _operand2;
        break;
      case '*':
        result = _operand1 * _operand2;
        break;
      case '/':
        if (_operand2 == 0) {
          _display = 'Error';
          _hasError = true;
          return null;
        }
        result = _operand1 / _operand2;
        break;
      default:
        return null;
    }
    
    return result;
  }

  String _formatNumber(double number) {
    if (number == number.truncateToDouble()) {
      return number.truncate().toString();
    } else {
      String str = number.toString();
      if (str.length > 10) {
        return number.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
      }
      return str;
    }
  }
}