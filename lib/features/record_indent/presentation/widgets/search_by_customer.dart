import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/customers/domain/entity/customer_entity.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/shared/widgets/generic_auto_complete.dart';
import 'package:fuel_pro_360/shared/widgets/text_field_label.dart';

class SearchIndentByCustomer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCustomersState = ref.watch(allCustomersProvider);
    final selectedCustomer = ref.watch(selectedCustomerProvider);
    return allCustomersState.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      data: (customers) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextFieldLabel(
            label: "Search Customer",
          ),
          GenericAutocomplete<CustomerEntity>(
            items: customers,
            hintText: 'Search by name',
            displayString: (CustomerEntity item) => item.name ?? '',
            initialValue: selectedCustomer?.name ?? '',
            onSelected: (customerEntity) {
              ref.read(selectedCustomerProvider.notifier).state =
                  customerEntity;
            },
          ),
        ],
      ),
      error: (error, stackTrace) => const Center(
        child: Text('Error'),
      ),
    );
  }
}
