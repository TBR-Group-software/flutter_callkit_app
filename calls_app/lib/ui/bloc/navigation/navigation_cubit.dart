import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'bottom_navigation_page.dart';

@singleton
class NavigationCubit extends Cubit<BottomNavigationPage> {
  NavigationCubit() : super(BottomNavigationPage.calls);

  void navigateTo(int index) {
    emit(BottomNavigationPage.values[index]);
  }
}
