import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rfh/app_storage/secure_storage.dart';
import 'package:rfh/app_utils/index_app_util.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'controller/cancel_controller.dart';

class CancelDelivery extends StatefulWidget {
  final Map<String, String> value;
  const CancelDelivery({super.key, required this.value});

  @override
  State<CancelDelivery> createState() => _CancelDeliveryState();
}

AlertService alertService = AlertService();
//Selected cancel Reason
String? selectedCancelReason;
//Text field controller
TextEditingController textArea = TextEditingController();

class _CancelDeliveryState extends State<CancelDelivery> {
  //Boolean for show the text_area
  bool isTextArea = false;

  // Declare the Future for cancel reasons
  Future<List<Map<String, dynamic>>>? _cancelReasonFuture;

  CancelController cancelController = CancelController();

  late StreamSubscription<List<ConnectivityResult>> subscription;
  @override
  void initState() {
    super.initState();
    selectedCancelReason = null;
    textArea.clear();
    _cancelReasonFuture = cancelController.loadDropDown();
  }

  @override
  Widget build(BuildContext context) {
    final dark = RHelperFunction.isDarkMode(context);
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Cancel Delivery',
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
              //User Name
              UserName(),
              const SizedBox(
                height: RSizes.spaceBtwItems,
              ),

              //Invoice Number
              Text(
                'Invoice No : ${widget.value['invoiceNo']}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: RSizes.defaultSpace,
              ),
              Text(
                'Cancel Reason',
                style: Theme.of(context).textTheme.titleSmall,
              ),

              // Use FutureBuilder to handle the asynchronous dropdown loading
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _cancelReasonFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: dark ? RColors.darkerGrey : RColors.grey,
                          border: Border.all(
                              width: 1,
                              color: dark ? RColors.darkerGrey : RColors.grey)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: DropdownButton<String>(
                          isExpanded: true, // Set this property to true
                          value: selectedCancelReason,
                          underline: const SizedBox(),
                          hint: Text(
                            'Select Reason',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          items:
                              snapshot.data!.map((Map<String, dynamic> reason) {
                            return DropdownMenuItem<String>(
                                value: reason['reasonsvalue'].toString(),
                                child: Text(
                                  reason['Reason'],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              if (newValue == '5') {
                                isTextArea = true;
                                selectedCancelReason = newValue;
                              } else {
                                isTextArea = false;
                                selectedCancelReason = newValue;
                              }
                            });
                          },
                        ),
                      ),
                    );
                  } else {
                    return const Text('No reasons available');
                  }
                },
              ),
              const SizedBox(
                height: RSizes.spaceBtwItems,
              ),

              //Text area
              isTextArea
                  ? TextField(
                      onChanged: (value) {
                        setState(() {
                          isTextArea = true;
                        });
                      },
                      controller: textArea,
                      textAlign: TextAlign.justify,
                      maxLines: null, // This allows multiple lines
                      decoration: const InputDecoration(
                        hintText: 'Enter your reason',
                        hintStyle: TextStyle(
                            color: RColors
                                .darkGrey), // Adjust hint text style if needed
                      ),
                    )
                  : const SizedBox(),
              //Error Message
              !getBoolValue()
                  ? const Text('Cancel Request Required*',
                      style: TextStyle(
                        fontSize: RSizes.md,
                        color: RColors.error,
                      ))
                  : const SizedBox(),
              const SizedBox(
                height: RSizes.defaultSpace,
              ),
              //Button
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                color: getBoolValue()
                                    ? RColors.primary
                                    : RColors.grey)),
                        onPressed: getBoolValue()
                            ? () async {
                                alertService.showLoading("please wait");
                                //Update cancel status
                                String deliverythruid =
                                    await BoxStorage().getDeliveryThrustId();
                                Future<bool> response = CancelController()
                                    .updateCancelStatus(
                                        driverid: deliverythruid,
                                        status: selectedCancelReason,
                                        invoiceid: widget.value['invoiceId']!,
                                        text: textArea.text);
                                if (await response) {
                                  Future.delayed(const Duration(seconds: 3),
                                      () {
                                    alertService.hideLoading();
                                    alertService.successToast(
                                        'Cancellation successfull');
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        'deliveryDashboard', (route) => false);
                                  });
                                } else {
                                  alertService.hideLoading();
                                  alertService
                                      .errorToast('cancellation failed');
                                }
                              }
                            : null,
                        child: const Text('Submit')),
                    ElevatedButton(
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool getBoolValue() {
    if (isTextArea) {
      return (textArea.text.isEmpty ? false : true);
    } else {
      return (selectedCancelReason == 'Other' || selectedCancelReason == null
          ? false
          : true);
    }
  }
}
