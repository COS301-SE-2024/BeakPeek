import 'package:beakpeek/Controller/DB/life_list_provider.dart';
import 'package:beakpeek/Model/BirdInfo/bird.dart';
import 'package:beakpeek/Model/bird_search_functions.dart' as bsf;
import 'package:beakpeek/Styles/colors.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';
import 'package:beakpeek/Model/help_icon.dart';
import 'package:go_router/go_router.dart';

class FilterableSearchbar extends StatefulWidget {
  const FilterableSearchbar({
    super.key,
    required this.birds,
    required this.sort,
  });

  final List<Bird> birds;
  final int sort;

  @override
  State<FilterableSearchbar> createState() {
    return _FilterableSearchbarState();
  }
}

class _FilterableSearchbarState extends State<FilterableSearchbar> {
  late final LifeListProvider lifeList = LifeListProvider.instance;
  List<Widget> items = [];
  final SearchController controller = SearchController();
  late List<Bird> filteredBirds;

  @override
  void initState() {
    super.initState();
    filteredBirds = widget.birds;
    items = bsf.getWidgetListOfBirds(filteredBirds);
  }

  void searchBarTyping(String data) {
    setState(() {
      filteredBirds =
          data.isEmpty ? widget.birds : bsf.searchForBird(widget.birds, data);
      items = bsf.getWidgetListOfBirds(filteredBirds);
    });
  }

  void sortAlphabetically() {
    setState(() {
      filteredBirds = bsf.sortAlphabetically(filteredBirds);
      items = bsf.getWidgetListOfBirds(filteredBirds);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void sortByReportingRate() {
    setState(() {
      filteredBirds = bsf.sortRepotRateDESC(filteredBirds);
      items = bsf.getWidgetListOfBirds(filteredBirds);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final logoSize = screenWidth * 0.18;
    final searchBarHeight = screenHeight * 0.06;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Image.asset(
                'assets/icons/Logo.png',
                width: logoSize,
                height: logoSize,
              ),
            ),
            Expanded(
              child: Container(
                height: searchBarHeight,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.secondaryColor(context),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                child: SearchAnchor(
                  searchController: controller,
                  viewHintText: 'Search Bird...',
                  viewOnChanged: searchBarTyping,
                  dividerColor: AppColors.secondaryColor(context),
                  viewLeading: IconButton(
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      )),
                  headerTextStyle:
                      TextStyle(color: AppColors.secondaryColor(context)),
                  headerHintStyle:
                      TextStyle(color: AppColors.secondaryColor(context)),
                  builder: (context, controller) {
                    return Row(
                      children: [
                        Icon(Icons.search, color: AppColors.iconColor(context)),
                        SizedBox(width: screenWidth * 0.02),
                        Text('Search for birds...',
                            style: GlobalStyles.contentSecondary(context)),
                      ],
                    );
                  },
                  suggestionsBuilder: (context, controller) {
                    return items;
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.02),
              child: const HelpIcon(
                  content:
                      'Type in the common name, group or genus of a bird and see all the results. You can tap on a result to see all of that birds information.'),
            ),
          ],
        ),
      ],
    );
  }
}
