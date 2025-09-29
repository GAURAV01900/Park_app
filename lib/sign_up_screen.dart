import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1A202C)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Sign Up',
          style: TextStyle(
            color: Color(0xFF1A202C),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 8.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      const SizedBox(height: 16),
                      _buildLabel('Full Name'),
                      _buildTextField(_nameController, 'John Doe', false),
                      const SizedBox(height: 16),
                      _buildLabel('Email Address'),
                      _buildTextField(_emailController, 'you@example.com', false, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 16),
                      _buildLabel('Contact Number'),
                      _buildTextField(_contactController, '+1 (555) 000-0000', false, keyboardType: TextInputType.phone),
                      const SizedBox(height: 16),
                      _buildLabel('Vehicle Number'),
                      _buildTextField(_vehicleController, 'GA-03-AB-1234', false),
                      const SizedBox(height: 16),
                      _buildLabel('Password'),
                      _buildTextField(_passwordController, '••••••••', true),
                      const SizedBox(height: 16),
                      _buildLabel('Confirm Password'),
                      _buildTextField(_confirmPasswordController, '••••••••', true),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1173D4),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            // TODO: Add sign up logic
                          },
                          child: const Text('Sign Up'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Already have an account? Sign In',
                            style: TextStyle(
                              color: Color(0xFF1173D4),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Color(0xFF1A202C),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, bool obscure,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFE5E7EB),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontSize: 16,
        ),
      ),
      style: const TextStyle(
        color: Color(0xFF374151),
        fontSize: 16,
      ),
    );
  }
}
