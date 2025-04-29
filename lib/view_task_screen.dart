// تم التحديث لإظهار أيقونة الجرس إذا كانت المهمة تحتوي على تذكير
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'add_task_page.dart';
import 'package:intl/intl.dart' hide TextDirection;

class ViewTasksScreen extends StatefulWidget {
  final void Function(bool) onToggleTheme;
  final String? initialPayload;
  const ViewTasksScreen({
    super.key,
    required this.onToggleTheme,
    this.initialPayload,
  });

  @override
  State<ViewTasksScreen> createState() => _ViewTasksScreenState();
}

class _ViewTasksScreenState extends State<ViewTasksScreen> {
  List<Map<String, dynamic>> _tasks = [];
  Set<int> _expandedTasks = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialPayload != null) {
      print("📩 Payload received from notification: ${widget.initialPayload}");
      // ممكن تعمل بيها فلترة أو عرض معين
    }
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List decoded = jsonDecode(tasksJson);
      setState(() {
        _tasks = List<Map<String, dynamic>>.from(decoded);
      });
    }
  }

  void _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', jsonEncode(_tasks));
  }

  bool useWhiteForeground(Color backgroundColor) {
    final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);
    return brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المهام المحفوظة'),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                switch (value) {
                  case 'theme':
                    widget.onToggleTheme(!isDark);
                    break;
                  case 'profile':
                    break;
                  case 'language':
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'theme',
                  child: Row(
                    children: [
                      Icon(
                        isDark ? Icons.light_mode : Icons.dark_mode,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(width: 8),
                      Text(isDark ? 'وضع النهار' : 'الوضع الليلي'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: _tasks.isEmpty
            ? const Center(
                child: Text('لا توجد مهام محفوظة  📭',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  final groupColor = task['groupColor'] != null
                      ? Color(task['groupColor'])
                      : Colors.white;
                  final isExpanded = _expandedTasks.contains(index);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded
                            ? _expandedTasks.remove(index)
                            : _expandedTasks.add(index);
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isExpanded
                            ? groupColor.withOpacity(0.65)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: groupColor, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? groupColor.withOpacity(0.30)
                                : groupColor.withOpacity(0.30),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  task['title'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                  ),
                                ),
                              ),
                              if (task['reminderEnabled'] == true)
                                const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(Icons.notifications_active,
                                      color: Colors.orangeAccent),
                                ),
                            ],
                          ),
                          if (isExpanded) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.notes,
                                  size: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  task['details'] ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.folder,
                                  size: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'المجموعة: ${task['group'] ?? ''}',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.repeat,
                                  size: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'التكرار: ${task['repeat'] ?? ''}',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'الوقت و التاريخ: ${DateFormat('hh:mm', 'ar').format(DateTime.parse(task['dateTime']))} ${DateFormat('a', 'ar').format(DateTime.parse(task['dateTime']))} – ${DateFormat('d MMMM yyyy', 'ar').format(DateTime.parse(task['dateTime']))}',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(
                                          MaterialPageRoute(
                                            builder: (_) => AddTaskPage(
                                              existingTask: _tasks[index],
                                              taskIndex: index,
                                            ),
                                          ),
                                        )
                                        .then((_) => _loadTasks());
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _tasks.removeAt(index);
                                      _saveTasks();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton.extended(
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('إضافة مهمة'),
          onPressed: () async {
            // await Navigator.of(context)
            //     .push(
            //   PageRouteBuilder(
            //     pageBuilder: (context, animation, secondaryAnimation) =>
            //         const AddTaskPage(),
            //     transitionsBuilder:
            //         (context, animation, secondaryAnimation, child) {
            //       var curve = Curves.fastLinearToSlowEaseIn;
            //       var curvedAnimation =
            //           CurvedAnimation(parent: animation, curve: curve);
            //
            //       return ScaleTransition(
            //         scale: Tween<double>(begin: 0.9, end: 1.0)
            //             .animate(curvedAnimation),
            //         child: FadeTransition(
            //           opacity: curvedAnimation,
            //           child: child,
            //         ),
            //       );
            //     },
            //     transitionDuration: const Duration(milliseconds: 800),
            //   ),
            // )
            await Navigator.of(context)
                .push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const AddTaskPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            )
                .then((result) {
              if (result == 'added' || result == 'edited') {
                _loadTasks();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result == 'added'
                        ? '✅ تمت إضافة المهمة بنجاح'
                        : '✏️ تم تعديل المهمة بنجاح'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            });
          },
        ),
      ),
    );
  }
}
