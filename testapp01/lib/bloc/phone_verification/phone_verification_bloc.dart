import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'phone_verification_event.dart';
import 'phone_verification_state.dart';


class PhoneVerificationBloc extends Bloc<PhoneVerificationEvent, PhoneVerificationState> {
  PhoneVerificationBloc() : super(PhoneInitial()) {
    on<ValidatePhoneNumber>(_onValidatePhoneNumber);
    on<RequestOtp>(_onRequestOtp);

  }

  void _onValidatePhoneNumber(ValidatePhoneNumber event,
      Emitter<PhoneVerificationState> emit,) {
    final phoneNumber = event.phoneNumber;
   // print('validating phone no : $phoneNumber');
    if (phoneNumber.length == 10 &&
        (phoneNumber.startsWith('6') || phoneNumber.startsWith('7') ||
            phoneNumber.startsWith('8') || phoneNumber.startsWith('9'))) {
      //print('phone no is vaild');
      emit(PhoneValid());
    } else {
      //print('phone no is invalid');
      emit(PhoneInvalid());
    }
  }

  Future<void> _onRequestOtp(RequestOtp event,
      Emitter<PhoneVerificationState> emit,) async {
    emit(PhoneVerificationLoading());

    //final url = Uri.parse('http://localhost:3000/api/users/phone');
   final url = Uri.parse('https://60de-121-200-52-98.ngrok-free.app/api/users/phone');
    //final url = Uri.parse('http://10.0.2.2:3000/api/users/phone');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone': event.phoneNumber,
          'name': event.userName,
          'streetCity': event.streetCity,
          'adminLocality': event.adminLocality,
          'country': event.country,
          'postalCode': event.postalCode,

        }),
      );
      if (response.statusCode == 200) {
        print('data saved successfully');
        emit(PhoneVerificationSuccess());
      } else {
        emit(PhoneVerificationFailure(
            'Failed to send data: ${response.statusCode}'));
      }
    } catch (e) {
      emit(PhoneVerificationFailure('Error : $e'));
    }
  }
}



