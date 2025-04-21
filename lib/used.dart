import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:lab/login.dart'; // Make sure baseurl is defined here

class UsedPhonesScreen extends StatefulWidget {
  @override
  _UsedPhonesScreenState createState() => _UsedPhonesScreenState();
}

class _UsedPhonesScreenState extends State<UsedPhonesScreen> {
  List<dynamic> phones = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPhones();
  }

  Future<void> fetchPhones() async {
    final dio = Dio();
    try {
      final response = await dio.get('$baseurl/ViewUsedApi');
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          phones = response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching used phones: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: Text("Used Phones"),
        backgroundColor: Colors.purple.shade700,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: phones.length,
                itemBuilder: (context, index) {
                  final phone = phones[index];

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (phone['image'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                baseurl + phone['image'],
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        Icon(Icons.broken_image, size: 100),
                              ),
                            ),
                          SizedBox(height: 10),
                          Text(
                            phone['model'] ?? 'Unknown Model',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text("Price: ₹${phone['price'] ?? 'N/A'}"),
                          SizedBox(height: 6),
                          Text(
                            "Description: ${phone['description'] ?? 'No description'}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => UsedPhoneDetailScreen(
                                        phoneData: phone,
                                      ),
                                ),
                              );
                            },
                            child: Text('View Details'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.purple.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}

class UsedPhoneDetailScreen extends StatelessWidget {
  final Map<String, dynamic> phoneData;

  UsedPhoneDetailScreen({required this.phoneData});

  TableRow buildTableRow(
    String label,
    String value, {
    Widget? customValueWidget,
  }) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: customValueWidget ?? Text(value),
        ),
      ],
    );
  }

  // Method to show full-screen image
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                leading: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Center(
                child: InteractiveViewer(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (context, error, stackTrace) => Text(
                          'Failed to load image',
                          style: TextStyle(color: Colors.white),
                        ),
                  ),
                ),
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Details'),
        backgroundColor: Colors.purple.shade700,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              phoneData['model'] ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: Colors.grey),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                buildTableRow('Price', '₹${phoneData['price'] ?? ''}'),
                buildTableRow('Item Name', phoneData['item_name'] ?? ''),
                buildTableRow('Serial Number', phoneData['serial_no'] ?? ''),
                buildTableRow('Condition', phoneData['status'] ?? ''),
                buildTableRow(
                  'Business Name',
                  phoneData['Bussiness_name'] ?? '',
                ),
                buildTableRow('Contact', phoneData['contact'] ?? ''),
                buildTableRow('Address', phoneData['address'] ?? ''),
                buildTableRow('Invoice No', phoneData['invoice_no'] ?? ''),
                buildTableRow('GSTIN', phoneData['GSTIN'] ?? ''),
                buildTableRow('Bill Date', phoneData['Bill_date'] ?? ''),
                buildTableRow('Description', phoneData['description'] ?? ''),
                if (phoneData['Bill_Image'] != null)
                  buildTableRow(
                    'Bill Image',
                    '',
                    customValueWidget: GestureDetector(
                      onTap:
                          () => _showFullScreenImage(
                            context,
                            baseurl + phoneData['Bill_Image'],
                          ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          baseurl + phoneData['Bill_Image'],
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Text(
                                'Failed to load image',
                                style: TextStyle(color: Colors.red),
                              ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
