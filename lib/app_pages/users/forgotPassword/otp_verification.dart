import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rfh/app_utils/otp_field_widget.dart';
import '../../../app_utils/index_app_util.dart';
import 'controller/forgotController.dart';
import 'dart:convert';

class OtpVerification extends StatefulWidget {
  final Map<String, String> value;
  const OtpVerification({super.key, required this.value});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  AlertService alertService = AlertService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool newPassword = false;
  String? errorMessage;
  String? errorMessage2;
  //Resent counter time
  bool isResendEnabled = false;
  int resendCountdown = 60;
  late Timer timer;

  void startResendTimer() {
    isResendEnabled = false;
    resendCountdown = 60;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (resendCountdown > 0) {
          resendCountdown--;
        } else {
          isResendEnabled = true;
          timer.cancel();
        }
      });
    });
  }

  void disableResend() {
    setState(() {
      isResendEnabled = false;
    });
    startResendTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startResendTimer();
    setState(() {
      controller.text = '';
      newPassword = false;
    });
  }

  sentOtp() async {
    alertService.showLoading('Please wait');
    setState(() {
      controller.text = '';
      newPassword = false;
    });
    await ForgotController().sentOtp(
        mobileNo: widget.value['mobileNo'],
        vehicleNo: widget.value['vehicleNo']);
  }

  verifyOtp({mobileNo, otp, vehicleNo}) async {
    alertService.showLoading('Please wait');
    String response = await ForgotController()
        .verifyPasswordOtp(mobileNo: mobileNo, otp: otp, vehicleNo: vehicleNo);

    if (response == 'Otp Verified') {
      setState(() {
        alertService.hideLoading();
        alertService.successToast('Otp verified');
        errorMessage = null; // Clear any previous error message
        newPassword = true;
      });
    } else if (response.isNotEmpty) {
      alertService.hideLoading();
      setState(() {
        errorMessage = response;
        newPassword = false;
      });
    } else {
      alertService.hideLoading();
      setState(() {
        errorMessage = 'An error occurred. Please try again.';
        newPassword = false;
      });
    }
  }

  resetPassword(
      {required mobileNo, required password, required vehicleNo}) async {
    alertService.showLoading('Please wait');
    String response = await ForgotController().resetPassword(
        mobileNo: mobileNo, password: password, vehicleNo: vehicleNo);

    if (response == 'Password Reset Successfully') {
      setState(() {
        errorMessage2 = null; // Clear any previous error message
      });
      alertService.hideLoading();
      alertService.successToast('Password Reset Successfully');
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    } else if (response.isNotEmpty) {
      alertService.hideLoading();
      setState(() {
        errorMessage2 = response;
      });
    } else {
      alertService.hideLoading();
      setState(() {
        errorMessage2 = 'An error occurred. Please try again.';
      });
    }
  }

//encode password
  String encodeToBase64(String data) {
    var bytes = utf8.encode(data); // Convert the string to a list of UTF8 bytes
    var base64Str = base64Encode(bytes); // Encode the bytes in Base64
    return base64Str;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget(
          title: 'Reset Password',
          action: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: RSizes.lg,
              horizontal: RSizes.lg,
            ),
            child: !newPassword
                ? Column(
                    children: [
                      Text(
                        'Vehicle No - ${widget.value['vehicleNo']}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                          'Please enter your OTP, sent to ${widget.value['mobileNo']}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith()),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              //Otp input field
                              OtpField(
                                lable: 'OTP',
                                otpValue: controller,
                                maxLength: 6,
                              ),
                              const SizedBox(height: 10),
                              //verify otp
                              if (errorMessage != null) ...[
                                Text(errorMessage!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: RColors.error)),
                                const SizedBox(height: RSizes.spaceBtwItems),
                              ],
                              const SizedBox(height: 10),
                              isResendEnabled
                                  ? const SizedBox()
                                  : Center(
                                      child: Text(
                                        '00:${resendCountdown.toString().padLeft(2, '0')}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                              //Resent text
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                      text: "Didn't Receive the otp? ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                      children: [
                                        TextSpan(
                                          text: "Resent Code",
                                          style: isResendEnabled
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                      color: RColors.primary)
                                              : Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              94,
                                                              120,
                                                              133)),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              if (isResendEnabled) {
                                                disableResend();
                                                // Handle link tap
                                                sentOtp();
                                              }
                                            },
                                        )
                                      ]),
                                ),
                              ),
                              const SizedBox(
                                height: RSizes.spaceBtwItems,
                              ),

                              //Reset Button
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      verifyOtp(
                                          mobileNo: widget.value['mobileNo'],
                                          vehicleNo: widget.value['vehicleNo'],
                                          otp: controller.text);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(),
                                  child: const Text("Verify otp")),
                            ],
                          )),
                    ],
                  )
                : Form(
                    key: _formKey2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vehicle No - ${widget.value['vehicleNo']}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Set Your New Password',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(
                          height: RSizes.defaultSpace,
                        ),
                        TextFormField(
                          controller: password,
                          obscureText: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              hintText: 'Enter New Password',
                              labelText: 'New Password'),
                          validator: (value) {
                            if (value!.isEmpty) return 'Password is required';
                            if (value.length < 4) {
                              return 'Password minimum have 4 character';
                            }
                            if (value.length > 15) {
                              return 'Password Not greater than 15 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: RSizes.spaceBtwItems,
                        ),
                        TextFormField(
                          controller: confirmPassword,
                          obscureText: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              hintText: 'Enter Confirm Password',
                              labelText: "Confirm Password"),
                          validator: (value) {
                            if (value!.isEmpty) return 'Password is required';
                            if (value.length < 4) {
                              return 'Password minimum have 4 character';
                            }
                            if (value.length > 15) {
                              return 'Password Not greater than 15 characters';
                            }
                            return null;
                          },
                        ),
                        if (errorMessage2 != null) ...[
                          const SizedBox(height: RSizes.spaceBtwItems),
                          Text(errorMessage2!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: RColors.error)),
                          const SizedBox(height: RSizes.spaceBtwItems),
                        ],
                        const SizedBox(
                          height: RSizes.sm,
                        ),
                        Center(
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey2.currentState?.validate() ??
                                      false) {
                                    if (password.text == confirmPassword.text) {
                                      setState(() {
                                        errorMessage2 = null;
                                      });
                                      var password =
                                          encodeToBase64(confirmPassword.text);
                                      await resetPassword(
                                          mobileNo: widget.value['mobileNo'],
                                          vehicleNo: widget.value['vehicleNo'],
                                          password: password);
                                    } else {
                                      setState(() {
                                        errorMessage2 = 'Mismatch Password';
                                      });
                                    }
                                  }
                                },
                                child: const Text('Submit')))
                      ],
                    ),
                  ),
          ),
        ));
  }
}
