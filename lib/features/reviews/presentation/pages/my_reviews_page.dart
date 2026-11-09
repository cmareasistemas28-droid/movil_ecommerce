import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../shared/widgets/account_layout.dart';
import '../../../../shared/widgets/shop_layout.dart';
import '../../../products/presentation/widgets/rating_star.dart';
import 'review_form_page.dart';

class MyReviewsPage extends StatelessWidget {
  const MyReviewsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    return AccountPage(
      title: 'Mis reseñas',
      children: [
        if (shop.reviews.isEmpty)
          const EmptyState(
            icon: Icons.rate_review_outlined,
            title: 'Todavía no escribiste reseñas',
            message:
                'Abre un producto y comparte tu experiencia para verla aquí.',
          ),
        for (final review in shop.reviews)
          AccountCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  review.productName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
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
                Text(review.comment),
                const SizedBox(height: 8),
                Text(
                  accountDate(context, review.createdAt),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  children: [
                    if (shop.products.any(
                      (product) => product.id == review.productId,
                    )) ...[
                      TextButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/product',
                          arguments: shop.products.firstWhere(
                            (product) => product.id == review.productId,
                          ),
                        ),
                        child: const Text('Ver producto'),
                      ),
                      IconButton(
                        tooltip: 'Editar reseña de ${review.productName}',
                        onPressed: () => openShopPage<void>(
                          context,
                          ReviewFormPage(
                            product: shop.products.firstWhere(
                              (product) => product.id == review.productId,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    ],
                    IconButton(
                      tooltip: 'Eliminar reseña de ${review.productName}',
                      onPressed: () => accountAction(
                        context,
                        () => shop.deleteReview(review.productId),
                      ),
                      icon: const Icon(Icons.delete_outline_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
