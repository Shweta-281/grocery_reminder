import 'package:flutter/material.dart';
import '../models/grocery_item.dart';

class GroceryListItem extends StatelessWidget {
  final GroceryItem item;
  final VoidCallback onDelete;

  const GroceryListItem({
    super.key,
    required this.item,
    required this.onDelete,
  });

  Color _getIndicatorColor(int daysLeft) {
    if (daysLeft < 0) return Colors.grey; // Expired
    if (daysLeft <= 1) return Colors.red; // Expiring soon
    return Colors.green; // Safe
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getIndicatorColor(item.daysLeft),
        child: Text(
          item.daysLeft.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(item.name),
      subtitle: Text('Exp: ${item.formattedDate}'),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}