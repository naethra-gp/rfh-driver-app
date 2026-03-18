import 'package:flutter/material.dart';
import 'package:rfh/app_model/delivery_list_model.dart';
import '../../../app_utils/index_app_util.dart';
import '../../invoice_view/widget/address_table.dart';

class DeliveryListWidget extends StatefulWidget {
  const DeliveryListWidget({super.key, required this.item});

  final DeliveryListModel item;

  @override
  State<DeliveryListWidget> createState() => _DeliveryListWidgetState();
}

class _DeliveryListWidgetState extends State<DeliveryListWidget> {
  @override
  Widget build(BuildContext context) {
    final dark = RHelperFunction.isDarkMode(context);
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: RColors.grey),
          color: dark ? null : RColors.primaryBackground),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRow('Invoice No : ', widget.item.invoiceNo),
                      buildRow('Name : ', widget.item.customerName),
                      buildRow('Delivery Date : ', widget.item.invoiceDate),
                      buildRow('Remarks : ', widget.item.remark),
                      buildRow('Address : ', widget.item.deliveryAddress),
                      buildRow(
                        'Area : ',
                        widget.item.area,
                      ),
                      buildRow('Zone : ', widget.item.zone),
                      buildRow(
                        'Pin Code : ',
                        widget.item.pinCode,
                      ),
                      buildRow('Mobile No : ', widget.item.mobileNo),
                      buildRow(
                          'Alternate No : ', widget.item.alternateMobileNo),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    AlertService().showLoading('Please wait');
                    // Handle location button press
                    helperFunction.handleLocation2(
                        context, widget.item.deliveryAddress);
                  },
                  icon: const CircleAvatar(
                    backgroundColor: RColors.grey,
                    child: Icon(
                      Icons.location_pin,
                      color: RColors.primary, // Adjust the color as needed
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buildIconText(Icons.delivery_dining,
                      widget.item.deliveryprdDetails.length, RColors.primary),
                  const SizedBox(width: 10), // Add space between icons
                  buildIconText(Icons.assignment,
                      widget.item.pendingdelivery.length, RColors.warning),
                  const SizedBox(width: 10), // Add space between icons
                  buildIconText(
                      Icons.check_circle,
                      widget.item.alreadydeliveredPrddetails.length,
                      RColors.success),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Expanded(
          child: Text(
            value == '' ? '' : value,
            style: Theme.of(context).textTheme.bodyMedium,
            softWrap: true, // Allow text to wrap to the next line
            overflow: TextOverflow.visible, // Handle overflow by wrapping
          ),
        ),
      ],
    );
  }

  Widget buildIconText(IconData icon, int text, Color Color) {
    return Row(
      children: [
        Icon(icon, color: Color), // Customize the icon color
        const SizedBox(width: 5), // Add space between icon and text
        Text(
          '$text',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: RColors.primary),
        ),
      ],
    );
  }
}
