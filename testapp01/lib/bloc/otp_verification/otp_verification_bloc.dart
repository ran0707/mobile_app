// otp_verification_bloc.dart
import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'otp_verification_event.dart';
import 'otp_verification_state.dart';

class OtpVerificationBloc extends Bloc<OtpVerificationEvent, OtpVerificationState> {


  OtpVerificationBloc() : super(OtpInitial()) {
    // on<SendOtp>(_onSendOtp);
    on<VerifyOtp>(_onVerifyOtp);
  }



  Future<void> _onVerifyOtp(VerifyOtp event, Emitter<OtpVerificationState> emit) async {
    emit(OtpVerificationLoading());
    final url = Uri.parse('http://10.0.2.2:3000/api/users/verify-otp');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'otp': event.otp}),
      );
      if (response.statusCode == 200) {
        emit(OtpVerificationSuccess());

      } else {
        emit(OtpVerificationFailure('Failed to verify OTP: ${response.statusCode}'));
      }
    } catch (e) {
      emit(OtpVerificationFailure('Error verifying OTP: $e'));
    }
  }
}
