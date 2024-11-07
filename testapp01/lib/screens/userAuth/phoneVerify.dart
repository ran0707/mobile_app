// lib/screens/userAuth/phoneVerify.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../bloc/phone_verification/phone_verification_bloc.dart';
import '../../bloc/phone_verification/phone_verification_event.dart';
import '../../bloc/phone_verification/phone_verification_state.dart';
import 'otpverify.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:another_flushbar/flushbar.dart'; // Import Flushbar

class PhoneVerification extends StatefulWidget {
  const PhoneVerification({super.key});

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
  const PhoneVerificationForm({super.key});

  @override
  _PhoneVerificationFormState createState() => _PhoneVerificationFormState();
}

class _PhoneVerificationFormState extends State<PhoneVerificationForm> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController street = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController postalcode = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String? _errorMessage;

  Future<Position> _determinePosition() async {
    try {
      print('Requesting location permission...');
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied');
        Flushbar(
          title: 'Permission Denied',
          message: FlutterI18n.translate(context, 'location_permission_denied'),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          margin: const EdgeInsets.all(8),
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(8),
        ).show(context);
        return Future.error('Location permission denied');
      } else if (permission == LocationPermission.deniedForever) {
        print('Location permission denied forever');
        Flushbar(
          title: 'Permission Denied Forever',
          message: FlutterI18n.translate(
              context, 'location_permission_denied_forever'),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          margin: const EdgeInsets.all(8),
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(8),
        ).show(context);
        return Future.error('Location permission denied forever');
      }

      print('Checking if location services are enabled...');
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled');
        Flushbar(
          title: 'Location Service Disabled',
          message: FlutterI18n.translate(context, 'location_service_disabled'),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          margin: const EdgeInsets.all(8),
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(8),
        ).show(context);
        return Future.error('Location service is disabled');
      }

      print('Fetching current position...');
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('Current position: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      print('Error determining position: $e');
      Flushbar(
        title: 'Error',
        message: 'Failed to determine location: $e',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        margin: const EdgeInsets.all(8),
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(8),
      ).show(context);
      rethrow;
    }
  }

  Future<void> GetAddressFromCoor(Position position) async {
    try {
      print('Fetching address from coordinates...');
      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemark.first;

      String getStreetAddress() {
        String streetAddress = "";
        if (place.street != null && place.street!.isNotEmpty) {
          streetAddress += "${place.street!} ";
        }
        if (place.subThoroughfare != null &&
            place.subThoroughfare!.isNotEmpty) {
          streetAddress += "${place.subThoroughfare!} ";
        }
        if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
          streetAddress += "${place.thoroughfare!} ";
        }
        return streetAddress.trim();
      }

      street.text = getStreetAddress();
      city.text = '${place.locality ?? ''}, ${place.administrativeArea ?? ''}';
      country.text = place.country ?? '';
      postalcode.text = place.postalCode ?? '';

      print(
          'Address fetched: ${street.text}, ${city.text}, ${country.text}, ${postalcode.text}');
    } catch (e) {
      print('Error fetching address: $e');
      Flushbar(
        title: 'Error',
        message: FlutterI18n.translate(context, 'error_fetching_address'),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        margin: const EdgeInsets.all(8),
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(8),
      ).show(context);
    }
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final String name = _nameController.text.trim();
    final String phone = _mobileController.text.trim();
    final String address = street.text.trim();
    final String cityName = city.text.split(',').first.trim();
    final String stateName =
        city.text.split(',').length > 1 ? city.text.split(',')[1].trim() : '';
    final String countryName = country.text.trim();

    print(
        'Registering user: $name, $phone, $address, $cityName, $stateName, $countryName');

    // Dispatch the RegisterUser event
    context.read<PhoneVerificationBloc>().add(RegisterUser(
          name: name,
          phone: phone,
          address: address,
          city: cityName,
          state: stateName,
          country: countryName,
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
              // Show loading indicator
              print('PhoneVerificationBloc: Loading...');
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
                title: 'Success',
                message: state.message,
                duration: const Duration(seconds: 3),
                backgroundColor: Colors.green,
                margin: const EdgeInsets.all(8),
                flushbarPosition: FlushbarPosition.TOP,
                borderRadius: BorderRadius.circular(8),
              ).show(context);

              // Navigate to OTP Verification Screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => OtpVerification(
                    locality: city.text.split(',').first,
                    phone: _mobileController.text.trim(),
                  ),
                ),
              );
            }

            if (state is PhoneVerificationFailure) {
              print('PhoneVerificationBloc: Failure - ${state.error}');
              Flushbar(
                title: 'Error',
                message: state.error,
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
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: FlutterI18n.translate(context, 'your_name'),
                        prefixIcon: const Icon(CupertinoIcons.profile_circled),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: IntlPhoneField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: FlutterI18n.translate(context, 'phone_no'),
                        prefixIcon: const Icon(CupertinoIcons.phone),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            try {
                              print('Get OTP button pressed');
                              Position position = await _determinePosition();
                              await GetAddressFromCoor(position);
                              // Proceed to register user and send OTP
                              await _registerUser();
                            } catch (e) {
                              print('Error during OTP process: $e');
                              Flushbar(
                                title: 'Error',
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
                    FlutterI18n.translate(context, 'location_disclaimer'),
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
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
