import 'package:flutter/material.dart';
import 'package:meta_content/features/home/presentation/provider/home_provider.dart';
import 'package:nav_service/nav_service.dart';
import 'package:provider/provider.dart';

import 'features/home/presentation/pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=> HomeProvider()..getDbInfo(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: SnackService.messagerKey,
        navigatorKey: NavService.navigatorKey,
        home: const HomePage()

      ),
    );
  }
}
