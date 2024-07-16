import 'dart:convert';
import 'package:meta_content/core/models/response_model.dart';
import 'package:meta_content/core/server/content_service.dart';
import 'package:server_grpc/server_grpc.dart';

class TransactionService {

 static Future<ResponseModel> registerTran(TransactionGRpcModel transac) async {
    final resp = RegisterTransactionRequest(origin: 'desde web', transaction: Transaction.fromJson(transac.toJsonGrpc()));
    final resQuery = await ContentService.query(url: TypeUrl.registerTransaction,activeStream: false, selection: base64Encode(resp.writeToBuffer()));
    if(resQuery.isEmpty) return ResponseModel(status: false, info: 'No se recibio data');
    final dataR = RegisterTransactionResponse.fromBuffer( base64Decode(resQuery));

    if(dataR.hasError()) return ResponseModel(status: false, info: dataR.error.errorMsg);
    return ResponseModel(status: true, info: 'ok', transcion:transac.copyWith(idProtoTransaction: dataR.id));
  }

 static Future<ResponseModel> getTran({required String id, String origin = 'web'}) async {
final requestInt = GetTransactionRequest(id: id,origin:origin);
    final resQuery = await ContentService.query(url: TypeUrl.getTransac,activeStream: false, selection:base64Encode(requestInt.writeToBuffer()));
    if(resQuery.isEmpty) return ResponseModel(status: false, info: 'No se recibio data');
    final dataR = GetTransactionResponse.fromBuffer( base64Decode(resQuery));

    if(dataR.hasError()) return ResponseModel(status: false, info: dataR.error.errorMsg);
      final trnsac = TransactionGRpcModel.fromMapByGrpc(dataR.transaction.writeToJsonMap());
    return ResponseModel(status: true, info: 'ok', transcion:trnsac.copyWith(idProtoTransaction: id));
  }

 static Future<ResponseModel> getStat({required String id, String origin = 'web'}) async {
final requestInt = GetStatusRequest(id: id,origin:origin);
    final resQuery = await ContentService.query(url: TypeUrl.getStatus,activeStream: false, selection:base64Encode(requestInt.writeToBuffer()));
    if(resQuery.isEmpty) return ResponseModel(status: false, info: 'No se recibio data');
    final dataR = GetStatusResponse.fromBuffer( base64Decode(resQuery));
    if(dataR.hasError()) return ResponseModel(status: false, info: dataR.error.errorMsg);
    return ResponseModel(status: true, info: 'ok', statusTransac: dataR.status);
  }
   static Future<ResponseModel> startTransaction({required String id, String origin = 'web', required Function() onPressed,}) async {
final requestInt = StartTransactionRequest(id: id,origin:origin);
    final resQuery = await ContentService.query(url: TypeUrl.startTransac,activeStream: true, 
    selection:base64Encode(requestInt.writeToBuffer()),
    onPressed: onPressed
    );
    if(resQuery.isEmpty) return ResponseModel(status: false, info: 'No se recibio data');
    final dataR = TransactionNotification.fromBuffer( base64Decode(resQuery));
    if(dataR.hasError()) return ResponseModel(status: false, info: dataR.error.errorMsg);
    return ResponseModel(status: true, info: 'ok', transcion:  TransactionGRpcModel.fromMapByGrpc(dataR.transaction.writeToJsonMap()));
  }

    static Future<ResponseModel> transactionResult({required String id, String origin = 'web'}) async {
    final requestInt = StartTransactionRequest(id: id,origin:origin);
    final resQuery = await ContentService.query(url: TypeUrl.transactionResult,activeStream: false, 
    selection:base64Encode(requestInt.writeToBuffer()),
    );
    if(resQuery.isEmpty) return ResponseModel(status: false, info: 'No se recibio data');
    final dataR = TransactionNotification.fromBuffer( base64Decode(resQuery));
    if(dataR.hasError()) return ResponseModel(status: false, info: dataR.error.errorMsg);
    return ResponseModel(status: true, info: 'ok', transcion: TransactionGRpcModel.fromMapByGrpc(dataR.transaction.writeToJsonMap()));
  }
     static Future<ResponseModel> cancelTransaction({required String id, String origin = 'web', required Function() onPressed,}) async {
final requestInt = CancelRequest(id: id,origin:origin);
    final resQuery = await ContentService.query(url: TypeUrl.cancelTransaction,activeStream: true, 
    selection:base64Encode(requestInt.writeToBuffer()),
    onPressed: onPressed
    );
    if(resQuery.isEmpty) return ResponseModel(status: false, info: 'No se recibio data');
    final dataR = CancelNotification.fromBuffer( base64Decode(resQuery));
    if(dataR.hasError()) return ResponseModel(status: false, info: dataR.error.errorMsg);
    return ResponseModel(status: true, info: 'ok', statusTransac: dataR.status);
  }

      static Future<ResponseModel> cancelResult({required String id, String origin = 'web'}) async {
    final requestInt = CancelRequest(id: id,origin:origin);
    final resQuery = await ContentService.query(url: TypeUrl.transactionResult,activeStream: false, 
    selection:base64Encode(requestInt.writeToBuffer()),
    );
    if(resQuery.isEmpty) return ResponseModel(status: false, info: 'No se recibio data');
    final dataR = CancelNotification.fromBuffer( base64Decode(resQuery));
    if(dataR.hasError()) return ResponseModel(status: false, info: dataR.error.errorMsg);
       return ResponseModel(status: true, info: 'ok', statusTransac: dataR.status);
  }
}
