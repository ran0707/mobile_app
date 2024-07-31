import 'package:equatable/equatable.dart';

abstract class PhoneVerificationEvent extends Equatable {
  const PhoneVerificationEvent();

  @override
  List<Object> get props => [];
}

class ValidatePhoneNumber extends PhoneVerificationEvent {
  final String phoneNumber;

  const ValidatePhoneNumber(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class RequestOtp extends PhoneVerificationEvent {
  final String phoneNumber;
  final String userName;
  final String streetCity;
  final String adminLocality;
  final String country;
  final String postalCode;

  const RequestOtp(
    this.phoneNumber,
    this.userName,
    this.streetCity,
    this.adminLocality,
    this.country,
    this.postalCode,
  );

  @override
  List<Object> get props => [
        phoneNumber,
        userName,
        streetCity,
        adminLocality,
        country,
        postalCode,
      ];
}


