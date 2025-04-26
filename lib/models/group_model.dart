
import 'package:flutter/material.dart';

class GroupModel {
  final String id;
  final String name;
  final Color color;
  final bool isDefault;

  GroupModel({
    required this.id,
    required this.name,
    required this.color,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'isDefault': isDefault,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'],
      name: map['name'],
      color: Color(map['color']),
      isDefault: map['isDefault'] ?? false,
    );
  }

  static List<GroupModel> defaultGroups = [
    GroupModel(
      id: 'personal',
      name: 'شخصي',
      color: Colors.blue,
      isDefault: true,
    ),
    GroupModel(
      id: 'work',
      name: 'عمل',
      color: Colors.green,
      isDefault: true,
    ),
    GroupModel(
      id: 'study',
      name: 'دراسة',
      color: Colors.orange,
      isDefault: true,
    ),
    GroupModel(
      id: 'family',
      name: 'عائلي',
      color: Colors.purple,
      isDefault: true,
    ),
    ...List.generate(5, (index) {
      return GroupModel(
        id: 'user_$index',
        name: 'مجموعة ${index + 1}',
        color: [
          Colors.red,
          Colors.teal,
          Colors.indigo,
          Colors.brown,
          Colors.cyan,
        ][index],
        isDefault: false,
      );
    })
  ];
}
