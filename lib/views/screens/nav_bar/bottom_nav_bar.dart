import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_fonts.dart';
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
    items = [HomeScreen(), WorkoutScreen(), RecordsScreen(), AnalyticsScreen(), AccountScreen()];
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
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: Offset(0, -3), spreadRadius: 0),
        ],
      ),
      child: BottomAppBar(
        height: 70,
        color: kPrimaryColor,
        padding: EdgeInsets.all(10),
        elevation: 0.0,
        child: Row(
          children: [
            navItem(0, pageIndex == 0, 'Pulse', onTap: () => onTap(0)),
            navItem(1, pageIndex == 1, 'Build', onTap: () => onTap(1)),
            navItem(2, pageIndex == 2, 'Records', onTap: () => onTap(2)),
            navItem(3, pageIndex == 3, 'Stats', onTap: () => onTap(3)),
            navItem(4, pageIndex == 4, 'Account', onTap: () => onTap(4)),
          ],
        ),
      ),
    );
  }

  final List<List<String>> _iconPaths = [
    [Assets.pulseIcon, Assets.pulseIcon], // Home - using pulse SVG
    [Assets.buildIcon, Assets.buildIcon], // Workout - using build SVG
    [Assets.recordsIcon, Assets.recordsIcon], // Records - using records SVG
    [Assets.statsIcon, Assets.statsIcon], // Analytics - using stats SVG
    [Assets.accountIcon, Assets.accountIcon], // Account - using account SVG
  ];

  Widget navItem(int index, bool selected, String title, {Function()? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selected
                ? Column(
                    children: [
                      SvgPicture.asset(
                        _iconPaths[index][selected ? 1 : 0],
                        height: 30,
                        width: 30,
                        colorFilter: ColorFilter.mode(
                          selected ? kSelectedNavBarItem : kUnselectedNavBarItem,
                          BlendMode.srcIn,
                        ),
                      ),
                      MyText(
                        text: title,
                        weight: AppFontWeight.bold,
                        size: 10,
                        color: selected ? kSelectedNavBarItem : kUnselectedNavBarItem,
                        paddingTop: 4,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      SvgPicture.asset(
                        _iconPaths[index][selected ? 1 : 0],
                        height: 25,
                        width: 25,
                        colorFilter: ColorFilter.mode(kUnselectedNavBarItem, BlendMode.srcIn),
                      ),
                      MyText(
                        text: title,
                        weight: AppFontWeight.regular,
                        size: 10,
                        color: kUnselectedNavBarItem,
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
