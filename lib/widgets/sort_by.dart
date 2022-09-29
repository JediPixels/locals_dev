import 'package:flutter/material.dart';
import '../helpers/default_helpers.dart';

class SortBy extends StatelessWidget {
  const SortBy(
      {Key? key,
        required this.selected,
        required this.onChanged})
      : super(key: key);

  static List<String> sortByList = FeedOrder.values.map((e) => e.name.firstLetterCapitalize).toList();
  final String selected;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Sort by:'),
        const SizedBox(width: 4,),
        DropdownButtonHideUnderline(
          child: DropdownButton(
            focusColor: Colors.transparent,
            value: selected.toLowerCase(),
            items: sortByList.map<DropdownMenuItem<String>>((String selected) {
              return DropdownMenuItem<String>(
                value: selected.toLowerCase(),
                child: Text(selected),
              );
            }).toList(),
            onChanged: (value) => onChanged(value),
          ),
        ),
        const SizedBox(width: 8,)
      ],
    );
  }
}
