import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_screen.dart';
import 'models/meat_item.dart';
import 'providers/meat_providers.dart';

class MeatInventoryScreen extends ConsumerWidget {
  const MeatInventoryScreen({super.key});

  String _format12Hour(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour : $minute $period';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meatItems = ref.watch(meatItemsProvider);
    final currentTime = TimeOfDay.now();

    // Update the design size for 11-inch tablet
    ScreenUtil.init(
      context,
      designSize: const Size(1194, 834), // 11-inch iPad Pro dimensions
      splitScreenMode: true,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 32.w, vertical: 24.h), // Increased padding
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 60.h, // Increased logo size
                  ),
                  Row(
                    children: [
                      Text(
                        _format12Hour(currentTime),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 24.w), // Increased spacing
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w, // Increased padding
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => const SettingsDialog(),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.settings,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Settings',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              // Meat Cards
              Expanded(
                child: Row(
                  children: meatItems.map((item) {
                    final thresholds = ref.watch(stockThresholdsProvider);
                    final hour = currentTime.hour;
                    bool isLowStock = false;

                    if (hour >= 16 &&
                        hour < 17 &&
                        item.totalCount <= thresholds.fourPM) {
                      isLowStock = true;
                    }
                    if (hour >= 17 &&
                        hour < 18 &&
                        item.totalCount <= thresholds.fivePM) {
                      isLowStock = true;
                    }
                    if (hour >= 18 &&
                        hour < 19 &&
                        item.totalCount <= thresholds.sixPM) {
                      isLowStock = true;
                    }
                    if (hour >= 19 &&
                        hour < 20 &&
                        item.totalCount <= thresholds.sevenPM) {
                      isLowStock = true;
                    }

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: MeatCard(
                          title: item.type,
                          value: item.totalCount.toStringAsFixed(2),
                          color: _getColorForType(item.type),
                          icon: _getIconForType(item.type),
                          buttons: _getButtonsForType(item.type),
                          isLowStock: isLowStock,
                          onButtonPressed: (amount) {
                            ref.read(meatItemsProvider.notifier).reduceCount(
                                  item.type,
                                  amount,
                                );
                          },
                          onValueTap: () async {
                            final controller = TextEditingController(
                              text: item.totalCount.toStringAsFixed(2),
                            );

                            await showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: Container(
                                  width: 600.w, // Increased dialog width
                                  padding:
                                      EdgeInsets.all(32.r), // Increased padding
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Edit ${item.type} Count',
                                        style: GoogleFonts.inter(
                                          fontSize:
                                              32.sp, // Increased font size
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                          height: 32.h), // Increased spacing
                                      TextField(
                                        controller: controller,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        style: GoogleFonts.inter(
                                            fontSize:
                                                28.sp), // Increased font size
                                        decoration: InputDecoration(
                                          labelText: 'Total Count (lbs)',
                                          labelStyle: GoogleFonts.inter(
                                              fontSize:
                                                  24.sp), // Increased font size
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 24.w,
                                              vertical:
                                                  20.h), // Increased padding
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                12.r), // Increased border radius
                                            borderSide: BorderSide(
                                                width: 2
                                                    .w), // Increased border width
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: 32.h), // Increased spacing
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 24.w,
                                                  vertical: 12
                                                      .h), // Increased padding
                                              child: Text(
                                                'Cancel',
                                                style: GoogleFonts.inter(
                                                    fontSize: 24
                                                        .sp), // Increased font size
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: 24.w), // Increased spacing
                                          ElevatedButton(
                                            onPressed: () {
                                              final newCount = double.tryParse(
                                                  controller.text);
                                              if (newCount != null) {
                                                ref
                                                    .read(meatItemsProvider
                                                        .notifier)
                                                    .updateCount(
                                                      item.type,
                                                      newCount,
                                                    );
                                              }
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  _getColorForType(item.type),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 32.w,
                                                  vertical: 16
                                                      .h), // Increased padding
                                            ),
                                            child: Text(
                                              'Save',
                                              style: GoogleFonts.inter(
                                                fontSize: 24
                                                    .sp, // Increased font size
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          lastUpdated: item.lastUpdated,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'Pork':
        return const Color(0xFFD64B7D);
      case 'Beef':
        return const Color(0xFF00A878);
      case 'Ribs':
        return const Color(0xFFE17B37);
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Pork':
        return Icons.restaurant;
      case 'Beef':
        return Icons.egg_outlined;
      case 'Ribs':
        return Icons.restaurant_menu;
      default:
        return Icons.help_outline;
    }
  }

  List<String> _getButtonsForType(String type) {
    if (type == 'Ribs') {
      return ['Full Rack', 'Half Rack', '3 Bone'];
    }
    return ['1 lb', '1/2 lb', '1/3 lb', 'Meals', 'Taco'];
  }
}

class MeatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  final List<String> buttons;
  final bool isLowStock;
  final Function(double) onButtonPressed;
  final VoidCallback onValueTap;
  final DateTime lastUpdated;

  const MeatCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
    required this.buttons,
    required this.isLowStock,
    required this.onButtonPressed,
    required this.onValueTap,
    required this.lastUpdated,
  });

  double _getAmountForButton(String button) {
    switch (button) {
      case '1 lb':
        return MeatPortions.onePound;
      case '1/2 lb':
        return MeatPortions.halfPound;
      case '1/3 lb':
        return MeatPortions.thirdPound;
      case 'Meals':
        return MeatPortions.sandwichSize;
      case 'Taco':
        return MeatPortions.tacoSize;
      case 'Full Rack':
        return MeatPortions.fullRack;
      case 'Half Rack':
        return MeatPortions.halfRack;
      case '3 Bone':
        return MeatPortions.threeBone;
      default:
        return 0.0;
    }
  }

  String _format12Hour(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour : $minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return isLowStock ? BlinkingBorder(child: _buildCard()) : _buildCard();
  }

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  _format12Hour(TimeOfDay.fromDateTime(lastUpdated)),
                  style: GoogleFonts.inter(
                    color: Colors.white.withAlpha(150),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Value
          GestureDetector(
            onTap: onValueTap,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Text(
                value,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 60.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          // Buttons
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buttons.map((button) {
                  // Special case for Meals and Taco buttons
                  if (button == 'Meals' || button == 'Taco') {
                    if (button == 'Meals') {
                      return Row(
                        children: [
                          Expanded(
                            child: _buildButton('Meals'),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: _buildButton('Taco'),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox
                          .shrink(); // Skip Taco button as it's handled with Meals
                    }
                  }
                  return _buildButton(button);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String button) {
    return Container(
      width: double.infinity,
      height: 60.h,
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: InkWell(
        onTap: () => onButtonPressed(_getAmountForButton(button)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.remove_circle_outline,
              color: Colors.white,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              button,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlinkingBorder extends StatefulWidget {
  final Widget child;

  const BlinkingBorder({
    super.key,
    required this.child,
  });

  @override
  State<BlinkingBorder> createState() => _BlinkingBorderState();
}

class _BlinkingBorderState extends State<BlinkingBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.red.withOpacity(_animation.value),
              width: 5.w,
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
