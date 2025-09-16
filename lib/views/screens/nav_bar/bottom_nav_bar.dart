import 'package:flutter/material.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_images.dart';
import 'package:heavek/views/screens/account/account_screen.dart';
import 'package:heavek/views/screens/analytics/analytics_screen.dart';
import 'package:heavek/views/screens/home/home_screen.dart';
import 'package:heavek/views/screens/records/records_screen.dart';
import 'package:heavek/views/screens/workout/workout_screen.dart';
import 'package:heavek/views/widgets/my_text.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedTab = 0;
  List<Widget> items = [];

  @override
  void initState() {
    super.initState();
    items = [
      HomeScreen(),
      WorkoutScreen(),
      RecordsScreen(),
      AnalyticsScreen(),
      AccountScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items[selectedTab],
      bottomNavigationBar: NavBar(
        pageIndex: selectedTab,
        onTap: (index) {
          setState(() {
            selectedTab = index;
          });
        },
      ),
    );
  }
}

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  NavBar({super.key, required this.pageIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 100,
      color: Colors.transparent,
      padding: EdgeInsets.only(bottom: 8, left: 10, right: 10, top: 16),
      elevation: 0.0,
      child: Container(
        decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        // height: 64,
        child: Row(
          children: [
            navItem(0, pageIndex == 0, 'Home', onTap: () => onTap(0)),
            navItem(1, pageIndex == 1, 'Workout', onTap: () => onTap(1)),
            navItem(2, pageIndex == 2, 'Records', onTap: () => onTap(2)),
            navItem(3, pageIndex == 3, 'Analytics', onTap: () => onTap(3)),
            navItem(4, pageIndex == 4, 'Account', onTap: () => onTap(4)),
          ],
        ),
      ),
    );
  }

  final List<List<String>> _iconPaths = [
    [Assets.imagesSelectedHomeIcon, Assets.imagesSelectedHomeIcon],
    [Assets.imagesUnselectedWorkoutIcon, Assets.imagesUnselectedWorkoutIcon],
    [Assets.imagesUnselectedRecordsIcon, Assets.imagesUnselectedRecordsIcon],
    [
      Assets.imagesUnselectedAnalyticsIcon,
      Assets.imagesUnselectedAnalyticsIcon,
    ],
    [Assets.imagesUnselectedAccountIcon, Assets.imagesUnselectedAccountIcon],
  ];

  Widget navItem(int index, bool selected, String title, {Function()? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selected
                ? Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      color: kSelectedColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          _iconPaths[index][selected ? 1 : 0],
                          height: 20,
                          width: 20,
                          color: kWhiteColor,
                        ),
                        MyText(
                          text: title,
                          weight: FontWeight.w500,
                          size: 10,
                          color: kWhiteColor,
                          paddingTop: 4,
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Image.asset(
                        _iconPaths[index][selected ? 1 : 0],
                        height: 20,
                        width: 20,
                      ),
                      MyText(
                        text: title,
                        weight: FontWeight.w500,
                        size: 10,
                        color: kWhiteColor.withOpacity(0.8),
                        paddingTop: 4,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
