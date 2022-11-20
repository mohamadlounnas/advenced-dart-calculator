import 'dart:math' as math;

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

  static num call(String? name, List<num> args) {
    var value;
    if (args.isNotEmpty) {
      value = args.first;
    }
    if (name == 'sqrt') {
      return math.sqrt(value);
    } else if (name == 'sin') {
      return math.sin(value);
    } else if (name == 'cos') {
      return math.cos(value);
    } else if (name == 'tan') {
      return math.tan(value);
    } else if (name == 'asin') {
      return math.asin(value);
    } else if (name == 'acos') {
      return math.acos(value);
    } else if (name == 'atan') {
      return math.atan(value);
    } else if (name == 'log') {
      return math.log(value);
    } else if (name == 'ln') {
      return math.log(value);
    } else if (name == 'exp') {
      return math.exp(value);
    } else if (name == 'pow') {
      return math.pow(value, args[1]);
    } else if (name == 'sqr') {
      return math.pow(value, 2);
    } else if (name == 'cube') {
      return math.pow(value, 3);
    } else if (name == 'cbrt') {
      return math.pow(value, 1 / 3);
    } else if (name == 'asin') {
      return math.asin(value);
    } else if (name == 'acos') {
      return math.acos(value);
    } else if (name == 'atan') {
      return math.atan(value);
    } else if (name == 'atan2') {
      return math.atan2(value, args[1]);
    } else if (name == 'sin') {
      return math.sin(value);
    } else if (name == 'cos') {
      return math.cos(value);
    } else if (name == 'tan') {
      return math.tan(value);
    } else if (name == 'asin') {
      return math.asin(value);
    } else if (name == 'acos') {
      return math.acos(value);
    } else if (name == 'atan') {
      return math.atan(value);
    } else if (name == 'atan2') {
      return math.atan2(value, args[1]);
    } else if (name == 'mod') {
      return AdditionalFunctions.mod(value, args[1]);
    } else if (name == 'fact') {
      return AdditionalFunctions.fact(value);
    } else if (name == 'abs') {
      return AdditionalFunctions.abs(value);
    } else if (name == 'ln') {
      return AdditionalFunctions.ln(value);
    }
    return value;
  }
}
