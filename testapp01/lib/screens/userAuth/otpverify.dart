import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testapp01/localization/app_localizations.dart';
import 'package:testapp01/screens/userAuth/userverify.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:testapp01/bloc/otp_verification/otp_verification_bloc.dart';
import 'package:testapp01/bloc/otp_verification/otp_verification_event.dart';
import 'package:testapp01/bloc/otp_verification/otp_verification_state.dart';

import '../dashboard/home.dart';

class OtpVerification extends StatefulWidget {

final String locality;

  // final String phone;
  // final String name;

  const OtpVerification({ super.key, required this.locality});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> with CodeAutoFill {
  final _otpController = TextEditingController();
  late OtpVerificationBloc _bloc;


  @override
  void initState(){
    super.initState();
    _bloc = BlocProvider.of<OtpVerificationBloc>(context);
    listenForCode();
  }

  @override
  void codeUpdated(){
    setState(() {
      _otpController.text = code!;
    });
    _bloc.add(VerifyOtp(code!));
  }

@override
  void dispose(){
    cancel();
    super.dispose();
 }
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => OtpVerificationBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations?.translate('otp_verification') ?? ' '),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child:BlocListener<OtpVerificationBloc, OtpVerificationState>(
            listener: (context, state){
             if (state is OtpVerificationSuccess) {
               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>   Home( locality: widget.locality,)));
             } else if(state is OtpVerificationFailure){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(state.error)));
               //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const UserVerification(phone: '',)));
             }
           },
            child: Column(
              children: [
                //Text('Otp sent to ${widget.phone}', style: const TextStyle(fontSize: 20.0),),
                const SizedBox(height: 14.0,),

                PinFieldAutoFill(
                  controller: _otpController,
                  codeLength: 6,
                ),
                const SizedBox(height: 20.0,),
                BlocBuilder<OtpVerificationBloc, OtpVerificationState> (
                    builder: (context, state){
                   if(state is OtpVerificationLoading) {
                     return const CircularProgressIndicator();
                   }
                   return OutlinedButton(

                     onPressed: (){
                       Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Home(locality: widget.locality,)));
                     // _bloc.add(VerifyOtp(_otpController.text));
                   }, child:const Text('verify otp'),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
