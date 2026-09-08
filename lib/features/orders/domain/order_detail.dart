import '../../../data/local/app_database.dart';

/// A [CustomerOrder] joined with its product name, for display without the
/// UI having to look the product up separately.
class OrderDetail {
  const OrderDetail({required this.order, required this.productName});

  final CustomerOrder order;
  final String productName;
}
