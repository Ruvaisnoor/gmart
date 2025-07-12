// lib/screens/sign_up_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController  = TextEditingController();
  bool isPasswordVisible        = false;
  bool isConfirmPasswordVisible = false;

  Future<void> _handleSignUp() async {
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match"))
      );
      return;
    }
    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters"))
      );
      return;
    }
    final user = await _authService.signUp(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sign up failed. Please try again."))
      );
    }
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
        width: w,
        height: h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
                "Create Account",
                style: GoogleFonts.poppins(
                  fontSize: w * 0.08,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: h * 0.05),

              // Email
              _buildInputField(
                controller: _emailController,
                hint:       "Email",
                icon:       Icons.email,
                width:      w,
              ),
              SizedBox(height: h * 0.02),

              // Password
              _buildPasswordField(
                controller:    _passwordController,
                hint:          "Password",
                width:         w,
                isVisible:     isPasswordVisible,
                toggleVisible: () => setState(() => isPasswordVisible = !isPasswordVisible),
              ),
              SizedBox(height: h * 0.02),

              // Confirm Password
              _buildPasswordField(
                controller:    _confirmController,
                hint:          "Confirm Password",
                width:         w,
                isVisible:     isConfirmPasswordVisible,
                toggleVisible: () => setState(() => isConfirmPasswordVisible = !isConfirmPasswordVisible),
              ),
              SizedBox(height: h * 0.05),

              // Sign Up Button
              _buildButton(
                label:   "SIGN UP",
                onTap:   _handleSignUp,
                width:   w,
                color:   Colors.greenAccent,
              ),
              SizedBox(height: h * 0.05),

              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.04,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
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
        style: TextStyle(fontSize: width * 0.045, color: Colors.white),
        decoration: InputDecoration(
          filled:     true,
          fillColor:  Colors.white.withOpacity(0.15),
          hintText:   hint,
          hintStyle:  TextStyle(fontSize: width * 0.04, color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70, size: width * 0.06),
          border:     OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide:    BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String               hint,
    required double               width,
    required bool                 isVisible,
    required VoidCallback         toggleVisible,
  }) {
    return Container(
      width: width * 0.85,
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        style: TextStyle(fontSize: width * 0.045, color: Colors.white),
        decoration: InputDecoration(
          filled:     true,
          fillColor:  Colors.white.withOpacity(0.15),
          hintText:   hint,
          hintStyle:  TextStyle(fontSize: width * 0.04, color: Colors.white70),
          prefixIcon: Icon(Icons.lock, color: Colors.white70, size: width * 0.06),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white70,
            ),
            onPressed: toggleVisible,
          ),
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
