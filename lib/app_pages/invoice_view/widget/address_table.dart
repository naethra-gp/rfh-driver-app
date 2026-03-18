import 'package:flutter/material.dart';
import 'package:rfh/app_model/delivery_list_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_utils/index_app_util.dart';

class AddressTable extends StatefulWidget {
  const AddressTable({
    super.key,
    required this.singleDeliveryInfo,
  });

  final DeliveryListModel singleDeliveryInfo;

  @override
  State<AddressTable> createState() => _AddressTableState();
}

RHelperFunction helperFunction = RHelperFunction();

class _AddressTableState extends State<AddressTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1), // 1st column width
            1: FlexColumnWidth(5), // 2nd column width
            2: FlexColumnWidth(1), // 3rd column width
          },
          children: [
            TableRow(
              children: [
                const SizedBox(
                  child: Align(
                      alignment: Alignment.centerLeft, child: Icon(Icons.home)),
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.singleDeliveryInfo.deliveryAddress,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Row(
                        children: [
                          Text(
                            'Area : ',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            widget.singleDeliveryInfo.area,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       'LandMark : ',
                      //       style: Theme.of(context).textTheme.bodyLarge,
                      //     ),
                      //     Text(
                      //       'T-Nagar',
                      //       // widget.singleDeliveryInfo.pinCode,
                      //       style: Theme.of(context).textTheme.bodyMedium,
                      //     ),
                      //   ],
                      // ),
                      Row(
                        children: [
                          Text(
                            'Zone : ',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            widget.singleDeliveryInfo.zone,
                            // widget.singleDeliveryInfo.area,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Pincode : ',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            widget.singleDeliveryInfo.pinCode,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const CircleAvatar(
                      backgroundColor: RColors.grey,
                      child: Icon(
                        Icons.location_pin,
                        color: RColors.primary,
                      )),
                  onPressed: () {
                    AlertService().showLoading('Please wait');
                    helperFunction.handleLocation2(
                        context, widget.singleDeliveryInfo.deliveryAddress);
                  },
                ),
              ],
            ),
            // TableRow(
            //   children: [
            //     const Align(
            //         alignment: Alignment.centerLeft, child: Icon(Icons.call)),
            //     Text(
            //       widget.singleDeliveryInfo.mobileNo,
            //       style: Theme.of(context).textTheme.bodyMedium,
            //     ),
            //     const SizedBox(), // Empty SizedBox to align with the 3rd column of the first row
            //   ],
            // ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
            flex: 1,
            child: Text(
              'Mobile No   ',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(
              widget.singleDeliveryInfo.mobileNo,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Flexible(
            flex: 1,
            child: IconButton(
              icon: const CircleAvatar(
                  backgroundColor: RColors.grey,
                  child: Icon(
                    Icons.call,
                    color: RColors.primary,
                  )),
              onPressed: () {
                _launchUrl(widget.singleDeliveryInfo.mobileNo);
              },
            ),
          ),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
            flex: 1,
            child: Text(
              'Alternate No',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(
              widget.singleDeliveryInfo.alternateMobileNo,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Flexible(
            flex: 1,
            child: IconButton(
              icon: const CircleAvatar(
                  backgroundColor: RColors.grey,
                  child: Icon(
                    Icons.call,
                    color: RColors.primary,
                  )),
              onPressed: () {
                _launchUrl(widget.singleDeliveryInfo.alternateMobileNo);
              },
            ),
          ),
        ]),
      ],
    );
  }

  Future<void> _launchUrl(String number) async {
    final url = Uri(scheme: 'tel', path: number);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
