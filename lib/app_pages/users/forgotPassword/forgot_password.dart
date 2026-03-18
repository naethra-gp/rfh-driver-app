import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app_utils/index_app_util.dart';
import 'controller/forgotController.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

TextEditingController mobileNo = TextEditingController();
TextEditingController vehicleNo = TextEditingController();

GlobalKey<FormState> key = GlobalKey<FormState>();

class _ForgotPasswordState extends State<ForgotPassword> {
  sentForgotOtp() async {
    AlertService().showLoading('Please wait');
    var response = await ForgotController()
        .sentOtp(mobileNo: mobileNo.text, vehicleNo: vehicleNo.text);
    if (response == true) {
      Map<String, String> value = {
        'mobileNo': mobileNo.text,
        'vehicleNo': vehicleNo.text,
      };
      Navigator.pushNamed(context, 'otpVerification', arguments: value);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobileNo.text = '';
    vehicleNo.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Reset Password',
        action: false,
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;
          if (MediaQuery.of(context).orientation == Orientation.landscape) {
            maxWidth = maxWidth * 0.6;
          }
          return Center(
            child: SizedBox(
              width: maxWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: RSizes.lg,
                  horizontal: RSizes.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Lost your password? \n\nPlease enter your registered mobile number and vehicle number',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: key,
                      child: Column(
                        children: [
                          TextFormField(
                              controller: mobileNo,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                hintText: 'Enter Mobile Number',
                                labelText: 'Mobile Number',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Mobile Number is required';
                                }
                                if (value.length != 10) {
                                  return 'Mobile Number must have 10 digits';
                                }
                                return null;
                              }),
                          const SizedBox(
                            height: RSizes.defaultSpace,
                          ),
                          TextFormField(
                              controller: vehicleNo,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                hintText: 'Enter Vehicle Number',
                                labelText: 'Vehicle Number',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(
                                    r'[a-zA-Z0-9]')), // Allows only alphanumeric characters
                                UpperCaseTextFormatter(), // Converts characters to uppercase
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vehicle Number is required';
                                }
                                return null;
                              }),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: RSizes.defaultSpace,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (key.currentState?.validate() ?? false) {
                            sentForgotOtp();
                          }
                        },
                        child: const Text('Sent OTP'))
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
