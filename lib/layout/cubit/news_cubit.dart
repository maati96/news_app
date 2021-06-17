import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/modules/business/business_screen.dart';
import 'package:news_app/modules/science/science_screen.dart';
import 'package:news_app/modules/sports/sports_screen.dart';
import 'package:news_app/shared/network/dio_helper.dart';
import 'package:news_app/shared/network/local/cashe_helper.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.business,
      ),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.sports,
      ),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.science,
      ),
      label: 'Science',
    ),
  ];

  List<Widget> screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];

  List<dynamic> business = [];

  void getBusiness() {
    emit(NewsGetBusinessLoadingState());
    DioHelper.getData(
      url: 'v2/top-headlines',
      query: {
        'country': 'eg',
        'category': 'business',
        'apiKey': '849c89780fb64b3c86d7eb5aa8334e0f',
      },
    ).then((value) {
      business = value.data['articles'];

      print(business[0]);
      emit(NewsGetBusinessSuccessState());
    }).catchError(
      (error) {
        print(error.toString());
        emit(NewsGetBusinessErrorState(error.toString()));
      },
    );
  }

  List<dynamic> sports = [];

  void getSports() {
    emit(NewsGetSportsLoadingState());
    if (sports.length == 0) {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'eg',
          'category': 'sports',
          'apiKey': '849c89780fb64b3c86d7eb5aa8334e0f',
        },
      ).then((value) {
        sports = value.data['articles'];

        print(sports[0]);
        emit(NewsGetSportsSuccessState());
      }).catchError(
        (error) {
          print(error.toString());
          emit(NewsGetSportsErrorState(error.toString()));
        },
      );
    } else {
      emit(NewsGetSportsSuccessState());
    }
  }

  List<dynamic> science = [];

  void getScience() {
    emit(NewsGetScienceLoadingState());
    if (science.length == 0) {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'eg',
          'category': 'science',
          'apiKey': '849c89780fb64b3c86d7eb5aa8334e0f',
        },
      ).then((value) {
        science = value.data['articles'];

        print(science[0]);
        emit(NewsGetScienceSuccessState());
      }).catchError(
        (error) {
          print(error.toString());
          emit(NewsGetScienceErrorState(error.toString()));
        },
      );
    } else {
      emit(NewsGetScienceSuccessState());
    }
  }

  void changeBottomNavBar(int index) {
    currentIndex = index;
    if (index == 1) getSports();
    if (index == 2) getScience();
    emit(NewsBottomNavState());
  }

  bool isDark = false;

  void changeAppMode() {
    isDark = !isDark;
    CasheHelper.putData(key: 'isDark', value: isDark).then(
      (value) => {
        emit(NewsChangeModeState()),
      },
    );
  }
}
