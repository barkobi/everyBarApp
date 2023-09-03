import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iBar/models/business_model.dart';
import 'package:iBar/widgets/business_list_generator.dart';
import 'package:iBar/widgets/search_bar.dart';
import 'package:iBar/data/data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.passStr});
  final String passStr;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isEnter = false;
  List<Widget> stepsWidgets = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNodeOfSearchBar = FocusNode();
  final FocusNode _focusNodeOfSilverAppBar = FocusNode();
  BusinessList searchResult = const BusinessList(isList: true, bList: []);

  List<Business> searchByKeywords(String lowercaseSearchQuery) {
    List<Business> newList = [];
    for (var i in businessList) {
      final String lowercaseText = i.name.toLowerCase();
      if (lowercaseText.contains(lowercaseSearchQuery) ||
          lowercaseSearchQuery.startsWith(lowercaseText)) {
        newList.add(i);
      }
      for (var key in i.menu.keys) {
        String newKey = key.toLowerCase();
        if (newKey.contains(lowercaseSearchQuery)) newList.add(i);
      }
    }
    return newList;
  }

  void searchRes(String string) {
    final String lowercaseSearchQuery = string.toLowerCase();

    setState(() {
      if (isEnter) {
        searchResult = BusinessList(
            bList: searchByKeywords(lowercaseSearchQuery), isList: false);
      } else {
        for (int i = 0; i < stepsWidgets.length; i++) {
          Widget stepWidget = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white)),
                  child: Text(
                    '${i + 1}.b',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
              ),
              const SizedBox(height: 33),
            ],
          );
          stepsWidgets.add(stepWidget);
        }
      }
    });
  }

  void handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter) {
      isEnter = true;
      String keywords = _searchController.text;
      if (keywords.isNotEmpty) searchRes(keywords);
    }
    if (event is RawKeyDownEvent) {
      final keyLabel = event.logicalKey.keyLabel;
      if (keyLabel.isNotEmpty &&
          keyLabel.codeUnitAt(0) >= 65 &&
          keyLabel.codeUnitAt(0) <= 90) {
        String keywords = _searchController.text;
        if (keywords.isNotEmpty) searchRes(keywords);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return RawKeyboardListener(
      focusNode: _focusNodeOfSilverAppBar,
      onKey: handleKeyEvent,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                "assests/background.jpg",
                fit: BoxFit.fill,
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                title: MySearchBar(
                  focusNode: _focusNodeOfSearchBar,
                  onSearch: searchRes,
                  searchController: _searchController,
                ),
                expandedHeight: deviceHeight * 0.2,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return !isEnter
                        ? BusinessList(isList: false, bList: searchResult.bList)
                        : Column();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}