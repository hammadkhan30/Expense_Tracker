import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  final Function addTx;
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  NewTransaction(this.addTx);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              autocorrect: true,
              decoration: InputDecoration(
                  labelText: 'Title', hintText: 'Enter the item :'),
            ),
            TextField(
              controller: amountController,
              textCapitalization: TextCapitalization.words,
              autocorrect: true,
              decoration: InputDecoration(
                  labelText: 'Amount', hintText: 'Enter the amount:'),
            ),
            FlatButton(
              child: Text('Add Transaction'),
              textColor: Colors.orangeAccent,
              onPressed: () {
                addTx(
                  titleController.text,
                  double.parse(amountController.text),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
