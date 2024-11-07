// lib/bloc/phone_verification/phone_verification_state.dart

import 'package:equatable/equatable.dart';

abstract class PhoneVerificationState extends Equatable {
  const PhoneVerificationState();

  @override
  List<Object> get props => [];
}

class PhoneVerificationInitial extends PhoneVerificationState {}

class PhoneVerificationLoading extends PhoneVerificationState {}

class PhoneVerificationSuccess extends PhoneVerificationState {
  final String message;

  const PhoneVerificationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class PhoneVerificationFailure extends PhoneVerificationState {
  final String error;

  const PhoneVerificationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
