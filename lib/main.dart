import 'package:flutter/material.dart';
import 'package:hive_example/pages/transction_page.dart';
import 'package:hive_example/utils/constants.dart';
import 'package:hive_flutter/adapters.dart';

import 'models/transaction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());

  await Hive.openBox<Transaction>(boxTransaction);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TransactionPage(),
    );
  }
}
