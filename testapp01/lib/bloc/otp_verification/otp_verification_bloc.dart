// lib/bloc/otp_verification/otp_verification_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/api_services.dart';
import 'otp_verification_event.dart';
import 'otp_verification_state.dart';
import 'dart:convert';

class OtpVerificationBloc extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  final ApiService apiService;

  OtpVerificationBloc({required this.apiService}) : super(OtpVerificationInitial()) {
    on<VerifyOtp>(_onVerifyOtp);
  }

  Future<void> _onVerifyOtp(
      VerifyOtp event,
      Emitter<OtpVerificationState> emit,
      ) async {
    emit(OtpVerificationLoading());

    try {
      final response = await apiService.verifyOtp(
        phone: event.phone,
        otpCode: event.otpCode, // Correct parameter name
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        emit(OtpVerificationSuccess(message: responseData['message'] ?? 'OTP verified successfully.'));
      } else {
        final responseData = json.decode(response.body);
        String errorMessage = 'An error occurred. Please try again.';
        if (responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        print('OtpVerificationBloc Failure: $errorMessage'); // Log specific error
        emit(OtpVerificationFailure(error: errorMessage));
      }
    } catch (error) {
      print('OtpVerificationBloc Error: $error'); // Log the actual error
      emit(OtpVerificationFailure(error: 'An error occurred. Please try again.'));
    }
  }
}
