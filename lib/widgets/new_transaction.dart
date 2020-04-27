import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  final Function addTx;
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  NewTransaction(this.addTx);

  void submitData() {
    final enteredTitle =titleController.text;
    final enteredAmount =double.parse(amountController.text);
    if (titleController.text.isEmpty || double.parse(amountController.text)<=0){
      return;
    }
    addTx(
      enteredTitle,
      enteredAmount,
    );
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
              textColor: Colors.orangeAccent,
              onPressed: () {

              },
            ),
          ],
        ),
      ),
    );
  }
}
