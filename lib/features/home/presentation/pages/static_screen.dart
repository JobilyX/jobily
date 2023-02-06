import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/constant/spaces.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../settings/domain/usecases/get_static_pages.dart';
import '../../../settings/presentation/cubit/static_pages/cubit/static_content_cubit.dart';

class StaticPage extends StatelessWidget {
  const StaticPage({Key? key, required this.staticFilter}) : super(key: key);
  final StaticFilter staticFilter;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(),
      body: Padding(
        padding: sidePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceV10BE(),
            Text(
              context
                  .read<StaticContentCubit>()
                  .getInfoByFillter(filter: staticFilter),
              style: TextStyles.bodyText20,
            )
          ],
        ),
      ),
    );
  }
}
