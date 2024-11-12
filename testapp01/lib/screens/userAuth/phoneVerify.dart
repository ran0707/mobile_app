// lib/screens/userAuth/phone_verification.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:testapp01/screens/userAuth/otpverify.dart';

import '../../bloc/phone_verification/phone_verification_bloc.dart';
import '../../bloc/phone_verification/phone_verification_event.dart';
import '../../bloc/phone_verification/phone_verification_state.dart';


class PhoneVerification extends StatefulWidget {
  const PhoneVerification({Key? key}) : super(key: key);

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  @override
  Widget build(BuildContext context) {
    return const PhoneVerificationForm();
  }
}

class PhoneVerificationForm extends StatefulWidget {
  const PhoneVerificationForm({Key? key}) : super(key: key);

  @override
  _PhoneVerificationFormState createState() => _PhoneVerificationFormState();
}

class _PhoneVerificationFormState extends State<PhoneVerificationForm> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final String name = _nameController.text.trim();
    final String phone = _mobileController.text.trim();

    print('Sending OTP to $phone for user $name');

    // Dispatch the RegisterUser event
    context.read<PhoneVerificationBloc>().add(RegisterUser(
          name: name,
          phone: phone,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, 'app_name')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocListener<PhoneVerificationBloc, PhoneVerificationState>(
          listener: (context, state) {
            if (state is PhoneVerificationLoading) {
              setState(() {
                isLoading = true;
              });
            } else {
              setState(() {
                isLoading = false;
              });
            }

            if (state is PhoneVerificationSuccess) {
              print('PhoneVerificationBloc: Success - ${state.message}');
              Flushbar(
                title: FlutterI18n.translate(context, 'success'),
                message: FlutterI18n.translate(context, state.message),
                duration: const Duration(seconds: 3),
                backgroundColor: Colors.green,
                margin: const EdgeInsets.all(8),
                flushbarPosition: FlushbarPosition.TOP,
                borderRadius: BorderRadius.circular(8),
              ).show(context);

              // Navigate to OTP Verification Screen, passing 'name' and 'phone'
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => OtpVerification(
                    name: _nameController.text.trim(),
                    phone: _mobileController.text.trim(),
                  ),
                ),
              );
            }

            if (state is PhoneVerificationFailure) {
              print('PhoneVerificationBloc: Failure - ${state.error}');
              Flushbar(
                title: FlutterI18n.translate(context, 'error'),
                message: FlutterI18n.translate(context, state.error),
                duration: const Duration(seconds: 3),
                backgroundColor: Colors.red,
                margin: const EdgeInsets.all(8),
                flushbarPosition: FlushbarPosition.TOP,
                borderRadius: BorderRadius.circular(8),
              ).show(context);
            }
          },
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    FlutterI18n.translate(context, "phone_verification_title"),
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: FlutterI18n.translate(context, 'your_name'),
                        prefixIcon: const Icon(CupertinoIcons.profile_circled),
                        border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return FlutterI18n.translate(
                              context, "please_enter_your_name");
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  IntlPhoneField(
                    controller: _mobileController,
                    decoration: InputDecoration(
                      labelText: FlutterI18n.translate(context, 'phone_no'),
                      prefixIcon: const Icon(CupertinoIcons.phone),
                      border: const OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      // Optional: Additional actions on phone number change
                    },
                    validator: (phone) {
                      if (phone == null || phone.number.isEmpty) {
                        return FlutterI18n.translate(
                            context, 'invalid_mobile_number');
                      }
                      // Optional: Add more phone number validations if needed
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            try {
                              print('Get OTP button pressed');
                              // Proceed to send OTP
                              await _sendOtp();
                            } catch (e) {
                              print('Error during OTP process: $e');
                              Flushbar(
                                title:
                                    FlutterI18n.translate(context, 'error'),
                                message: FlutterI18n.translate(
                                    context, 'error_sending_otp'),
                                duration: const Duration(seconds: 3),
                                backgroundColor: Colors.red,
                                margin: const EdgeInsets.all(8),
                                flushbarPosition: FlushbarPosition.TOP,
                                borderRadius: BorderRadius.circular(8),
                              ).show(context);
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            FlutterI18n.translate(context, 'get_otp'),
                          ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    FlutterI18n.translate(
                        context, 'phone_verification_disclaimer'),
                    style: const TextStyle(
                        fontSize: 14.0, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
