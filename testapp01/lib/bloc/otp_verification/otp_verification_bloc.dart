// lib/bloc/otp_verification/otp_verification_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/api_services.dart';
import 'otp_verification_event.dart';
import 'otp_verification_state.dart';

class OtpVerificationBloc
    extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  final ApiService apiService;

  OtpVerificationBloc({required this.apiService})
      : super(OtpVerificationInitial()) {
    on<VerifyOtp>(_onVerifyOtp);
  }

  Future<void> _onVerifyOtp(
      VerifyOtp event, Emitter<OtpVerificationState> emit) async {
    emit(OtpVerificationLoading());

    try {
      final response = await apiService.verifyOtp(
        name: event.name,
        phone: event.phone,
        otpCode: event.otpCode,
        address: event.address,
        city: event.city,
        state: event.state,
        country: event.country,
      );

      if (response['message'] ==
          'OTP verified and user registered successfully.') {
        emit(OtpVerificationSuccess(message: response['message']));
      } else {
        emit(OtpVerificationFailure(
            error: response['message'] ?? 'Failed to verify OTP.'));
      }
    } catch (e) {
      emit(OtpVerificationFailure(
          error: 'An error occurred while verifying OTP.'));
    }
  }
}
