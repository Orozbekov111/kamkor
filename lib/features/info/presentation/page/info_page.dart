import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kamkor/features/info/presentation/view/info_view.dart';

/// Public reference sections menu — reachable with or without authentication.
@RoutePage()
class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) => const InfoView();
}
