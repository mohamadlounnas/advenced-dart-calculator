import 'dart:io';
import 'package:calculator/calculator.dart';

void main(List<String> arguments) {
  var strEx = '2+3*3*((3+1*5)/16)-1';

  /// parse expression to be:
  var expr = add([
    2,
    prod([
      3,
      3,
      block(
        div([
          block(
            add([
              3,
              prod([1, 5])
            ]),
          ),
          16,
        ]),
      ),
    ]),
    -1
  ]);

  print(expr);
}

num add(List<num> nums) {
  return nums.reduce((a, b) => a + b);
}

num prod(List<num> nums) {
  return nums.reduce((a, b) => a * b);
}

num div(List<num> nums) {
  return nums.reduce((a, b) => a / b);
}

num block(num num) {
  return num;
}
