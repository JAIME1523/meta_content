import 'package:flutter/material.dart';
import 'package:meta_content/features/home/presentation/provider/home_provider.dart';
import 'package:meta_content/features/home/presentation/widgets/custom_input.dart';
import 'package:meta_content/features/home/utils/uitls_amont.dart';
import 'package:nav_service/nav_service.dart';
import 'package:provider/provider.dart';


class CarView extends StatelessWidget {
  const CarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    return Scaffold(
      appBar: AppBar(
        actions: provider.isLoading ? []: [
          IconButton(
              onPressed: () {
            provider.clearAll();
              },
              icon: const Icon(Icons.delete_forever_outlined)),
              const _AddProduc()
        ],
      ),
      body: provider.producListCar.isEmpty
          ? const Center(
              child: Text('No hay nada en el carrito'),
            )
          : const _BodyCard(),
      floatingActionButton:
          provider.producListCar.isEmpty ? null : const _Icon(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _AddProduc extends StatelessWidget {
  const _AddProduc();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HomeProvider>();

    return IconButton(onPressed: ()async{
      provider.activeButon = false;
      final TextEditingController monto = TextEditingController();

    ShowService.alert(content: _AlerInser( monto: monto));
    }, icon: const Icon(Icons.add));
  }

    alertInsert() {
  
  } 
}

class _AlerInser extends StatelessWidget {
  const _AlerInser({
    required this.monto,
  });

  final TextEditingController monto;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final size = MediaQuery.sizeOf(context);
    return AlertDialog(
      content: SizedBox(
        height: size.height * 0.3,
        child: Form(
          key: provider.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Ingresa monto'),
              CustomInputField(
                onChange: (va){
                  provider.validateInput();
                },
                validator: (value) {
                  return UtilsAmont.validtesAmont(value ?? '');
                },
             
                controller: monto,
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                  onPressed: provider.activeButon ? () async {
                    
                    provider.manualInsertion(monto.text);
                  }:null,
                  child: const Text('Guardar'))
            ],
          ),
        ),
      ),
    );
  }
}

class _BodyCard extends StatelessWidget {
  const _BodyCard();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return ListView(
      children: [
        ...List.generate(provider.producListCar.length, (index) {
          final prod = provider.producListCar[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.all(5),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: prod.image.isEmpty? null: DecorationImage(
                                image: NetworkImage(prod.image))),
                                child:prod.image.isEmpty? const FittedBox(
                                  fit: BoxFit.cover,
                                  child: Icon(Icons.tag_faces_outlined)):null,
                      ),
                      const Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                       
                              const Text('Prudct Info:'),
                              Text(prod.name),
                              Text(prod.species),
                              Text(prod.status)

                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                  Text( '\$ ${UtilsAmont.amontCustom(prod.precie.toString())}',)
                ],
              ),
            ),
          );
        }),
        const SizedBox(
          height: 100,
        ),
      ],
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final styleText = Theme.of(context).textTheme;
    final provider = context.watch<HomeProvider>();
    return Container(
      padding: const EdgeInsets.all(10),
      height: 108,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          color: colors.secondaryContainer),
      child:
      provider.isLoading ? const Center(child: CircularProgressIndicator()):
       Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Total: ',
              style: styleText.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            if (provider.monto.isNotEmpty)
              Text(
                '\$ ${provider.monto.replaceRange(provider.monto.length - 2, null, '')}',
                style:
                    styleText.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
          ]),
           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Envio: ',
              style: styleText.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 10),
            ),
            if (provider.monto.isNotEmpty)
              Text(
                'Gratis',
                style:
                    styleText.bodyLarge!.copyWith(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 10),
              ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          ElevatedButton(
              onPressed: () {
                provider.inserStartTransac();
              },
              child: const Text('Continuar compra')),
              ElevatedButton(child: const Text('Solo registrar'), onPressed: (){
                provider.registrerTransa();
              }),
          ],)
          
        ],
      ),
    );
  }
}
