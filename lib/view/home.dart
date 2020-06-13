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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("ExpenseTracker"),
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
            new Tab(icon: new Icon(Icons.home)),
            new Tab(icon: new Icon(Icons.chat)),
            new Tab(icon: new Icon(Icons.notifications)),
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
          new DocList(),
          new Text("This is chat Tab View"),
          new Text("This is notification Tab View"),
        ],
        controller: _tabController,
      ),
    );
  }
}
