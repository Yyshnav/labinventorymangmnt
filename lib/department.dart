import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:lab/login.dart';
import 'package:lab/pdfview.dart';

// PDF model
class Pdf {
  final String title;
  final String url;

  Pdf({required this.title, required this.url});

  factory Pdf.fromJson(Map<String, dynamic> json) {
    return Pdf(title: json['filename'] ?? 'Untitled', url: json['file'] ?? '');
  }
}

// PDF list screen
class PdfListScreen extends StatefulWidget {
  const PdfListScreen({super.key});
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
      final response = await _dio.get('$baseurl/GenerateReportApi/$lid');
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
