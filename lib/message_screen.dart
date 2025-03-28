import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _sendSms() async {
    final String phone = _phoneController.text.trim();
    final String message = _messageController.text.trim();
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phone,
      queryParameters: <String, String>{'body': message},
    );
    await launchUrl(smsUri, mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Send Message")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a phone number';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _messageController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Message",
                  border: OutlineInputBorder(),
                ),
                minLines: 4,
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _sendSms();
                  }
                },
                child: const Text("Send"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
