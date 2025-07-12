// lib/screens/forgot_password_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthService _authService     = AuthService();
  final TextEditingController _emailC = TextEditingController();
  bool isEmailSent = false;

  Future<void> _handleResetPassword() async {
    await _authService.resetPassword(_emailC.text.trim());
    setState(() => isEmailSent = true);
  }

  @override
  Widget build(BuildContext context) {
    final size        = MediaQuery.of(context).size;
    final w           = size.width;
    final h           = size.height;
    const topColor    = Color(0xFF4CAF50);
    const bottomColor = Color.fromARGB(221, 190, 234, 175);

    return Scaffold(
      body: Container(
        width:  w,
        height: h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end:   Alignment.bottomCenter,
            colors: [ topColor, bottomColor ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.07,
            vertical:   h * 0.07,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: h * 0.08),
              Text(
                "Reset Password",
                style: GoogleFonts.poppins(
                  fontSize: w * 0.08,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: h * 0.05),

              // Email Input
              _buildInputField(
                controller: _emailC,
                hint:       "Email",
                icon:       Icons.email,
                width:      w,
              ),
              SizedBox(height: h * 0.05),

              // Reset Button
              _buildButton(
                label:   "RESET PASSWORD",
                onTap:   _handleResetPassword,
                width:   w,
                color:   Colors.greenAccent,
              ),
              SizedBox(height: h * 0.03),

              // Confirmation Message
              if (isEmailSent)
                Text(
                  "✅ Reset link sent to your email!",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: w * 0.045,
                  ),
                ),
              SizedBox(height: h * 0.05),

              // Back to Login
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Back to Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.04,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String               hint,
    required IconData             icon,
    required double               width,
  }) {
    return Container(
      width: width * 0.85,
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: width * 0.045,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          filled:     true,
          fillColor:  Colors.white.withOpacity(0.15),
          hintText:   hint,
          hintStyle:  TextStyle(
            fontSize: width * 0.04,
            color: Colors.white70,
          ),
          prefixIcon: Icon(icon, color: Colors.white70, size: width * 0.06),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide:    BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String       label,
    required VoidCallback onTap,
    required double       width,
    required Color        color,
  }) {
    return Container(
      width: width * 0.85,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          label,
          style: TextStyle(
            fontSize: width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(vertical: width * 0.035),
        ),
      ),
    );
  }
}
