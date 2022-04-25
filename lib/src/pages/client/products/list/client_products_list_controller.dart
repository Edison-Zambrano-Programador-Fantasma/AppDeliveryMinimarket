import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/models/category.dart';
import 'package:flutter_delivery_app/src/models/product.dart';
import 'package:flutter_delivery_app/src/models/user.dart';
import 'package:flutter_delivery_app/src/pages/client/products/detail/client_products_detail_page.dart';
import 'package:flutter_delivery_app/src/provider/categories_provider.dart';
import 'package:flutter_delivery_app/src/provider/products_provider.dart';
import 'package:flutter_delivery_app/src/utils/shared_pref.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientProductListController{

  BuildContext context;
  SharedPref _sharedPref= new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function refresh;
  User user;
  CategoriesProvider _categoriesProvider = new CategoriesProvider();
  ProductsProvider _productsProvider =new ProductsProvider();
  List<Category> categories = [];

  Timer searchOnStoppedTyping;
  String productName = '';

  Future init(BuildContext context, Function refresh) async{
    this.context= context;
    this.refresh= refresh;
    user= User.fromJson(await _sharedPref.read('user'));
    _categoriesProvider.init(context, user);
    _productsProvider.init(context, user);
    getCategories();
    refresh();
  }

  void onChangeText(String text){
    Duration duration = Duration(milliseconds: 800);

    if(searchOnStoppedTyping != null ){
      searchOnStoppedTyping.cancel();
      refresh();
    }

    searchOnStoppedTyping = new Timer(duration, (){
      productName = text;

      refresh();
      print('TEXTO COMPLETO: $productName');
    });
  }

  Future<List<Product>> getProducts(String idCategory, String productName) async{

    if(productName.isEmpty){
      return await _productsProvider.getByCategory(idCategory);
    }
    else{
      return await _productsProvider.getByCategoryAndProductName(idCategory, productName);
    }

  }

  void getCategories () async{
    categories = await _categoriesProvider.getAll();
    refresh();
  }

  void openBottomSheet(Product product){
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ClientProductsDetailPage(product: product)
    );
  }

  void logout(){
    _sharedPref.logout(context, user.id);
  }

  void openDrawer (){
    key.currentState.openDrawer();

  }
  void goToUpdatePage(){
    // ESTE TE ENVIA DE UNA PANTALLA A OTRA Y NO ELIMINA EL HISTORIAL
    Navigator.pushNamed(context, 'client/update');
  }

  void goToOrdersList(){
    // ESTE TE ENVIA DE UNA PANTALLA A OTRA Y NO ELIMINA EL HISTORIAL
    Navigator.pushNamed(context, 'client/orders/list');
  }

  void goToOrderCreatePage(){
    // ESTE TE ENVIA DE UNA PANTALLA A OTRA Y NO ELIMINA EL HISTORIAL
    Navigator.pushNamed(context, 'client/orders/create');
  }

  void goToRoles(){
    //ELIMINA EL HISTORIAL DE PANTALLA
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

}