import 'dart:convert';

import 'package:android_content_provider/android_content_provider.dart';
import 'package:flutter/material.dart';
import 'package:meta_content/core/models/response_model.dart';
import 'package:meta_content/core/models/transaction_content_model.dart';
import 'package:meta_content/core/server/service/transaction_service.dart';

enum TypeUrl {
  startTransac('startTransac'), getTransac('getTransac');
  final  String value ;
  const TypeUrl(this.value);
  }


class ContentService  {
ContentService();
  static const _baseUri = 'content://com.example.meta_app.MyAndroidContentProvider';
static const String _transaction = '$_baseUri/startTransac';

 static Future<ResponseDataModel?> query({required TypeUrl url, List<String>? selectionArgs, bool activeStream = true}) async {
   String homeUri = '$_baseUri/${url.value}';
    NativeCursor? cursor;
    try {
      cursor = await AndroidContentResolver.instance.query(uri: homeUri, selectionArgs: selectionArgs);
    if (cursor == null) return null; 

      switch (homeUri) {
        case _transaction:
   if(activeStream)    await cursor.registerContentObserver(TransactionContentObserver(cursor));
       final res =  await TransactionService.query(cursor);
          return res;
        default:
        return null;
      }
    } catch (e) {
      print(e);
     return null;
     //return const ResponseDataModel(st atus: false, message: 'Error en el server', data: 'info');
    }
  }


  static Future insert({required TypeUrl url, required ResponseDataModel mapInfo }) async {
 String homeUri = '$_baseUri/${url.value}';
    final info = await AndroidContentResolver.instance.insert(uri: homeUri, 
    values:mapInfo.toContentValues());
    return info; 


  }

  /// Calls [AndroidContentResolver.delete].
 static Future<void> delete({required TypeUrl url, required int id}) async {
   String urlPost = '$_baseUri/${url.value}';
   await AndroidContentResolver.instance.delete(uri: urlPost,selectionArgs: ['$id']);
  }
}


//mandar al provider
class TransactionContentObserver extends ContentObserver {
  final NativeCursor _cursor;

  TransactionContentObserver(this._cursor, );

  @override
  void onChange(bool selfChange, String? uri, int flags)async {
    print('selfChange $selfChange uri $uri flags $flags');
   await processChange();
  }

  Future<void> processChange() async {
    // liberamos el observador del cursor anterior para evitar un bucle de observadores
    await _cursor.unregisterContentObserver(this);
    await _cursor.close();
    await ContentService.query(url: TypeUrl.startTransac, activeStream: false);
  }
}