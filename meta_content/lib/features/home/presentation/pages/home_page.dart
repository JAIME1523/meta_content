import 'package:flutter/material.dart';
import 'package:meta_content/features/home/presentation/provider/home_provider.dart';
import 'package:meta_content/features/home/presentation/views/car_view.dart';
import 'package:meta_content/features/home/presentation/views/history_view.dart';
import 'package:meta_content/features/home/presentation/views/product_view.dart';
import 'package:meta_content/features/home/presentation/widgets/custom_nav_m.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: viewSwitch(provider.viewStatus),
        ),
      ),
      bottomNavigationBar: const _Nav(),
    );
  }

  viewSwitch(ViewsStatus view) {
    switch (view) {
      case ViewsStatus.product:
        return const ProductView();

      case ViewsStatus.history:
        return const HistoryView();
      case ViewsStatus.carShop:
        return const CarView();

      default:
        return const ProductView();
    }
  }
}

class _Nav extends StatelessWidget {
  const _Nav({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<HomeProvider>();
    final colors = Theme.of(context).colorScheme;
    return CustomNavMenu(activeColor: colors.secondaryContainer, items: [
      CustomNavButto(
          icon: Icons.home,
          tilte: 'Product',
          onPressed: () {
            navProvider.viewStatus = ViewsStatus.product;
          }),
      CustomNavButto(
          icon: Icons.history_sharp,
          tilte: 'History',
          onPressed: () {
            navProvider.viewStatus = ViewsStatus.history;
          }),
      CustomNavButto(
          icon: Icons.shopping_cart,
          tilte: 'shopping',
          onPressed: () {
            navProvider.viewStatus = ViewsStatus.carShop;
          }),
    ]);
  }
}
