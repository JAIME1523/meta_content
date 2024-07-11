import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta_content/core/json/data_p.dart';
import 'package:meta_content/core/json/model_data/produc_model.dart';

enum ViewsStatus { product, history, carShop }

class HomeProvider extends ChangeNotifier {
  ViewsStatus _viewStatus = ViewsStatus.product;
  List<ProductModel> producList = [];

  Future<void> getData() async {
    for (var element in dataProduct) {
      final preciS = (_generedNumber().toString()).split('');
      preciS.addAll(['0', '0']);
      final preci = preciS.join();
      final prod = ProductModel.fromJson(element);
      prod.precie = preci.toString();
      producList.add(prod);
    }
  }

  int _generedNumber() {
    final preci = Random().nextInt(99) + 10;
    if (preci % 2 != 0) {
      return _generedNumber();
    }
    return preci;
  }

  ViewsStatus get viewStatus => _viewStatus;

  set viewStatus(ViewsStatus value) {
    _viewStatus = value;
    notifyListeners();
  }
}
