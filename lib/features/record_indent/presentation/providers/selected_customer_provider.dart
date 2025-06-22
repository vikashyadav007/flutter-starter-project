import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/customers/domain/entity/customer_entity.dart';

final selectedCustomerProvider =
    StateNotifierProvider<SelectedCustomerNotifier, CustomerEntity?>(
  (ref) => SelectedCustomerNotifier(),
);

class SelectedCustomerNotifier extends StateNotifier<CustomerEntity?> {
  SelectedCustomerNotifier() : super(null);

  void setCustomer(CustomerEntity customer) {
    state = customer;
  }

  get customer => state;

  void clearCustomer() {
    state = null;
  }
}
