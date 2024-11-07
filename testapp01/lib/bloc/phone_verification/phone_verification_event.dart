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
  final String address;
  final String city;
  final String state;
  final String country;

  const RegisterUser({
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
  });

  @override
  List<Object> get props => [name, phone, address, city, state, country];
}
