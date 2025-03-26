import 'package:flutter/material.dart';

class Feature {
  final String id;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  bool isEnabled;

  Feature({
    required this.id,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isEnabled = true,
  });

  Feature copyWith({
    String? id,
    String? label,
    IconData? icon,
    VoidCallback? onTap,
    bool? isEnabled,
  }) {
    return Feature(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      onTap: onTap ?? this.onTap,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'isEnabled': isEnabled,
    };
  }

  factory Feature.fromJson(Map<String, dynamic> json, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Feature(
      id: json['id'],
      label: json['label'],
      icon: icon,
      onTap: onTap,
      isEnabled: json['isEnabled'] ?? true,
    );
  }
}