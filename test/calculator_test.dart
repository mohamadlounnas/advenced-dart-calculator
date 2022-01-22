import 'package:calculator/calculator.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    var calculator = Calculator();
    expect(calculator.calculate('1+1'), 2);
    expect(calculator.calculate('1-1'), 0);
    expect(calculator.calculate('1*1'), 1);
    expect(calculator.calculate('1/1'), 1);
    expect(calculator.calculate('1+1*10'), 11);
    expect(calculator.calculate('!(3)'), 6);
    expect(calculator.calculate('3^2'), 9);
    expect(
        calculator
            .calculate("2-1*(10-12/(10+10*5))+1000+!(3)+01.8+(500*(1+1-2+2))"),
        2000);
  });
}
