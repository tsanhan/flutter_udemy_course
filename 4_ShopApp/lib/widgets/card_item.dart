import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CardItem extends StatelessWidget {
  final CartItem cardItem;

  CardItem(this.cardItem);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context, listen: false);
    return Dismissible(
      key: ValueKey(cardItem.id),
      background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4)),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context, 
          builder: ((ctx) => AlertDialog(
            title: Text("Are You Sure"),
            content: Text("do you want tot remove the item from the cart?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(ctx).pop(false), 
                child: Text("No")),
              FlatButton(
                onPressed: () => Navigator.of(ctx).pop(true), 
                child: Text("Yes"))
           ],
        )));
      },
      onDismissed: (direction) => cart.removeItem(product: cardItem.product),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text('\$${cardItem.product.price}'),
                  )),
            ),
            title: Text(cardItem.product.title),
            subtitle: Text(
                'Total: \$${(cardItem.product.price * cardItem.quantity).toStringAsFixed(2)}'),
            trailing: Text('${cardItem.quantity} x'),
          ),
        ),
      ),
    );
  }
}
