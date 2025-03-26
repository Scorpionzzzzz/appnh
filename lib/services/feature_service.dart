import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../models/feature.dart';

class FeatureService {
  static const String _key = 'feature_settings';
  static final FeatureService _instance = FeatureService._internal();
  
  factory FeatureService() {
    return _instance;
  }

  FeatureService._internal();

  Future<void> saveFeatureSettings(List<Feature> features) async {
    final prefs = await SharedPreferences.getInstance();
    final featureData = features.map((f) => f.toJson()).toList();
    await prefs.setString(_key, jsonEncode(featureData));
  }

  Future<Map<String, bool>> getFeatureSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data == null) return {};

    final List<dynamic> featureData = jsonDecode(data);
    return Map.fromEntries(
      featureData.map((f) => MapEntry(f['id'], f['isEnabled'] ?? true)),
    );
  }

  Future<void> updateFeature(String featureId, bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data == null) {
      await saveFeatureSettings([Feature(
        id: featureId,
        label: '',
        icon: Icons.error,
        onTap: () {},
        isEnabled: isEnabled,
      )]);
      return;
    }

    final List<dynamic> featureData = jsonDecode(data);
    final updatedData = featureData.map((f) {
      if (f['id'] == featureId) {
        return {...f, 'isEnabled': isEnabled};
      }
      return f;
    }).toList();

    await prefs.setString(_key, jsonEncode(updatedData));
  }
} 