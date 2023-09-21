import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_room/extension/on_built_in/context_extension.dart';
import 'package:living_room/extension/selected_tab_extension.dart';
import 'package:living_room/screens/base/app_base_screen.dart';
import 'package:living_room/state/app/navigator_bar_cubit.dart';
import 'package:living_room/state/app/navigator_bar_state.dart';
import 'package:living_room/util/constants.dart';

abstract class ContentWithBottomBar extends AppBaseScreen {
  const ContentWithBottomBar({super.key});

  void _handleNavigatorTap(BuildContext context, int index) {
    context.cubits.navigatorBar.changeRoute(SelectedTab.values[index]);
  }

  @nonVirtual
  @override
  Widget body(BuildContext context) {
    return BlocBuilder<NavigatorBarCubit, NavigatorBarState>(
      buildWhen: (previous, current) => previous.currentTab != current.currentTab,
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
            bottomNavigationBar: DotNavigationBar(
              backgroundColor: AppColors.whiteOp30,
              currentIndex: SelectedTab.values.indexOf(state.currentTab),
              onTap: (int index) => _handleNavigatorTap(context, index),
              items: [

                /// Home
                DotNavigationBarItem(
                  icon: Icon(Icons.home),
                  selectedColor: Colors.purple,
                ),

                /// Likes
                DotNavigationBarItem(
                  icon: Icon(Icons.favorite_border),
                  selectedColor: Colors.pink,
                ),

                /// Search
                DotNavigationBarItem(
                  icon: Icon(Icons.search),
                  selectedColor: Colors.orange,
                ),

                /// Profile
                DotNavigationBarItem(
                  icon: Icon(Icons.person),
                  selectedColor: Colors.teal,
                ),

              ],
            ),
            body: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [AppColors.purple, AppColors.sand],
                  )),
              child: Container(
                alignment: Alignment.center,
                color: AppColors.white.withOpacity(0.5),
                child: SafeArea(child: onBuild(context)),
              ),
            ));
      }
    );
  }

  Widget onBuild(BuildContext context);
}
