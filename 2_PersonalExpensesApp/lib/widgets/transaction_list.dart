
import '../models/transaction.dart';
import 'package:flutter/material.dart';

import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
  TransactionList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return  transactions.isEmpty ? 
    LayoutBuilder(builder: (ctx, constraints) {
      return  Column(
                children: <Widget>[
                   Text("No Transactions Added Yet!!",
                    style: Theme.of(context).textTheme.title,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: constraints.maxHeight * .6,
                    child: Image.asset('assets/images/waiting.png',
                          fit: BoxFit.cover,),
                  )
                ],
              );
      })
       : 
       ListView(
        children: transactions.map((tx) => TransactionItem(
            key: ValueKey(tx.id), // not UniqueKey() whitch recreated on each build 
            tx: tx, 
            deleteTransaction: deleteTransaction
            )
          ).toList()
        
      );
      // ListView.builder HAS A BUG and not working well with keys
      // ListView.builder(
      //   itemCount: transactions.length,
      //   itemBuilder: (ctx, index) {
      //     final Transaction tx = transactions[index];
      //     return TransactionItem(
      //       key: ValueKey(tx.id),
      //       tx: tx, 
      //       deleteTransaction: deleteTransaction
      //       );
      //   },
      // );
    
  }
}

/**
 * 
ListView(
        children: transactions.map((tx) => TransactionItem(
            key:ValueKey(tx.id),
            tx: tx, 
            deleteTransaction: deleteTransaction
            )
          ).toList()
        
      );
 */