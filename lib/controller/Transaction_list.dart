/*import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import '../controller/dbhelper.dart';

class TransactionList extends StatelessWidget {
  final dbhelper = DatabaseCreator.instance;
  final List<Transactions> transactions;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TransactionList(this.transactions);

  //TODO: Update the name of the file
  //TODO: Refactor code into clean function, or widgets
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: transactions.isEmpty
          ? Column(
              children: <Widget>[
                Text(
                  'No transactions found',
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  height:200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                if (index == transactions.length){
                  return RaisedButton(
                    child: Text('Refresh'),
                    onPressed: () {
                        _queryAll();
                    },
                  );
                }
                return Card(
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Theme.of(context).primaryColorDark,
                          width: 2,
                        )),
                        padding: EdgeInsets.all(10),
                        child: Text(
                            '\$${transactions[index].amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Theme.of(context).primaryColorDark,
                            )),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            transactions[index].title,
                            style: Theme.of(context).textTheme.title,
                          ),
                          Text(
                              DateFormat.yMMMd()
                                  .format(transactions[index].date),
                              style: TextStyle(
                                color: Colors.grey,
                              )),
                        ],
                      )
                    ],
                  ),
                );
              },
              itemCount: transactions.length + 1,
            ),
    );
  }
  void _showMessageInScaffold(String message){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(message),
        )
    );
  }

  void _queryAll() async {
    final allRows = await dbhelper.queryAllRows();
    transactions.clear();
    allRows.forEach((row) => transactions.add(Transactions.fromMap(row)));
    _showMessageInScaffold('Query done.');
  }
}*/


