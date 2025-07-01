import 'package:hive_flutter/hive_flutter.dart';
import '../models/grocery_item.dart';

class StorageService {
  static const _boxName = 'groceryBox';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(GroceryItemAdapter());
    await Hive.openBox<GroceryItem>(_boxName);
  }

  Box<GroceryItem> get box => Hive.box<GroceryItem>(_boxName);

  void addItem(GroceryItem item) => box.add(item);

  void deleteItem(int index) => box.deleteAt(index);

  List<GroceryItem> get items => box.values.toList();
}