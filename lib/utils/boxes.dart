import 'package:hive_example/models/transaction.dart';
import "package:hive/hive.dart";
import 'package:hive_example/utils/constants.dart';

class Boxes {
  static Box<Transaction> getTransactions() {
    return Hive.box<Transaction>(boxTransaction);
  }
}
