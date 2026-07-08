import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kamkor/core/theme/app_spacing.dart';
import 'package:kamkor/features/info/presentation/widgets/phone_link_text.dart';

/// A single reference article. Content is passed in directly, so no fetch is
/// needed. Reachable without auth. Phone numbers in the body are tappable.
@RoutePage()
class InfoDetailPage extends StatelessWidget {
  const InfoDetailPage({required this.title, required this.body, super.key});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: PhoneLinkText(body, style: theme.textTheme.bodyLarge),
      ),
    );
  }
}
