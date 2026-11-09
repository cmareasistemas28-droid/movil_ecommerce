import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../shared/widgets/account_layout.dart';
import '../../../reviews/presentation/pages/review_form_page.dart';
import '../../domain/entities/product.dart';
import 'rating_star.dart';

class ProductReviews extends StatelessWidget {
  const ProductReviews({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) {
    final review = ShopScope.of(context).reviewFor(product.id);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Reseñas', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        const Text('Comparte tu experiencia con este producto.'),
        const SizedBox(height: 16),
        if (review != null)
          AccountCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Tu reseña', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Semantics(
                  label: '${review.rating} de 5 estrellas',
                  child: ExcludeSemantics(
                    child: Row(
                      children: [
                        for (var index = 0; index < 5; index++)
                          RatingStar(fill: index < review.rating ? 1 : 0),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(review.comment, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 8),
                Text(
                  accountDate(context, review.createdAt),
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text('Aún no has escrito una reseña de este producto.'),
          ),
        OutlinedButton.icon(
          onPressed: () =>
              openShopPage<void>(context, ReviewFormPage(product: product)),
          icon: const Icon(Icons.rate_review_outlined),
          label: Text(review == null ? 'Escribir reseña' : 'Editar mi reseña'),
        ),
      ],
    );
  }
}
