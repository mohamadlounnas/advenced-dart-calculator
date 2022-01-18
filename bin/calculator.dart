import 'dart:io';
import 'package:calculator/calculator.dart';

void main(List<String> arguments) {
  var calculator = Calculator();
  // read expression from stdin
  stdout.write('Enter expression: ');
  String expression = stdin.readLineSync()!;
  var result = calculator.calculate(expression);
  print("=$result");
  main(arguments);
}
