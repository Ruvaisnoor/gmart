import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  bool isEmailSent = false;

  Future<void> _handleResetPassword() async {
    await _authService.resetPassword(_emailController.text);
    setState(() {
      isEmailSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double screenHeight = size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.redAccent.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07, vertical: screenHeight * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.08),
              Text(
                "Reset Password",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.08,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              _buildInputField(_emailController, "Email", Icons.email, screenWidth),
              SizedBox(height: screenHeight * 0.05),
              _buildButton("RESET PASSWORD", _handleResetPassword, screenWidth, Colors.redAccent),
              SizedBox(height: screenHeight * 0.05),
              if (isEmailSent)
                Text(
                  "✅ Reset link sent to your email!",
                  style: TextStyle(color: Colors.greenAccent, fontSize: screenWidth * 0.045),
                ),
              SizedBox(height: screenHeight * 0.05),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Back to Login", style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint, IconData icon, double screenWidth) {
    return Container(
      width: screenWidth * 0.85,
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.15),
          hintText: hint,
          hintStyle: TextStyle(fontSize: screenWidth * 0.04, color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70, size: screenWidth * 0.06),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed, double screenWidth, Color color) {
    return Container(
      width: screenWidth * 0.85,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label, style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.035),
          elevation: 4,
        ),
      ),
    );
  }
}
