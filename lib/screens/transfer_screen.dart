import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/user.dart';
import '../utils/toast_utils.dart';

class TransferScreen extends StatefulWidget {
  final User user;

  const TransferScreen({super.key, required this.user});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedBank = 'EASIBANK';
  String _selectedAccountType = 'Tài khoản EASIBANK';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: const Color(0xFF4A8B4A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Chuyển tiền',
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
              Colors.white,
              const Color(0xFFE8F5E9).withOpacity(0.5),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thông tin người gửi
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: const Color(0xFF4A8B4A).withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thông tin người gửi',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4A8B4A),
                        ),
                      ),
                      SizedBox(height: 16.h),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.user.fullName,
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  widget.user.accountNumber,
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Số dư khả dụng: ${widget.user.balance.toStringAsFixed(0)} VND',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF4A8B4A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // Thông tin người nhận
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: const Color(0xFF4A8B4A).withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thông tin người nhận',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4A8B4A),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      DropdownButtonFormField<String>(
                        value: _selectedBank,
                        decoration: InputDecoration(
                          labelText: 'Chọn ngân hàng',
                          labelStyle: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: Colors.black54,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        items: ['EASIBANK', 'Vietcombank', 'Techcombank', 'ACB']
                            .map((bank) => DropdownMenuItem(
                                  value: bank,
                                  child: Text(bank),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedBank = value!;
                          });
                        },
                      ),
                      SizedBox(height: 16.h),
                      DropdownButtonFormField<String>(
                        value: _selectedAccountType,
                        decoration: InputDecoration(
                          labelText: 'Loại tài khoản',
                          labelStyle: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: Colors.black54,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        items: [
                          'Tài khoản EASIBANK',
                          'Thẻ ATM',
                          'Tài khoản ngân hàng khác'
                        ].map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            )).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedAccountType = value!;
                          });
                        },
                      ),
                      SizedBox(height: 16.h),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Số tài khoản',
                          labelStyle: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: Colors.black54,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.mic_none_rounded,
                              color: const Color(0xFF4A8B4A),
                              size: 24.w,
                            ),
                            onPressed: () {
                              showTopToast(context, 'Tính năng nhập bằng giọng nói đang được phát triển');
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Số tiền',
                          labelStyle: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: Colors.black54,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.mic_none_rounded,
                              color: const Color(0xFF4A8B4A),
                              size: 24.w,
                            ),
                            onPressed: () {
                              showTopToast(context, 'Tính năng nhập bằng giọng nói đang được phát triển');
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextField(
                        controller: _noteController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Nội dung chuyển khoản',
                          labelStyle: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: Colors.black54,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.mic_none_rounded,
                              color: const Color(0xFF4A8B4A),
                              size: 24.w,
                            ),
                            onPressed: () {
                              showTopToast(context, 'Tính năng nhập bằng giọng nói đang được phát triển');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Nút chuyển tiền
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement transfer logic
                    showTopToast(context, 'Tính năng chuyển tiền đang được phát triển');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A8B4A),
                    minimumSize: Size(double.infinity, 48.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Chuyển tiền',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }
} 