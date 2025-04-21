import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:lab/login.dart';

class AllDevicesScreen extends StatefulWidget {
  @override
  _AllDevicesScreenState createState() => _AllDevicesScreenState();
}

class _AllDevicesScreenState extends State<AllDevicesScreen> {
  List<dynamic> devices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDevices();
  }

  Future<void> fetchDevices() async {
    final dio = Dio();
    try {
      final response = await dio.get('$baseurl/ViewItemsApi');
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          devices = response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching devices: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route) => false,
              );
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
        title: Text("All Lab Devices"),
        backgroundColor: Colors.purple.shade700,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];

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
                          if (device['image'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                baseurl + device['image'],
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
                            device['item_name'] ?? 'No Name',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text("MRP: ₹${device['price'] ?? 'N/A'}"),
                          Text("Serial No: ${device['serial_no'] ?? 'N/A'}"),
                          Text("Model : ${device['model'] ?? 'N/A'}"),
                          SizedBox(height: 6),

                          Text(
                            "Description : ${device['description'] ?? 'no description'}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to the Invoice screen with the invoice data
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => InvoiceViewScreen(
                                        invoiceData: {
                                          'invoice_no': device['invoice_no'],
                                          'item_name': device['name'],
                                          'model': device['model_number'],
                                          'serial_no': device['serial_number'],
                                          'price': device['mrp'],
                                          'description': device['description'],
                                          'Bill_date': device['Bill_date'],
                                          'Bussiness_name':
                                              device['Bussiness_name'],
                                          'contact': device['contact'],
                                          'address': device['address'],
                                          'GSTIN': device['GSTIN'],
                                        },
                                      ),
                                ),
                              );
                            },
                            child: Text('View Invoice'),
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

class InvoiceViewScreen extends StatelessWidget {
  final Map<String, dynamic> invoiceData;

  InvoiceViewScreen({required this.invoiceData});

  // Returns a TableRow widget
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Details'),
        backgroundColor: Colors.purple.shade700,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice #${invoiceData['invoice_no']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: Colors.grey),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // buildTableRow('Item Name', invoiceData['item_name'] ?? ''),
                // buildTableRow('Model', invoiceData['model'] ?? ''),
                // buildTableRow('Serial No', invoiceData['serial_no'] ?? ''),
                // buildTableRow('Price', '₹${invoiceData['price'] ?? ''}'),
                // buildTableRow('Description', invoiceData['description'] ?? ''),
                buildTableRow('Bill Date', invoiceData['Bill_date'] ?? ''),
                buildTableRow(
                  'Business Name',
                  invoiceData['Bussiness_name'] ?? '',
                ),
                buildTableRow('Contact', invoiceData['contact'] ?? ''),
                buildTableRow('Address', invoiceData['address'] ?? ''),
                buildTableRow('GSTIN', invoiceData['GSTIN'] ?? ''),
                if (invoiceData['Bill_Image'] != null)
                  buildTableRow(
                    'Bill Image',
                    '',
                    customValueWidget: GestureDetector(
                      onTap:
                          () => _showFullScreenImage(
                            context,
                            baseurl + invoiceData['Bill_Image'],
                          ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          baseurl + invoiceData['Bill_Image'],
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
            if (invoiceData['Bill_Image'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bill Image:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      invoiceData['Bill_Image'], // Assuming the image path is accessible
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

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
}
