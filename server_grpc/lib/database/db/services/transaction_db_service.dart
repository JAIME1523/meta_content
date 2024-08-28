import 'package:server_grpc/database/db/data/db_implement.dart';
import 'package:server_grpc/database/db/data/db_table_repo.dart';
import 'package:server_grpc/database/models/transaction_grpc_model.dart';
import 'package:server_grpc/grpc_data/protos/model/transactions/transactions.pb.dart';
import 'package:server_grpc/logger/logger_printer.dart';
import 'package:uuid/uuid.dart';

class TransactionsDbService {
  static final log  = getLogger(TransactionsDbService);
  static final _impl = DbImplement();
  static const _table = NameTable.transaccion;

  static Future<String> insert(TransactionGRpcModel data) async  {
    final newId = const Uuid().v4();
    final newData =  data;
    if(data.idProtoTransaction != null){
    data.copyWith(idProtoTransaction: newId);
    }
    return  (await _impl.insert(_table, newData) != 0) ? 
      newData.idProtoTransaction! :
      '0';
    }
///* validar si existe , si existe genera uno nuevo y vuelve a evaluar y si no existe regresa el mismo generaddo
///? Un falta validar funcionamiento 
/*    static Future<String> _validateC(String id)async{
    final transaction = await _impl.getByIdOrigin(origin: '', idTransaccion:id);
      if(transaction.isNotEmpty) {
       final newId = const Uuid().v4();
        return await _validateC(newId);
      }
      return id;
    }  */

  static Future<int> update( {required TransactionGRpcModel data, required String id}) async => await _impl.update(_table, data: data, value: id);


  static Future<int> updateStatus({required TransactionStatus status, required String idTransaction}) async {
    Map<String, dynamic> data = {'status':  statusValues.reverse[status],};
   return await _impl.updateStatus(_table, data: data, idTransaction: idTransaction);
  }

static Future<int> updateAmount({required String amont, required String idTransaction}) async {
    Map<String, dynamic> data = {'amont': amont,};
   return await _impl.updateStatus(_table, data: data, idTransaction: idTransaction);
  }
  static Future<List<TransactionGRpcModel>> getAll() async {
    List<TransactionGRpcModel> listTra = [];
    final resp = await _impl.getAll(_table);
    log.d(resp);
    for (var transac in resp) {
      listTra.add(TransactionGRpcModel.fromMap(transac));
    }

    return listTra;
  }

 static Future<TransactionGRpcModel?> getByIdOrigin({required String origin, required String idProtoTra}) async {
      final transaction = await _impl.getByIdOrigin(origin: origin, idTransaccion: idProtoTra);
    try {
      final info = TransactionGRpcModel.fromMap(transaction.last);
      return info;
    } catch (e) {
      return null;
    }
  }
}
