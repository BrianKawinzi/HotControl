import 'package:isar/isar.dart';

part 'order_model.g.dart';

@Collection()
class Order {
  Id id = Isar.autoIncrement;
  final String name;
  final String store;
  final double quantity;
  final double buyingPrice;
  final String state;
  final DateTime date;

  Order({
    required this.name,
    required this.store,
    required this.quantity,
    required this.buyingPrice,
    required this.state,
    required this.date
  });
}