// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:math';

import 'package:calculator/functions.dart';
import 'package:collection/collection.dart';

import 'package:calculator/calculator.dart' as c;

void main(List<String> arguments) {
  stdout.write('Enter expression: ');
  String expression = stdin.readLineSync()!;
  printWarning(Calculator.calculate(expression).toString());
  //var result = calculator.calculate(expression);
  //if (result == null) {
  //  printError("expression is invalid");
  //} else {
  //  stdout.write("= $result\n");
  //}
  main(arguments);
}

void printWarning(String text) {
  print('\x1B[33m$text\x1B[0m');
}

void printError(String text) {
  print('\x1B[31m$text\x1B[0m');
}

/// Calculator class that can evaluate advenced arithmetic expressions.
/// its a singleton class.
/// it has ability to evaluate expressions with brackets and functions.
/// also has memory for variables and history of calculations.
/// it uses streams to manage data flow.
class Calculator {
  static final Calculator _instance = Calculator._();

  /// instance of the calculator class.
  Calculator get instance => _instance;

  Calculator._();

  /// memory
  final Map<String, CalculatorVariableType> _memory = {
    'pi': CalculatorNumberType(3.141592653589793),
    'e': CalculatorNumberType(2.718281828459045),
    'phi': CalculatorNumberType(1.618033988749895),
    'exp': CalculatorFunctionType(args: ['x'], body: 'e^x'),
  };

  /// history of calculations
  final _history = [];

  /// returns the value of a variable.
  CalculatorVariableType? getVariable(String name) {
    return _memory[name];
  }

  static List<String> preprocess(String input) {
    var _tokens = input.split('');
    var _blocks = <String>[];
    String tmp = "";
    var i = 0;
    while (i < _tokens.length) {
      if (["."].contains(_tokens[i]) ||
          int.tryParse(_tokens[i]) != null ||
          RegExp(r'[a-zA-Z]').hasMatch(_tokens[i])) {
        tmp += _tokens[i];
      } else {
        if (tmp != "") {
          _blocks.add(tmp);
          tmp = "";
        }
        _blocks.add(_tokens[i]);
      }
      if ((i + 1) == _tokens.length) {
        if (tmp != "") {
          _blocks.add(tmp);
          tmp = "";
        }
      }
      i++;
    }
    return _blocks;
  }

  static List<dynamic> preprocessParenthese(List<String> _tokens) {
    List<dynamic> tokens = ["(", ..._tokens, ")"];
    List<int> sartParentheseIndexes = tokens
        .asMap()
        .entries
        .where((element) => element.value == "(")
        .map((e) => e.key)
        .toList();
    if (sartParentheseIndexes.isEmpty) {
      return tokens;
    }
    List<int> endParentheseIndexes = tokens
        .asMap()
        .entries
        .where((element) => element.value == ")")
        .map((e) => e.key)
        .toList()
        .reversed
        .toList();

    // start from the last parenthese
    int shiftBy = 0;
    while (tokens.contains("(")) {
      var start = sartParentheseIndexes.last;
      var end = endParentheseIndexes.last - shiftBy;
      var block = tokens.sublist(start + 1, end);
      tokens.removeRange(start, end + 1);
      tokens.insert(start, block);
      sartParentheseIndexes.removeLast();
      endParentheseIndexes.removeLast();
      shiftBy = shiftBy + block.length + 1;
    }

    return tokens;
  }

  /// culculate single bloc
  static calculate(String input) {
    var _preprocessData = preprocess(input);
    var _preprocessParentheseData = preprocessParenthese(_preprocessData);
    var _blocks = Blocks.fromList(_preprocessParentheseData);
    print(_blocks.toColorStringWithColor());
    print(calculateBlock(_blocks));
    print(calculateDynamic(_preprocessParentheseData));
  }

  static num calculateBlock(Block block) {
    if (block is NumberBloc) {
      return block.value;
    } else if (block is Blocks) {
      if (block.blocks.length == 1) {
        return calculateBlock(block.blocks[0]);
      }
      List<OperatorBloc> exists =
          block.blocks.whereType<AdditionOperatorBloc>().toList();
      if (exists.isEmpty) {
        exists = block.blocks.whereType<SubtractionOperatorBloc>().toList();
      }
      if (exists.isEmpty) {
        exists = block.blocks.whereType<MultiplicationOperatorBloc>().toList();
      }
      if (exists.isEmpty) {
        exists = block.blocks.whereType<DivisionOperatorBloc>().toList();
      }
      if (exists.isNotEmpty) {
        return exists.first.apply(block);
      }
      if (block.blocks.first is FunctionBloc) {
        if (block.blocks.length == 2) {
          var name = (block.blocks.first as FunctionBloc).name;
          var args = block.blocks.last as Blocks;
          var addData = Calculator.splitByType<CommaBloc>(args.blocks);

          return AdditionalFunctions.call(
              name,
              addData
                  .map((e) => calculateBlock(((_block) {
                        return _block is List
                            ? Blocks(<Block>[..._block])
                            : _block;
                      })(e)))
                  .toList());
        }
      }
    }
    return throw Exception("invalid input");
  }

  /// culculate single bloc
  static num? calculateDynamic(dynamic preprocessParentheseData) {
    if (preprocessParentheseData is! List) {
      return double.parse(preprocessParentheseData);
    }
    if (preprocessParentheseData.length == 1) {
      return calculateDynamic(preprocessParentheseData[0]);
    } else if (preprocessParentheseData.contains("+")) {
      var addData = splitList(preprocessParentheseData, "+").toList();
      var addResult = calculateDynamic(addData.first)!;
      addData.removeAt(0);
      for (var addItem in addData) {
        addResult = addResult + calculateDynamic(addItem)!;
      }
      return addResult;
    } else if (preprocessParentheseData.contains("-")) {
      var addData = splitList(preprocessParentheseData, "-").toList();
      var addResult = calculateDynamic(addData.first)!;
      addData.removeAt(0);
      for (var addItem in addData) {
        addResult = addResult - calculateDynamic(addItem)!;
      }
      return addResult;
    } else if (preprocessParentheseData.contains("*")) {
      var addData = splitList(preprocessParentheseData, "*").toList();
      var addResult = calculateDynamic(addData.first)!;
      addData.removeAt(0);
      for (var addItem in addData) {
        addResult = addResult * calculateDynamic(addItem)!;
      }
      return addResult;
    } else if (preprocessParentheseData.contains("/")) {
      var addData = splitList(preprocessParentheseData, "/").toList();
      var addResult = calculateDynamic(addData.first)!;
      addData.removeAt(0);
      for (var addItem in addData) {
        addResult = addResult / calculateDynamic(addItem)!;
      }
      return addResult;
    } else if (preprocessParentheseData.contains("^")) {
      var addData = splitList(preprocessParentheseData, "^").toList();
      var addResult = calculateDynamic(addData.first)!;
      addData.removeAt(0);
      for (var addItem in addData) {
        addResult = pow(addResult, calculateDynamic(addItem)!).toDouble();
      }
      return addResult;
    } else if (RegExp(r'[a-zA-Z]').hasMatch(preprocessParentheseData.first)) {
      if (preprocessParentheseData.length == 2) {
        var name = preprocessParentheseData.first as String;
        var args = preprocessParentheseData.last as List;
        var addData = splitList(args, ",").toList();
        return AdditionalFunctions.call(
            name, addData.map((e) => calculateDynamic(e)!).toList());
      }
    } else {
      return throw Exception("invalid input");
    }
  }

  static Iterable splitList(List list, by) {
    return list.splitBefore((e) => e == by).mapIndexed((index, element) {
      var el;
      if (index > 0) {
        el = element.sublist(1);
      } else {
        el = element;
      }

      if (el is List && el.length == 1) {
        return el[0];
      }
      return el;
    });
  }

  static Iterable splitByType<T>(List list) {
    return list.splitBefore((e) => e is T).mapIndexed((index, element) {
      var el;
      if (index > 0) {
        el = element.sublist(1);
      } else {
        el = element;
      }

      if (el is List && el.length == 1) {
        return el[0];
      }
      return el;
    });
  }

  String? nextNumber(token) {
    String result = "";
    var i = 0;
    while (i < token.length) {
      if (token[i] == "." || int.tryParse(token[i]) != null) {
        result += token[i];
      } else {
        return result;
      }
      i++;
    }
    return result != "" ? result : null;
  }
}

class RGBAColor {
  final int r;
  final int g;
  final int b;
  final double a;

  RGBAColor(this.r, this.g, this.b, this.a);

  @override
  String toString() {
    return 'rgba($r, $g, $b, $a)';
  }
}

abstract class Block {
  // all clock should have color getter
  RGBAColor? get color => RGBAColor(100, 20, 155, 1);
  num calculate() =>
      throw Exception("${runtimeType} doesn't have calculate method");

  static Block? fromString(String block) {
    switch (block) {
      case "+":
        return AdditionOperatorBloc();
      case "-":
        return SubtractionOperatorBloc();
      case "*":
        return MultiplicationOperatorBloc();
      case "/":
        return DivisionOperatorBloc();
    }
    if (RegExp(r"^[a-zA-Z]+$").hasMatch(block)) {
      return FunctionBloc(block);
    }
    if (block == ",") {
      return CommaBloc(block);
    }
    var number = double.tryParse(block);
    if (number != null) {
      return NumberBloc(number);
    }
    if (block == " ") {
      return SpaceBloc(block);
    }
  }

  // console colord string
  String toColorString() => toString();

  String toColorStringWithColor() {
    return '\x1B[38;2;${color!.r};${color!.g};${color!.b}m${toString()}\x1B[0m';
  }
}

class NumberBloc extends Block {
  @override
  RGBAColor? get color => RGBAColor(50, 200, 155, 1);
  final num value;
  NumberBloc(this.value);

  @override
  String toString() {
    return value.toString();
  }

  @override
  String toColorString() {
    // use Magenta
    return '\x1B[34m${toString()}\x1B[0m';
  }
}

class OperatorBloc extends Block {
  /// execute operator
  num execute(num a, num b) =>
      throw Exception("operator ${runtimeType} doesn't have execute method");
  @override
  RGBAColor? get color => RGBAColor(80, 2, 255, 1);
  final String operator;
  OperatorBloc(this.operator);

  @override
  String toString() {
    return operator;
  }

  @override
  String toColorString() {
    // use Yellow
    return '\x1B[33m${toString()}\x1B[0m';
  }

  num apply<T>(Blocks block) {
    var addData = block.blocks
        .splitBefore((e) => e is OperatorBloc && e.operator == operator)
        .mapIndexed((index, element) {
      var el;
      if (index > 0) {
        el = element.sublist(1);
      } else {
        el = element;
      }

      if (el is List && el.length == 1) {
        return el[0];
      }
      return el;
    }).toList();
    var addResult = Calculator.calculateBlock(((_block) {
      return _block is List ? Blocks(_block as List<Block>) : _block;
    })(addData.first));
    addData.removeAt(0);
    for (var addItem in addData) {
      addResult = execute(addResult, Calculator.calculateBlock(addItem));
    }
    return addResult;
  }
}

class AdditionOperatorBloc extends OperatorBloc {
  /// execute operator
  @override
  num execute(num a, num b) => a + b;
  AdditionOperatorBloc() : super("+");
  @override
  num apply<AdditionOperatorBloc>(Blocks block) =>
      super.apply<AdditionOperatorBloc>(block);
}

class SubtractionOperatorBloc extends OperatorBloc {
  /// execute
  @override
  num execute(num a, num b) => a - b;

  SubtractionOperatorBloc() : super("-");
  @override
  num apply<SubtractionOperatorBloc>(Blocks block) =>
      super.apply<SubtractionOperatorBloc>(block);
}

class MultiplicationOperatorBloc extends OperatorBloc {
  /// execute
  @override
  num execute(num a, num b) => a * b;

  MultiplicationOperatorBloc() : super("*");
  @override
  num apply<MultiplicationOperatorBloc>(Blocks block) =>
      super.apply<MultiplicationOperatorBloc>(block);
}

class DivisionOperatorBloc extends OperatorBloc {
  /// execute
  @override
  num execute(num a, num b) => a / b;

  DivisionOperatorBloc() : super("/");
  @override
  num apply<DivisionOperatorBloc>(Blocks block) =>
      super.apply<DivisionOperatorBloc>(block);
}

class PowerOperatorBloc extends OperatorBloc {
  @override
  num execute(num a, num b) => pow(a, b);
  PowerOperatorBloc() : super("^");
  @override
  num apply<PowerOperatorBloc>(Blocks block) =>
      super.apply<PowerOperatorBloc>(block);
}

class FunctionBloc extends Block {
  @override
  RGBAColor? get color => RGBAColor(15, 10, 130, 1);
  final String name;
  FunctionBloc(this.name);

  @override
  String toString() {
    return name;
  }

  @override
  String toColorString() {
    // use Yellow
    return '\x1B[33m${toString()}\x1B[0m';
  }
}

class SpaceBloc extends Block {
  @override
  RGBAColor? get color => RGBAColor(255, 255, 255, 0);
  final String value;
  SpaceBloc(this.value);

  @override
  String toString() {
    return value;
  }

  @override
  String toColorString() {
    // use Yellow
    return '\x1B[33m${toString()}\x1B[0m';
  }
}

class CommaBloc extends Block {
  @override
  RGBAColor? get color => RGBAColor(8, 22, 60, 1);
  final String operator;
  CommaBloc(this.operator);

  @override
  String toString() {
    return operator;
  }

  @override
  String toColorString() {
    // use Yellow
    return '\x1B[33m${toString()}\x1B[0m';
  }
}

class Blocks extends Block {
  @override
  RGBAColor? get color => RGBAColor(255, 15, 155, 1);
  final List<Block> blocks;
  Blocks(this.blocks);

  static Blocks fromList(List<dynamic> list) {
    var _blocks = <Block>[];
    for (var i = 0; i < list.length; i++) {
      var _item = list[i];
      if (_item is List) {
        _blocks.add(fromList(list[i]));
      } else if (_item is String) {
        var block = Block.fromString(list[i]);
        if (block != null) {
          _blocks.add(block);
        }
      } else {
        throw UnimplementedError("that was un expected!");
      }
    }
    return Blocks(_blocks);
  }

  @override
  String toString() {
    return '(${blocks.map((e) => e.toString()).join("")})';
  }

  @override
  String toColorString() {
    // use Cyan
    return '\x1B[32m(\x1B[0m'
        '${blocks.map((e) => e.toColorString()).join("")}'
        '\x1B[32m)\x1B[0m';
  }

  @override
  String toColorStringWithColor() {
    return '\x1B[38;2;${color!.r};${color!.g};${color!.b}m(\x1B[0m'
        '${blocks.map((e) => e.toColorStringWithColor()).join("")}'
        '\x1B[38;2;${color!.r};${color!.g};${color!.b}m)\x1B[0m';
  }
}

class SourceRang {
  final int start;
  final int end;
  SourceRang({
    required this.start,
    required this.end,
  });

  @override
  bool operator ==(covariant SourceRang other) {
    if (identical(this, other)) return true;

    return other.start == start && other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}

class Result {
  final String? error;
  final Object? result;

  Result({this.error, this.result});
}

class ExecuteResult extends Result {
  @override
  final CalculatorVariableType? result;
  @override
  final String? error;

  ExecuteResult({
    this.result,
    this.error,
  }) : super(result: result, error: error);
}

/// CalculatorVariableType class is a wrapper for variables.
abstract class CalculatorVariableType extends Object {}

/// CalculatorNumberType class is a wrapper for numbers.
class CalculatorNumberType extends CalculatorVariableType {
  double value;
  CalculatorNumberType(this.value);
}

/// CalculatorFunctionType class is a wrapper for functions.
/// functions in the calculator are simple functions that take one or more arguments
/// and return a value or function.
class CalculatorFunctionType extends CalculatorVariableType {
  /// arguments of the function.
  final List<String> args;

  /// body of the function.
  final String body;
  CalculatorFunctionType({this.args = const [], required this.body});
}
