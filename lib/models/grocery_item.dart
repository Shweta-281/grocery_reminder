import 'package:hive/hive.dart';

part 'grocery_item.g.dart'; // Generated file

@HiveType(typeId: 0)
class GroceryItem {
  @HiveField(0)
  final String name;
  
  @HiveField(1)
  final DateTime expiryDate;

  GroceryItem({
    required this.name,
    required this.expiryDate,
  });

  int get daysLeft {
    final now = DateTime.now();
    return expiryDate.difference(now).inDays;
  }

  String get formattedDate {
    return '${expiryDate.day}/${expiryDate.month}/${expiryDate.year}';
  }
}