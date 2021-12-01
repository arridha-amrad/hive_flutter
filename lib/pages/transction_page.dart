import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_example/models/transaction.dart';
import 'package:hive_example/utils/boxes.dart';
import 'package:hive_example/utils/constants.dart';
import 'package:hive_example/widgets/transaction_dialog.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final df = DateFormat('dd-MM-yyyy hh:mm a');

  @override
  void dispose() {
    // Hive.close();  close active box
    Hive.box(boxTransaction).close(); // close specific box
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive NoSQL DB"),
      ),
      body: ValueListenableBuilder<Box<Transaction>>(
        valueListenable: Boxes.getTransactions().listenable(),
        builder: (context, value, child) {
          var transactions = value.values.toList().cast<Transaction>();
          transactions.sort((a, b) => b.createDate.compareTo(a.createDate));
          double balance = 0;
          for (var transaction in transactions) {
            if (transaction.isExpense) {
              balance -= transaction.amount;
            } else {
              balance += transaction.amount;
            }
          }
          return Column(
            children: [
              transactions.isEmpty
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Net Balance : $balance",
                        style: const TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
              Expanded(
                child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      transactions[index].name,
                                    ),
                                    subtitle: Text(df.format(
                                        transactions[index].createDate)),
                                    trailing: Text(
                                        transactions[index].amount.toString(),
                                        style: TextStyle(
                                            color: transactions[index].isExpense
                                                ? Colors.red
                                                : Colors.green)),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () => showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    TransactionDialog(
                                                  isEdit: true,
                                                  transaction:
                                                      transactions[index],
                                                ),
                                              ),
                                          child: const Text("Edit")),
                                      TextButton(
                                          onPressed: () async {
                                            await transactions[index].delete();
                                          },
                                          child: const Text("Delete")),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const TransactionDialog(),
        ),
      ),
    );
  }
}
