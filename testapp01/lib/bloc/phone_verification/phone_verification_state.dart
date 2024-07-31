abstract class PhoneVerificationState{ }

class PhoneInitial extends PhoneVerificationState { }

class PhoneValid extends PhoneVerificationState { }

class PhoneInvalid extends PhoneVerificationState { }

class PhoneVerificationLoading extends PhoneVerificationState { }

class PhoneVerificationSuccess extends PhoneVerificationState { }

class PhoneVerificationFailure extends PhoneVerificationState{
  final String error;
  PhoneVerificationFailure(this.error);
}
