import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';

import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/editProductOverview.dart';
import 'package:shop_app/widgets/appDrawer.dart';
import 'package:shop_app/widgets/userProductItem.dart';

class UserProductsOverview extends StatelessWidget {
  static const String routeName = '/user/products';

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context).userId;
    final productsData = Provider.of<Products>(context)
        .items
        .where((item) => item.userId == userId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('User Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductOverview.routeName),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.length,
          itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
            value: productsData[index],
            child: UserProductItem(),
          ),
        ),
      ),
    );
  }
}
