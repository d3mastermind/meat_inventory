import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'models/meat_item.dart';
import 'meat_inventory_screen.dart';
import 'providers/meat_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force landscape orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(MeatItemAdapter());
  final meatBox = await Hive.openBox<MeatItem>('meat_items');

  // Initialize with default items if empty
  if (meatBox.isEmpty) {
    await meatBox.addAll([
      MeatItem(type: 'Pork', totalCount: 0, lastUpdated: DateTime.now()),
      MeatItem(type: 'Beef', totalCount: 0, lastUpdated: DateTime.now()),
      MeatItem(type: 'Ribs', totalCount: 0, lastUpdated: DateTime.now()),
    ]);
  }

  runApp(
    ProviderScope(
      overrides: [
        meatBoxProvider.overrideWithValue(meatBox),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize:
          const Size(1024, 600), // Common tablet resolution in landscape
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meat Inventory',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.brown,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const MeatInventoryScreen(),
      ),
    );
  }
}
