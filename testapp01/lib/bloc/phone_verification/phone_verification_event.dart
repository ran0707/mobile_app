// lib/bloc/phone_verification/phone_verification_event.dart

import 'package:equatable/equatable.dart';

abstract class PhoneVerificationEvent extends Equatable {
  const PhoneVerificationEvent();

  @override
  List<Object> get props => [];
}

class RegisterUser extends PhoneVerificationEvent {
  final String name;
  final String phone;

  const RegisterUser({required this.name, required this.phone});

  @override
  List<Object> get props => [name, phone];
}
