import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_booklet_entity.dart';

final selectedIndentBookletProvider =
    StateNotifierProvider<SelectedIndentBookletNotifier, IndentBookletEntity?>(
  (ref) => SelectedIndentBookletNotifier(),
);

class SelectedIndentBookletNotifier
    extends StateNotifier<IndentBookletEntity?> {
  SelectedIndentBookletNotifier() : super(null);

  void setIndentBooklet(IndentBookletEntity indentBooklet) {
    state = indentBooklet;
  }

  get indentBooklet => state;

  void clearIndentBooklet() {
    state = null;
  }
}
