import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/notification_service.dart';

class AddTaskPage extends StatefulWidget {
  final Map<String, dynamic>? existingTask;
  final int? taskIndex;

  const AddTaskPage({super.key, this.existingTask, this.taskIndex});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  DateTime? _selectedDateTime;
  String _selectedRepeat = 'none';
  String _selectedGroup = 'شخصي';
  bool _enableReminder = false;
  double _reminderMinutes = 5;

  final List<Map<String, dynamic>> _defaultGroups = [
    {'name': 'شخصي', 'color': Colors.pinkAccent},
    {'name': 'عمل', 'color': Colors.blueAccent},
    {'name': 'دراسة', 'color': Colors.orangeAccent},
    {'name': 'عائلي', 'color': Colors.green},
  ];

  final List<Map<String, dynamic>> _customGroups = [];

  @override
  void initState() {
    super.initState();
    _loadCustomGroups();
    if (widget.existingTask != null) {
      _titleController.text = widget.existingTask!['title'] ?? '';
      _detailsController.text = widget.existingTask!['details'] ?? '';
      _selectedDateTime =
          DateTime.tryParse(widget.existingTask!['dateTime'] ?? '');
      _selectedRepeat = widget.existingTask!['repeat'] ?? 'none';
      _selectedGroup = widget.existingTask!['group'] ?? '';
      _enableReminder = widget.existingTask!['reminderEnabled'] ?? false;
    }
  }

  Future<void> _loadCustomGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final groupsJson = prefs.getString('customGroups');
    if (groupsJson != null) {
      final List decoded = jsonDecode(groupsJson);
      setState(() {
        _customGroups.clear();
        _customGroups.addAll(decoded.map((g) => {
              'name': g['name'],
              'color': Color(g['color']),
            }));
      });
    }
  }

  Future<void> _saveCustomGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final groupsJson = jsonEncode(_customGroups
        .map((g) => {
              'name': g['name'],
              'color': (g['color'] as Color).value,
            })
        .toList());
    await prefs.setString('customGroups', groupsJson);
  }

  bool _canSubmit() {
    return _titleController.text.isNotEmpty &&
        _detailsController.text.isNotEmpty &&
        _selectedDateTime != null &&
        _selectedGroup.isNotEmpty;
  }

  void _showAddGroupDialog() {
    final nameController = TextEditingController();
    Color selectedColor = Colors.grey;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('إنشاء مجموعة جديدة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم المجموعة'),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  Colors.brown,
                  Colors.cyan,
                  Colors.indigo,
                  Colors.amber,
                  Colors.deepOrange,
                  Colors.lime,
                  Colors.blueAccent,
                  Colors.pinkAccent,
                  Colors.tealAccent,
                  Colors.purple
                ].map((color) {
                  final isSelected = selectedColor == color;
                  return GestureDetector(
                    onTap: () => setState(() => selectedColor = color),
                    child: Container(
                      width: 34,
                      height: 34,
                      margin: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              ),
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty &&
                    !_customGroups.any((g) => g['name'] == newName) &&
                    !_defaultGroups.any((g) => g['name'] == newName)) {
                  if (_customGroups.length >= 5) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('يمكنك إضافة حتى 5 مجموعات فقط'),
                      ),
                    );
                    return;
                  }
                  setState(() {
                    _customGroups
                        .add({'name': newName, 'color': selectedColor});
                  });
                  _saveCustomGroups();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'اسم المجموعة موجود مسبقًا أو غير صالح',
                        style: TextStyle(color: Color(0xffffffff)),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('إضافة'),
            )
          ],
        ),
      ),
    );
  }

  void _submitTask() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString('tasks');
      List tasks = tasksJson != null ? jsonDecode(tasksJson) : [];

      final newTask = {
        'title': _titleController.text.trim(),
        'details': _detailsController.text.trim(),
        'dateTime': _selectedDateTime!.toIso8601String(),
        'repeat': _selectedRepeat,
        'group': _selectedGroup,
        'groupColor': (_defaultGroups + _customGroups)
            .firstWhere((g) => g['name'] == _selectedGroup)['color']
            .value,
        'reminderEnabled': _enableReminder,
      };

      if (widget.taskIndex != null) {
        tasks[widget.taskIndex!] = newTask;
      } else {
        tasks.add(newTask);
      }
      if (_enableReminder) {
        Future.delayed(
          Duration(minutes: _reminderMinutes.round()),
          () {
            NotificationService.showReminderNotification(
              id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
              title: '📌 تذكير بمهمة',
              body: _titleController.text.trim(),
              payload: _titleController.text.trim(), // اسم المهمة أو ID مميز
            );
          },
        );
      }
      await prefs.setString('tasks', jsonEncode(tasks));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.taskIndex != null
              ? 'تم تعديل المهمة بنجاح'
              : 'تمت إضافة المهمة بنجاح'),
        ),
      );
      Navigator.pop(context);
    }
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) =>
          value == null || value.isEmpty ? 'هذا الحقل مطلوب' : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).cardColor,
      ),
    );
  }

  Widget _buildDateTimePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (time != null) {
            setState(() {
              _selectedDateTime = DateTime(
                  date.year, date.month, date.day, time.hour, time.minute);
            });
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.onSurface),
        ),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        child: Text(
          _selectedDateTime == null
              ? 'اختيار التاريخ والوقت'
              : _selectedDateTime.toString(),
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownRepeat() {
    return DropdownButtonFormField<String>(
      value: _selectedRepeat,
      items: const [
        DropdownMenuItem(value: 'none', child: Text('لا تكرار')),
        DropdownMenuItem(value: 'daily', child: Text('يوميًا')),
        DropdownMenuItem(value: 'alternate', child: Text('يوم ويوم')),
        DropdownMenuItem(value: 'weekly', child: Text('أسبوعيًا')),
        DropdownMenuItem(value: 'monthly', child: Text('شهريًا')),
      ],
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelText: 'تكرار المهمة',
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      onChanged: (value) => setState(() => _selectedRepeat = value!),
    );
  }

  Widget _buildGroupSection(List<Map<String, dynamic>> groups) {
    final bool isCustom = groups == _customGroups;
    return Column(
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: groups.map((group) {
            final isSelected = _selectedGroup == group['name'];
            final isCustomGroup = _customGroups.contains(group);
            final color = group['color'] as Color;

            return GestureDetector(
              onTap: () => setState(() => _selectedGroup = group['name']!),
              onLongPress:
                  isCustomGroup ? () => _showEditGroupDialog(group) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: color,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        group['name'],
                        style: TextStyle(
                          color: isSelected ? Colors.white : color,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.check, color: Colors.white, size: 18),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (isCustom) ...[
          const SizedBox(height: 10),
          Container(
              margin: EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: Colors.greenAccent, // ← لون الخلفية الجديد
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton.icon(
                onPressed: _showAddGroupDialog,
                icon: const Icon(Icons.add, color: Color(0xffffffff)),
                label: const Text('إضافة مجموعة جديدة',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xffffffff))),
              )),
        ],
      ],
    );
  }

  Widget _buildReminderSection() {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('تفعيل التذكير'),
          value: _enableReminder,
          onChanged: (value) => setState(() => _enableReminder = value!),
        ),
        if (_enableReminder)
          Column(
            children: [
              const Text('اختيار مدة التذكير (بالدقائق)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: _reminderMinutes,
                min: 5,
                max: 60,
                divisions: 11,
                label: '${_reminderMinutes.round()} دقيقة',
                onChanged: (value) {
                  setState(() => _reminderMinutes = value);
                },
              ),
            ],
          )
      ],
    );
  }

  void _showEditGroupDialog(Map<String, dynamic> group) {
    final nameController = TextEditingController(text: group['name']);
    Color selectedColor = group['color'] ?? Colors.grey;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('تعديل المجموعة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم المجموعة'),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  Colors.brown,
                  Colors.cyan,
                  Colors.indigo,
                  Colors.amber,
                  Colors.deepOrange,
                  Colors.lime,
                  Colors.blueAccent,
                  Colors.pinkAccent,
                  Colors.tealAccent,
                  Colors.purple
                ].map((color) {
                  final isSelected = selectedColor.value == color.value;
                  return GestureDetector(
                    onTap: () => setState(() => selectedColor = color),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              ),
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => _customGroups.remove(group));
                _saveCustomGroups();
                Navigator.pop(context);
              },
              child: const Text('حذف', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty &&
                    !_customGroups
                        .any((g) => g['name'] == newName && g != group) &&
                    !_defaultGroups.any((g) => g['name'] == newName)) {
                  setState(() {
                    group['name'] = newName;
                    group['color'] = selectedColor;
                    _saveCustomGroups();
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'اسم المجموعة موجود مسبقًا أو غير صالح',
                        style: TextStyle(color: Color(0xffffffff)),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('حفظ'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF000080),
          foregroundColor: Color(0xffffffff),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          if (_canSubmit()) {
            _submitTask();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('يرجى ملء جميع الحقول المطلوبة قبل حفظ المهمة'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Text(widget.taskIndex != null ? 'حفظ التعديلات' : 'إضافة المهمة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة مهمة'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                  controller: _titleController, label: 'عنوان المهمة'),
              const SizedBox(height: 10),
              _buildTextField(
                  controller: _detailsController,
                  label: 'تفاصيل المهمة',
                  maxLines: 4),
              const SizedBox(height: 10),
              _buildDateTimePicker(context),
              const SizedBox(height: 10),
              _buildDropdownRepeat(),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerRight,
                child: Text('المجموعات الافتراضية:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),
              _buildGroupSection(_defaultGroups),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'مجموعاتي',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'يمكن تعديل مجموعاتي عن طريق الضغط المطول لمدة 3 ثواني.',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.help_outline,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              _buildGroupSection(_customGroups),
              const SizedBox(height: 20),
              _buildReminderSection(),
              const SizedBox(height: 20),
              _buildGradientButton(),
            ],
          ),
        ),
      ),
    );
  }
}
