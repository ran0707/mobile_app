// otp_verification_event.dart
abstract class OtpVerificationEvent {}

class SendOtp extends OtpVerificationEvent {
  final String phone;
  final String name;

  SendOtp(this.phone, this.name);
}

class VerifyOtp extends OtpVerificationEvent {
  final String otp;

  VerifyOtp(this.otp);
}
