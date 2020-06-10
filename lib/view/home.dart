import 'package:flutter/material.dart';
import './home_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("ExpenseTracker"),
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.amber,
          tabs: [
            new Tab(icon: new Icon(Icons.call)),
            new Tab(
              icon: new Icon(Icons.chat),
            ),
            new Tab(
              icon: new Icon(Icons.notifications),
            )
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
          new Text("This is call Tab View"),
          new Text("This is chat Tab View"),
          new Text("This is notification Tab View"),
        ],
        controller: _tabController,
      ),
    );
  }
}
