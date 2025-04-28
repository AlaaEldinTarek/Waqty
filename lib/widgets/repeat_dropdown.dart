import 'package:flutter/material.dart';

class RepeatDropdown extends StatelessWidget {
  final String selectedRepeat;
  final Function(String?) onChanged;

  const RepeatDropdown({
    super.key,
    required this.selectedRepeat,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter, // أو حسب انت عايز
      child: Flexible(
        child: SizedBox(
          width: 300, // 👈 كده حجمه محدد
          child: DropdownButtonFormField<String>(
            value: selectedRepeat,
            onChanged: onChanged,
            decoration: InputDecoration(
              // labelText: 'تكرار المهمة',
              // labelStyle: TextStyle(
              //   color: Theme.of(context).colorScheme.onSurface,
              //   fontWeight: FontWeight.bold,
              // ),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              prefixIcon: const Icon(Icons.repeat),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            ),
            dropdownColor: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest, // 👈 لون مميز للقائمة
            elevation: 8, // 👈 ظل خفيف
            items: const [
              DropdownMenuItem(
                value: 'none',
                child: SizedBox(
                  width: 150, // 👈 العرض اللي انت تتحكم فيه
                  child: Text('لا تكرار'),
                ),
              ),
              DropdownMenuItem(
                value: 'daily',
                child: SizedBox(
                  width: 150,
                  child: Text('يوميًا'),
                ),
              ),
              DropdownMenuItem(
                value: 'alternate',
                child: SizedBox(
                  width: 150,
                  child: Text('يوم ويوم'),
                ),
              ),
              DropdownMenuItem(
                value: 'weekly',
                child: SizedBox(
                  width: 150,
                  child: Text('أسبوعيًا'),
                ),
              ),
              DropdownMenuItem(
                value: 'monthly',
                child: SizedBox(
                  width: 150,
                  child: Text('شهريًا'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
