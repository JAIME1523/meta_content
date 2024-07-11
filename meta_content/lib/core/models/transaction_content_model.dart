import 'package:android_content_provider/android_content_provider.dart';
import 'package:meta_content/core/models/response_model.dart';
import 'package:server_grpc/database/models/transaction_grpc_model.dart';
import 'package:server_grpc/grpc_data/grpc_data.dart';

class TransactionContentModel extends ResponseDataModel {
  TransactionGRpcModel transaction;

  TransactionContentModel({required this.transaction});

  static NativeCursorGetBatch createBatch(NativeCursor cursor) {
    final bacth = cursor.batchedGet();
    bacth.getInt(0);
    bacth.getInt(1);
    bacth.getInt(2);
    bacth.getString(3);
    bacth.getString(4);
    bacth.getString(5);
    bacth.getString(6);
    bacth.getString(7);
    return bacth;
  }

  factory TransactionContentModel.fromCursorData(List<Object?> data) {
    return TransactionContentModel(
        transaction: TransactionGRpcModel(
      status: TransactionStatus.valueOf(data[0] as int),
      type: TransactionType.valueOf(data[1] as int),
      amount: data[2] as int,
      referenceNumber:  data[3].toString() ,
      arqc: data[4].toString(),
      maskPan: data[5].toString(),
      authorizationNumber: data[6].toString(),
      stan: data[7].toString(),
    ));
  }
  @override
  ContentValues toContentValues() {
    final content = ContentValues();
    content.putInt('status', transaction.status!.value);
    content.putInt('type', transaction.type!.value);
    content.putInt('amount', transaction.amount);
    if (transaction.referenceNumber != null) content.putString('referenceNumber', transaction.referenceNumber);
    if (transaction.arqc != null) content.putString('arqc', transaction.arqc);
    if (transaction.maskPan != null) content.putString('maskPan', transaction.maskPan);
    if (transaction.authorizationNumber != null) content.putString('authorizationNumber', transaction.authorizationNumber);
    if (transaction.stan != null) content.putString('stan', transaction.stan);
    return content;
  }
/* 
  static const contentProviderProjection = [
    'status',
    'type',
    'amount',
    'referenceNumber',
    'arqc',
    'maskPan',
    'authorizationNumber',
    'stan'
  ];

  factory TransactionContentModel.fromContentValues(
          ContentValues contentValues) =>
      TransactionContentModel(
        transaction: TransactionGRpcModel(
          status: TransactionStatus.valueOf(contentValues.getInt('status')!),
          type: TransactionType.valueOf(contentValues.getInt('type')!),
          amount: contentValues.getInt('amount')!,
          referenceNumber: contentValues.getString('referenceNumber'),
          arqc: contentValues.getString('arqc'),
          maskPan: contentValues.getString('maskPan'),
          authorizationNumber: contentValues.getString('authorizationNumber'),
          stan: contentValues.getString('stan'),
        ),
      ); */
}
