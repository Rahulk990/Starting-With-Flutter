import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';

import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/authOverview.dart';
import 'package:shop_app/screens/cartOverview.dart';
import 'package:shop_app/screens/editProductOverview.dart';
import 'package:shop_app/screens/productsOverview.dart';
import 'package:shop_app/screens/userProductsOverview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(null, null, []),
          update: (ctx, authData, prevProducts) => Products(
            authData.token,
            authData.userId,
            prevProducts == null ? [] : prevProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Shopping App',
          theme: ThemeData(
            primarySwatch: Colors.red,
            fontFamily: 'Lato',
          ),
          home: authData.isAuthenticated
              ? ProductsOverview()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, authResult) =>
                      authResult.connectionState == ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : AuthOverview(),
                ),
          routes: {
            CartOverview.routeName: (ctx) => CartOverview(),
            UserProductsOverview.routeName: (ctx) => UserProductsOverview(),
            EditProductOverview.routeName: (ctx) => EditProductOverview(),
          },
        ),
      ),
    );
  }
}
