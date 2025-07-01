import 'package:flutter/material.dart';
import 'package:grocery_reminder/theme_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import '../models/grocery_item.dart';
import '../widgets/add_item_dialog.dart';
import '../widgets/grocery_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StorageService storage;

  @override
  void initState() {
    super.initState();
    storage = context.read<StorageService>();
  }

  void _addItem(GroceryItem item) {
    storage.addItem(item);
    // Schedule notification (Bonus)
    NotificationService.scheduleNotification(
      id: item.hashCode,
      title: 'Expiry Reminder',
      body: '${item.name} is expiring tomorrow!',
      scheduleTime: item.expiryDate.subtract(const Duration(days: 1)),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AddItemDialog(onAdd: _addItem),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery Expiry Tracker'),
        actions: [
          // Dark/Light Mode Toggle (Bonus)
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: storage.box.listenable(),
        builder: (context, Box<GroceryItem> box, _) {
          final items = box.values.toList().reversed.toList();
          
          if (items.isEmpty) {
            return const Center(child: Text('No items added yet'));
          }
          
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GroceryListItem(
                item: item,
                onDelete: () => storage.deleteItem(box.keyAt(box.values.length - 1 - index)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}