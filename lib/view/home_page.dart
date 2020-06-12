import 'dart:async';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../controller/dbhelper.dart';
import '../controller/utils.dart';
import './new_transaction.dart';

const menuReset = "Reset Local Data";
List<String> menuOptions = const <String> [
  menuReset
];

class DocList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DocListState();
}

class DocListState extends State<DocList> {
  DbHelper dbh = DbHelper();
  List<Transactions> docs;
  int count = 0;
  DateTime cDate;

  @override
  void initState() {
    super.initState();
  }

  Future getData() async {
    final dbFuture = dbh.initializeDb();
    dbFuture.then(
            (result) {
          final docsFuture = dbh.getDocs();
          docsFuture.then(
                  (result) {
                if (result.length >= 0) {
                  List<Transactions> docList = List<Transactions>();
                  var count = result.length;
                  for (int i = 0; i <= count - 1; i++) {
                    docList.add(Transactions.fromObject(result[i]));
                  }
                  setState(() {
                    if (this.docs.length > 0) {
                      this.docs.clear();
                    }

                    this.docs = docList;
                    this.count = count;
                  });
                }
              });
        });
  }

  void _checkDate() {
    const secs = const Duration(seconds:10);

    new Timer.periodic(secs, (Timer t) {
      DateTime nw = DateTime.now();

      if (cDate.day != nw.day || cDate.month != nw.month || cDate.year != nw.year) {
        getData();
        cDate = DateTime.now();
      }
    });
  }

  void navigateToDetail(Transactions doc) async {
    bool r = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => DocDetail(doc))
    );

    if (r == true) {
      getData();
    }
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Reset"),
          content: new Text("Do you want to delete all local data?"),
          actions: <Widget>[
            FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Future f = _resetLocalData();
                f.then(
                        (result) {
                      Navigator.of(context).pop();
                    }
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future _resetLocalData() async {
    final dbFuture = dbh.initializeDb();
    dbFuture.then(
            (result) {
          final dDocs = dbh.deleteRows(DbHelper.tblDoccs);
          dDocs.then(
                  (result) {
                setState(() {
                  this.docs.clear();
                  this.count = 0;
                });
              }
          );
        }
    );
  }

  void _selectMenu(String value) async {
    switch (value) {
      case menuReset:
        _showResetDialog();
    }
  }

  ListView docListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
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
                    '\$${this.docs[position].amount}',
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
                    this.docs[position].title,
                    style: Theme.of(context).textTheme.title,
                  ),
                  Text(
                      DateUtils.convertToDateFull(
                          this.docs[position].date),
                      style: TextStyle(
                        color: Colors.grey,
                      )),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    this.cDate = DateTime.now();

    if (this.docs == null) {
      this.docs = List<Transactions>();
      getData();
    }

    _checkDate();

    return Scaffold(
      /*resizeToAvoidBottomPadding: false,
      appBar: AppBar(
          title: Text("ExpenseTracker"),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: _selectMenu,
              itemBuilder: (BuildContext context) {
                return menuOptions.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ]
      ),*/
      body: Center(
        child: Scaffold(
          body: Stack(
              children: <Widget>[
                docListItems(),
              ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              navigateToDetail(Transactions.withId(-1,"",0,"", 1, 1,));
            },
            tooltip: "Add new doc",
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}