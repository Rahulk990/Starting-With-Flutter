import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';

class ProductItem extends StatefulWidget {
  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _showDescription = false;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Product>(context);
    final cartProvider = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () => setState(() => _showDescription = !_showDescription),
          child: _showDescription
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    productProvider.description,
                    textAlign: TextAlign.center,
                  ),
                )
              : Image.network(
                  productProvider.imageUrl,
                  fit: BoxFit.cover,
                ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            productProvider.title,
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            icon: Icon(
              productProvider.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
            onPressed: () => productProvider.toggleFavorite(),
          ),
          trailing: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                cartProvider.addItem(productProvider);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Item added to Cart'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
