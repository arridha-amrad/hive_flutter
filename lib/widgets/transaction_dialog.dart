import 'package:flutter/material.dart';
import 'package:hive_example/models/transaction.dart';
import 'package:hive_example/utils/boxes.dart';

class TransactionDialog extends StatefulWidget {
  final bool? isEdit;
  final Transaction? transaction;

  const TransactionDialog({Key? key, this.isEdit = false, this.transaction})
      : super(key: key);

  @override
  _TransactionDialogState createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  late TextEditingController nameController;
  late TextEditingController amountController;
  bool isExpense = false;
  bool isIncome = false;

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    nameController = TextEditingController();
    amountController = TextEditingController();
    if (widget.isEdit == true) {
      nameController.text = widget.transaction!.name;
      amountController.text = widget.transaction!.amount.toString();
      if (widget.transaction!.isExpense) {
        isExpense = true;
      } else {
        isIncome = true;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.isEdit == true
          ? const Text("Edit Trasaction")
          : const Text("Add Transaction"),
      content: SingleChildScrollView(
          child: ListBody(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
                labelText: "Enter name", border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: amountController,
            decoration: const InputDecoration(
                labelText: "Enter amount", border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Checkbox(
                  value: isIncome,
                  onChanged: (bool? val) => setState(() => isIncome = val!)),
              const Text("Income")
            ],
          ),
          Row(
            children: [
              Checkbox(
                  value: isExpense,
                  onChanged: (bool? val) => setState(() => isExpense = val!)),
              const Text("Expense")
            ],
          ),
        ],
      )),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel")),
        TextButton(
            onPressed: () async {
              if (widget.isEdit == true) {
                await editTransaction(
                    widget.transaction!.key,
                    nameController.text,
                    double.parse(amountController.text),
                    isExpense);
              } else {
                await addTransaction(nameController.text,
                    double.parse(amountController.text), isExpense);
              }
              Navigator.of(context).pop();
            },
            child: widget.isEdit == true
                ? const Text("Update")
                : const Text("Save")),
      ],
    );
  }

  Future addTransaction(String name, double amount, bool isExpense) async {
    final transaction = Transaction()
      ..name = name
      ..amount = amount
      ..isExpense = isExpense
      ..createDate = DateTime.now();

    var boxes = Boxes.getTransactions();
    await boxes.add(transaction);
  }

  Future editTransaction(
      int key, String name, double amount, bool isExpense) async {
    final transaction = Transaction()
      ..name = name
      ..amount = amount
      ..isExpense = isExpense
      ..createDate = DateTime.now();

    var boxes = Boxes.getTransactions();
    await boxes.put(key, transaction);
  }
}
