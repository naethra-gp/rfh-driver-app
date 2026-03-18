import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rfh/app_pages/cancel_delivery/cancel_delivery.dart';
import '../../app_storage/secure_storage.dart';
import '../../app_utils/index_app_util.dart';
import '../../app_utils/otp_field_widget.dart';
import 'controller/otp_controller.dart';

class SentOtp extends StatefulWidget {
  final Map<String, String> value;
  const SentOtp({super.key, required this.value});

  @override
  State<SentOtp> createState() => _SentOtpState();
}

class _SentOtpState extends State<SentOtp> {
  // Define deliveryInfo as a nullable
  late Map<String, String> customerInfo;

  // State variable to track the error message
  String? errorMessage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController otpValue = TextEditingController();
  BoxStorage storageService = BoxStorage();

  @override
  void dispose() {
    super.dispose();
    otpValue.dispose();
  }

  @override
  void initState() {
    super.initState();
    customerInfo = widget.value;
  }

  Future<void> verifyOtp() async {
    alertService.showLoading("please wait");
    String deliverythruid = await storageService.getDeliveryThrustId();
    String response = '';

    response = await OtpController().verifyOtp(
      otp: otpValue.text,
      invoiceid: widget.value['invoiceId'],
      deliverythruid: deliverythruid,
    );

    if (response == 'Success') {
      alertService.hideLoading();
      // AlertService().successToast('Otp verified');
      Navigator.pushNamedAndRemoveUntil(
        context,
        'successOtp',
        (route) => false,
      );
    } else {
      alertService.hideLoading();
      setState(() {
        errorMessage = response; // Set the error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'DC Code',
        action: true,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: RSizes.sm,
            horizontal: RSizes.lg,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///username
                UserName(),
                const SizedBox(
                  height: RSizes.spaceBtwItems,
                ),
                //Invoice no
                Text(
                  'Invoice No : ${customerInfo['invoiceNo']}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: RSizes.spaceBtwInputFields,
                ),
                //Name
                Text(
                  'Customer Name : ${customerInfo['customerName']}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: RSizes.spaceBtwInputFields,
                ),
                //OTP sent to
                Text(
                  'Enter the DC-Code ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(
                  height: RSizes.spaceBtwItems,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      OtpField(
                        lable: 'Dc-Code',
                        otpValue: otpValue,
                        maxLength: 6,
                        enableField: true,
                      ),
                      const SizedBox(height: RSizes.spaceBtwItems),
                      // Display error message if OTP verification fails
                      if (errorMessage != null) ...[
                        Text(errorMessage!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: RColors.error)),
                        const SizedBox(height: RSizes.spaceBtwItems),
                      ],

                      const SizedBox(
                        height: RSizes.spaceBtwItems,
                      ),

                      //button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  await verifyOtp();
                                }
                              },
                              child: const Text('Verify Code')),
                          const SizedBox(
                            width: RSizes.defaultSpace,
                          ),
                          SizedBox(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  overlayColor: Colors.black,
                                  backgroundColor: RColors.grey,
                                  side: const BorderSide(color: RColors.grey),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Back',
                                  style: TextStyle(color: RColors.black),
                                )),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
