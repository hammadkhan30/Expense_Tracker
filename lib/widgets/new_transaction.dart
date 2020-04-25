import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  String titleInput;
  String amountInput;

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
              onChanged: (val) {
                titleInput = val;
              },
              textCapitalization: TextCapitalization.words,
              autocorrect: true,
              decoration: InputDecoration(
                  labelText: 'Title', hintText: 'Enter the item :'),
            ),
            TextField(
              onChanged: (amt) {
                amountInput = amt;
              },
              textCapitalization: TextCapitalization.words,
              autocorrect: true,
              decoration: InputDecoration(
                  labelText: 'Title', hintText: 'Enter the item :'),
            ),
            FlatButton(
              child: Text('Add Transaction'),
              textColor: Colors.orangeAccent,
              onPressed: () {},
            ),
          ],
        ),
      ),
    )
    ,;
  }
}
