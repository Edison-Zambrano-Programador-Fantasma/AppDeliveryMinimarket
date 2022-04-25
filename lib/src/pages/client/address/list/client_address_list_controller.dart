import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/models/address.dart';
import 'package:flutter_delivery_app/src/models/order.dart';
import 'package:flutter_delivery_app/src/models/product.dart';
import 'package:flutter_delivery_app/src/models/response_api.dart';
import 'package:flutter_delivery_app/src/models/user.dart';
import 'package:flutter_delivery_app/src/provider/StripeProvider.dart';
import 'package:flutter_delivery_app/src/provider/address_provider.dart';
import 'package:flutter_delivery_app/src/provider/orders_provider.dart';
import 'package:flutter_delivery_app/src/utils/my_snackbar.dart';
import 'package:flutter_delivery_app/src/utils/shared_pref.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ClientAddressListController{

  BuildContext context;
  Function refresh;

  List<Address> address = [];
  AddressProvider _addressProvider = new AddressProvider();
  User user;
  SharedPref _sharedPref = new SharedPref();

  int radioValue = 0;

  bool isCreated ;

  Map<String, dynamic> dataIsCreated;

  OrdersProvider _ordersProvider = new OrdersProvider();
  StripeProvider _stripeProvider = new StripeProvider();

  ProgressDialog progressDialog;

  Future init (BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    progressDialog = new ProgressDialog(context: context);
    user = User.fromJson(await _sharedPref.read('user'));
    _addressProvider.init(context, user);
    _ordersProvider.init(context, user);
    _stripeProvider.init(context);

    refresh();
  }

  void createOrder() async {

    progressDialog.show(max: 100, msg: 'Espere un momento');
    var response = await _stripeProvider.payWithCard('${150*100}', 'USD'); // aqui el precio
    progressDialog.close();

    MySnackbar.show(context, response.message);

    if(response.success){

      Address a = Address.fromJson(await _sharedPref.read('address') ?? {});
      List<Product> selectedProducts = Product.fromJsonList(await _sharedPref.read('order')).toList;
      //List<Product> priceProducts = Product.fromJson(await _sharedPref.read ('price')).toList;
      Order order = new Order(
          idClient: user.id,
          idAddress: a.id,
          products: selectedProducts

      );
      ResponseApi responseApi = await _ordersProvider.create(order);

      if(responseApi.success){
        Navigator.pushNamedAndRemoveUntil(
            context,
            'client/payments/status',
                (route) => false,
            arguments: {
              'brand': response.paymentMethod.card.brand,
              'last4': response.paymentMethod.card.last4
            }
        );
      }

      print('Respuesta orden: ${responseApi.message}');
    }
  }

  void handleRadioValueChange(int value) async{
    radioValue = value;
    _sharedPref.save('address', address[value]);

    refresh();
    print('Valor seleccionado:${radioValue}');
  }

  Future<List<Address>> getAddress() async{
    address = await _addressProvider.getByUser(user.id);

    Address a = Address.fromJson(await _sharedPref.read('address') ?? {});
    int index = address.indexWhere((ad) => ad.id == a.id);

    if(index != -1){
      radioValue = index;
    }
    print('SE GUARDO LA DIRECCION:${a.toJson()}');

    return address;
  }

  void goToNewAddress() async {
    var result  = await Navigator.pushNamed(context, 'client/address/create');

    if(result != null ){
      if(result){
        refresh();
      }
    }
  }
}