import 'dart:math';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:meta_content/core/json/data_p.dart';
import 'package:meta_content/core/json/model_data/produc_model.dart';
import 'package:meta_content/core/models/models.dart';
import 'package:meta_content/core/server/service/transaction_service.dart';
import 'package:nav_service/nav_service.dart';
import 'package:server_grpc/server_grpc.dart';

enum ViewsStatus { product, history, carShop }

class HomeProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  bool _activeButon = true;
  bool _isLoading = false;
  ViewsStatus _viewStatus = ViewsStatus.product;
  List<ProductModel> producList = [];
  List<ProductModel> producListCar = [];
  List<TransactionGRpcModel> listransac = [];
  String monto = '';
  TransactionGRpcModel? transactionGet;

  addPructCar(ProductModel produc) {
    producListCar.add(produc);
    _calculeMont();
  }

  delete(ProductModel produc) {
    producListCar.remove(produc);
    _calculeMont();
  }

  clearAll() {
    monto = '';
    producListCar = [];
    notifyListeners();
  }

  Future<TransactionGRpcModel> getTransac(String id) async {
    isLoading = true;
    final resTransac = await TransactionService.getTran(id: id);
    isLoading = false;
    transactionGet = resTransac.transcion;
    return resTransac.transcion!;
  }

  Future inserStartTransac() async {
    final resTransac = await registrerTransa();
    if (!resTransac.status) return;
    await satrtTransac(resTransac.transcion!.idProtoTransaction!);
  }

  Future<ResponseModel> registrerTransa() async {
    isLoading = true;
    final tra = TransactionGRpcModel(
        amount: int.tryParse(monto) ?? 0,
        status: TransactionStatus.Pending,
        type: TransactionType.Sale);

    final resTransac = await TransactionService.registerTran(tra);
    if (!resTransac.status) {
      SnackService.showSnackbarError('No se resgistro');
      isLoading = false;
      return resTransac;
    }
    final id = resTransac.transcion!.idProtoTransaction!;
    listransac.add(tra.copyWith(idProtoTransaction: id));
    isLoading = false;
    clearAll();
    return resTransac;
  }

  Future<ResponseModel> getStatus(String id) async {
    return await TransactionService.getStat(id: id, origin: 'desde la web');
  }

  Future satrtTransac(String id) async {
    await TransactionService.startTransaction(
        id: id,
        onPressed: () {
          processChange(id);
        });

    await _openApp();
  }

  Future<void> _openApp() async {
    try {
      var openAppResult = await LaunchApp.openApp(
        androidPackageName: 'com.example.meta_app',
      );
      if (openAppResult != 1) {
        SnackService.showSnackbarError('No se puede abrir app');
      }
    } catch (e) {
      SnackService.showSnackbarError('No se encontro app');
    }
  }

  Future satrtCancelTransac(TransactionGRpcModel  transac) async {
    await TransactionService.cancelTransaction(
        id: transac.idProtoTransaction!,
        transac: transac,
        onPressed: () {
          cancelChange(transac);
        });
    await _openApp();
  }

  Future processChange(String id) async {
    final res = await TransactionService.transactionResult(id: id);
    if (res.transcion != null) {
      SnackService.showSnackbar('TODO OK');

      for (var i = 0; i < listransac.length; i++) {
        if (listransac[i].idProtoTransaction == id) {
          listransac[i] = res.transcion!.copyWith(idProtoTransaction: id);
        }
      }
    } else {
      final reserror = await TransactionService.getTran(id: id);
      if (!res.status) SnackService.showSnackbarError(res.info);
      for (var i = 0; i < listransac.length; i++) {
        if (listransac[i].idProtoTransaction == id) {
          listransac[i] = reserror.transcion!.copyWith(idProtoTransaction: id);
        }
      }
    }
    clearAll();
  }

  Future cancelChange(TransactionGRpcModel  transac) async {
    final res = await TransactionService.cancelResult(id: transac.idProtoTransaction!, transac: transac);
    if(!res.status){
      SnackService.showSnackbarError(res.info);
    }
    if (res.statusTransac != null) {
      SnackService.showSnackbar('TODO OK');
      for (var i = 0; i < listransac.length; i++) {
        if (listransac[i].idProtoTransaction == transac.idProtoTransaction) {
          listransac[i] = listransac[i].copyWith(status: res.statusTransac);
        }
      }
    }
    clearAll();
  }

  validateInput() {
    activeButon = formKey.currentState!.validate();
    notifyListeners();
  }

  manualInsertion(String amontR) {
    final amontArray = amontR.split('.');
    if (amontArray.length <= 1) {
      amontArray.add('00');
    }

    amontArray[1] = amontArray[1].padRight(2, '0');
    //amontArray[1].padRight(2, '0');
    final amont = amontArray.join();
    NavService.pop();
    if (amont.isEmpty || amont == '0' || amont == '0.00' || amont == '0.0') {
      return;
    }
    final int newmont = int.tryParse(amont) ?? 0;
    if (newmont == 0) {
      SnackService.showSnackbarError('Valor invalido');
      return;
    }
    final produc = ProductModel(
        id: 152,
        name: 'Sin dato',
        status: '',
        species: '',
        image: '',
        precie: newmont.toString());
    addPructCar(produc);
  }

  Future<void> getData() async {
    producList = [];
    for (var element in dataProduct) {
      final preciS = (_generedNumber().toString()).split('');
      preciS.addAll(['0', '0']);
      final preci = preciS.join();
      final prod = ProductModel.fromJson(element);
      prod.precie = preci.toString();
      producList.add(prod);
    }
    notifyListeners();
  }

  int _generedNumber() {
    final preci = Random().nextInt(99) + 10;
    if (preci % 2 != 0) {
      return _generedNumber();
    }
    return preci;
  }

  _calculeMont() {
    int newMont = 0;

    for (var element in producListCar) {
      newMont = newMont + (int.tryParse(element.precie) ?? 0);
    }
    monto = newMont.toString();
    notifyListeners();
  }

  ViewsStatus get viewStatus => _viewStatus;
  set viewStatus(ViewsStatus value) {
    _viewStatus = value;
    notifyListeners();
  }

  bool get activeButon => _activeButon;
  set activeButon(bool value) {
    _activeButon = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
