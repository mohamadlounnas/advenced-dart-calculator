// math expression
abstract class Expression {
  final num? value;
  final List<Expression>? expressions;
  num operation(num total, num next);
  // num execute({int? length, int? depth}) {

  // }
  Expression({this.value, this.expressions})
      : assert((value != null && expressions == null) ||
            (expressions != null && value == null));
}

// math expression
class Summation extends Expression {
  @override
  num operation(num total, num next) => total + next;
}
