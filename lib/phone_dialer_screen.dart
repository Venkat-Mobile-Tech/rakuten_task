import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneDialer extends StatefulWidget {
  const PhoneDialer({super.key});
  @override
  State<PhoneDialer> createState() => _PhoneDialerState();
}

class _PhoneDialerState extends State<PhoneDialer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  bool _isValidPhone = false;
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _phoneController.addListener(_onPhoneChanged);
    _isValidPhone = RegExp(r'^\d{10}$').hasMatch(_phoneController.text);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    final isValid = RegExp(r'^\d{10}$').hasMatch(_phoneController.text);
    if (_isValidPhone != isValid) {
      setState(() {
        _isValidPhone = isValid;
      });
    }
  }

  Future<void> _checkPermission() async {
    PermissionStatus status = await Permission.phone.status;
    if (status.isGranted) {
      if (kDebugMode) {
        print("Permission granted");
      }
      setState(() {
        _permissionGranted = true;
      });
    } else {
      setState(() {
        _permissionGranted = false;
      });
      if (kDebugMode) {
        if (status.isPermanentlyDenied) {
          print("Permission permanently denied");
        } else {
          print("Permission denied");
        }
      }
    }
  }

  Future<void> _requestOrOpenSettings() async {
    PermissionStatus status = await Permission.phone.request();
    if (status.isGranted) {
      setState(() {
        _permissionGranted = true;
      });
    } else if (status.isPermanentlyDenied) {
      // If permanently denied, navigate to the app settings.
      openAppSettings();
    } else {
      setState(() {
        _permissionGranted = false;
      });
    }
  }

  Future<void> _makePhoneCall(String number) async {
    final Uri uri = Uri.parse("tel:$number");
    PermissionStatus status = await Permission.phone.status;
    if (status.isGranted) {
      await launchUrl(uri);
    } else {
      if (kDebugMode) {
        print("Permission denied");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If permission is not granted, display a message with a button to request permission.
    if (!_permissionGranted) {
      return Scaffold(
        appBar: AppBar(title: const Text("Dialer Example")),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "You need to provide phone permission to make a call.",
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _requestOrOpenSettings,
                child: const Text("Request Permission"),
              ),
            ],
          ),
        ),
      );
    }

    // If permission is granted, show the dialer form.
    return Scaffold(
      appBar: AppBar(title: const Text("Dialer Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Enter phone number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    _isValidPhone
                        ? () {
                          if (_formKey.currentState!.validate()) {
                            _makePhoneCall(_phoneController.text);
                          }
                        }
                        : null,
                child: Text("Call "),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
