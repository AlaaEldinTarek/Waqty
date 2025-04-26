// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';
// import 'package:intl/intl.dart';
// import '../models/task_model.dart';
// import '../models/group_model.dart';
// import '../widgets/repeat_dropdown.dart';
// import '../screens/group_selector.dart';
// import '../services/storage_helper.dart';
// import '../services/notification_helper.dart';
//
// class AddTaskPage extends StatefulWidget {
//   const AddTaskPage({super.key});
//
//   @override
//   State<AddTaskPage> createState() => _AddTaskPageState();
// }
//
// class _AddTaskPageState extends State<AddTaskPage> {
//   final _titleController = TextEditingController();
//   final _detailsController = TextEditingController();
//   DateTime? _selectedDateTime;
//   String _selectedRepeat = 'none';
//   GroupModel? _selectedGroup;
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(title: const Text('إضافة مهمة')),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 TextField(
//                   controller: _titleController,
//                   decoration: const InputDecoration(labelText: 'عنوان المهمة'),
//                 ),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: _detailsController,
//                   maxLines: 3,
//                   decoration: const InputDecoration(labelText: 'تفاصيل المهمة'),
//                 ),
//                 const SizedBox(height: 12),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final picked = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime(2100),
//                       locale: const Locale('ar', 'EG'),
//                     );
//                     if (picked != null) {
//                       final time = await showTimePicker(
//                         context: context,
//                         initialTime: TimeOfDay.now(),
//                       );
//                       if (time != null) {
//                         setState(() {
//                           _selectedDateTime = DateTime(
//                             picked.year,
//                             picked.month,
//                             picked.day,
//                             time.hour,
//                             time.minute,
//                           );
//                         });
//                       }
//                     }
//                   },
//                   child: Text(_selectedDateTime == null
//                       ? 'اختر التاريخ والوقت'
//                       : DateFormat.yMMMMEEEEd('ar')
//                           .add_jm()
//                           .format(_selectedDateTime!)),
//                 ),
//                 const SizedBox(height: 12),
//                 RepeatDropdown(
//                   initialValue: _selectedRepeat,
//                   onChanged: (val) => setState(() => _selectedRepeat = val),
//                 ),
//                 const SizedBox(height: 12),
//                 GroupSelector(
//                   selectedGroupId: _selectedGroup?.id,
//                   onGroupSelected: (group) {
//                     setState(() {
//                       _selectedGroup = group;
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (_titleController.text.isNotEmpty &&
//                         _selectedDateTime != null &&
//                         _selectedGroup != null) {
//                       final task = TaskModel(
//                         id: const Uuid().v4(),
//                         title: _titleController.text.trim(),
//                         details: _detailsController.text.trim(),
//                         dateTime: _selectedDateTime!,
//                         group: _selectedGroup!.id,
//                         repeat: _selectedRepeat,
//                       );
//                       final tasks = await StorageHelper.loadTasks();
//                       tasks.add(task);
//                       await StorageHelper.saveTasks(tasks);
//                       await NotificationHelper.showNotificationBeforeTask(
//                           task.title, task.dateTime);
//                       if (mounted) Navigator.pop(context);
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('يرجى تعبئة جميع الحقول')),
//                       );
//                     }
//                   },
//                   child: const Text('إضافة المهمة'),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
