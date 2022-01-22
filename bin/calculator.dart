import 'dart:io';
import 'package:calculator/calculator.dart';

void main(List<String> arguments) {
  var calculator = Calculator();
  stdout.write('Enter expression: ');
  String expression = stdin.readLineSync()!;
  var result = calculator.calculate(expression);
  stdout.write("=$result\n");
  main(arguments);
}
