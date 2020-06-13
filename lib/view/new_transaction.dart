import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../models/transaction.dart';
import '../controller/utils.dart';
import '../controller/dbhelper.dart';

const menuDelete = "Delete";
final List<String> menuOptions = const <String>[menuDelete];

class DocDetail extends StatefulWidget {
  Transactions doc;
  final DbHelper dbh = DbHelper();

  DocDetail(this.doc);

  @override
  State<StatefulWidget> createState() => DocDetailState();
}

class DocDetailState extends State<DocDetail> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final int daysAhead = 5475; // 15 years in the future

  final titleCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final dateCtrl =
      MaskedTextController(mask: '2000-00-00');

  void _initCtrls() {
    titleCtrl.text = widget.doc.title != null ? widget.doc.title : "";
    //int.parse(amountCtrl.text) = widget.doc.amount != null ? widget.doc.amount : "";
    dateCtrl.text = widget.doc.date != null ? widget.doc.date : "";
  }

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = DateUtils.convertToDate(initialDateString) ?? now;

    initialDate = (initialDate.year >= now.year && initialDate.isAfter(now)
        ? initialDate
        : now);

    DatePicker.showDatePicker(context, showTitleActions: true,
        onConfirm: (date) {
      setState(() {
        DateTime dt = date;
        String r = DateUtils.ftDateAsStr(dt);
        dateCtrl.text = r;
      });
    }, currentTime: initialDate);
  }

  void _selectMenu(String value) async {
    switch (value) {
      case menuDelete:
        if (widget.doc.id == -1) {
          return;
        }
        await _deleteDoc(widget.doc.id);
    }
  }

  void _deleteDoc(int id) async {
    int r = await widget.dbh.deleteDoc(widget.doc.id);
    Navigator.pop(context, true);
  }

  void _saveDoc() {
    widget.doc.title = titleCtrl.text;
    widget.doc.amount = int.parse(amountCtrl.text);
    widget.doc.date = dateCtrl.text;

    if (widget.doc.id > -1) {
      debugPrint("_update->Doc Id: " + widget.doc.id.toString());
      widget.dbh.updateDoc(widget.doc);
      Navigator.pop(context, true);
    } else {
      Future<int> idd = widget.dbh.getMaxId();
      idd.then((result) {
        debugPrint("_insert->Doc Id: " + widget.doc.id.toString());
        widget.doc.id = (result != null) ? result + 1 : 1;
        widget.dbh.insertDoc(widget.doc);
        Navigator.pop(context, true);
      });
    }
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Some data is invalid. Please correct.');
    } else {
      _saveDoc();
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  @override
  void initState() {
    super.initState();
    _initCtrls();
  }

  @override
  Widget build(BuildContext context) {
    const String cStrDays = "Enter a number of days";
    TextStyle tStyle = Theme.of(context).textTheme.title;
    String ttl = widget.doc.title;

    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("New Transaction"),
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
        ),
        body: Form(
            key: _formKey,
            autovalidate: true,
            child: SafeArea(
              top: false,
              bottom: false,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  TextFormField(
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9 ]"))
                    ],
                    controller: titleCtrl,
                    style: tStyle,
                    validator: (val) => Val.ValidateTitle(val),
                    decoration: InputDecoration(
                      icon: const Icon(Icons.title),
                      hintText: 'Enter the expense',
                      labelText: 'Expense Name',
                    ),
                  ),
                  TextFormField(
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9 ]"))
                    ],
                    controller: amountCtrl,
                    style: tStyle,
                    //validator: (val) => Val.ValidateTitle(val),
                    decoration: InputDecoration(
                      icon: const Icon(Icons.title),
                      hintText: 'Enter the amount',
                      labelText: 'amount',
                    ),
                  ),
                  Row(children: <Widget>[
                    Expanded(
                        child: TextFormField(
                      controller: dateCtrl,
                      maxLength: 10,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.calendar_today),
                          hintText: 'Enter the date',
                          labelText: 'Enter the  Date'),
                      keyboardType: TextInputType.number,
                      validator: (val) => DateUtils.isValidDate(val)
                          ? null
                          : 'Not a valid future date',
                    )),
                    IconButton(
                      icon: new Icon(Icons.more_horiz),
                      tooltip: 'Choose date',
                      onPressed: (() {
                        _chooseDate(context, dateCtrl.text);
                      }),
                    )
                  ]),
                  Container(
                      padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                      child: RaisedButton(
                        child: Text("Save"),
                        onPressed: _submitForm,
                      )),
                ],
              ),
            )));
  }
}
