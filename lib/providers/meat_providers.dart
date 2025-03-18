import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/meat_item.dart';

final meatBoxProvider = Provider<Box<MeatItem>>((ref) {
  throw UnimplementedError();
});

final meatItemsProvider =
    StateNotifierProvider<MeatItemsNotifier, List<MeatItem>>((ref) {
  final box = ref.watch(meatBoxProvider);
  return MeatItemsNotifier(box);
});

class MeatItemsNotifier extends StateNotifier<List<MeatItem>> {
  final Box<MeatItem> box;
  DateTime _lastReduceTime = DateTime.now();
  static const _debounceTime = Duration(milliseconds: 500);

  MeatItemsNotifier(this.box) : super([]) {
    _loadItems();
  }

  void _loadItems() {
    state = box.values.toList();
  }

  void updateCount(String type, double newCount) {
    // Ensure newCount is not negative
    final validCount = (newCount < 0 ? 0.0 : newCount).toDouble();

    state = [
      for (final item in state)
        if (item.type == type)
          MeatItem(
            type: type,
            totalCount: validCount,
            lastUpdated: DateTime.now(),
          )
        else
          item
    ];

    final index = box.values.toList().indexWhere((item) => item.type == type);
    if (index != -1) {
      box.putAt(
        index,
        MeatItem(
          type: type,
          totalCount: validCount,
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  void reduceCount(String type, double amount) {
    final now = DateTime.now();
    if (now.difference(_lastReduceTime) < _debounceTime) {
      return; // Ignore tap if too soon after last tap
    }
    _lastReduceTime = now;

    final item = state.firstWhere((item) => item.type == type);
    final newCount = (item.totalCount - amount).toDouble();
    // Only update if the new count would not be negative
    if (newCount >= 0) {
      updateCount(type, newCount);
    }
  }

  void resetInventory() async {
    // Clear both the box and state
    await box.clear();
    state = [];

    // Add new items to box
    await box.addAll([
      MeatItem(type: 'Pork', totalCount: 0, lastUpdated: DateTime.now()),
      MeatItem(type: 'Beef', totalCount: 0, lastUpdated: DateTime.now()),
      MeatItem(type: 'Ribs', totalCount: 0, lastUpdated: DateTime.now()),
    ]);

    // Update state with new items
    state = box.values.toList();
  }
}

final stockThresholdsProvider = StateProvider<StockThresholds>((ref) {
  return const StockThresholds();
});
