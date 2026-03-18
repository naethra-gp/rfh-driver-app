import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import '../../app_model/delivery_list_model.dart';
import '../../app_utils/index_app_util.dart';
import 'widget/address_table.dart';
import 'widget/product_table.dart';

class InvoiceView extends StatefulWidget {
  final DeliveryListModel item;
  const InvoiceView({super.key, required this.item});

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  CustomSegmentedController<int> controller = CustomSegmentedController();
  late DeliveryListModel singleDeliveryInfo;

  @override
  void initState() {
    super.initState();
    controller.value = 1;
    singleDeliveryInfo = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    final dark = RHelperFunction.isDarkMode(context);
    final width = MediaQuery.of(context).size.width;
    Future<bool> hasInternet = InternetConnectivity().hasInternetConnection;
    AlertService alertService = AlertService();
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Invoice View',
        action: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: RSizes.sm,
          horizontal: RSizes.md,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserName(),
              const SizedBox(
                height: RSizes.spaceBtwItems,
              ),
              Text(
                'Invoice Full View',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: RSizes.spaceBtwItems,
              ),
              buildRow('Invoice No : ', singleDeliveryInfo.invoiceNo),
              buildRow('Customer Name : ', singleDeliveryInfo.customerName),
              buildRow('Delivery Date : ', singleDeliveryInfo.invoiceDate),
              buildRow('Remarks : ', singleDeliveryInfo.remark),
              const SizedBox(
                height: RSizes.spaceBtwItems,
              ),
              AddressTable(singleDeliveryInfo: singleDeliveryInfo),
              const SizedBox(
                height: RSizes.spaceBtwItems,
              ),

              // Tab view
              Center(
                child: CustomSlidingSegmentedControl<int>(
                  initialValue: 1,
                  padding: width <= 380 ? 9 : 14,
                  curve: Curves.easeInCirc,
                  controller: controller,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  duration: const Duration(milliseconds: 100),
                  innerPadding: const EdgeInsets.all(5.0),
                  onValueChanged: (int index) {
                    controller.value = index;
                    setState(() {});
                  },
                  children: {
                    1: getTitle('Delivery List', 1),
                    2: getTitle('Pending Delivery', 2),
                    3: getTitle('Already Delivered', 3),
                  },
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  thumbDecoration: BoxDecoration(
                    color: RColors.primary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        blurRadius: 2.0,
                        offset: const Offset(0.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Expanded with SingleChildScrollView for scrollable content
              Column(
                children: [
                  if (controller.value == 1) ...[
                    singleDeliveryInfo.deliveryprdDetails.isNotEmpty
                        ? ProductTable(
                            dark: dark,
                            productInfo: singleDeliveryInfo.deliveryprdDetails,
                            tableName: 'Delivery List',
                          )
                        : Center(
                            child: SizedBox(
                              height: 125,
                              child: Center(
                                child: Text(
                                  'No  Delivery Found',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ),
                          ),
                  ],
                  if (controller.value == 2) ...[
                    singleDeliveryInfo.pendingdelivery.isNotEmpty
                        ? ProductTable(
                            dark: dark,
                            productInfo: singleDeliveryInfo.pendingdelivery,
                            tableName: 'Pending Delivery',
                          )
                        : Center(
                            child: SizedBox(
                              height: 125,
                              child: Center(
                                child: Text(
                                  'No Pending Delivery Found',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ),
                          ),
                  ],
                  if (controller.value == 3) ...[
                    singleDeliveryInfo.alreadydeliveredPrddetails.isNotEmpty
                        ? ProductTable(
                            dark: dark,
                            productInfo:
                                singleDeliveryInfo.alreadydeliveredPrddetails,
                            tableName: 'Already Delivered',
                          )
                        : Center(
                            child: SizedBox(
                              height: 125,
                              child: Center(
                                child: Text(
                                  'No Already Delivery Found',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ),
                          ),
                  ],
                ],
              ),
              const SizedBox(
                height: RSizes.spaceBtwItems,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Map<String, String> value = {
                        'invoiceId': singleDeliveryInfo.invoiceId,
                        'invoiceNo': singleDeliveryInfo.invoiceNo,
                        'mobileNo': singleDeliveryInfo.mobileNo,
                        'customerName': singleDeliveryInfo.customerName,
                      };
                      if (!await hasInternet) {
                        return alertService.errorToast(
                            'Please check your internet connection');
                      }
                      Navigator.pushNamed(context, 'sentOtp', arguments: value);
                    },
                    child: const Text('DC-Code'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      overlayColor: Colors.black,
                      backgroundColor: RColors.grey,
                      side: const BorderSide(color: RColors.grey),
                    ),
                    onPressed: () async {
                      Map<String, String> value = {
                        'invoiceId': singleDeliveryInfo.invoiceId,
                        'invoiceNo': singleDeliveryInfo.invoiceNo,
                      };

                      Navigator.pushNamed(context, 'cancelDelivery',
                          arguments: value);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: RColors.black),
                    ),
                  ),
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
                      'Close',
                      style: TextStyle(color: RColors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Expanded(
              child: Text(
                value.isEmpty ? '' : value,
                style: Theme.of(context).textTheme.bodyMedium,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: RSizes.sm,
        ),
      ],
    );
  }

  Widget getTitle(String title, int index) {
    return Text(
      title,
      softWrap: true,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        fontWeight:
            index == controller.value ? FontWeight.bold : FontWeight.w600,
        color: index == controller.value ? Colors.white : Colors.black45,
      ),
    );
  }
}
