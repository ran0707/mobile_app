// lib/bloc/phone_verification/phone_verification_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/api_services.dart';
import 'phone_verification_event.dart';
import 'phone_verification_state.dart';

class PhoneVerificationBloc
    extends Bloc<PhoneVerificationEvent, PhoneVerificationState> {
  final ApiService apiService;

  PhoneVerificationBloc({required this.apiService})
      : super(PhoneVerificationInitial()) {
    on<RegisterUser>(_onRegisterUser);
  }

  Future<void> _onRegisterUser(
      RegisterUser event, Emitter<PhoneVerificationState> emit) async {
    emit(PhoneVerificationLoading());

    try {
      final response = await apiService.sendOtp(event.name, event.phone);

      if (response['message'] == 'OTP sent successfully.') {
        emit(PhoneVerificationSuccess(message: response['message']));
      } else {
        emit(PhoneVerificationFailure(
            error: response['message'] ?? 'Failed to send OTP.'));
      }
    } catch (e) {
      emit(PhoneVerificationFailure(
          error: 'An error occurred while sending OTP.'));
    }
  }
}
