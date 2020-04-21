import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() {
  runApp(MyApp());

  //force portrait, disable landscape
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Personal Expenses',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.amber,
            fontFamily: 'Quicksand',
            textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                button: TextStyle(color: Colors.white)),
            appBarTheme: AppBarTheme(
                textTheme: ThemeData.light().textTheme.copyWith(
                    title: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold)))),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// with... => a mixin = adding some functionality (features/classes) to the class
class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {


  @override // added by the mixin
  void didChangeAppLifecycleState(AppLifecycleState state) {
  
    super.didChangeAppLifecycleState(state);
    // inactive: (important) app inactive: no user input - ios only
    // paused: (important) app not visible - running in bg
    // resumed: (important) arr returned from paused and is visible again
    // suspended: app about to be exited
    print(state);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

  }
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   amount: 69.99,
    //   date: DateTime.now(),
    //   id: 't1',
    //   title: 'New Shows'),
    // Transaction(
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   id: 't2',
    //   title: 'Weekly Groceries')
  ];

  void _addNewTransaction(String title, double amount, DateTime selectedDate) {
    final newTx = new Transaction(
        amount: amount,
        title: title,
        date: selectedDate,
        id: DateTime.now().toString());

    setState(() {
      this._userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((x) => x.id == id);
    });
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((x) {
      return x.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _startAddNewTransaction() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (bCtx) {
          return NewTransaction(_addNewTransaction);
        });
  }

  bool _showChart = false;


 List<Widget> _buildLandscapeContnent(
   MediaQueryData mediaQuery, 
    AppBar appBar,
    Widget txListWidget) {
    return
    [ Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text("show chart",
              style: Theme.of(context).textTheme.title,),
              Switch(
                  value: _showChart,
                  onChanged: (val) {
                    setState(() {
                      _showChart = val;
                    });
                  })
            ]
            ),
            _showChart
                ? Container(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.7,
                    child: Chart(_recentTransactions))
                : txListWidget
      ];
  }


  List<Widget> _buildPortraitContnent(
    MediaQueryData mediaQuery, 
    AppBar appBar,
    Widget txListWidget) {
        return [

              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTransactions)),
                txListWidget
        ];
          
  }

  Widget  _buildAppbar(){
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Personal Expenses'),
            trailing:  Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: _startAddNewTransaction,
                )
              ],
            ),
          )
        : AppBar(
            title: const Text('Personal Expenses'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _startAddNewTransaction,
              )
            ],
          );
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = _buildAppbar();

    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            .7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    final pagBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandscape) ..._buildLandscapeContnent(mediaQuery,appBar,txListWidget)
          else ..._buildPortraitContnent(mediaQuery,appBar,txListWidget ) ,
          
        ],
      ),
    ));
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pagBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pagBody,
            // chek if ios
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: _startAddNewTransaction,
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}


