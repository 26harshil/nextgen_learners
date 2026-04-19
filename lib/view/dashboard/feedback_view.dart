import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';
import 'dart:math' as math;

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  late AnimationController _floatingController;
  late AnimationController _fadeController;
  bool _isLoading = false;
  String _version = '1.0.0'; // Default version

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _getAppVersion();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _fadeController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _version = packageInfo.version;
      });
    } catch (e) {
      print('Error getting app version: $e');
    }
  }

  Future<void> _sendFeedback() async {
    if (_nameController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _messageController.text.isEmpty) {
      _showSnackBar('Please fill all fields');
      return;
    }

    if (!_isValidName(_nameController.text)) {
      _showSnackBar('Name should contain only letters and spaces');
      return;
    }

    if (!_isValidMobile(_mobileController.text)) {
      _showSnackBar('Mobile number must be exactly 10 digits');
      return;
    }

    if (!_isValidEmail(_emailController.text)) {
      _showSnackBar('Please enter a valid email address');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final String appName = 'MongoVerse';
      final String platform = Platform.isAndroid ? 'Android' : 'iOS';
      final String personName = _nameController.text;
      final String mobile = _mobileController.text;
      final String email = _emailController.text;
      final String message = _messageController.text;
      final String remarks = '';

      final Map<String, String> formData = {
        'AppName': appName,
        'VersionNo': _version,
        'Platform': platform,
        'PersonName': personName,
        'Mobile': mobile,
        'Email': email,
        'Message': message,
        'Remarks': remarks,
      };

      final response = await http.post(
        Uri.parse('http://api.aswdc.in/Api/MST_AppVersions/PostAppFeedback/AppPostFeedback'),
        headers: {
          'API_KEY': '1234',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: formData,
        encoding: Encoding.getByName('utf-8'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['IsResult'] == 1) {
          _showSnackBar('Feedback sent successfully!', isSuccess: true);
          _clearForm();
        } else {
          _showSnackBar('Error: ${jsonResponse['Message']}');
        }
      } else {
        _showSnackBar('Failed to send feedback: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isValidName(String name) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(name);
  }

  bool _isValidMobile(String mobile) {
    return RegExp(r'^\d{10}$').hasMatch(mobile);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  void _clearForm() {
    _nameController.clear();
    _mobileController.clear();
    _emailController.clear();
    _messageController.clear();
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: isSuccess ? Colors.green.shade600 : Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade600, Colors.purple.shade600],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            title: const Text(
              'Feedback',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [Colors.grey.shade900, Colors.grey.shade800]
                : [Colors.white, Colors.blue.shade50],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeController,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Animated Header
                Container(
                  width: size.width,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade700, Colors.purple.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      AnimatedBuilder(
                        animation: _floatingController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, math.sin(_floatingController.value * 2 * math.pi) * 8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.feedback_outlined,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Share Your Feedback',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Version $_version',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Form Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputField(
                          controller: _nameController,
                          label: 'Name',
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                          ],
                          validator: _isValidName,
                          errorMessage: 'Name should contain only letters and spaces',
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          controller: _mobileController,
                          label: 'Mobile Number',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: _isValidMobile,
                          errorMessage: 'Mobile must be exactly 10 digits',
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          controller: _emailController,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: _isValidEmail,
                          errorMessage: 'Please enter a valid email address',
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          controller: _messageController,
                          label: 'Feedback',
                          keyboardType: TextInputType.multiline,
                          maxLines: 6,
                          validator: (value) => value != null && value.isNotEmpty,
                          errorMessage: 'Feedback cannot be empty',
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _isLoading ? null : _sendFeedback,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                shadowColor: Colors.black.withOpacity(0.2),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                                  : const Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _clearForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                                foregroundColor: isDarkMode ? Colors.white : Colors.black87,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                shadowColor: Colors.black.withOpacity(0.2),
                              ),
                              child: const Text(
                                'Clear',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines,
    bool Function(String)? validator,
    String? errorMessage,
    required bool isDarkMode,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black87,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey.shade600 : Colors.blue.shade200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey.shade600 : Colors.blue.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.blue.shade600,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        errorText: controller.text.isNotEmpty && validator != null && !validator(controller.text)
            ? errorMessage
            : null,
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
        filled: true,
        fillColor: isDarkMode ? Colors.grey.shade700 : Colors.white,
      ),
      onChanged: (value) => setState(() {}), // Update UI on text change
    );
  }
}