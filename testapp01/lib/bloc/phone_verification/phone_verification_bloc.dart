// lib/bloc/phone_verification/phone_verification_bloc.dart

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/api_services.dart';
import 'phone_verification_event.dart';
import 'phone_verification_state.dart';

class PhoneVerificationBloc extends Bloc<PhoneVerificationEvent, PhoneVerificationState> {
  final ApiService apiService;

  PhoneVerificationBloc({required this.apiService}) : super(PhoneVerificationInitial()) {
    on<RegisterUser>(_onRegisterUser);
  }

  Future<void> _onRegisterUser(
      RegisterUser event,
      Emitter<PhoneVerificationState> emit,
      ) async {
    emit(PhoneVerificationLoading());

    try {
      final response = await apiService.registerUser(
        name: event.name,
        phone: event.phone,
        address: event.address,
        city: event.city,
        state: event.state,
        country: event.country,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        emit(PhoneVerificationSuccess(message: responseData['message'] ?? 'OTP sent successfully.'));
      } else {
        final responseData = json.decode(response.body);
        emit(PhoneVerificationFailure(error: responseData['message'] ?? 'Failed to send OTP.'));
      }
    } catch (error) {
      emit(PhoneVerificationFailure(error: 'An error occurred. Please try again.'));
    }
  }
}
