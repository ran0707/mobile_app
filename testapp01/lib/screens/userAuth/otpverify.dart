// // lib/screens/userAuth/otp_verification.dart

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_i18n/flutter_i18n.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:another_flushbar/flushbar.dart';

// import '../../bloc/otp_verification/otp_verification_bloc.dart';
// import '../../bloc/otp_verification/otp_verification_event.dart';
// import '../../bloc/otp_verification/otp_verification_state.dart';
// import '../dashboard/home.dart';

// class OtpVerification extends StatefulWidget {
//   final String name;
//   final String phone;

//   const OtpVerification({
//     super.key,
//     required this.name,
//     required this.phone,
//   });

//   @override
//   State<OtpVerification> createState() => _OtpVerificationState();
// }

// class _OtpVerificationState extends State<OtpVerification> {
//   final TextEditingController _otpController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   bool isLoading = false;

//   @override
//   void dispose() {
//     _otpController.dispose();
//     super.dispose();
//   }

//   Future<void> _verifyOtp() async {
//     if (!_formKey.currentState!.validate()) {
//       print('OTP form validation failed');
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     final String otpCode = _otpController.text.trim();

//     try {
//       // Determine user position
//       Position position = await _determinePosition();

//       // Get address details
//       Map<String, String> addressDetails = await _getAddress(position);

//       // Dispatch VerifyOtp event with all required fields
//       context.read<OtpVerificationBloc>().add(VerifyOtp(
//             name: widget.name,
//             phone: widget.phone,
//             otpCode: otpCode,
//             address: addressDetails['address'] ?? '',
//             city: addressDetails['city'] ?? '',
//             state: addressDetails['state'] ?? '',
//             country: addressDetails['country'] ?? '',
//           ));
//     } catch (e) {
//       print('Error during OTP verification: $e');
//       // Error messages are already handled in _determinePosition and _getAddress
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<Position> _determinePosition() async {
//     try {
//       // Check location permissions
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied ||
//             permission == LocationPermission.deniedForever) {
//           Flushbar(
//             title: FlutterI18n.translate(context, 'permission_denied'),
//             message:
//                 FlutterI18n.translate(context, 'location_permission_denied'),
//             duration: const Duration(seconds: 3),
//             backgroundColor: Colors.red,
//             margin: const EdgeInsets.all(8),
//             flushbarPosition: FlushbarPosition.TOP,
//             borderRadius: BorderRadius.circular(8),
//           ).show(context);
//           throw Exception('Location permission denied');
//         }
//       }

//       // Check if location services are enabled
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         Flushbar(
//           title: FlutterI18n.translate(context, 'location_service_disabled'),
//           message:
//               FlutterI18n.translate(context, 'enable_location_services'),
//           duration: const Duration(seconds: 3),
//           backgroundColor: Colors.red,
//           margin: const EdgeInsets.all(8),
//           flushbarPosition: FlushbarPosition.TOP,
//           borderRadius: BorderRadius.circular(8),
//         ).show(context);
//         throw Exception('Location services disabled');
//       }

//       // Get current position
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       return position;
//     } catch (e) {
//       Flushbar(
//         title: FlutterI18n.translate(context, 'error'),
//         message: FlutterI18n.translate(context, 'failed_to_get_location'),
//         duration: const Duration(seconds: 3),
//         backgroundColor: Colors.red,
//         margin: const EdgeInsets.all(8),
//         flushbarPosition: FlushbarPosition.TOP,
//         borderRadius: BorderRadius.circular(8),
//       ).show(context);
//       rethrow;
//     }
//   }

//   Future<Map<String, String>> _getAddress(Position position) async {
//     try {
//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks.first;

//       String address = "${place.street}, ${place.locality}";
//       String city = "${place.locality}";
//       String state = "${place.administrativeArea}";
//       String country = "${place.country}";

//       return {
//         'address': address,
//         'city': city,
//         'state': state,
//         'country': country,
//       };
//     } catch (e) {
//       Flushbar(
//         title: FlutterI18n.translate(context, 'error'),
//         message: FlutterI18n.translate(context, 'failed_to_get_address'),
//         duration: const Duration(seconds: 3),
//         backgroundColor: Colors.red,
//         margin: const EdgeInsets.all(8),
//         flushbarPosition: FlushbarPosition.TOP,
//         borderRadius: BorderRadius.circular(8),
//       ).show(context);
//       rethrow;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           FlutterI18n.translate(context, 'verify_otp'),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: BlocListener<OtpVerificationBloc, OtpVerificationState>(
//           listener: (context, state) {
//             if (state is OtpVerificationLoading) {
//               setState(() {
//                 isLoading = true;
//               });
//             } else {
//               setState(() {
//                 isLoading = false;
//               });
//             }

//             if (state is OtpVerificationSuccess) {
//               print('OtpVerificationBloc: Success - ${state.message}');
//               Flushbar(
//                 title: FlutterI18n.translate(context, 'success'),
//                 message: FlutterI18n.translate(context, state.message),
//                 duration: const Duration(seconds: 3),
//                 backgroundColor: Colors.green,
//                 flushbarPosition: FlushbarPosition.TOP,
//                 margin: const EdgeInsets.all(8),
//                 borderRadius: BorderRadius.circular(8),
//               ).show(context);

//               // Navigate to HomePage and remove all previous routes
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => const Home(locality: '',)),
//                 (Route<dynamic> route) => false,
//               );
//             }

//             if (state is OtpVerificationFailure) {
//               print('OtpVerificationBloc: Failure - ${state.error}');
//               Flushbar(
//                 title: FlutterI18n.translate(context, 'error'),
//                 message: FlutterI18n.translate(context, state.error),
//                 duration: const Duration(seconds: 3),
//                 backgroundColor: Colors.red,
//                 flushbarPosition: FlushbarPosition.TOP,
//                 margin: const EdgeInsets.all(8),
//                 borderRadius: BorderRadius.circular(8),
//               ).show(context);
//             }
//           },
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 Text(
//                   FlutterI18n.translate(context, 'otp_verification_title'),
//                   style: const TextStyle(
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20.0),
//                 TextFormField(
//                   controller: _otpController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: FlutterI18n.translate(context, 'enter_otp'),
//                     prefixIcon: const Icon(CupertinoIcons.lock),
//                     border: const OutlineInputBorder(
//                       borderRadius:
//                           BorderRadius.all(Radius.circular(10.0)),
//                     ),
//                   ),
//                   maxLength: 6,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return FlutterI18n.translate(context, 'invalid_otp');
//                     }
//                     if (value.length != 6) {
//                       return FlutterI18n.translate(
//                           context, 'otp_length_error');
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20.0),
//                 ElevatedButton(
//                   onPressed: isLoading ? null : _verifyOtp,
//                   style: ElevatedButton.styleFrom(
//                     minimumSize:
//                         const Size.fromHeight(50), // Make button full width
//                   ),
//                   child: isLoading
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2.0,
//                           ),
//                         )
//                       : Text(
//                           FlutterI18n.translate(context, 'verify_button'),
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:testapp01/screens/dashboard/home.dart';

import '../../bloc/otp_verification/otp_verification_bloc.dart';
import '../../bloc/otp_verification/otp_verification_event.dart';
import '../../bloc/otp_verification/otp_verification_state.dart';

class OtpVerification extends StatefulWidget {
  final String name;
  final String phone;

  const OtpVerification({
    Key? key,
    required this.name,
    required this.phone,
  }) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) {
      print('OTP form validation failed');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final String otpCode = _otpController.text.trim();

    try {
      // Determine user position
      Position position = await _determinePosition();

      // Get address details
      Map<String, String> addressDetails = await _getAddress(position);

      // Dispatch VerifyOtp event with all required fields
      context.read<OtpVerificationBloc>().add(VerifyOtp(
            name: widget.name,
            phone: widget.phone,
            otpCode: otpCode,
            address: addressDetails['address'] ?? '',
            city: addressDetails['city'] ?? '',
            state: addressDetails['state'] ?? '',
            country: addressDetails['country'] ?? '',
          ));
    } catch (e) {
      print('Error during OTP verification: $e');
      // Error messages are already handled in _determinePosition and _getAddress
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Position> _determinePosition() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          Flushbar(
            title: FlutterI18n.translate(context, 'permission_denied'),
            message:
                FlutterI18n.translate(context, 'location_permission_denied'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
            margin: const EdgeInsets.all(8),
            flushbarPosition: FlushbarPosition.TOP,
            borderRadius: BorderRadius.circular(8),
          ).show(context);
          throw Exception('Location permission denied');
        }
      }

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Flushbar(
          title: FlutterI18n.translate(context, 'location_service_disabled'),
          message:
              FlutterI18n.translate(context, 'enable_location_services'),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          margin: const EdgeInsets.all(8),
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(8),
        ).show(context);
        throw Exception('Location services disabled');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      Flushbar(
        title: FlutterI18n.translate(context, 'error'),
        message: FlutterI18n.translate(context, 'failed_to_get_location'),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        margin: const EdgeInsets.all(8),
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(8),
      ).show(context);
      rethrow;
    }
  }

  Future<Map<String, String>> _getAddress(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;

      String address = "${place.street}, ${place.locality}";
      String city = "${place.locality}";
      String state = "${place.administrativeArea}";
      String country = "${place.country}";

      return {
        'address': address,
        'city': city,
        'state': state,
        'country': country,
      };
    } catch (e) {
      Flushbar(
        title: FlutterI18n.translate(context, 'error'),
        message: FlutterI18n.translate(context, 'failed_to_get_address'),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        margin: const EdgeInsets.all(8),
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(8),
      ).show(context);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, 'verify_otp')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocListener<OtpVerificationBloc, OtpVerificationState>(
          listener: (context, state) {
            if (state is OtpVerificationLoading) {
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
                title: FlutterI18n.translate(context, 'success'),
                message: FlutterI18n.translate(context, 'otp_verified_successfully'),
                duration: const Duration(seconds: 3),
                backgroundColor: Colors.green,
                flushbarPosition: FlushbarPosition.TOP,
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
                title: FlutterI18n.translate(context, 'error'),
                message: FlutterI18n.translate(context, state.error),
                duration: const Duration(seconds: 3),
                backgroundColor: Colors.red,
                flushbarPosition: FlushbarPosition.TOP,
                margin: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(8),
              ).show(context);
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  FlutterI18n.translate(context, 'otp_verification_title'),
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
                      borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  maxLength: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return FlutterI18n.translate(context, 'invalid_otp');
                    }
                    if (value.length != 6) {
                      return FlutterI18n.translate(
                          context, 'otp_length_error');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        const Size.fromHeight(50), // Make button full width
                  ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}