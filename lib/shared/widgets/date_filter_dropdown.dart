import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/shared/utils/utils.dart';

enum DateFilterOption {
  today,
  yesterday,
  last7days,
  monthtodate,
  custom,
}

class DateRange {
  final DateTime? from;
  final DateTime? to;

  DateRange({this.from, this.to});
}

class DateFilterDropdown extends ConsumerStatefulWidget {
  final DateFilterOption value;
  final Function(DateFilterOption, DateRange?) onChange;
  final DateRange? customDateRange;

  const DateFilterDropdown({
    super.key,
    required this.value,
    required this.onChange,
    this.customDateRange,
  });

  @override
  ConsumerState<DateFilterDropdown> createState() => _DateFilterDropdownState();
}

class _DateFilterDropdownState extends ConsumerState<DateFilterDropdown> {
  String _getDateFilterDisplayText(
      DateFilterOption option, DateRange? customRange) {
    switch (option) {
      case DateFilterOption.today:
        return 'Today';
      case DateFilterOption.yesterday:
        return 'Yesterday';
      case DateFilterOption.last7days:
        return 'Last 7 Days';
      case DateFilterOption.monthtodate:
        return 'Month to Date';
      case DateFilterOption.custom:
        return 'Custom Range';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DateFilterOption>(
          value: widget.value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: DateFilterOption.values.map((option) {
            return DropdownMenuItem<DateFilterOption>(
              value: option,
              child: Text(
                _getDateFilterDisplayText(option, widget.customDateRange),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: (DateFilterOption? newValue) {
            if (newValue != null) {
              if (newValue == DateFilterOption.custom) {
                selectCustomDateRange(
                    context: context,
                    onChange: widget.onChange,
                    customDateRange: widget.customDateRange);
              } else {
                widget.onChange(newValue, null);
              }
            }
          },
        ),
      ),
    );
  }
}
