import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/customers/domain/entity/customer_entity.dart';
import 'package:starter_project/features/record_indent/presentation/pages/search_by_customer_body.dart';
import 'package:starter_project/features/record_indent/presentation/pages/search_by_indent_body.dart';
import 'package:starter_project/features/record_indent/presentation/providers/providers.dart';
import 'package:starter_project/shared/widgets/generic_auto_complete.dart';
import 'package:starter_project/shared/widgets/text_field_label.dart';

class SearchIndentByCustomer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCustomersState = ref.watch(allCustomersProvider);
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
            initialValue: '',
            onSelected: (customerEntity) {
              ref.read(selectedCustomerProvider.notifier).state =
                  customerEntity;
              // ref
              //     .read(recordIndentProvider.notifier)
              //     .handleCustomerSelect(customerEntity);
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
