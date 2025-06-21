import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:krs_app/providers/loader.dart';
import 'dart:ui';

import 'package:krs_app/services/auth.dart';
import 'package:provider/provider.dart';

class Details extends StatefulWidget {
  final String email, pass;
  const Details({super.key, required this.email, required this.pass});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rollController = TextEditingController();
  final _phoneController = TextEditingController();

  String? selectedYear, selectedBranch, selectedDomain;
  final List<String> year = ["1st", "2nd", "3rd", "4th"];
  final List<String> branch = [
    "CSE",
    "CSSE",
    "CSCE",
    "IT",
    "ETC",
    "EEE",
    "ECS",
    "E&I",
    "Electrical",
    "Civil",
    "Mechanical",
    "Mechatronics",
    "Aerospace",
    "Mass Comms",
    "Medical Sciences",
    "Dental Sciences",
    "Nursing Sciences",
  ];
  final List<String> domain = [
    "Advanced Embedded",
    "IoT",
    "Robotics",
    "App Development",
    "Machine Learning",
    "Web Development",
    "Operations",
    "Marketing",
    "Content",
    "Graphic Designing",
    "Video Editing",
    "Photography",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _rollController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    AuthService authService = AuthService();
    if (_formKey.currentState!.validate()) {
      Provider.of<LoaderProvider>(context, listen: false).showLoader(context);

      bool success = await authService.signup(
        _nameController.text.toString(),
        widget.email,
        selectedDomain ?? "None",
        _rollController.text.toString(),
        _phoneController.text.toString(),
        selectedBranch ?? "None",
        selectedYear ?? "None",
        widget.pass,
      );
      if (!mounted) return;
      Provider.of<LoaderProvider>(context, listen: false).hideLoader();

      if (!mounted) return;

      if (success) {
        await Fluttertoast.showToast(
          msg: "SignUp Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/wait');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.sizeOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
              backgroundColor: const Color(0xffE5A122),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    left: -40,
                    bottom: -30,
                    child: _glowCircle(
                      140,
                      const Color(0xFFF1B500),
                      80,
                      30,
                      50,
                    ),
                  ),
                  Positioned(
                    right: -60,
                    bottom: s.height * 0.4,
                    child: _glowCircle(
                      160,
                      const Color(0xFFF1B500),
                      70,
                      25,
                      40,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 20,
                    child: _glowCircle(
                      120,
                      const Color(0xFFF1B500),
                      30,
                      30,
                      20,
                      narrow: true,
                    ),
                  ),

                  SafeArea(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: s.height * 0.04),

                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    "KIIT ROBOTICS",
                                    style: TextStyle(
                                      color: const Color(0xff353535),
                                      fontSize: s.width * 0.11,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          offset: const Offset(-1.5, -1.5),
                                          color: const Color(0xffE5A122),
                                        ),
                                        Shadow(
                                          offset: const Offset(1.5, -1.5),
                                          color: const Color(0xffE5A122),
                                        ),
                                        Shadow(
                                          offset: const Offset(1.5, 1.5),
                                          color: const Color(0xffE5A122),
                                        ),
                                        Shadow(
                                          offset: const Offset(-1.5, 1.5),
                                          color: const Color(0xffE5A122),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "SOCIETY",
                                    style: TextStyle(
                                      color: const Color(0xff353535),
                                      fontSize: s.width * 0.11,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          offset: const Offset(-1.5, -1.5),
                                          color: const Color(0xffE5A122),
                                        ),
                                        Shadow(
                                          offset: const Offset(1.5, -1.5),
                                          color: const Color(0xffE5A122),
                                        ),
                                        Shadow(
                                          offset: const Offset(1.5, 1.5),
                                          color: const Color(0xffE5A122),
                                        ),
                                        Shadow(
                                          offset: const Offset(-1.5, 1.5),
                                          color: const Color(0xffE5A122),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: s.height * 0.08),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(s.width * 0.05),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(204),
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(0xff194DA6),
                                    const Color(0xff2164D7).withAlpha(20),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Center(
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Complete Your Profile',
                                            style: TextStyle(
                                              color: Color(0xffE5A122),
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: s.height * 0.03),
                                  const Text(
                                    'Name',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: s.height * 0.01),
                                  _buildTextField(
                                    icon: Icons.person,
                                    hintText: "Enter your full name",
                                    controller: _nameController,
                                    constraints: constraints,
                                    keyboardType: TextInputType.name,
                                  ),
                                  const Text(
                                    'Roll Number',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: s.height * 0.01),
                                  _buildTextField(
                                    icon: Icons.badge,
                                    hintText: "Enter your roll number",
                                    controller: _rollController,
                                    constraints: constraints,
                                    keyboardType: TextInputType.text,
                                  ),
                                  const Text(
                                    'Phone Number',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: s.height * 0.01),
                                  _buildTextField(
                                    icon: Icons.phone,
                                    hintText: "Enter your phone number",
                                    controller: _phoneController,
                                    constraints: constraints,
                                    keyboardType: TextInputType.phone,
                                  ),
                                  const Text(
                                    'Branch',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: s.height * 0.01),
                                  _buildDropdownField(
                                    dropdownValues: branch,
                                    selectedValue: selectedBranch,
                                    onChanged: (String? v) {
                                      setState(() {
                                        selectedBranch = v;
                                      });
                                    },
                                    hintText: "e.g. CSE, IT, etc",
                                    validatorMessage: "Please select a branch",
                                    isRequired: true,
                                  ),
                                  SizedBox(height: s.height * 0.01),
                                  const Text(
                                    'Year',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: s.height * 0.01),
                                  _buildDropdownField(
                                    dropdownValues: year,
                                    selectedValue: selectedYear,
                                    onChanged: (String? v) {
                                      setState(() {
                                        selectedYear = v;
                                      });
                                    },
                                    hintText: "e.g. 1st, 2nd, etc",
                                    isRequired: true,
                                    validatorMessage:
                                        "Please select your year of study",
                                  ),
                                  SizedBox(height: s.height * 0.01),
                                  const Text(
                                    'Domain',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: s.height * 0.01),
                                  _buildDropdownField(
                                    dropdownValues: domain,
                                    selectedValue: selectedDomain,
                                    onChanged: (String? v) {
                                      setState(() {
                                        selectedDomain = v;
                                      });
                                    },
                                    hintText: "e.g. Operations, Embedded, etc",
                                    isRequired: true,
                                    validatorMessage: "Please select a domain",
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: constraints.maxHeight * 0.02,
                                      bottom: constraints.maxHeight * 0.01,
                                    ),
                                    width: double.infinity,
                                    height: s.height * 0.06,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xff194DA6),
                                          Color(0xffE5A122),
                                        ],
                                      ),
                                    ),
                                    child: TextButton(
                                      onPressed: _submitForm,
                                      child: const Text(
                                        "Submit",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
        );
      },
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hintText,
    required TextEditingController controller,
    required BoxConstraints constraints,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: constraints.maxHeight * 0.025),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: Icon(icon, color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xffE5A122), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '${hintText.split(' ').first} is required';
          }

          if (hintText.toLowerCase().contains('phone')) {
            if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
              return 'Please enter a valid 10-digit phone number';
            }
          }

          if (hintText.toLowerCase().contains('roll')) {
            if (value.trim().length < 3) {
              return 'Please enter a valid roll number';
            }
          }
          if (hintText.toLowerCase().contains('name')) {
            if (value.trim().length < 2) {
              return 'Name must be at least 2 characters long';
            }
            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
              return 'Name can only contain letters and spaces';
            }
          }

          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField({
    required List<String> dropdownValues,
    required String? selectedValue,
    required Function(String?) onChanged,
    String? hintText,
    String? validatorMessage,
    bool isRequired = false,
  }) {
    return DropdownButtonFormField<String>(
      iconEnabledColor: Colors.white,
      hint: Text(hintText.toString(), style: TextStyle(color: Colors.white54)),

      dropdownColor: Color(0xffE5A122),
      style: TextStyle(color: Colors.white, fontSize: 18),
      value: selectedValue,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xffE5A122), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items:
          dropdownValues.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(child: Text(value)),
              ),
            );
          }).toList(),
      onChanged: onChanged,
      validator:
          isRequired
              ? (value) {
                if (value == null || value.isEmpty) {
                  return validatorMessage ?? 'Please select an option';
                }
                return null;
              }
              : null,
    );
  }

  Widget _glowCircle(
    double size,
    Color color,
    double blur,
    double spread,
    double blurSigma, {
    bool narrow = false,
  }) {
    return Container(
      width: narrow ? 30 : size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withAlpha(78),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(103),
            blurRadius: blur,
            spreadRadius: spread,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}
