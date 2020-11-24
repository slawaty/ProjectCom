import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kirana/database/cart.dart';
import 'package:kirana/pages/payment.dart';

class Order {
  String shopid;
  String userid;
  String remarks;
  int createdAt;
  String status;
  String id;
  double price;
  String userName;
  Order.fromdocument(DocumentSnapshot document) {
    shopid = document.data['shopid'];
    userid = document.data['userid'];
    remarks = document.data['remarks'];
    createdAt = document.data['createdAt'];
    status = document.data['status'];
    id = document.documentID;
    price = document.data['price'];
    userName = document.data['userName'];
  }

  Map<String, dynamic> toJson() {
    return {
      'shopid': shopid,
      'userid': userid,
      'remarks': remarks,
      'createdAt': createdAt,
      'status': status,
      'price': price,
      'userName': userName
    };
  }
}

class Payment {
  String shopid;
  String userid;
  Payment.fromdocument(DocumentSnapshot document) {
    shopid = document.data['shopid'];
    userid = document.data['userid'];
  }
}

Stream<List<Order>> getUserOrders(userid) {
  return Firestore.instance
      .collection('orders')
      .where("userid", isEqualTo: userid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((event) =>
          event.documents.map((e) => Order.fromdocument(e)).toList());
}

Stream<List<Payment>> getPaymentOrders(userid) {
  return Firestore.instance
      .collection('payment')
      .where("shopid", isEqualTo: userid)
      .snapshots()
      .map((event) =>
          event.documents.map((e) => Payment.fromdocument(e)).toList());
}

Stream<List<Order>> getOwnerOrders(userid) {
  return Firestore.instance
      .collection('orders')
      .where("shopid", isEqualTo: userid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((event) =>
          event.documents.map((e) => Order.fromdocument(e)).toList());
}

Stream<List<Orderitem>> getorderitems(Order order) {
  return Firestore.instance
      .collection('orders')
      .document(order.id)
      .collection('orderitems')
      .snapshots()
      .map((event) =>
          event.documents.map((e) => Orderitem.fromJson(e.data)).toList());
}

void update(Order order, String status) {
  Firestore.instance
      .collection('orders')
      .document(order.id)
      .updateData({'status': status});
}
