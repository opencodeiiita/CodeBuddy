import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:codebuddy/search_bar.dart';
import 'package:codebuddy/search_result_item.dart';
import 'package:codebuddy/search_provider.dart';


class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Problems'),
      ),
      body: Column(
        children: [
          CustomSearchBar(
            onSearch: (query) => searchProvider.fetchResults(query),
          ),
          Expanded(
            child: searchProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : searchProvider.errorMessage.isNotEmpty
                ? Center(child: Text(searchProvider.errorMessage))
                : ListView.builder(
              itemCount: searchProvider.results.length,
              itemBuilder: (context, index) {
                final result = searchProvider.results[index];
                return SearchResultItem(result: result);
              },
            ),
          ),
        ],
      ),
    );
  }
}
