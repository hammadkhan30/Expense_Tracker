import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  void submitData() {
    final enteredTitle =titleController.text;
    final enteredAmount =double.parse(amountController.text);
    if (titleController.text.isEmpty || double.parse(amountController.text)<=0){
      return;
    }
    widget.addTx(
      enteredTitle,
      enteredAmount,
    );
    Navigator.of(context).pop();
  }

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
              onSubmitted:(_)=>submitData(),
            ),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.words,
              autocorrect: true,
              decoration: InputDecoration(
                  labelText: 'Amount', hintText: 'Enter the amount:'),
              onSubmitted:(_)=>submitData(),
            ),
            FlatButton(
              child: Text('Add Transaction'),
              textColor: Theme.of(context).primaryColorDark,
              onPressed: () {

              },
            ),
          ],
        ),
      ),
    );
  }
}
