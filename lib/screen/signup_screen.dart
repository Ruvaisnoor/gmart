import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  Future<void> _handleSignUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return;
    }
    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password should be at least 6 characters")));
      return;
    }
    final user = await _authService.signUp(_emailController.text, _passwordController.text);
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign up failed.")));
    }
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
                "Create Account",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.08,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              _buildInputField(_emailController, "Email", Icons.email, screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildPasswordField(_passwordController, "Password", screenWidth, isPasswordVisible, () => setState(() => isPasswordVisible = !isPasswordVisible)),
              SizedBox(height: screenHeight * 0.02),
              _buildPasswordField(_confirmPasswordController, "Confirm Password", screenWidth, isConfirmPasswordVisible, () => setState(() => isConfirmPasswordVisible = !isConfirmPasswordVisible)),
              SizedBox(height: screenHeight * 0.05),
              _buildButton("SIGN UP", _handleSignUp, screenWidth, Colors.redAccent),
              SizedBox(height: screenHeight * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04)),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Login", style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
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

  Widget _buildPasswordField(TextEditingController controller, String hint, double screenWidth, bool isVisible, VoidCallback toggleVisibility) {
    return Container(
      width: screenWidth * 0.85,
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.15),
          hintText: hint,
          hintStyle: TextStyle(fontSize: screenWidth * 0.04, color: Colors.white70),
          prefixIcon: Icon(Icons.lock, color: Colors.white70, size: screenWidth * 0.06),
          suffixIcon: IconButton(
            icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
            onPressed: toggleVisibility,
          ),
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
        child: Text(label,
            style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)),
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.035),
          elevation: 4,
        ),
      ),
    );
  }
}
