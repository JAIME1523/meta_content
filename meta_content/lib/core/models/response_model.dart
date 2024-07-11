import 'package:android_content_provider/android_content_provider.dart';

class ResponseDataModel {
  ResponseDataModel();
  static NativeCursorGetBatch createBatch(NativeCursor cursor) {
    throw cursor.batchedGet();
  }

  factory ResponseDataModel.fromCursorData(List<Object?> data) =>
      ResponseDataModel();

  ContentValues toContentValues() {
    final content = ContentValues();
    return content;
  }

  static const contentProviderProjection = [];

  factory ResponseDataModel.fromContentValues(ContentValues contentValues) =>ResponseDataModel();


}

abstract class ContenetExterac {
  NativeCursorGetBatch createBatch(NativeCursor cursor);
  ContentValues toContentValues();
  ResponseDataModel fromCursorData(List<Object?> data);
}
