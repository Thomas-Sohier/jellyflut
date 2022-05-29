import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchNoResultsPlaceholder extends StatelessWidget {
  const SearchNoResultsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Icon(Icons.movie, size: 42, color: Colors.white),
            Text(
              'search_no_results'.tr(),
              style: TextStyle(fontSize: 18, color: Colors.white70),
            )
          ])),
    );
  }
}
