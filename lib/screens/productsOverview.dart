import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cartOverview.dart';
import 'package:shop_app/widgets/productItem.dart';
import 'package:shop_app/widgets/badge.dart';

enum FilterOptions { Favorites, All }

class ProductsOverview extends StatefulWidget {
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  bool _showFavorites = false;

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final productsData =
        _showFavorites ? productsProvider.favorites : productsProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shopping App",
        ),
        actions: [
          Consumer<Cart>(
            builder: (_, cartProvider, ch) => Badge(
              child: ch!,
              color: Colors.yellow,
              value: cartProvider.length.toString(),
            ),
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartOverview.routeName),
              icon: const Icon(
                Icons.shopping_cart,
              ),
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions option) {
              setState(() {
                if (option == FilterOptions.Favorites)
                  _showFavorites = true;
                else
                  _showFavorites = false;
              });
            },
            icon: Icon(
              Icons.filter_alt,
            ),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('Favorites Only'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: productsData.length,
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: productsData[index],
          child: ProductItem(),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
