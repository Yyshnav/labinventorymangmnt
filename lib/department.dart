import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:lab/login.dart';
import 'package:lab/pdfview.dart';

class Department {
  final int id;
  final String name;

  Department({required this.id, required this.name});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(id: json['id'], name: json['department']);
  }
}

// PDF model
class Pdf {
  final String title;
  final String url;

  Pdf({required this.title, required this.url});

  factory Pdf.fromJson(Map<String, dynamic> json) {
    return Pdf(title: json['filename'] ?? 'Untitled', url: json['file'] ?? '');
  }
}

class DepartmentListScreen extends StatefulWidget {
  @override
  _DepartmentListScreenState createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {
  final Dio _dio = Dio();
  List<Department> departments = [];
  bool isLoading = false;
  String? errorMessage;

  // Assuming baseUrl is defined; replace with your actual base URL
  // final String baseurl = 'https://api.example.com';

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await _dio.get('$baseurl/DepartmentApi');
      print(response.data);
      final List<dynamic> data = response.data;
      setState(() {
        departments = data.map((json) => Department.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load departments: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50, // Light purple background
      appBar: AppBar(
        title: Text('Departments', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple.shade700, // Purple theme for AppBar
        elevation: 4, // Slight shadow for depth
        iconTheme: IconThemeData(color: Colors.white), // White icons
      ),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.purple.shade700,
                  ),
                ),
              )
              : errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.purple.shade700,
                      size: 48,
                    ),
                    SizedBox(height: 16),
                    Text(
                      errorMessage!,
                      style: TextStyle(
                        color: Colors.purple.shade700,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: fetchDepartments,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: departments.length,
                itemBuilder: (context, index) {
                  final department = departments[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        department.name,
                        style: TextStyle(
                          color: Colors.purple.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.purple.shade700,
                        size: 16,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => PdfListScreen(id: department.id),
                          ),
                        );
                      },
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}

// PDF list screen
class PdfListScreen extends StatefulWidget {
  final int id;

  const PdfListScreen({super.key, required this.id});
  @override
  _PdfListScreenState createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> {
  final Dio _dio = Dio();
  List<Pdf> pdfs = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchPdfs();
  }

  Future<void> fetchPdfs() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Replace with your actual API endpoint
      final response = await _dio.get(
        '$baseurl/GenerateReportApi/${widget.id}',
      );
      print(response.data);

      // Check if response.data is a Map (single object) or List
      if (response.data is Map<String, dynamic>) {
        // Handle single PDF object
        final pdf = Pdf.fromJson(response.data);
        setState(() {
          pdfs = [pdf]; // Wrap single PDF in a list
          isLoading = false;
        });
      } else if (response.data is List<dynamic>) {
        // Handle list of PDFs (if API changes in the future)
        final List<dynamic> data = response.data;
        setState(() {
          pdfs = data.map((json) => Pdf.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load PDFs: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(backgroundColor: Colors.purple.shade50),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : pdfs.isEmpty
              ? const Center(child: Text('No PDFs available'))
              : ListView.builder(
                itemCount: pdfs.length,
                itemBuilder: (context, index) {
                  final pdf = pdfs[index];
                  return Card(
                    margin: EdgeInsets.all(16.0),
                    color: Colors.white,
                    child: ListTile(
                      title: Text(pdf.title),
                      onTap: () {
                        openPdf(pdf.url, pdf.title, context);
                        // Handle PDF tap (e.g., open PDF in a viewer)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Downloading...')),
                        );
                        // Add logic to open the PDF (see below)
                      },
                    ),
                  );
                },
              ),
    );
  }
}
