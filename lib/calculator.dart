// import 'dart:math' as math;

// import 'functions.dart';

// class Calculator {
//   num? calculate(String expression) {
//     try {
//       expression = expression.replaceAll(' ', '');
//       if (expression.isEmpty) {
//         return 0;
//       }
//       var symbolsAndConstants = {
//         "√": "sqrt",
//         "!": "fact",
//         "pi": math.pi,
//         "π": math.pi,
//         "e": math.e,
//       };
//       if (expression.contains(',')) {
//         expression = expression.replaceAll(',', '.');
//       }
//       for (var key in symbolsAndConstants.keys) {
//         expression =
//             expression.replaceAll(key, symbolsAndConstants[key].toString());
//       }
//       expression = '($expression)';
//       while (expression.contains('(')) {
//         var block = nextSBlock(expression);
//         var result = block.calc();
//         expression = expression.replaceRange(
//             block.range.start, block.range.end, result.toString());
//       }
//       var result = num.parse(expression);
//       return result.toInt() == result ? result.toInt() : result;
//     } catch (e) {
//       return null;
//     }
//   }

//   String validate(String expression) {
//     try {
//       expression = expression.replaceAll(' ', '');
//       if (expression.isEmpty) {
//         return 0.toString();
//       }
//       var symbols = {
//         "sqrt": "√",
//         "fact": "!",
//         "pi": "π",
//       };
//       // replace with symbols
//       for (var key in symbols.keys) {
//         expression = expression.replaceAll(key, symbols[key].toString());
//       }
//       var chars = expression.split('');
//       for (var i = 0; i < chars.length; i++) {
//         var char = chars[i];
//         if (chars.length > i + 1) {}
//         String? nextChar = chars[i + 1];
//         if (symbols.keys.contains(char) && nextChar != "(") {
//           chars.insert(i + 1, "(");
//         }
//         // return 'Invalid character: $char';
//       }
//       // add brackets after symbols if need and it found
//       return chars.join("");
//     } catch (e) {
//       return expression;
//     }
//   }

//   SBlock nextSBlock(String expression) {
//     var openBracketIndex = 0;
//     var closeBracketIndex = 0;
//     var regex = RegExp(r'([A-Za-z]+|)+\(([^()]+)\)');
//     var allMatches = regex.allMatches(expression);
//     var value = allMatches.first.group(2)!;
//     List<String?> args = [];
//     if (value.contains(",")) {
//       var args = value.split(",");
//       value = args.first;
//       args = args.length > 1 ? args.sublist(1) : [];
//     }
//     return SBlock(
//       name: allMatches.first.group(1),
//       value: value,
//       args: args,
//       range: SBlockRange(
//         allMatches.first.start,
//         allMatches.first.end,
//       ),
//     );
//   }
// }

// class SBlock {
//   String? name;
//   String value;
//   List<String?> args;
//   SBlockRange range;
//   SBlock({
//     this.name,
//     required this.value,
//     required this.range,
//     this.args = const [],
//   });
//   num calc() {
//     var result = num.parse(execute(value));
//     return AdditionalFunctions.apply(name, result, args);
//   }

//   String simplify() {
//     var result = executeS(value);
//     return result;
//   }

//   String executeS(String expression) {
//     var operators = Operator.operators;
//     if (!expression
//         .split("")
//         .any((element) => operators.keys.contains(element))) {
//       return expression;
//     }
//     List<String> data = [];
//     late var total;
//     for (var operator in operators.keys) {
//       if (expression.contains(operator)) {
//         var _data = expression
//             .split(operator)
//             .map((e) => e == "" ? operators[operator]!.initValue.toString() : e)
//             .toList();
//         var index = 0;
//         for (var _expr in _data) {
//           if (_expr == "") {
//             continue;
//           }
//           if (index == 0) {
//             total = num.parse(executeS(_expr));
//             index++;
//             continue;
//           }
//           for (var _operator in operators.keys) {
//             if (operator == _operator) {
//               total =
//                   operators[_operator]!.calc(total, num.parse(executeS(_expr)));
//               break;
//             }
//           }
//           index++;
//         }
//         expression = total.toString();
//       }
//     }
//     return total.toString();
//   }

//   String execute(String expression) {
//     var operators = Operator.operators;
//     if (!expression
//         .split("")
//         .any((element) => operators.keys.contains(element))) {
//       return expression;
//     }
//     List<String> data = [];
//     late var total;
//     for (var operator in operators.keys) {
//       if (expression.contains(operator)) {
//         var _data = expression
//             .split(operator)
//             .map((e) => e == "" ? operators[operator]!.initValue.toString() : e)
//             .toList();
//         var index = 0;
//         for (var _expr in _data) {
//           if (_expr == "") {
//             continue;
//           }
//           if (index == 0) {
//             total = num.parse(execute(_expr));
//             index++;
//             continue;
//           }
//           for (var _operator in operators.keys) {
//             if (operator == _operator) {
//               total =
//                   operators[_operator]!.calc(total, num.parse(execute(_expr)));
//               break;
//             }
//           }
//           index++;
//         }
//         expression = total.toString();
//       }
//     }
//     return total.toString();
//   }
// }

// class Equation {
//   String equation;
//   Equation({
//     required this.equation,
//   });
// }

// class SBlockRange {
//   int start;
//   int end;
//   SBlockRange(this.start, this.end);
// }

// abstract class Operator {
//   num get initValue => 0;
//   String get symbol;
//   num calc(num total, num next);
//   static final Map<String, Operator> _operators = {
//     '+': AddOperator(),
//     '-': SubOperator(),
//     '*': MulOperator(),
//     '/': DivOperator(),
//     '^': PowOperator(),
//     '%': ModOperator(),
//   };
//   static Map<String, Operator> get operators => _operators;
// }

// class AddOperator extends Operator {
//   @override
//   String get symbol => '+';

//   @override
//   num calc(num total, num next) {
//     return total + next;
//   }
// }

// class SubOperator extends Operator {
//   @override
//   String get symbol => '-';

//   @override
//   num calc(num total, num next) {
//     return total - next;
//   }
// }

// class MulOperator extends Operator {
//   @override
//   num get initValue => 1;
//   @override
//   String get symbol => '*';

//   @override
//   num calc(num total, num next) {
//     return total * next;
//   }
// }

// class DivOperator extends Operator {
//   @override
//   num get initValue => 1;
//   @override
//   String get symbol => '/';

//   @override
//   num calc(num total, num next) {
//     return total / next;
//   }
// }

// class PowOperator extends Operator {
//   @override
//   String get symbol => '^';

//   @override
//   num calc(num total, num next) {
//     return math.pow(total, next);
//   }
// }

// class ModOperator extends Operator {
//   @override
//   String get symbol => '%';

//   @override
//   num calc(num total, num next) {
//     return total % next;
//   }
// }
