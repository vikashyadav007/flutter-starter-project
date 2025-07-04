import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/customers/domain/entity/customer_entity.dart';
import 'package:starter_project/features/record_indent/presentation/providers/all_customers_provider.dart';
import 'package:starter_project/features/record_indent/presentation/providers/record_indent_provider.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_customer_provider.dart';
import 'package:starter_project/shared/widgets/generic_auto_complete.dart';
import 'package:starter_project/shared/widgets/text_field_label.dart';

class SearchIndentByCustomer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCustomersState = ref.watch(allCustomersProvider);
    return allCustomersState.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (message) => Center(
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 16,
          ),
        ),
      ),
      loaded: (customers) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextFieldLabel(
            label: "Search Customer",
          ),
          GenericAutocomplete<CustomerEntity>(
            items: customers,
            hintText: 'Search by name',
            displayString: (CustomerEntity item) => item.name ?? '',
            initialValue: '',
            onSelected: (customerEntity) {
              ref
                  .read(selectedCustomerProvider.notifier)
                  .setCustomer(customerEntity);
              ref
                  .read(recordIndentProvider.notifier)
                  .handleCustomerSelect(customerEntity);
            },
          ),
        ],
      ),
    );
  }
}
