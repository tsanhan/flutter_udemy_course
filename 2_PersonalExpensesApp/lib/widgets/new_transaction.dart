import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {

  final Function addNewTransaction;

  /**
   * statefull widget filecycle:
   * ctor
   *  V
   * initState()
   *  V
   * build()
   *  V
   * setState() - only the fuirst time
   *  V
   * didUpdateWidget()
   *  V
   * build()
   *  V
   * dispose() - when destroyed 
   */
  NewTransaction(this.addNewTransaction) {
    print("Constructor NewTransaction Widget");
  }

  @override
  _NewTransactionState createState() {
    print("createState NewTransaction Widget");
    return _NewTransactionState();
    }
}

class _NewTransactionState extends State<NewTransaction> {

 
  final _titleController = TextEditingController();
  final _amoutController = TextEditingController();
  DateTime _selectedDate;

  void _submitData([val]) {
     
    if(_amoutController.text.isEmpty)
      return;
    
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amoutController.text);

    if(enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addNewTransaction(
      enteredTitle, 
      enteredAmount,
      _selectedDate
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker(){
     showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(1985), 
      lastDate: DateTime.now()
      ).then((pickedDate) {
        if(pickedDate == null)
          return;

        setState(() {
          _selectedDate = pickedDate;
        });
      });
  }
  
  _NewTransactionState() {
    print("Constructor NewTransaction State");
  }

  @override
  void initState() { // used to load some data from DB/server
    super.initState();
    print("initState()");
  }
  
  @override
  void didUpdateWidget(NewTransaction oldWidget) {
    // have access to new widget and old one
    //widget.
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget()");
  }

  @override
  void dispose() {
    print("dispose()");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build NewTransaction State");
    return SingleChildScrollView(
          child: Card(
              elevation: 5,
              child: Container(
                padding: EdgeInsets.only(
                  top: 10, 
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10, 
                  left: 10, 
                  right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[         
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title'
                      ),
                      onSubmitted: _submitData,
                    ),
                    TextField(
                      controller: _amoutController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                      ),
                      onSubmitted: _submitData,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          
                          Text(
                            _selectedDate == null ? 
                            "No Date Chozen": 
                            'Picked Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}' 
                            ),
                          AdaptiveFlatButton(_presentDatePicker, "Choose Date")
                        ],
                      ),
                    ),           
                    RaisedButton(
                      child: Text('Add Transaction'),
                      onPressed: _submitData,
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).textTheme.button.color,

                    )
                  ],
                ),
              ),
            ),
    );
  }
}