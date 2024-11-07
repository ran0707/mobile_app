// lib/bloc/otp_verification/otp_verification_event.dart

import 'package:equatable/equatable.dart';

abstract class OtpVerificationEvent extends Equatable {
  const OtpVerificationEvent();

  @override
  List<Object> get props => [];
}

class VerifyOtp extends OtpVerificationEvent {
  final String phone;
  final String otpCode; // Note: 'otpCode' is the parameter name

  const VerifyOtp({required this.phone, required this.otpCode});

  @override
  List<Object> get props => [phone, otpCode];
}
