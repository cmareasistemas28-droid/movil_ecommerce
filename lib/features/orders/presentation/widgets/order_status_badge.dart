import 'package:flutter/material.dart';

import '../../domain/entities/customer_order.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});
  final OrderStatus status;
  @override
  Widget build(BuildContext context) => Text(
    status.label,
    style: TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
  );
}
