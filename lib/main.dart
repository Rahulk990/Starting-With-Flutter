import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cartOverview.dart';
import 'package:shop_app/screens/productsOverview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Shopping App',
        theme: ThemeData(
          primarySwatch: Colors.red,
          fontFamily: 'Lato',
        ),
        home: ProductsOverview(),
        routes: {
          CartOverview.routeName: (ctx) => CartOverview(),
        },
      ),
    );
  }
}
