import 'package:android_content_provider/android_content_provider.dart';
import 'package:meta_content/core/models/transaction_content_model.dart';

class TransactionService {
  static Future<TransactionContentModel> query(NativeCursor? cursor) async {
    final batch = TransactionContentModel.createBatch(cursor!);
    final responseCount =(await cursor.batchedGet().getCount().commit()).first as int;
    final data = await batch.commitRange(0, responseCount);
    final responce = TransactionContentModel.fromCursorData(data[0]);
    return responce;
  }
}
