// otp_verification_state.dart
abstract class OtpVerificationState {}

class OtpInitial extends OtpVerificationState {}

class OtpSending extends OtpVerificationState {}

class OtpSent extends OtpVerificationState {}

class OtpVerificationLoading extends OtpVerificationState {}

class OtpVerificationSuccess extends OtpVerificationState {}

class OtpVerificationFailure extends OtpVerificationState {
  final String error;

  OtpVerificationFailure(this.error);
}
