import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final int quantity;
  final double price;
  final String title;

  CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure ?'),
            content: Text('Do you want to remove $title from the cart ?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        cart.removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Text('Rs $price'),
                      ),
                    ),
                  ),
                  title: Text(title),
                  subtitle: Text('Total: Rs ${price * quantity}'),
                ),
              ),
            ),
            IconButton(
              icon: quantity > 1
                  ? Icon(Icons.remove)
                  : Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
              onPressed: () {
                if (quantity == 1) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Are you sure ?'),
                      content:
                          Text('Do you want to remove $title from the cart ?'),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                          child: Text('No'),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                            cart.removeSingleItem(productId);
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    ),
                  );
                } else
                  cart.removeSingleItem(productId);
              },
            ),
            FittedBox(
              child: Text('$quantity'),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => cart.addItem(productId, price, title),
            )
          ],
        ),
      ),
    );
  }
}
