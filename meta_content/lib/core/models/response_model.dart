import 'package:server_grpc/server_grpc.dart';

class ResponseModel {
  final bool status;
  final String info;
  final TransactionGRpcModel? transcion;
  final TransactionStatus? statusTransac;

  ResponseModel(  {required this.status, required this.info, this.transcion, this.statusTransac});
}
