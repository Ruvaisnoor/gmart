import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = false;

  Future<void> _handleLogin() async {
    UserCredential? user = await _authService.login(
      _emailController.text, _passwordController.text
    );
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed. Please check your credentials."))
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    UserCredential? user = await _authService.signInWithGoogle();
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google sign in canceled or failed"))
      );
    }
  }

  Future<void> _handleFacebookSignIn() async {
    // Call the static Facebook sign-in method.
    UserCredential? user = await AuthService.signInWithFacebook();
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Facebook sign in canceled or failed"))
      );
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
        // Gradient background.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.redAccent.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.07, vertical: screenHeight * 0.07
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.08),
              Text(
                "Login",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.08,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              _buildInputField(_emailController, "Email", Icons.email, screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildPasswordField(_passwordController, "Password", screenWidth),
              SizedBox(height: screenHeight * 0.05),
              _buildButton("LOGIN", _handleLogin, screenWidth, Colors.redAccent),
              SizedBox(height: screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(Icons.g_mobiledata, "Google",
                      _handleGoogleSignIn, screenWidth),
                  _buildSocialButton(Icons.facebook, "Facebook",
                      _handleFacebookSignIn, screenWidth),
                ],
              ),
              SizedBox(height: screenHeight * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: Text(
                      "Create an Account →",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/forgot'),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: screenWidth * 0.04,
                        fontStyle: FontStyle.italic
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
            borderSide: BorderSide.none
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hint, double screenWidth) {
    return Container(
      width: screenWidth * 0.85,
      child: TextField(
        controller: controller,
        obscureText: !isPasswordVisible,
        style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.15),
          hintText: hint,
          hintStyle: TextStyle(fontSize: screenWidth * 0.04, color: Colors.white70),
          prefixIcon: Icon(Icons.lock, color: Colors.white70, size: screenWidth * 0.06),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white70
            ),
            onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed, double screenWidth, Color color) {
    return Container(
      width: screenWidth * 0.85,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          )
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)
          ),
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.035),
          elevation: 4,
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label, VoidCallback onPressed, double screenWidth) {
    return Container(
      width: screenWidth * 0.4,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02, vertical: screenWidth * 0.035
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)
          ),
          elevation: 4,
        ),
        icon: Icon(icon, size: screenWidth * 0.06),
        label: Text(
          label,
          style: TextStyle(fontSize: screenWidth * 0.045)
        ),
        onPressed: onPressed,
      ),
    );
  }
}
