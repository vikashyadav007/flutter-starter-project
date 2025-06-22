import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_booklet_entity.dart';

final customerIndentProvider =
    StateNotifierProvider<CustomerIndentsNotifier, List<IndentBookletEntity>>(
  (ref) => CustomerIndentsNotifier(),
);

class CustomerIndentsNotifier extends StateNotifier<List<IndentBookletEntity>> {
  CustomerIndentsNotifier() : super([]);

  void setCustomerBookletIndent(List<IndentBookletEntity> indents) {
    state = indents;
  }

  get customerIndents => state;

  void clearIndents() {
    state = [];
  }
}
