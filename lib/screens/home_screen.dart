import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/user.dart';
import '../models/feature.dart';
import '../utils/toast_utils.dart';
import '../utils/responsive_text.dart';
import 'login_screen.dart';
import '../services/auth_service.dart';
import '../services/feature_service.dart';
import 'transfer_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _featureService = FeatureService();
  late List<Feature> _features;
  List<Feature> _enabledFeatures = [];

  @override
  void initState() {
    super.initState();
    _initializeFeatures();
  }

  void _initializeFeatures() {
    _features = [
      Feature(
        id: 'transfer',
        label: 'Chuyển tiền',
        icon: Icons.sync_alt_rounded,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransferScreen(user: widget.user),
            ),
          );
        },
      ),
      Feature(
        id: 'savings',
        label: 'Tiết kiệm',
        icon: Icons.savings_outlined,
        onTap: () {
          showTopToast(context, 'Tính năng tiết kiệm đang được phát triển');
        },
      ),
      Feature(
        id: 'bill_payment',
        label: 'Thanh toán\nhoá đơn',
        icon: Icons.receipt_long_outlined,
        onTap: () {
          showTopToast(context, 'Tính năng thanh toán hoá đơn đang được phát triển');
        },
      ),
      Feature(
        id: 'phone_topup',
        label: 'Nạp thẻ\nđiện thoại',
        icon: Icons.phone_android_outlined,
        onTap: () {
          showTopToast(context, 'Tính năng nạp thẻ điện thoại đang được phát triển');
        },
      ),
      Feature(
        id: 'insurance',
        label: 'Bảo hiểm',
        icon: Icons.health_and_safety_outlined,
        onTap: () {
          showTopToast(context, 'Tính năng bảo hiểm đang được phát triển');
        },
      ),
      Feature(
        id: 'investment',
        label: 'Đầu tư',
        icon: Icons.trending_up_rounded,
        onTap: () {
          showTopToast(context, 'Tính năng đầu tư đang được phát triển');
        },
      ),
      Feature(
        id: 'loan',
        label: 'Vay vốn',
        icon: Icons.account_balance_wallet_outlined,
        onTap: () {
          showTopToast(context, 'Tính năng vay vốn đang được phát triển');
        },
      ),
      Feature(
        id: 'credit_card',
        label: 'Thẻ tín dụng',
        icon: Icons.credit_card_outlined,
        onTap: () {
          showTopToast(context, 'Tính năng thẻ tín dụng đang được phát triển');
        },
      ),
    ];
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
      _updateEnabledFeatures();
    });
  }

  void _updateEnabledFeatures() {
    _enabledFeatures = _features.where((f) => f.isEnabled).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: Column(
            children: [
              // Logo và thương hiệu
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'EASIBANK',
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E7D32),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.settings_outlined,
                            size: 24.w,
                            color: const Color(0xFF4A8B4A),
                          ),
                          onPressed: () async {
                            final result = await Navigator.push<List<Feature>>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsScreen(features: _features),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                _features = result;
                                _updateEnabledFeatures();
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.notifications_none_rounded,
                            size: 24.w,
                            color: const Color(0xFF4A8B4A),
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.logout_rounded,
                            size: 24.w,
                            color: const Color(0xFF4A8B4A),
                          ),
                          onPressed: () async {
                            await AuthService.logout();
                            if (mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Thẻ thông tin người dùng
                      Container(
                        margin: EdgeInsets.all(16.w),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFF2E7D32).withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2E7D32).withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24.r,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.elderly_rounded,
                                    size: 32.w,
                                    color: Colors.amber,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: ResponsiveText(
                                    widget.user.fullName,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ResponsiveText(
                                    'Số tài khoản: ${widget.user.accountNumber}',
                                    fontSize: 16,
                                    color: Colors.black87,
                                    maxLines: 1,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Toggle hiển thị số dư
                                  },
                                  child: Icon(
                                    Icons.visibility_outlined,
                                    size: 20.w,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            ResponsiveText(
                              'Số dư: ${widget.user.balance.toStringAsFixed(0)} VND',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2E7D32),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),

                      // Grid chức năng
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 16.h,
                          crossAxisSpacing: 16.w,
                          childAspectRatio: 1.2,
                          children: _enabledFeatures.map((feature) {
                            return _buildFeatureButton(
                              icon: feature.icon,
                              label: feature.label,
                              onTap: feature.onTap,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom navigation
              Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBottomNavItem(
                        icon: Icons.photo_library_outlined,
                        label: 'Sổ tay\nhình ảnh',
                        onTap: () {
                          showTopToast(context, 'Tính năng sổ tay hình ảnh đang được phát triển');
                        },
                      ),
                      _buildBottomNavItem(
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'Quét QR',
                        onTap: () {
                          showTopToast(context, 'Tính năng quét QR đang được phát triển');
                        },
                        isQRScan: true,
                      ),
                      _buildBottomNavItem(
                        icon: Icons.mic_none_rounded,
                        label: 'Sổ tay\ngiọng nói',
                        onTap: () {
                          showTopToast(context, 'Tính năng sổ tay giọng nói đang được phát triển');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F9F5),
            border: Border.all(
              color: const Color(0xFF2E7D32).withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48.w,
                color: const Color(0xFF2E7D32),
              ),
              SizedBox(height: 12.h),
              ResponsiveText(
                label,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isQRScan = false,
  }) {
    final color = isQRScan ? const Color(0xFF2E7D32) : const Color(0xFF2E7D32).withOpacity(0.8);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: isQRScan ? BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ) : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: isQRScan ? 36.w : 28.w,
                color: color,
              ),
              SizedBox(height: 4.h),
              ResponsiveText(
                label,
                fontSize: isQRScan ? 18 : 15,
                fontWeight: isQRScan ? FontWeight.w600 : FontWeight.w500,
                color: color,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}