import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';
import '../widgets/search_bar.dart';
import '../widgets/search_result_item.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Problems'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SearchBar(
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
