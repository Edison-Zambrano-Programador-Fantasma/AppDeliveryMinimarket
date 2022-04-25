import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/models/order.dart';
import 'package:flutter_delivery_app/src/models/product.dart';
import 'package:flutter_delivery_app/src/models/response_api.dart';
import 'package:flutter_delivery_app/src/models/user.dart';
import 'package:flutter_delivery_app/src/provider/orders_provider.dart';
import 'package:flutter_delivery_app/src/provider/users_provider.dart';
import 'package:flutter_delivery_app/src/utils/my_snackbar.dart';
import 'package:flutter_delivery_app/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RestaurantOrdersDetailController{

  BuildContext context;
  Function refresh;

  Product product;

  int counter = 1;
  double productPrice;

  SharedPref _sharedPref = new SharedPref();


  double total = 0;
  Order order;

  User user;
  List<User> users =[];
  UsersProvider _usersProvider = new UsersProvider();
  OrdersProvider _ordersProvider = new OrdersProvider();
  String idDelivery;

  Future init(BuildContext context, Function refresh, Order order) async{
    this.context= context;
    this.refresh = refresh;
    this.order = order;
    user= User.fromJson(await _sharedPref.read('user'));
    _usersProvider.init(context, sessionUser: user);
    _ordersProvider.init(context, user);
    getTotal();
    getUsers();
    refresh();
  }

  void updateOrder() async {
    if(idDelivery != null){
      order.idDelivery = idDelivery;
      ResponseApi responseApi = await _ordersProvider.updateToDispatched(order);
      Fluttertoast.showToast(msg:responseApi.message, toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context, true);
    }else{
      Fluttertoast.showToast(msg: 'Selecciona el repartidor');
      //MySnackbar.show(context, 'Selecciona el repartidor');
    }
  }

  void getUsers() async {
    users = await _usersProvider.getDeliveryMen();
    refresh();
  }

  void getTotal(){
    total = 0;
    order.products.forEach((product) {
      total = total+ (product.price * product.quantity);
    });
    refresh ();
  }
}