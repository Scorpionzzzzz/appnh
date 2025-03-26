import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/database_service.dart';
import '../utils/toast_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Kiểm tra username đã tồn tại chưa
      final isAvailable = await DatabaseService.instance.isUsernameAvailable(
        _usernameController.text,
      );

      if (!isAvailable) {
        if (!mounted) return;
        showTopToast(context, 'Tên đăng nhập đã tồn tại');
        return;
      }

      // Tạo tài khoản mới
      await DatabaseService.instance.createUser(
        username: _usernameController.text,
        password: _passwordController.text,
        fullName: _fullNameController.text,
        phoneNumber: _phoneController.text,
        email: _emailController.text,
      );

      if (!mounted) return;
      showTopToast(context, 'Đăng ký thành công');
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      showTopToast(context, 'Lỗi: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4A8B4A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Đăng ký tài khoản',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4A8B4A),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFF0F9F0),
              const Color(0xFF4A8B4A).withOpacity(0.15),
            ],
            stops: const [0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thông tin tài khoản',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Tên đăng nhập
                  _buildTextField(
                    controller: _usernameController,
                    icon: 'assets/icons/user.svg',
                    label: 'Tên đăng nhập',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên đăng nhập';
                      }
                      if (value.length < 4) {
                        return 'Tên đăng nhập phải có ít nhất 4 ký tự';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  // Mật khẩu
                  _buildTextField(
                    controller: _passwordController,
                    icon: 'assets/icons/lock.svg',
                    label: 'Mật khẩu',
                    obscureText: _obscurePassword,
                    onToggleObscure: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu';
                      }
                      if (value.length < 6) {
                        return 'Mật khẩu phải có ít nhất 6 ký tự';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  // Xác nhận mật khẩu
                  _buildTextField(
                    controller: _confirmPasswordController,
                    icon: 'assets/icons/lock.svg',
                    label: 'Xác nhận mật khẩu',
                    obscureText: _obscureConfirmPassword,
                    onToggleObscure: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng xác nhận mật khẩu';
                      }
                      if (value != _passwordController.text) {
                        return 'Mật khẩu không khớp';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Thông tin cá nhân',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Họ và tên
                  _buildTextField(
                    controller: _fullNameController,
                    icon: 'assets/icons/user.svg',
                    label: 'Họ và tên',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập họ và tên';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  // Số điện thoại
                  _buildTextField(
                    controller: _phoneController,
                    icon: 'assets/icons/phone.svg',
                    label: 'Số điện thoại',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập số điện thoại';
                      }
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return 'Số điện thoại không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  // Email
                  _buildTextField(
                    controller: _emailController,
                    icon: 'assets/icons/email.svg',
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32.h),
                  // Nút đăng ký
                  Container(
                    height: 48.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF4A8B4A),
                          const Color(0xFF4A8B4A).withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text(
                        'Đăng ký',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String icon,
    required String label,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: SvgPicture.asset(
              icon,
              width: 20.w,
              height: 20.w,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
              ),
              decoration: InputDecoration(
                hintText: label,
                hintStyle: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15.h,
                ),
                suffixIcon: onToggleObscure != null
                    ? IconButton(
                        icon: SvgPicture.asset(
                          obscureText
                              ? 'assets/icons/eye-off.svg'
                              : 'assets/icons/eye.svg',
                          width: 20.w,
                          height: 20.w,
                          color: Colors.grey[600],
                        ),
                        onPressed: onToggleObscure,
                      )
                    : null,
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
} 