// math expression
abstract class Unit {
  Unit({List<num>? nums, List<Unit>? units}) {
    this.nums = nums ?? const [];
    this.units = units ?? const [];
  }
  late final List<num> nums;
  late final List<Unit> units;
  num operation(num total, num next);

  num get initial => 0;
  execute() {
    num total = initial;
    for (var unit in units) {
      total = operation(total, unit.execute());
    }
    for (var num in nums) {
      total = operation(total, num);
    }
    return total;
  }
}

// Summation Unit
class Sum extends Unit {
  Sum({List<num>? nums, List<Unit>? units}) : super(nums: nums, units: units);
  @override
  num operation(num total, num next) => total + next;
}

// Subtraction Unit
class Sub extends Unit {
  Sub({List<num>? nums, List<Unit>? units}) : super(nums: nums, units: units);
  @override
  num operation(num total, num next) => total - next;
}

// Multiplication Unit
class Mul extends Unit {
  Mul({List<num>? nums, List<Unit>? units}) : super(nums: nums, units: units);
  @override
  num get initial => 1;
  @override
  num operation(num total, num next) => total * next;
}

// Division Unit
class Div extends Unit {
  Div({List<num>? nums, List<Unit>? units}) : super(nums: nums, units: units);
  @override
  num get initial => 1;
  @override
  num operation(num total, num next) => total / next;
}
