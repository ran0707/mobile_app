// lib/bloc/otp_verification/otp_verification_event.dart

import 'package:equatable/equatable.dart';

abstract class OtpVerificationEvent extends Equatable {
  const OtpVerificationEvent();

  @override
  List<Object> get props => [];
}

class VerifyOtp extends OtpVerificationEvent {
  final String name;
  final String phone;
  final String otpCode;
  final String address;
  final String city;
  final String state;
  final String country;

  const VerifyOtp({
    required this.name,
    required this.phone,
    required this.otpCode,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
  });

  @override
  List<Object> get props =>
      [name, phone, otpCode, address, city, state, country];
}
