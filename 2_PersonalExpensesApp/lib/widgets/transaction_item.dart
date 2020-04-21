
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'package:flutter/cupertino.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.tx,
    @required this.deleteTransaction,
  }) : super(key: key);

  final Transaction tx;
  final Function deleteTransaction;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {

Color _bgColor;


  @override
  void initState() {
    // executed before build
    const availbleColors =[
      Colors.red,
      Colors.black,
      Colors.blue,
      Colors.purple
    ];

    _bgColor = availbleColors[Random().nextInt(availbleColors.length)];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _bgColor,
            radius: 30,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FittedBox(
                  child:  Text(
                    '\$${widget.tx.amount.toStringAsFixed(2)}',
                  ),
              ),
            )
          ),
          title: Text(
                  widget.tx.title,
                  style: Theme.of(context).textTheme.title,
                ),
          subtitle: Text(DateFormat('dd/MM/yyyy').format(widget.tx.date),
                    style: TextStyle(color: Colors.grey)
                    ),
          trailing: MediaQuery.of(context).size.width > 500 
           ? FlatButton.icon(
              icon: const Icon(Icons.delete), 
              textColor: Theme.of(context).errorColor,
              // const will skip construction on widget rebuild
              label: const Text("Delete"), 
              onPressed: () => widget.deleteTransaction(widget.tx.id))
           : IconButton(
            icon: const Icon(Icons.delete), 
            onPressed:  () => widget.deleteTransaction(widget.tx.id),
            color: Theme.of(context).errorColor,
            ),
          
      ),
    );
  }
}
