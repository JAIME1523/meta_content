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
      create: (_)=> HomeProvider()..getData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: SnackService.messagerKey,
        navigatorKey: NavService.navigatorKey,
        home: const HomePage()
        
         /*    Scaffold(
          body: Center(
            child: ElevatedButton(
                onPressed: () async {
                  //ContentService.query(url: TypeUrl.startTransac, selectionArgs: ['500']);
                  // ShowService.modal(content: const AlertDialog(title: Text('Hola'),));
                      final tra = TransactionContentModel(transaction: TransactionGRpcModel(amount: 2000, status: TransactionStatus.Pending, type: TransactionType.Sale));
      
          final resp =      (await   ContentService.insert( url: TypeUrl.startTransac, mapInfo:tra ));
           ( await   ContentService.query( url: TypeUrl.startTransac, selectionArgs: ['500']));
       /*    print('desde el main');
      print(resp.transaction.toJson())   */
        var openAppResult = await LaunchApp.openApp(
                    androidPackageName: 'com.example.meta_app',
      
                    // openStore: false
                  );
                  print('openAppResult => $openAppResult ${openAppResult.runtimeType}'); 
       
      
      
                },
                child: Text('Hello World!')),
          ),
        ), */
      ),
    );
  }
}
