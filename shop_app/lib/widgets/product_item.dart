import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/util/constants.dart';

import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cartProvider = Provider.of<Cart>(context);
    return ClipRRect(
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)),
        child: GridTile(
            footer: GridTileBar(
              title: Text(
                product.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: "Poppins"),
              ),
              leading: Consumer<Product>(
                  builder: (ctx, product, _) => IconButton(
                        icon: product.isFavourite
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_outline),
                        onPressed: () => product.toggleFavourite(),
                        color: Theme.of(context).colorScheme.secondary,
                      )),
              trailing: IconButton(
                  onPressed: () => cartProvider.addItem(
                        product.id,
                        product.price,
                        product.image,
                        product.description,
                        product.title,
                      ),
                  icon: const Icon(Icons.shopping_cart),
                  color: Theme.of(context).colorScheme.secondary),
              backgroundColor: Colors.black54,
            ),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                  PRODUCT_DETAIL_PAGE_ROUTE_NAME,
                  arguments: product.id),
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
              ),
            )));
  }
}
