import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:lab/login.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();

  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _penNameController = TextEditingController();

  String? selectedDepartment;
  List<Map<String, dynamic>> departments = [];

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    try {
      final response = await Dio().get('$baseurl/DepartmentApi');
      print(response);
      setState(() {
        departments = List<Map<String, dynamic>>.from(response.data);
      });
    } catch (e) {
      print('Error fetching departments: $e');
    }
  }

  Future<void> registerUser() async {
    try {
      final data = {
        'name': _nameController.text,
        "username": _usernameController.text,
        'password': _passwordController.text,
        'email': _emailController.text,
        'contact': _contactController.text,
        'pen_no': _penNameController.text,
        'department': selectedDepartment,
        "user_type": "pending",
      };

      final response = await Dio().post('$baseurl/UserRegApi', data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } catch (e) {
      print('Registration failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.shade900,
              Colors.purple.shade300,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.3, 0.9],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(
              children: [
                SizedBox(height: 16),
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(height: 40),
                Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30),
                buildTextField('Name', _nameController),

                buildTextField('Username', _usernameController),
                buildTextField(
                  'Password',
                  _passwordController,
                  isPassword: true,
                ),
                buildTextField('Email', _emailController),
                buildTextField('Contact Number', _contactController),
                buildTextField('Pen No', _penNameController),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedDepartment,
                  items:
                      departments.map((dept) {
                        return DropdownMenuItem(
                          value: dept["id"].toString(),
                          child: Text(dept["department"]),
                        );
                      }).toList(),
                  onChanged:
                      (value) => setState(() => selectedDepartment = value),
                  decoration: InputDecoration(
                    labelText: 'Department',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'REGISTER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
