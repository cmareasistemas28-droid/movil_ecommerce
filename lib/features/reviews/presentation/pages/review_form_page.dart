import 'package:flutter/material.dart';

import '../../../../app/store/shop_scope.dart';
import '../../../../shared/widgets/account_layout.dart';
import '../../../../shared/widgets/shop_layout.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/presentation/widgets/rating_star.dart';

class ReviewFormPage extends StatefulWidget {
  const ReviewFormPage({super.key, required this.product});
  final Product product;
  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  final _form = GlobalKey<FormState>();
  final _comment = TextEditingController();
  int _rating = 0;
  bool _initialized = false;
  bool _saving = false;
  String? _ratingError;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final review = ShopScope.of(context).reviewFor(widget.product.id);
      _rating = review?.rating ?? 0;
      _comment.text = review?.comment ?? '';
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(
      () => _ratingError = _rating == 0 ? 'Selecciona una valoración.' : null,
    );
    if (!_form.currentState!.validate() || _rating == 0) return;
    setState(() => _saving = true);
    final saved = await accountAction(
      context,
      () => ShopScope.of(context).saveReview(
        productId: widget.product.id,
        rating: _rating,
        comment: _comment.text,
      ),
    );
    if (!mounted) return;
    if (saved) {
      Navigator.pop(context);
    } else {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: Scaffold(
      appBar: AppBar(title: const Text('Tu reseña')),
      body: SafeArea(
        child: ShopWidth(
          child: Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  widget.product.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                const Text('¿Qué te pareció este producto?'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 4,
                  children: [
                    for (var index = 1; index <= 5; index++)
                      IconButton(
                        tooltip:
                            '$index ${index == 1 ? 'estrella' : 'estrellas'}',
                        isSelected: _rating == index,
                        onPressed: _saving
                            ? null
                            : () => setState(() {
                                _rating = index;
                                _ratingError = null;
                              }),
                        icon: RatingStar(
                          size: 28,
                          fill: index <= _rating ? 1 : 0,
                        ),
                      ),
                  ],
                ),
                if (_ratingError != null)
                  Text(
                    _ratingError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                const SizedBox(height: 24),
                TextFormField(
                  key: const Key('review-comment'),
                  controller: _comment,
                  enabled: !_saving,
                  maxLength: 1000,
                  minLines: 4,
                  maxLines: 8,
                  decoration: accountInput(context, 'Escribe tu reseña'),
                  validator: (value) => value == null || value.trim().length < 3
                      ? 'Escribe al menos 3 caracteres.'
                      : null,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  key: const Key('save-review'),
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(48, 52),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(_saving ? 'Guardando…' : 'Guardar reseña'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
