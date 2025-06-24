import 'dart:async';

import 'package:flutter/material.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';

class GenericAutocomplete<T extends Object> extends StatelessWidget {
  final List<T> items;
  final String Function(T) displayString;
  final void Function(T)? onSelected;
  final void Function()? onClear;
  final String hintText;
  final String initialValue;

  GenericAutocomplete(
      {required this.items,
      required this.displayString,
      this.onSelected,
      this.onClear,
      this.hintText = 'Enter text',
      required this.initialValue});

  Future<Iterable<T>> Function(TextEditingValue) debounce(
    Future<Iterable<T>> Function(TextEditingValue) func,
    int milliseconds,
  ) {
    Timer? timer;
    Completer<Iterable<T>>? completer;
    return (TextEditingValue param) {
      if (timer != null) {
        timer!.cancel();
      }
      completer = Completer<Iterable<T>>();
      timer = Timer(Duration(milliseconds: milliseconds), () async {
        try {
          final result = await func(param);
          if (!completer!.isCompleted) {
            completer!.complete(result);
          }
        } catch (error, stackTrace) {
          if (!completer!.isCompleted) {
            completer!.completeError(error);
          }
        }
      });
      return completer!.future;
    };
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      initialValue: TextEditingValue(
        text: initialValue,
      ),
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: Container(
              height: 200.0,
              color: Colors.white,
              width: 330,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final T item = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onSelected(item);
                      FocusScope.of(context).unfocus();
                    },
                    child: ListTile(
                      title: Text(displayString(item)),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      optionsBuilder: debounce((TextEditingValue textEditingValue) async {
        final query = textEditingValue.text.toLowerCase();
        if (query.isEmpty) {
          return items;
        }
        return items
            .where((item) => displayString(item).toLowerCase().contains(query));
      }, 300),
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          onSubmitted: (String value) => onFieldSubmitted(),
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: UiColors.gray,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: UiColors.gray,
                width: 1,
              ),
            ),
          ),
        );
      },
      onSelected: (T item) {
        if (onSelected != null) {
          onSelected!(item);
        }
        print("Selected item: ${displayString(item)}");
      },
      displayStringForOption: displayString,
    );
  }
}
