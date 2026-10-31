import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  final String planName;
  final double price;
  final int validityDays;
  final String description;

  const PaymentPage({
    super.key,
    required this.planName,
    required this.price,
    required this.validityDays,
    required this.description,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController upiController = TextEditingController();

  bool paymentVerified = false;
  DateTime? paymentTime;
  DateTime? expiryTime;

  final String merchantUpi = "yourupi@bank";

  String get qrData {
    return "upi://pay"
        "?pa=$merchantUpi"
        "&pn=MyApp"
        "&am=${widget.price.toStringAsFixed(2)}"
        "&cu=INR";
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  // Payment verification placeholder
  // Connect your payment gateway/backend here.

  Future<void> verifyPayment() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment verification requires a payment gateway."),
      ),
    );

    // Do not set paymentVerified = true here.
    // Set it only after server-side verification.
  }

  // Generate PDF invoice

  Future<void> generateInvoice() async {
    if (!paymentVerified || paymentTime == null || expiryTime == null) {
      return;
    }

    final pdf = pw.Document();

    final invoiceId = "INV-${paymentTime!.millisecondsSinceEpoch}";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,

        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(30),

            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,

              children: [
                pw.Text(
                  "PAYMENT INVOICE",
                  style: pw.TextStyle(
                    fontSize: 27,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 25),

                pw.Text("Invoice ID: $invoiceId"),
                pw.Text("Payment Status: SUCCESS"),

                pw.Divider(),

                pw.SizedBox(height: 15),

                pw.Text(
                  "SUBSCRIPTION DETAILS",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 10),

                pw.Text("Plan: ${widget.planName}"),
                pw.Text("Description: ${widget.description}"),
                pw.Text("Validity: ${widget.validityDays} Days"),

                pw.Text("Amount Paid: Rs. ${widget.price.toStringAsFixed(2)}"),

                pw.SizedBox(height: 20),

                pw.Text(
                  "PAYMENT INFORMATION",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 10),

                pw.Text("Payment Date & Time: ${formatDate(paymentTime!)}"),

                pw.SizedBox(height: 20),

                pw.Text(
                  "SUBSCRIPTION VALIDITY",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 10),

                pw.Text("Activation Date: ${formatDate(paymentTime!)}"),

                pw.Text("Expiry Date: ${formatDate(expiryTime!)}"),

                pw.Spacer(),

                pw.Divider(),

                pw.Text("Thank you for choosing our service!"),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  void dispose() {
    upiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment"), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Selected Plan",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                title: Text(
                  widget.planName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                subtitle: Text(
                  "${widget.validityDays} Days\n"
                  "${widget.description}",
                ),

                trailing: Text(
                  "₹${widget.price}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Center(
              child: Text(
                "Scan QR Code to Pay",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            Center(child: QrImageView(data: qrData, size: 210)),

            const SizedBox(height: 10),

            const Center(child: Text("Scan with any UPI application")),

            const SizedBox(height: 25),

            const Center(child: Text("OR")),

            const SizedBox(height: 20),

            const Text(
              "Enter UPI ID",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: upiController,

              decoration: const InputDecoration(
                hintText: "example@upi",
                prefixIcon: Icon(Icons.payment),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: verifyPayment,

                child: const Text(
                  "Verify Payment",
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (paymentVerified) ...[
              const Text(
                "Payment Successful!",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text("Paid: ${formatDate(paymentTime!)}"),

              Text("Expires: ${formatDate(expiryTime!)}"),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  onPressed: generateInvoice,

                  icon: const Icon(Icons.download),

                  label: const Text("Download Invoice PDF"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
