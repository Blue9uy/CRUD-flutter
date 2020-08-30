import 'package:Sqllite_CRUD/models/contact.dart';
import 'package:Sqllite_CRUD/utils/database_helper.dart';
import 'package:flutter/material.dart';

const darkBlueColor = Colors.blueGrey;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite CRUD',
      theme: ThemeData(
        primarySwatch: darkBlueColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'SQLite CRUD'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Contact _contact = Contact();
  List<Contact> _contacts = [];
  DatabaseHelper _dbHelper;
  final _formKey = GlobalKey<FormState>();
  final _ctrlName = TextEditingController();
  final _ctrlMobile = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshContactList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            widget.title,
            style: TextStyle(color: darkBlueColor),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[_form(), _list()],
        ),
      ),
    );
  }

  _form() => Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _ctrlName,
              decoration: InputDecoration(labelText: 'Name'),
              onSaved: (val) => setState(() => _contact.name = val),
              validator: (val) =>
                  (val.length == 0 ? 'This field is required' : null),
            ),
            TextFormField(
              controller: _ctrlMobile,
              decoration: InputDecoration(labelText: 'Telephone'),
              onSaved: (val) => setState(() => _contact.mobile = val),
              validator: (val) =>
                  (val.length < 11 ? 'Mobile Number is not valid' : null),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: RaisedButton(
                onPressed: () => _onSubmit(),
                child: Text('Submit'),
                color: darkBlueColor,
                textColor: Colors.white,
              ),
            )
          ],
        ),
      ));

  _refreshContactList() async {
    List<Contact> x = await _dbHelper.fetchContacts();
    setState(() {
      _contacts = x;
    });
  }

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_contact.id == null)
        await _dbHelper.insertContact(_contact);
      else
        await _dbHelper.updateContact(_contact);
      _refreshContactList();
      _resetForm();
      print(_contact.name);
      print(_contact.mobile);
    }
  }

  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _ctrlName.clear();
      _ctrlMobile.clear();
      _contact.id = null;
    });
  }

  _list() => Expanded(
          child: Card(
        margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: ListView.builder(
          padding: EdgeInsets.all(8),
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.account_circle,
                      color: darkBlueColor, size: 40.0),
                  title: Text(
                    _contacts[index].name.toUpperCase(),
                    style: TextStyle(
                        color: darkBlueColor, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_contacts[index].mobile),
                  trailing: IconButton(
                      icon: Icon(Icons.delete_sweep, color: darkBlueColor),
                      onPressed: () async {
                        await _dbHelper.deleteContact(_contacts[index].id);
                        _resetForm();
                        _refreshContactList();
                      }),
                  onTap: () {
                    setState(() {
                      _contact = _contacts[index];
                      _ctrlName.text = _contacts[index].name;
                      _ctrlMobile.text = _contacts[index].mobile;
                    });
                  },
                ),
                Divider(
                  height: 4.0,
                )
              ],
            );
          },
          itemCount: _contacts.length,
        ),
      ));
}
