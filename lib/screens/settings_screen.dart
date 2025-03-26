import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/feature.dart';
import '../services/feature_service.dart';
import '../utils/toast_utils.dart';

class SettingsScreen extends StatefulWidget {
  final List<Feature> features;

  const SettingsScreen({super.key, required this.features});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late List<Feature> _features;
  final _featureService = FeatureService();

  @override
  void initState() {
    super.initState();
    _features = List.from(widget.features);
    _loadFeatureSettings();
  }

  Future<void> _loadFeatureSettings() async {
    final settings = await _featureService.getFeatureSettings();
    setState(() {
      for (var feature in _features) {
        if (settings.containsKey(feature.id)) {
          feature.isEnabled = settings[feature.id]!;
        }
      }
    });
  }

  Future<void> _updateFeature(Feature feature, bool value) async {
    setState(() {
      feature.isEnabled = value;
    });
    await _featureService.updateFeature(feature.id, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cài đặt tính năng',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2E7D32),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32)),
          onPressed: () => Navigator.pop(context, _features),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _featureService.saveFeatureSettings(_features);
              if (mounted) {
                showTopToast(context, 'Đã lưu cài đặt');
                Navigator.pop(context, _features);
              }
            },
            child: Text(
              'Lưu',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2E7D32),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              const Color(0xFFE8F5E9).withOpacity(0.5),
            ],
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: _features.length,
          itemBuilder: (context, index) {
            final feature = _features[index];
            return Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                ),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                leading: Icon(
                  feature.icon,
                  size: 32.w,
                  color: const Color(0xFF2E7D32),
                ),
                title: Text(
                  feature.label,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Switch(
                  value: feature.isEnabled,
                  onChanged: (value) => _updateFeature(feature, value),
                  activeColor: const Color(0xFF2E7D32),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 