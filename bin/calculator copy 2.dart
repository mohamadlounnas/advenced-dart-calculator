import 'dart:io';
import 'package:calculator/calculator.dart';

void main(List<String> arguments) {
  var strEx = "(10*5*2+200+(10+40)-200)+20+0.1-0.01";
  var result = calculate(strEx);
  print(result);
}

num calculate(String expression) {
  expression = '($expression)';
  while (expression.contains('(')) {
    var bracketRange = findBracketRange(expression);
    var result = calculateSimpleExpression(bracketRange.value);
    expression = expression.replaceRange(
        bracketRange.start, bracketRange.end + 1, result);
  }
  var result = num.parse(expression);
  return result.toInt() == result ? result.toInt() : result;
}

calculateSimpleExpression(String expression) {
  var operators = ['*', '/', '+', '-'].reversed.toList();
  if (!expression.split("").any((element) => operators.contains(element))) {
    return expression;
  }
  List<String> data = [];
  late var total;
  for (var operator in operators) {
    if (expression.contains(operator)) {
      var _data = expression.split(operator);
      for (var _expr in _data) {
        if (_data.indexOf(_expr) == 0) {
          total = num.parse(calculateSimpleExpression(_expr));
          continue;
        }
        if (operator == '*') {
          total = total * num.parse(calculateSimpleExpression(_expr));
        } else if (operator == '/') {
          total = total / num.parse(calculateSimpleExpression(_expr));
        } else if (operator == '+') {
          total = total + num.parse(calculateSimpleExpression(_expr));
        } else if (operator == '-') {
          total = total - num.parse(calculateSimpleExpression(_expr));
        }
      }
      expression = total.toString();
    }
  }
  return total.toString();
}

BracketRange findBracketRange(String expression) {
  var openBracketIndex = 0;
  var closeBracketIndex = 0;
  var regex = RegExp(r'([A-Za-z]+|)+\(([^()]+)\)');
  Iterable allMatches = regex.allMatches(expression);
  for (var match in allMatches) {
    if (match.group(0).contains('(')) {
      openBracketIndex = match.start;
    } else {
      closeBracketIndex = match.end;
    }
    // print('Match ${matchCount}: ' + str1.substring(match.start, match.end));
  }
  for (var i = 0; i < expression.length; i++) {
    if (expression[i] == '(') {
      openBracketIndex = i;
    } else if (expression[i] == ')') {
      closeBracketIndex = i;
      break;
    }
  }
  var _sub = expression.substring(openBracketIndex + 1, closeBracketIndex);
  return BracketRange(openBracketIndex, closeBracketIndex, _sub);
}

class BracketRange {
  int start;
  int end;

  String value;
  BracketRange(this.start, this.end, this.value);
}
