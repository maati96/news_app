import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/cubit/news_cubit.dart';
import 'package:news_app/shared/componentes/componentes.dart';

class SportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var list = NewsCubit.get(context).sports;
        return ConditionalBuilder(
          condition: state is! NewsGetSportsLoadingState,
          builder: (context) => ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => buildArticleItem(list[index]),
              separatorBuilder: (context, index) => myDivider(),
              itemCount: 10),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
