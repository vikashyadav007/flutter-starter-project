// Project imports:

import 'package:fuel_pro_360/shared/models/filter/filter.dart';

String constructFilterString(List<Filter> filters) {
  final List<String> fields = [];
  final List<String> conditions = [];
  final List<String> values = [];

  for (int filterIndex = 0; filterIndex < filters.length; filterIndex++) {
    fields.add(filters[filterIndex].field);
    conditions.add(filters[filterIndex].condition);
    values.add(filters[filterIndex].value);
  }

  return '${fields.join(',')}/${conditions.join(',')}/${values.join(',')}';
}
