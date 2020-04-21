import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders_provider.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderItem;

  OrderItem(this.orderItem);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
                '\$${widget.orderItem.products.fold(0, (c, i) => c += i.quantity * i.product.price)}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                .format(widget.orderItem.dateTime)),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          //if(_expanded)
          
          AnimatedContainer(
              
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              height: _expanded ? min((widget.orderItem.products.length * 20.0) + 20, 100.0) : 0,
              child: ListView.builder(
                  itemCount: widget.orderItem.products.length,
                  itemBuilder: (ctx, i) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            widget.orderItem.products[i].product.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.orderItem.products[i].quantity} x\$${widget.orderItem.products[i].product.price}',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          )
                        ],
                      )),
            ),
          
        ],
      ),
    );
  }
}
