import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/editProductOverview.dart';

class UserProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Product>(context);

    return Card(
      child: ListTile(
        title: Text(productData.title),
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(productData.imageUrl),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  EditProductOverview.routeName,
                  arguments: productData.id,
                ),
                icon: Icon(Icons.edit),
                color: Colors.black,
              ),
              IconButton(
                onPressed: () {
                  // Provider.of<Products>(context, listen: false)
                  //     .removeProduct(productData.id)
                  //     .catchError((_) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Not Allowed!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  // });
                },
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
