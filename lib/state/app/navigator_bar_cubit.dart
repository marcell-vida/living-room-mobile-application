import 'package:bloc/bloc.dart';
import 'package:living_room/extension/selected_tab_extension.dart';
import 'package:living_room/state/app/navigator_bar_state.dart';

class NavigatorBarCubit extends Cubit<NavigatorBarState>{
  NavigatorBarCubit(): super(const NavigatorBarState());

  void changeRoute(SelectedTab newTab){
    if(state.currentTab != newTab){
      emit(state.copyWith(currentTab: newTab));
    }
  }
}