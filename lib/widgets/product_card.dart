import 'package:flutter_application_1/models/productos.dart';
import 'package:flutter_application_1/services/product_service.dart';
import 'package:flutter_application_1/theme/theme.dart';
import 'package:flutter_application_1/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Listado product;
  final Widget? trailing;

  const ProductCard({super.key, required this.product, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        width: double.infinity,
        decoration: _cardDecorations(context),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: _BackGroundImage(url: product.productImage),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProductDetails(product: product),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _PriceTag(product: product),
                              if (trailing != null) trailing!,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
           
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      'view_product',
                      arguments: product,
                    );
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('Ver'),
                ),
                const SizedBox(width: 10),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      'edit_product',
                      arguments: product,
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Botón de borrar producto
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final productService = Provider.of<ProductService>(context, listen: false);

                    try {
                      await productService.deleteProduct(product, context);
                      CustomNotification.show(
                        context,
                        message: 'Producto eliminado correctamente',
                        backgroundColor: Colors.green,
                        icon: Icons.error,
                        duration: const Duration(seconds: 2),
                      );
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'list_product');
                    } catch (e) {
                      CustomNotification.show(
                        context,
                        message: 'Error al eliminar el producto: $e',
                        backgroundColor: Colors.redAccent,
                        icon: Icons.error,
                        duration: const Duration(seconds: 2),
                      );
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Borrar Producto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecorations(BuildContext context) => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: MyTheme.primary.withOpacity(0.2),
            offset: const Offset(0, 5),
            blurRadius: 8,
          )
        ],
      );
}

class _ProductDetails extends StatelessWidget {
  final Listado product;

  const _ProductDetails({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        product.productName,
        style: TextStyle(
          fontSize: 20,
          color: MyTheme.primary,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _BackGroundImage extends StatelessWidget {
  final String? url;

  const _BackGroundImage({this.url});

  @override
  Widget build(BuildContext context) {
    final isValidUrl = url != null &&
        url!.trim().isNotEmpty &&
        (url!.startsWith('http://') || url!.startsWith('https://'));

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: isValidUrl
            ? FadeInImage(
                placeholder: const AssetImage('assets/jar-loading.gif'),
                image: NetworkImage(url!),
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return const Image(
                    image: AssetImage('assets/no-image.png'),
                    fit: BoxFit.cover,
                  );
                },
              )
            : const Image(
                image: AssetImage('assets/no-image.png'),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}


class _PriceTag extends StatelessWidget {
  final Listado product;

  const _PriceTag({required this.product});

  @override
  Widget build(BuildContext context) {
    return Text(
      '\$${product.productPrice}',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: MyTheme.primary,
      ),
    );
  }
}