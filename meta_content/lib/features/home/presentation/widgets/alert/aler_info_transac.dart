import 'package:flutter/material.dart';
import 'package:meta_content/features/home/presentation/provider/home_provider.dart';
import 'package:meta_content/features/home/utils/uitls_amont.dart';
import 'package:provider/provider.dart';

class AlertInfoTransac extends StatelessWidget {
  const AlertInfoTransac({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final styleText = Theme.of(context).textTheme;
    final provider = context.watch<HomeProvider>();

    final size = MediaQuery.sizeOf(context);
    return
        /*    AlertDialog(
            content: */
        provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : provider.transactionGet == null
                ? const Center(child: Text('No se encontro infromacion'))
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    width: double.infinity,
                    height: provider.transactionGet!.arqc != null
                        ? size.height * 0.7
                        : size.height * 0.3,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _ColumnInfo(
                            title: 'Id',
                            info: provider.transactionGet!.idProtoTransaction ??
                                '',
                          ),
                          _ColumnInfo(
                            title: 'Monto',
                            info: UtilsAmont.amontCustom(
                                provider.transactionGet!.amount.toString()),
                          ),
                          _ColumnInfo(
                            title: 'Estatus',
                            infoStyle: styleText.titleMedium!.copyWith(
                                color: provider.transactionGet!.status!.value ==
                                        4
                                    ? Colors.green
                                    : provider.transactionGet!.status!.value ==
                                            0
                                        ? Colors.blue
                                        : Colors.red),
                            info: provider.transactionGet!.status != null
                                ? provider.transactionGet!.status!.name
                                : '',
                          ),
                          if (provider.transactionGet!.arqc != null)
                            _ColumnInfo(
                              title: 'arqc',
                              info: provider.transactionGet!.arqc ?? '',
                            ),
                          if (provider.transactionGet!.authorizationNumber !=
                              null)
                            _ColumnInfo(
                              title: 'N. Autorización ',
                              info: provider
                                      .transactionGet!.authorizationNumber ??
                                  '',
                            ),
                          if (provider.transactionGet!.maskPan != null)
                            _ColumnInfo(
                              title: 'PAN',
                              info: provider.transactionGet!.maskPan ?? '',
                            ),
                          if (provider.transactionGet!.referenceNumber != null)
                            _ColumnInfo(
                              title: 'N. Referencia',
                              info: provider.transactionGet!.referenceNumber ??
                                  '',
                            ),
                          if (provider.transactionGet!.stan != null)
                            _ColumnInfo(
                              title: 'STAN',
                              info: provider.transactionGet!.stan ?? '',
                            ),
                        ],
                      ),
                    ),
                  );
    /*     actions: [
              ElevatedButton(
                  onPressed: () {
                    NavService.pop();
                  },
                  child: const Text('Ok'))
            ],
          ); */
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
