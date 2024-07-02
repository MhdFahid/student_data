import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void exportFile() async {
  final pdf = pw.Document();
  final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('students').get();

  final List<List<dynamic>> tableData = [];

  snapshot.docs.asMap().forEach((index, doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    tableData.add([
      index + 1, // Adding 1 to start index from 1 instead of 0
      data['name'] ?? '',
      data['email'] ?? '',
      data['age'] ?? '',
      data['address'] ?? '',
      // Add more fields as needed
    ]);
  });
  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Header(
          level: 2,
          child: pw.Text('Student List'),
        ),
        pw.TableHelper.fromTextArray(
          cellAlignment: pw.Alignment.topLeft,
          headerStyle: pw.TextStyle(
              color: PdfColors.black, fontWeight: pw.FontWeight.bold),
          headers: <String>[
            'No',
            'Name',
            'Email Address',
            'Age',
            'Address',
          ],
          data: tableData,
          cellStyle: const pw.TextStyle(),
        ),
      ],
    ),
  );

  await Printing.layoutPdf(onLayout: (format) => pdf.save());
}
