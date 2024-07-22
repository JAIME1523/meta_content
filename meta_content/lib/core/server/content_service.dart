import 'package:android_content_provider/android_content_provider.dart';

enum TypeUrl {
  startTransac('startTransaction'), getTransac('getTransaction'),
  transactionResult('transactionResult'), getStatus('getStatus'),
  cancelTransaction('cancelTransaction'),
  registerTransaction('registerTransaction'),
  cancelResult('cancelResult');
  final  String value ;
  const TypeUrl(this.value);
  }


class ContentService  {
ContentService();
  static const _baseUri = 'content://com.example.meta_app.MyAndroidContentProvider';
 static Future<String> query({required TypeUrl url, List<String>? selectionArgs, required bool activeStream , Function()? onPressed,   required String selection,}) async {
   String homeUri = '$_baseUri/${url.value}';
    NativeCursor? cursor;
    try {
      cursor = await AndroidContentResolver.instance.query(uri: homeUri, selectionArgs: selectionArgs, selection: selection);
    if (cursor == null) return ''; 
    if(activeStream)    await cursor.registerContentObserver(TransactionContentObserver(cursor, onPressed:onPressed!));
      final batss= cursor.batchedGet()..getString(0);
      final bat =await batss.commitRange(0, 1);
      String batchData =  bat[0][0].toString();
      return batchData;
    } catch (e) {
     return '';
    }
  }


}


//mandar al provider
class TransactionContentObserver extends ContentObserver {
  final NativeCursor _cursor;
Function() onPressed;
  TransactionContentObserver(this._cursor, {required this.onPressed});

  @override
  void onChange(bool selfChange, String? uri, int flags)async {
    // ignore: avoid_print
    print('selfChange $selfChange uri $uri flags $flags');
   await processChange(onPressed);
  }

  Future<void> processChange(Function() onPressed) async {
    // liberamos el observador del cursor anterior para evitar un bucle de observadores
    await _cursor.unregisterContentObserver(this);
    await _cursor.close();
   await onPressed();
  }
}