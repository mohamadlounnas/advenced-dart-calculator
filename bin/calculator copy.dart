// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:io';

// import 'package:collection/collection.dart';

// import 'package:calculator/calculator.dart' as c;

// void main(List<String> arguments) {
//   var calculator = c.Calculator();
//   stdout.write('Enter expression: ');
//   String expression = stdin.readLineSync()!;
//   printWarning(Calculator.calculate(expression).toString());
//   //var result = calculator.calculate(expression);
//   //if (result == null) {
//   //  printError("expression is invalid");
//   //} else {
//   //  stdout.write("= $result\n");
//   //}
//   main(arguments);
// }

// void printWarning(String text) {
//   print('\x1B[33m$text\x1B[0m');
// }

// void printError(String text) {
//   print('\x1B[31m$text\x1B[0m');
// }

// /// Calculator class that can evaluate advenced arithmetic expressions.
// /// its a singleton class.
// /// it has ability to evaluate expressions with brackets and functions.
// /// also has memory for variables and history of calculations.
// /// it uses streams to manage data flow.
// class Calculator {
//   static final Calculator _instance = Calculator._();

//   /// instance of the calculator class.
//   Calculator get instance => _instance;

//   Calculator._();

//   /// memory
//   final Map<String, CalculatorVariableType> _memory = {
//     'pi': CalculatorNumberType(3.141592653589793),
//     'e': CalculatorNumberType(2.718281828459045),
//     'phi': CalculatorNumberType(1.618033988749895),
//     'exp': CalculatorFunctionType(args: ['x'], body: 'e^x'),
//   };

//   /// history of calculations
//   final _history = [];

//   /// returns the value of a variable.
//   CalculatorVariableType? getVariable(String name) {
//     return _memory[name];
//   }

//   static List<String> preprocess(String input) {
//     var _tokens = input.split('');
//     var _blocks = <String>[];
//     String tmp = "";
//     var i = 0;
//     while (i < _tokens.length) {
//       if (_tokens[i] == "." || int.tryParse(_tokens[i]) != null) {
//         tmp += _tokens[i];
//       } else {
//         if (tmp != "") {
//           _blocks.add(tmp);
//           tmp = "";
//         }
//         _blocks.add(_tokens[i]);
//       }
//       if ((i + 1) == _tokens.length) {
//         if (tmp != "") {
//           _blocks.add(tmp);
//           tmp = "";
//         }
//       }
//       i++;
//     }
//     return _blocks;
//   }

//   static List<dynamic> preprocessParenthese(List<String> _tokens) {
//     List<dynamic> tokens = ["(", ..._tokens, ")"];
//     List<int> sartParentheseIndexes = tokens
//         .asMap()
//         .entries
//         .where((element) => element.value == "(")
//         .map((e) => e.key)
//         .toList();
//     if (sartParentheseIndexes.isEmpty) {
//       return tokens;
//     }
//     List<int> endParentheseIndexes = tokens
//         .asMap()
//         .entries
//         .where((element) => element.value == ")")
//         .map((e) => e.key)
//         .toList()
//         .reversed
//         .toList();

//     // start from the last parenthese
//     int shiftBy = 0;
//     while (tokens.contains("(")) {
//       var start = sartParentheseIndexes.last;
//       var end = endParentheseIndexes.last - shiftBy;
//       var block = tokens.sublist(start + 1, end);
//       tokens.removeRange(start, end + 1);
//       tokens.insert(start, block);
//       sartParentheseIndexes.removeLast();
//       endParentheseIndexes.removeLast();
//       shiftBy = shiftBy + block.length + 1;
//     }

//     return tokens;
//   }

//   /// culculate single bloc
//   static calculate(String input) {
//     var _preprocessData = preprocess(input);
//     var _preprocessParentheseData = preprocessParenthese(_preprocessData);
//     print(calculateBlock(_preprocessParentheseData));
//   }

//   /// culculate single bloc
//   static double? calculateBlock(dynamic preprocessParentheseData) {
//     if (preprocessParentheseData is! List) {
//       return double.parse(preprocessParentheseData);
//     }
//     if (preprocessParentheseData.length == 1) {
//       return calculateBlock(preprocessParentheseData[0]);
//     } else if (preprocessParentheseData.contains("+")) {
//       var addData = splitList(preprocessParentheseData, "+").toList();
//       var addResult = calculateBlock(addData.first)!;
//       addData.removeAt(0);
//       for (var addItem in addData) {
//         addResult = addResult + calculateBlock(addItem)!;
//       }
//       return addResult;
//     } else if (preprocessParentheseData.contains("-")) {
//       var addData = splitList(preprocessParentheseData, "-").toList();
//       var addResult = calculateBlock(addData.first)!;
//       addData.removeAt(0);
//       for (var addItem in addData) {
//         addResult = addResult - calculateBlock(addItem)!;
//       }
//       return addResult;
//     } else if (preprocessParentheseData.contains("*")) {
//       var addData = splitList(preprocessParentheseData, "*").toList();
//       var addResult = calculateBlock(addData.first)!;
//       addData.removeAt(0);
//       for (var addItem in addData) {
//         addResult = addResult * calculateBlock(addItem)!;
//       }
//       return addResult;
//     } else if (preprocessParentheseData.contains("/")) {
//       var addData = splitList(preprocessParentheseData, "/").toList();
//       var addResult = calculateBlock(addData.first)!;
//       addData.removeAt(0);
//       for (var addItem in addData) {
//         addResult = addResult / calculateBlock(addItem)!;
//       }
//       return addResult;
//     }
//   }

//   static Iterable splitList(List list, by) {
//     return list.splitBefore((e) => e == by).mapIndexed((index, element) {
//       var el;
//       if (index > 0) {
//         el = element.sublist(1);
//       } else {
//         el = element;
//       }

//       if (el is List && el.length == 1) {
//         return el[0];
//       }
//       return el;
//     });
//   }

//   String? nextNumber(token) {
//     String result = "";
//     var i = 0;
//     while (i < token.length) {
//       if (token[i] == "." || int.tryParse(token[i]) != null) {
//         result += token[i];
//       } else {
//         return result;
//       }
//       i++;
//     }
//     return result != "" ? result : null;
//   }
// }

// class RGBAColor {
//   final int r;
//   final int g;
//   final int b;
//   final double a;

//   RGBAColor(this.r, this.g, this.b, this.a);

//   @override
//   String toString() {
//     return 'rgba($r, $g, $b, $a)';
//   }
// }

// abstract class Block {
//   // all clock should have color getter
//   RGBAColor? get color => null;
// }

// class NumberBloc extends Block {
//   final double value;
//   NumberBloc(this.value);
// }

// class OperatorBloc extends Block {
//   final String operator;
//   OperatorBloc(this.operator);
// }

// class ParentheseBloc extends Block {
//   final List<Block> blocks;
//   ParentheseBloc(this.blocks);
// }

// class SourceRang {
//   final int start;
//   final int end;
//   SourceRang({
//     required this.start,
//     required this.end,
//   });

//   @override
//   bool operator ==(covariant SourceRang other) {
//     if (identical(this, other)) return true;

//     return other.start == start && other.end == end;
//   }

//   @override
//   int get hashCode => start.hashCode ^ end.hashCode;
// }

// class Result {
//   final String? error;
//   final Object? result;

//   Result({this.error, this.result});
// }

// class ExecuteResult extends Result {
//   final CalculatorVariableType? result;
//   final String? error;

//   ExecuteResult({
//     this.result,
//     this.error,
//   }) : super(result: result, error: error);
// }

// /// CalculatorVariableType class is a wrapper for variables.
// abstract class CalculatorVariableType extends Object {}

// /// CalculatorNumberType class is a wrapper for numbers.
// class CalculatorNumberType extends CalculatorVariableType {
//   double value;
//   CalculatorNumberType(this.value);
// }

// /// CalculatorFunctionType class is a wrapper for functions.
// /// functions in the calculator are simple functions that take one or more arguments
// /// and return a value or function.
// class CalculatorFunctionType extends CalculatorVariableType {
//   /// arguments of the function.
//   final List<String> args;

//   /// body of the function.
//   final String body;
//   CalculatorFunctionType({this.args = const [], required this.body});
// }
