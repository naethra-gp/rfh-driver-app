import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:rfh/app_pages/dashboard/controller/loadInvoiceCount.dart';
import '../../app_model/delivery_list_model.dart';
import 'widget/dashboard_counter.dart';
import 'controller/delivery_list.dart';
import '../../app_utils/index_app_util.dart';

class DeliveryDashboard extends StatefulWidget {
  const DeliveryDashboard({super.key});

  @override
  State<DeliveryDashboard> createState() => _DeliveryDashboardState();
}

class _DeliveryDashboardState extends State<DeliveryDashboard> {
  int total_count = 0;
  int completed = 0;
  int pending = 0;
  int totalDeliveredqty = 0;

  // Search Value
  var search_value = '';

  // Define a list of dropdown items
  late List<String> _deliveryDates;

  // Selected delivery date of dropdown
  String? _selectedDeliveryDate;

  // Save all delivery list
  List<DeliveryListModel> _deliveryDetails = [];
  bool _isLoading = true; // Loading state
  final AlertService alertService = AlertService(); // Alert service instance
  bool refresh_button = false; //refresh button when no list
  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    _initializeDateList();
  }

//check if the internet is available during initial
  Future<void> checkInternetConnection() async {
    Future<bool> hasInternet = InternetConnectivity().hasInternetConnection;
    if (await hasInternet) {
      initializeDeliveryData();
    } else {
      alertService.errorToast('No Internet Connection');
    }
  }

  // Get All Delivery List Function
  Future<void> initializeDeliveryData() async {
    try {
      alertService.showLoading("Please wait, Details are loading ....");
      DeliveryList deliveryList = DeliveryList();
      InvoiceCount invoiceCount = InvoiceCount();
      final deliveryData = await deliveryList.getAllDeliveryList(context);
      final invoiceCountData = await invoiceCount.getInvoiceCount(context);
      if (mounted) {
        setState(() {
          if (invoiceCountData.isNotEmpty) {
            total_count = invoiceCountData[0]['TotalQty'];
            completed = invoiceCountData[0]['DeliveredQty'];
            pending = invoiceCountData[0]['PendingQty'];
            totalDeliveredqty = invoiceCountData[0]['TotalDeliveredqty'];
          } else {
            total_count = 0;
            completed = 0;
            pending = 0;
            totalDeliveredqty = 0;
          }
          _deliveryDetails = deliveryData;

          _isLoading = false; // Hide loading indicator
        });
      }
    } catch (e) {
      print('Error fetching deliveries: $e');
      if (mounted) {
        setState(() {
          _isLoading = false; // Hide loading indicator in case of error
        });
      }
    } finally {
      alertService.hideLoading();
    }
  }

  // Function to initialize date list
  void _initializeDateList() {
    DateTime now = DateTime.now();
    _deliveryDates = ['Show All'];
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    for (int i = 0; i < 5; i++) {
      _deliveryDates.add(formatter.format(now.subtract(Duration(days: i))));
    }
  }

  Future<void> _refreshData() async {
    // await Future.delayed(const Duration(seconds: 2));
    _initializeDateList();
    checkInternetConnection();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final dark = RHelperFunction.isDarkMode(context);
    return WillPopScope(
      onWillPop: () async {
        bool exit = await _showExitConfirmationDialog(context);
        return exit;
      },
      child: InternetConnectivityListener(
        connectivityListener:
            (BuildContext context, bool hasInternetAccess) async {
          if (hasInternetAccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('You are back Online!'),
              backgroundColor: Colors.green,
            ));
            await _refreshData();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('No internet connection'),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: Scaffold(
          appBar: const AppBarWidget(
            automaticallyImplyLeading: false,
            title: 'Delivery List',
            action: true,
          ),
          body: RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: RSizes.md, vertical: RSizes.sm),
                child:
                    _isLoading // Show loading indicator if data is being fetched
                        ? Container() // Empty container when loading
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Left Side: Name
                                    Flexible(flex: 1, child: UserName()),

                                    // Right Side: Card with Total Deliveries
                                    Flexible(
                                      flex: 2,
                                      child: Card(
                                        color: Colors.lightBlue.shade50,
                                        elevation: 4.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Icon(
                                                Icons.done_all,
                                                color: Colors.green,
                                                size: 24.0,
                                              ),
                                              const SizedBox(width: 5.0),
                                              Flexible(
                                                child: Text(
                                                  'Delivered in ${DateFormat('MMM').format(DateTime.now())}',
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                              const SizedBox(width: 5.0),
                                              Card(
                                                elevation: 8.0,
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    shape: BoxShape.rectangle,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '$totalDeliveredqty',
                                                      style: const TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: RSizes.spaceBtwItems,
                                ),

                                // Total count, pending, and completed
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: DashboardCount(
                                        title: 'Total Count',
                                        color: RColors.primary,
                                        count: total_count,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: DashboardCount(
                                        title: 'Pending',
                                        color: RColors.warning,
                                        count: pending,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: DashboardCount(
                                        title: 'Completed',
                                        color: RColors.success,
                                        count: completed,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: RSizes.spaceBtwItems),

                                /// Search
                                SizedBox(
                                  width: double.infinity,
                                  height: RSizes.xxl,
                                  child: SearchBar(
                                    leading: const Icon(Icons.search),
                                    hintText: "Search Here",
                                    onChanged: (value) {
                                      setState(() {
                                        search_value = value;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: RSizes.spaceBtwItems),

                                /// Drop Down
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: RSizes.md,
                                      vertical: RSizes.xs),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'Delivery Date ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                  color: RColors.primary,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 20),
                                          softWrap: true,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsetsDirectional
                                            .symmetric(horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: RColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: DropdownButton<String>(
                                          value: _selectedDeliveryDate,
                                          hint: Text(
                                            'Show All',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                    color: RColors.white),
                                          ),
                                          items:
                                              _deliveryDates.map((String date) {
                                            return DropdownMenuItem<String>(
                                              value: date,
                                              child: Text(
                                                date,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                        color: RColors.white),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedDeliveryDate =
                                                  newValue == 'Show All'
                                                      ? null
                                                      : newValue;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                          ),
                                          underline: const SizedBox(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                          dropdownColor: RColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: RSizes.spaceBtwItems),

                                /// List items
                                buildDeliveryList(),
                              ],
                            ),
                          ),
              ),
            ),
          ),
          floatingActionButton: refresh_button
              ? FloatingActionButton(
                  onPressed: () {
                    _refreshData();
                  },
                  child: const Icon(Icons.refresh),
                )
              : const SizedBox(),
        ),
      ),
    );
  }

  /// Delivery list widget
  Widget buildDeliveryList() {
    final filteredList = getFilteredDeliveryInfo();

    if (filteredList.isEmpty) {
      setState(() {
        refresh_button = true;
      });
      return Center(
        child: Text(
          'No data found',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }
    setState(() {
      refresh_button = true;
    });
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final item = filteredList[index];
        return GestureDetector(
          onTap: () {
            DeliveryListModel value = item;
            Navigator.pushNamed(context, 'invoiceView', arguments: value);
          },
          child: Column(
            children: [
              DeliveryListWidget(item: item),
              const SizedBox(height: RSizes.spaceBtwItems),
            ],
          ),
        );
      },
    );
  }

  /// Filter the record based on dropdown selection and search option
  List<DeliveryListModel> getFilteredDeliveryInfo() {
    return _deliveryDetails.where((item) {
      final matchesDate = _selectedDeliveryDate == null ||
          item.invoiceDate.contains(_selectedDeliveryDate!);
      final searchLower = search_value.toLowerCase();
      final matchesSearch = search_value.isEmpty ||
          item.invoiceNo.toLowerCase().contains(searchLower) ||
          item.customerName.toLowerCase().contains(searchLower) ||
          item.invoiceDate.toLowerCase().contains(searchLower) ||
          item.deliveryAddress.toLowerCase().contains(searchLower) ||
          item.remark.toLowerCase().contains(searchLower) ||
          item.mobileNo.contains(searchLower) ||
          item.pinCode.contains(searchLower);
      return matchesDate && matchesSearch;
    }).toList();
  }

//Dialog box to exit the application
  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(
                    'Exit App',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  content: Text(
                    'Are you sure you want to exit the app?',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        overlayColor: RColors.black,
                        backgroundColor: RColors.grey,
                        side: const BorderSide(color: RColors.grey),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        'No',
                        style: TextStyle(color: RColors.black),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Yes'),
                    ),
                  ],
                )) ??
        false;
  }
}
