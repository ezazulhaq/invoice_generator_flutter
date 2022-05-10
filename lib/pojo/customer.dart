class Customer {
  String gstNo;
  String customerName;
  String address;
  String state;
  int phoneNumber;
  int pinCode;

  Customer(this.gstNo, this.customerName, this.address, this.state,
      this.phoneNumber, this.pinCode);

  factory Customer.fromJson(dynamic json) {
    return Customer(
        json["gstNo"] as String,
        json["customerName"] as String,
        json["address"] as String,
        json["state"] as String,
        json["phoneNumber"] as int,
        json["pinCode"] as int);
  }
}
