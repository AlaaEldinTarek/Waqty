
import 'package:flutter/material.dart';
import '../models/group_model.dart';

class GroupSelector extends StatefulWidget {
  final String? selectedGroupId;
  final Function(GroupModel) onGroupSelected;

  const GroupSelector({super.key, this.selectedGroupId, required this.onGroupSelected});

  @override
  State<GroupSelector> createState() => _GroupSelectorState();
}

class _GroupSelectorState extends State<GroupSelector> {
  late List<GroupModel> _groups;
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _groups = GroupModel.defaultGroups;
    _selectedId = widget.selectedGroupId;
  }

  void _onLongPress(GroupModel group) {
    if (!group.isDefault) {
      showModalBottomSheet(
        context: context,
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('تعديل المجموعة'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('حذف المجموعة'),
              onTap: () {
                setState(() {
                  _groups.removeWhere((g) => g.id == group.id);
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: _groups.map((group) {
          final isSelected = group.id == _selectedId;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedId = group.id;
              });
              widget.onGroupSelected(group);
            },
            onLongPress: () => _onLongPress(group),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: group.color.withOpacity(0.15),
                border: Border.all(color: group.color, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    group.name,
                    style: TextStyle(
                      color: group.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.check, color: group.color),
                  ]
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
