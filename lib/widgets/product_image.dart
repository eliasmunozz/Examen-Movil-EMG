import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/my_theme.dart';

class ProductImage extends StatelessWidget {
  final String? url;
  const ProductImage({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Container(
        decoration: _createDecoration(context),
        width: double.infinity,
        height: 400,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          child: url == null
              ? const Image(
                  image: AssetImage('assets/no-image.png'),
                  fit: BoxFit.cover,
                )
              : FadeInImage(
                  placeholder: const AssetImage('assets/jar-loading.gif'),
                  image: NetworkImage(url!),
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  BoxDecoration _createDecoration(BuildContext context) {
    return BoxDecoration(
      color: MyTheme.primary.withOpacity(0.1), 
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(45), topRight: Radius.circular(45)),
      boxShadow: [
        BoxShadow(
          color: MyTheme.primary.withOpacity(0.5), 
          offset: const Offset(0, 5),
          blurRadius: 10,
        )
      ],
    );
  }
}