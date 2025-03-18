import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/meat_item.dart';
import 'providers/meat_providers.dart';

class SettingsDialog extends ConsumerWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thresholds = ref.watch(stockThresholdsProvider);

    return Dialog(
      backgroundColor: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        width: 500.w,
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Settings',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            // Subtitle
            Text(
              'Adjust low stock thresholds for different time periods',
              style: GoogleFonts.inter(
                color: Colors.grey[400],
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 32.h),
            // Time period inputs
            _buildTimeInput(
              '3:00 PM - 4:59 PM',
              thresholds.fourPM.toString(),
              (value) {
                final newValue = double.tryParse(value);
                if (newValue != null) {
                  ref.read(stockThresholdsProvider.notifier).state =
                      StockThresholds(
                    fourPM: newValue,
                    fivePM: thresholds.fivePM,
                    sixPM: thresholds.sixPM,
                    sevenPM: thresholds.sevenPM,
                  );
                }
              },
            ),
            SizedBox(height: 16.h),
            _buildTimeInput(
              '5:00 PM - 5:59 PM',
              thresholds.fivePM.toString(),
              (value) {
                final newValue = double.tryParse(value);
                if (newValue != null) {
                  ref.read(stockThresholdsProvider.notifier).state =
                      StockThresholds(
                    fourPM: thresholds.fourPM,
                    fivePM: newValue,
                    sixPM: thresholds.sixPM,
                    sevenPM: thresholds.sevenPM,
                  );
                }
              },
            ),
            SizedBox(height: 16.h),
            _buildTimeInput(
              '6:00 PM - 7:00 PM',
              thresholds.sixPM.toString(),
              (value) {
                final newValue = double.tryParse(value);
                if (newValue != null) {
                  ref.read(stockThresholdsProvider.notifier).state =
                      StockThresholds(
                    fourPM: thresholds.fourPM,
                    fivePM: thresholds.fivePM,
                    sixPM: newValue,
                    sevenPM: thresholds.sevenPM,
                  );
                }
              },
            ),
            SizedBox(height: 16.h),
            _buildTimeInput(
              '7:00 PM - 8:00 PM',
              thresholds.sevenPM.toString(),
              (value) {
                final newValue = double.tryParse(value);
                if (newValue != null) {
                  ref.read(stockThresholdsProvider.notifier).state =
                      StockThresholds(
                    fourPM: thresholds.fourPM,
                    fivePM: thresholds.fivePM,
                    sixPM: thresholds.sixPM,
                    sevenPM: newValue,
                  );
                }
              },
            ),
            SizedBox(height: 24.h),
            // Divider
            Container(
              height: 1,
              color: Colors.grey[800],
            ),
            SizedBox(height: 24.h),
            // Reset button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Reset Inventory'),
                      content: const Text(
                        'Are you sure you want to reset all inventory counts to zero?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            ref
                                .read(meatItemsProvider.notifier)
                                .resetInventory();
                            Navigator.pop(context);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Inventory has been reset'),
                              ),
                            );
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Reset All Inventory',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 8.h,
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInput(
      String timeRange, String initialValue, void Function(String) onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 150.w,
          child: Text(
            timeRange,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: TextField(
              controller: TextEditingController(text: initialValue),
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                border: InputBorder.none,
                suffixText: 'lbs',
                suffixStyle: GoogleFonts.inter(
                  color: Colors.grey[600],
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
