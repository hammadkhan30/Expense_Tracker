import 'package:flutter/material.dart';
import './home_page.dart';
import '../models/transaction.dart';
import '../controller/dbhelper.dart';

const menuReset = "Reset Local Data";
List<String> menuOptions = const <String> [
  menuReset
];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  DbHelper dbh = DbHelper();
  List<Transactions> docs;
  int count = 0;
  DateTime cDate;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  void _selectMenu(String value) async {
    switch (value) {
      case menuReset:
        _showResetDialog();
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
                f.then((result) {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future _resetLocalData() async {
    final dbFuture = dbh.initializeDb();
    dbFuture.then((result) {
      final dDocs = dbh.deleteRows(DbHelper.tblDoccs);
      dDocs.then((result) {
        setState(() {
          this.docs.clear();
          this.count = 0;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ],
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.amber,
          tabs: [
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.chat)),
            Tab(icon: Icon(Icons.notifications)),
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
          DocList(),
          Text("Monthly info tab"),
          Text("don't know tab"),
        ],
        controller: _tabController,
      ),
    );
  }
}
