class DeliveryListModel {
  final String invoiceNo;
  final String invoiceId;
  final String invoiceDate;
  final String customerName;
  final String deliveryAddress;
  final String area;
  final String createddate;
  final String remark;
  final String mobileNo;
  final String alternateMobileNo;
  final String zone;
  final String pinCode;
  final List<DeliveryProduct> deliveryprdDetails;
  final List<PendingDeliveryProduct> pendingdelivery;
  final List<AlreadyDeliveredProduct> alreadydeliveredPrddetails;

  DeliveryListModel({
    required this.invoiceNo,
    required this.invoiceId,
    required this.invoiceDate,
    required this.customerName,
    required this.deliveryAddress,
    required this.area,
    required this.createddate,
    required this.remark,
    required this.mobileNo,
    required this.alternateMobileNo,
    required this.zone,
    required this.pinCode,
    required this.deliveryprdDetails,
    required this.pendingdelivery,
    required this.alreadydeliveredPrddetails,
  });

  factory DeliveryListModel.fromJson(Map<String, dynamic> json) {
    return DeliveryListModel(
      invoiceNo: json['invoiceno'],
      invoiceId: json['invoiceid'],
      invoiceDate: json['invoicedate'],
      customerName: json['custname'],
      deliveryAddress: json['daddress'],
      area: json['area'],
      createddate: json['createddate'],
      remark: json['remark'],
      mobileNo: json['mobileno'],
      alternateMobileNo: json['alternatePhone'],
      zone: json['zone'],
      pinCode: json['pincode'],
      deliveryprdDetails: (json['deliveryprdDetails'] as List<dynamic>)
          .map((item) => DeliveryProduct.fromJson(item))
          .toList(),
      pendingdelivery: (json['pendingdelivery'] as List<dynamic>)
          .map((item) => PendingDeliveryProduct.fromJson(item))
          .toList(),
      alreadydeliveredPrddetails:
          (json['alreadydeliveredPrddetails'] as List<dynamic>)
              .map((item) => AlreadyDeliveredProduct.fromJson(item))
              .toList(),
    );
  }
}

class DeliveryProduct {
  final String products;
  final int qty;

  DeliveryProduct({
    required this.products,
    required this.qty,
  });

  factory DeliveryProduct.fromJson(Map<String, dynamic> json) {
    return DeliveryProduct(
      products: json['deliverProducts'],
      qty: json['deliverQty'],
    );
  }
}

class PendingDeliveryProduct {
  final String products;
  final int qty;

  PendingDeliveryProduct({
    required this.products,
    required this.qty,
  });

  factory PendingDeliveryProduct.fromJson(Map<String, dynamic> json) {
    return PendingDeliveryProduct(
      products: json['pendingdeliveryproducts'],
      qty: json['pendingqty'],
    );
  }
}

class AlreadyDeliveredProduct {
  final String products;
  final int qty;

  AlreadyDeliveredProduct({
    required this.products,
    required this.qty,
  });

  factory AlreadyDeliveredProduct.fromJson(Map<String, dynamic> json) {
    return AlreadyDeliveredProduct(
      products: json['alreadydeliveredProduct'],
      qty: json['deliveredqty'],
    );
  }
}
