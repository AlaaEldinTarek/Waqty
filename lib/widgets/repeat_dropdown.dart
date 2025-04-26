// import 'package:flutter/material.dart';
//
// class RepeatDropdown extends StatelessWidget {
//   final String initialValue;
//   final Function(String) onChanged;
//
//   const RepeatDropdown(
//       {super.key, required this.initialValue, required this.onChanged});
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       value: initialValue,
//       isExpanded: true,
//       decoration: const InputDecoration(
//         labelText: 'تكرار المهمة',
//         border: OutlineInputBorder(),
//       ),
//       items: const [
//         DropdownMenuItem(value: 'none', child: Text('لا تكرار')),
//         DropdownMenuItem(value: 'daily', child: Text('يوميًا')),
//         DropdownMenuItem(value: 'everyOtherDay', child: Text('يوم ويوم')),
//         DropdownMenuItem(value: 'weekly', child: Text('أسبوعيًا')),
//         DropdownMenuItem(value: 'monthly', child: Text('شهريًا')),
//       ],
//       onChanged: onChanged,
//     );
//   }
// }
