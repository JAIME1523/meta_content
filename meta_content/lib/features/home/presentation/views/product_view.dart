import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meta_content/features/home/presentation/provider/home_provider.dart';
import 'package:nav_service/nav_service.dart';
import 'package:provider/provider.dart';

import '../../../../core/json/model_data/produc_model.dart';

class ProductView extends StatelessWidget {
  const ProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    return GridView.custom(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: SliverWovenGridDelegate.count(
        crossAxisCount: 2,
        pattern: [
          const WovenGridTile(1),
          const WovenGridTile(
            5 / 7,
            crossAxisRatio: 0.9,
            // alignment: AlignmentDirectional.,
          ),
        ],
      ),
      childrenDelegate: SliverChildBuilderDelegate((context, index) {
        final url = provider.producList[index];
        return _CharacterItem(
          product: url,
        );
      }, childCount: provider.producList.length),
    );
  }
}

class _CharacterItem extends StatelessWidget {
  const _CharacterItem({
    Key? key,
    required this.product,
  }) : super(key: key);
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            // scale: 2,
            fit: BoxFit.fill,
            image: NetworkImage(product.image)),
        color: Colors.blue.withOpacity(0.5),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.all(5),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: colors.secondaryContainer,
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text('Precio:'),
                  Text(product.precie.isNotEmpty ?  '${product.precie.replaceRange(product.precie.length -2, null, '')} \$': '')
                ],
              ),
              IconButton(onPressed: (){
                context.read<HomeProvider>().addPructCar(product);
                SnackService.showSnackbar('Se agrego al carrito');
              }, icon: const Icon(Icons.add_shopping_cart_rounded))
            ],
          ),
        ),
      ),
    );
  }
}
