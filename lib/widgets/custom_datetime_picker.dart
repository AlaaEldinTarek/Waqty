import 'package:flutter/material.dart';

class CustomDateTimePicker extends StatelessWidget {
  final DateTime? selectedDateTime;
  final void Function(DateTime dateTime) onDateTimeSelected;

  const CustomDateTimePicker({
    Key? key,
    required this.selectedDateTime,
    required this.onDateTimeSelected,
  }) : super(key: key);

  Future<void> _pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        onDateTimeSelected(DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pickDateTime(context),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.onSurface),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        child: Text(
          selectedDateTime == null
              ? 'اختيار التاريخ والوقت'
              : '${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year} - ${selectedDateTime!.hour}:${selectedDateTime!.minute}',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
      ),
    );
  }
}
