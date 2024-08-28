import 'package:server_grpc/database/database.dart';

class DBTransacs {
 static Future save(TransactionGRpcModel data) async {
    final reuslt = await TransactionsDbService.insert(data);
    return reuslt == '0' ? false : true;
  }

 static Future<bool> udpade(TransactionGRpcModel data) async {
    if (data.idProtoTransaction == null) return false;
    final reuslt = await TransactionsDbService.update(
        data: data, id: data.idProtoTransaction!);
    return reuslt == 0 ? false : true;
  }

 static Future<List<TransactionGRpcModel>> getAll() async => await TransactionsDbService.getAll();
  
}
