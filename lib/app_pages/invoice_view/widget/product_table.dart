import 'package:flutter/material.dart';
import '../../../app_utils/index_app_util.dart';

class ProductTable extends StatefulWidget {
  const ProductTable({
    super.key,
    required this.dark,
    required this.tableName,
    required this.productInfo,
  });

  final bool dark;
  final String tableName;
  final List<dynamic> productInfo;

  @override
  _ProductTableState createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: widget.dark ? RColors.darkerGrey : RColors.primaryBackground,
        ),
        color: widget.dark ? RColors.darkerGrey : RColors.primaryBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.all(RSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Center(
              child: Text(
                '${widget.tableName} ',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: widget.dark ? RColors.warning : RColors.primary),
              ),
            ),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(4),
                2: FlexColumnWidth(2)
              },
              children: [
                TableRow(
                  children: [
                    SizedBox(
                      height: 30,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'S.No',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Product Details',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Quantity',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: RSizes.spaceBtwItems / 2,
            ),
            Divider(
              height: 1,
              color: widget.dark ? RColors.grey : RColors.grey,
            ),
            const SizedBox(
              height: RSizes.spaceBtwItems / 2,
            ),

            // Product Rows with Scrollbar and ListView
            Container(
              // height: widget.productInfo.length * 100.0,
              height: 200,
              child: Scrollbar(
                controller: _scrollController,
                trackVisibility: true,
                thumbVisibility: true,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.productInfo.length,
                  itemBuilder: (BuildContext context, int index) {
                    final productDetail = widget.productInfo[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(4),
                          2: FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(
                            children: [
                              SizedBox(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${index + 1}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${productDetail.products!}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${productDetail.qty!}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
