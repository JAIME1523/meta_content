import 'package:flutter/material.dart';
import 'package:meta_content/features/home/presentation/provider/home_provider.dart';
import 'package:meta_content/features/home/presentation/widgets/widgtes.dart';
import 'package:nav_service/nav_service.dart';
import 'package:provider/provider.dart';
import 'package:server_grpc/database/models/transaction_grpc_model.dart';

import '../../utils/uitls_amont.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    return provider.listransac.isEmpty ? const Center(child: Text('Sin movimientos resientes'),):Stack(
      children: [
         ListView.builder(
        itemCount: provider.listransac.length,
        itemBuilder: (_, index) {
          final transacion = provider.listransac.reversed.toList()[index];
          return _BanerWidget(transacion: transacion);
        }),
         ButtonStatus(
          icon: Icons.health_and_safety_outlined ,
          title: 'Estatus',
          onPressed: (){
             final text = TextEditingController();
              ShowService.alert(
                  content: AlertGet(
                text: text,
                onPressed: (value) async {
                  final resp = await provider.getStatus(value);
                  if (resp.status) {
                    SnackService.showSnackbar(
                        top: true,
                        resp.statusTransac!.toString(),
                        backgroundColor: resp.statusTransac!.value == 4
                            ? Colors.green
                            : resp.statusTransac!.value == 0
                                ? Colors.blue
                                : Colors.red);
                    return;
                  }
                  SnackService.showSnackbarError(resp.info);
                },
              ));
          },
         )
      ],
    );
  }
}


class _BanerWidget extends StatelessWidget {
  const _BanerWidget({
    required this.transacion,
  });
  final TransactionGRpcModel transacion;

  @override
  Widget build(BuildContext context) {
    final styleText = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.sizeOf(context);
    final provider = context.read<HomeProvider>();

    return Container(
             margin: const EdgeInsets.all(10),

      child: GestureDetector(
        onTap: (){
      if(transacion.idProtoTransaction == null)  return;
      provider.getTransac(transacion.idProtoTransaction!);
          ShowService.modal(
            isScrollControlled: true,
            content: const AlertInfoTransac());
        },
        child: Banner(
          location: BannerLocation.topEnd,
          color: transacion.status!.value == 4
              ? Colors.green
              : transacion.status!.value == 0
                  ? Colors.blue
                  : Colors.red,
          message: transacion.status != null ? transacion.status!.name : '',
          child: SizedBox(
            width: size.width * 0.3,
            child: Card(
                color: colors.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                   _ColumnInfo(
                        title: 'id',
                        info: transacion.idProtoTransaction.toString(),
                        infoStyle: styleText.titleMedium!.copyWith(fontSize: 14.5),
                      ),
                      _ColumnInfo(
                        title: 'Monto',
                        info: UtilsAmont.amontCustom(transacion.amount.toString()),
                      ),
                      _ColumnInfo(
                        title: 'Estado',
                        info: transacion.status != null
                            ? transacion.status!.name
                            : '',
                        infoStyle: styleText.titleMedium!.copyWith(
                            color: transacion.status!.value == 4
                                ? Colors.green
                                : transacion.status!.value == 0
                                    ? Colors.blue
                                    : Colors.red),
                      ),
                    if(transacion.status!.value != 4 && transacion.status!.value != 2)    ElevatedButton(onPressed: (){
                          provider.satrtTransac(transacion.idProtoTransaction!);
                        }, child: const Text('Cobrar')),
                     if(transacion.status!.value == 4)
                       PrimaryButton(
                        borderRadius: 59,
                        ischarge: true,
                        title: 'cancel',onPressed:  ()async{
                          provider.satrtCancelTransac(transacion);
                   
                      }) 
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

class _ColumnInfo extends StatelessWidget {
  const _ColumnInfo({required this.title, required this.info, this.infoStyle});
  final String title;
  final String info;
  final TextStyle? infoStyle;
  @override
  Widget build(BuildContext context) {
    final styleText = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          title,
          style: styleText.bodySmall,
        ),
        SelectableText(
          info,
          style: infoStyle ?? styleText.titleMedium,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
