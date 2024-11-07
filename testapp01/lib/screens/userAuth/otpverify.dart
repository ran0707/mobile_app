// lib/screens/userAuth/otpverify.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/otp_verification/otp_verification_bloc.dart';
import '../../bloc/otp_verification/otp_verification_event.dart';
import '../../bloc/otp_verification/otp_verification_state.dart';
import '../dashboard/home.dart';

import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:another_flushbar/flushbar.dart'; // Import Flushbar

class OtpVerification extends StatefulWidget {
  final String locality;
  final String phone;

  const OtpVerification({
    Key? key,
    required this.locality,
    required this.phone,
  }) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final TextEditingController _otpController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().isEmpty) {
      print('OTP field is empty');
      Flushbar(
        title: 'Error',
        message: FlutterI18n.translate(context, 'invalid_otp'),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        flushbarPosition: FlushbarPosition.TOP, // Position at the top
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
      ).show(context);
      return;
    }

    print('Verifying OTP: ${_otpController.text.trim()} for phone: ${widget.phone}');

    // Dispatch the VerifyOtp event with correct parameter names
    context.read<OtpVerificationBloc>().add(VerifyOtp(
      phone: widget.phone,
      otpCode: _otpController.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(context, 'verify_otp'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocListener<OtpVerificationBloc, OtpVerificationState>(
          listener: (context, state) {
            if (state is OtpVerificationLoading) {
              // Show loading indicator
              print('OtpVerificationBloc: Loading...');
              setState(() {
                isLoading = true;
              });
            } else {
              setState(() {
                isLoading = false;
              });
            }

            if (state is OtpVerificationSuccess) {
              print('OtpVerificationBloc: Success - ${state.message}');
              Flushbar(
                title: 'Success',
                message: state.message,
                duration: const Duration(seconds: 3),
                backgroundColor: Colors.green,
                flushbarPosition: FlushbarPosition.TOP, // Position at the top
                margin: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(8),
              ).show(context);

              // Navigate to HomePage and remove all previous routes
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Home(locality: '',)),
                    (Route<dynamic> route) => false,
              );
            }

            if (state is OtpVerificationFailure) {
              print('OtpVerificationBloc: Failure - ${state.error}');
              Flushbar(
                title: 'Error',
                message: state.error,
                duration: const Duration(seconds: 3),
                backgroundColor: Colors.red,
                flushbarPosition: FlushbarPosition.TOP, // Position at the top
                margin: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(8),
              ).show(context);
            }
          },
          child: Column(
            children: [
              Text(
                FlutterI18n.translate(context, 'verify_otp_title'),
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: FlutterI18n.translate(context, 'enter_otp'),
                  prefixIcon: const Icon(CupertinoIcons.lock),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                maxLength: 6,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: isLoading ? null : _verifyOtp,
                child: isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.0,
                  ),
                )
                    : Text(
                  FlutterI18n.translate(context, 'verify_button'),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50), // Make button full width
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
