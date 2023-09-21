import 'package:flutter/cupertino.dart';
import 'package:living_room/screens/base/content_with_bottom_bar.dart';
import 'package:living_room/widgets/default/default_text.dart';

class HomeScreen extends ContentWithBottomBar {
  const HomeScreen({super.key});

  @override
  Widget onBuild(BuildContext context) {
    return DefaultText('Hey there');
  }
}
