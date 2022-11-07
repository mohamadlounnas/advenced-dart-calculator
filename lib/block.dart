abstract class Block extends Object {
  Block parse();
  List? get props => null;
  @override
  String toString() {
    return super.toString();
  }
}

abstract class SingleChildBlock<T> extends Block {
  T get data;
  Block? block;
  SingleChildBlock({this.block});
}

abstract class MultiChildBlock extends Block {
  List<Block>? blocks;
  MultiChildBlock({this.blocks});
}

// Example...
class NumBlock<num> extends SingleChildBlock {
  @override
  Block parse() {
    throw UnimplementedError();
  }

  final num data;
  NumBlock(this.data);
}

// class BracketBlock extends SingleChildBlock {
//   BracketBlock({Block? block}) : super(block: block);

//   @override
//   BracketBlock parse() {
//     // TODO: implement parse
//     throw UnimplementedError();
//   }
// }
