import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';

class NoIndentCheckbox extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noIndentCheckbox = ref.watch(noIndentCheckboxProvider);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    visualDensity: VisualDensity.compact,
                    value: noIndentCheckbox,
                    onChanged: (bool? value) {
                      ref.read(noIndentCheckboxProvider.notifier).state =
                          value ?? false;
                    },
                  ),
                  Container(
                    child: Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: const [
                            TextSpan(
                              text: 'No Indent ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '(Credit Transaction)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'This will be recorded as a credit transaction and will increase the customer\'s balance.',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
