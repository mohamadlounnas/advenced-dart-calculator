import 'dart:math' as math;

class Calculator {
  num calculate(String expression) {
    var symbolsAndConstants = {
      "√": "sqrt",
      "!": "fact",
      "π": math.pi,
      "e": math.e,
    };
    for (var key in symbolsAndConstants.keys) {
      expression =
          expression.replaceAll(key, symbolsAndConstants[key].toString());
    }
    expression = '($expression)';
    while (expression.contains('(')) {
      var block = nextBlock(expression);
      var result = block.calc();
      expression = expression.replaceRange(
          block.range.start, block.range.end, result.toString());
    }
    var result = num.parse(expression);
    return result.toInt() == result ? result.toInt() : result;
  }

  Block nextBlock(String expression) {
    var openBracketIndex = 0;
    var closeBracketIndex = 0;
    var regex = RegExp(r'([A-Za-z]+|)+\(([^()]+)\)');
    var allMatches = regex.allMatches(expression);
    var value = allMatches.first.group(2)!;
    List<String?> args = [];
    if (value.contains(",")) {
      var args = value.split(",");
      value = args.first;
      args = args.length > 1 ? args.sublist(1) : [];
    }
    return Block(
      name: allMatches.first.group(1),
      value: value,
      args: args,
      range: BlockRange(
        allMatches.first.start,
        allMatches.first.end,
      ),
    );
  }
}

class AdditionalFunctions {
  static num ln(num a) {
    return math.log(a);
  }

  static num fact(num a) {
    if (a == 0) {
      return 1;
    }
    return a * fact(a - 1);
  }

  static num mod(num a, num b) {
    return a % b;
  }

  static num abs(num a) {
    return a.abs();
  }
}

class Block {
  String? name;
  String value;
  List<String?> args;
  BlockRange range;
  Block(
      {this.name,
      required this.value,
      required this.range,
      this.args = const []});

  num calc() {
    var result = num.parse(execute(value));
    return applyMathFunction(result);
  }

  num applyMathFunction(num result) {
    if (name == 'sqrt') {
      return math.sqrt(result);
    } else if (name == 'sin') {
      return math.sin(result);
    } else if (name == 'cos') {
      return math.cos(result);
    } else if (name == 'tan') {
      return math.tan(result);
    } else if (name == 'asin') {
      return math.asin(result);
    } else if (name == 'acos') {
      return math.acos(result);
    } else if (name == 'atan') {
      return math.atan(result);
    } else if (name == 'log') {
      return math.log(result);
    } else if (name == 'ln') {
      return math.log(result);
    } else if (name == 'exp') {
      return math.exp(result);
    } else if (name == 'pow') {
      return math.pow(result, num.parse(args.first!));
    } else if (name == 'sqr') {
      return math.pow(result, 2);
    } else if (name == 'cube') {
      return math.pow(result, 3);
    } else if (name == 'cbrt') {
      return math.pow(result, 1 / 3);
    } else if (name == 'asin') {
      return math.asin(result);
    } else if (name == 'acos') {
      return math.acos(result);
    } else if (name == 'atan') {
      return math.atan(result);
    } else if (name == 'atan2') {
      return math.atan2(result, num.parse(args.first!));
    } else if (name == 'sin') {
      return math.sin(result);
    } else if (name == 'cos') {
      return math.cos(result);
    } else if (name == 'tan') {
      return math.tan(result);
    } else if (name == 'asin') {
      return math.asin(result);
    } else if (name == 'acos') {
      return math.acos(result);
    } else if (name == 'atan') {
      return math.atan(result);
    } else if (name == 'atan2') {
      return math.atan2(result, num.parse(args.first!));
    } else if (name == 'mod') {
      return AdditionalFunctions.mod(result, num.parse(args.first!));
    } else if (name == 'fact') {
      return AdditionalFunctions.fact(result);
    } else if (name == 'abs') {
      return AdditionalFunctions.abs(result);
    } else if (name == 'ln') {
      return AdditionalFunctions.ln(result);
    }
    return result;
  }

  String execute(String expression) {
    var operators = Operator.operators;
    if (!expression
        .split("")
        .any((element) => operators.keys.contains(element))) {
      return expression;
    }
    List<String> data = [];
    late var total;
    for (var operator in operators.keys) {
      if (expression.contains(operator)) {
        var _data = expression
            .split(operator)
            .map((e) => e == "" ? operators[operator]!.initValue.toString() : e)
            .toList();
        var index = 0;
        for (var _expr in _data) {
          if (_expr == "") {
            continue;
          }
          if (index == 0) {
            total = num.parse(execute(_expr));
            index++;
            continue;
          }
          for (var _operator in operators.keys) {
            if (operator == _operator) {
              total =
                  operators[_operator]!.calc(total, num.parse(execute(_expr)));
              break;
            }
          }
          index++;
        }
        expression = total.toString();
      }
    }
    return total.toString();
  }
}

class BlockRange {
  int start;
  int end;
  BlockRange(this.start, this.end);
}

abstract class Operator {
  num get initValue => 0;
  String get symbol;
  num calc(num total, num next);
  static final Map<String, Operator> _operators = {
    '+': AddOperator(),
    '-': SubOperator(),
    '*': MulOperator(),
    '/': DivOperator(),
    '^': PowOperator(),
    '%': ModOperator(),
  };
  static Map<String, Operator> get operators => _operators;
}

class AddOperator extends Operator {
  @override
  String get symbol => '+';

  @override
  num calc(num total, num next) {
    return total + next;
  }
}

class SubOperator extends Operator {
  @override
  String get symbol => '-';

  @override
  num calc(num total, num next) {
    return total - next;
  }
}

class MulOperator extends Operator {
  @override
  num get initValue => 1;
  @override
  String get symbol => '*';

  @override
  num calc(num total, num next) {
    return total * next;
  }
}

class DivOperator extends Operator {
  @override
  num get initValue => 1;
  @override
  String get symbol => '/';

  @override
  num calc(num total, num next) {
    return total / next;
  }
}

class PowOperator extends Operator {
  @override
  String get symbol => '^';

  @override
  num calc(num total, num next) {
    return math.pow(total, next);
  }
}

class ModOperator extends Operator {
  @override
  String get symbol => '%';

  @override
  num calc(num total, num next) {
    return total % next;
  }
}
