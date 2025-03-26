import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/database_service.dart';
import '../utils/toast_utils.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      final user = await DatabaseService.instance.getUserByUsername(_usernameController.text);
      if (user != null && user.password == _passwordController.text) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(user: user),
            ),
          );
        }
      } else {
        if (mounted) {
          showTopToast(context, 'Tên đăng nhập hoặc mật khẩu không đúng');
        }
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFE8F5E9),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 48.h),
                        Center(
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/logo.svg',
                                width: 120.w,
                                height: 120.w,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'EASIBANK',
                                style: GoogleFonts.inter(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                'Senior',
                                style: GoogleFonts.inter(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 32.h),
                              Text(
                                'Đăng nhập',
                                style: GoogleFonts.inter(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: const Color(0xFF4A8B4A).withOpacity(0.2),
                            ),
                          ),
                          child: TextField(
                            controller: _usernameController,
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Tên đăng nhập',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: Colors.black54,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16.w),
                              fillColor: Colors.transparent,
                              filled: true,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: const Color(0xFF4A8B4A).withOpacity(0.2),
                            ),
                          ),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Mật khẩu',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: Colors.black54,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16.w),
                              fillColor: Colors.transparent,
                              filled: true,
                              suffixIcon: Icon(
                                Icons.visibility_off_outlined,
                                color: Colors.black54,
                                size: 24.w,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4A8B4A),
                                  minimumSize: Size(double.infinity, 48.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Đăng nhập',
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Container(
                              height: 48.h,
                              width: 48.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A8B4A),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.face_unlock_rounded,
                                  color: Colors.white,
                                  size: 28.w,
                                ),
                                onPressed: () {
                                  showTopToast(context, 'Tính năng nhận diện khuôn mặt đang được phát triển');
                                },
                                style: IconButton.styleFrom(
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: [
                            TextButton(
                              onPressed: _navigateToRegister,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Đăng ký',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF4A8B4A),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                showTopToast(context, 'Tính năng đang được phát triển');
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Quên mật khẩu?',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF4A8B4A),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom navigation
              Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF7DCEA0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: _buildNavItem(
                                icon: Icons.support_agent_rounded,
                                label: 'Hỗ trợ',
                                onTap: () {
                                  showTopToast(context, 'Tính năng hỗ trợ đang được phát triển');
                                },
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              child: _buildNavItem(
                                icon: Icons.notifications_rounded,
                                label: 'Thông báo',
                                onTap: () {
                                  showTopToast(context, 'Tính năng thông báo đang được phát triển');
                                },
                                showBadge: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: -25.h,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              showTopToast(context, 'Tính năng quét QR đang được phát triển');
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.qr_code_scanner_rounded,
                                  size: 32.w,
                                  color: const Color(0xFF4A8B4A),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Quét QR',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF4A8B4A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool showBadge = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Icon(
                    icon,
                    size: 28.w,
                    color: Colors.white,
                  ),
                  if (showBadge)
                    Positioned(
                      right: -2.w,
                      top: 0,
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
} 