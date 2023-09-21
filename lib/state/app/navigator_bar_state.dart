import 'package:equatable/equatable.dart';
import 'package:living_room/extension/selected_tab_extension.dart';

class NavigatorBarState extends Equatable {
  final SelectedTab currentTab;

  const NavigatorBarState({this.currentTab = SelectedTab.home});

  NavigatorBarState copyWith({SelectedTab? currentTab}) {
    return NavigatorBarState(currentTab: currentTab ?? this.currentTab);
  }

  @override
  List<Object?> get props => [currentTab];
}
