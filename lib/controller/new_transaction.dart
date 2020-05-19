import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/controller/dbhelper.dart';

//TODO: Separate View and Controller
//TODO: Controller must interact with the model not view
class NewTransaction extends StatefulWidget {
  final Function addTx;
  NewTransaction(this.addTx) ;
  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final dbhelper = DatabaseCreator.instance;

  //controllers used in insert operation UI
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = _amountController.text;
    if (_titleController.text.isEmpty ||
        double.parse(_amountController.text) <= 0 ||
        _selectedDate == null) {
      return;
    }
    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );
    _insert(_titleController,_amountController,_selectedDate);
    Navigator.of(context).pop();
  }

  void _showMessageInScaffold(String message){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(message),
        )
    );
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    ).then(
          (pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(
              () {
            _selectedDate = pickedDate;
          },
        );
      },
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
              controller: _titleController,
              textCapitalization: TextCapitalization.words,
              autocorrect: true,
              decoration: InputDecoration(
                  labelText: 'Title', hintText: 'Enter the item :'),
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.words,
              autocorrect: true,
              decoration: InputDecoration(
                  labelText: 'Amount', hintText: 'Enter the amount:'),
              onSubmitted: (_) => _submitData(),
            ),
            Container(
              height: 160,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No Date Chosen'
                          : 'Picked Date : ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColorDark,
                    child: Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _presentDatePicker,
                  )
                ],
              ),
            ),
            RaisedButton(
              child: Text('Add Transaction'),
              textColor: Theme.of(context).textTheme.button.color,
              color: Theme.of(context).primaryColorDark,
              onPressed: _submitData,
            ),
          ],
        ),
      ),
    );
  }

  void _insert(_titleController, _amountController, _selectedDate) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseCreator.COLUMN_TITLE: _titleController,
      DatabaseCreator.COLUMN_AMOUNT: _amountController,
      DatabaseCreator.COLUMN_DATE: _selectedDate,
    };
    Transactions transaction = Transactions.fromMap(row);
    final id = await dbhelper.insert(transaction);
    _showMessageInScaffold('inserted row id: $id');
  }

}
