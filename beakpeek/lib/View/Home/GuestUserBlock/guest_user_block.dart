import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GuestUserBlock extends StatelessWidget {
  const GuestUserBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '''You need to Login To make a LifeList
            Or a Profile''',
            style: GlobalStyles.smallHeadingPrimary(context),
          ),
          OutlinedButton(
            style: GlobalStyles.buttonPrimaryFilled(context),
            child: Text('Please Login',
                style: GlobalStyles.primaryButtonText(context)),
            onPressed: () {
              context.go('/');
            },
          ),
          const SizedBox(
            height: 10,
          ),
          FilledButton(
            style: GlobalStyles.buttonPrimaryOutlined(context),
            child:
                Text('Back', style: GlobalStyles.secondaryButtonText(context)),
            onPressed: () {
              context.goNamed('home');
            },
          ),
        ],
      ),
    );
  }
}
