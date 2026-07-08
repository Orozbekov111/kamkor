// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [ContactsPage]
class ContactsRoute extends PageRouteInfo<void> {
  const ContactsRoute({List<PageRouteInfo>? children})
    : super(ContactsRoute.name, initialChildren: children);

  static const String name = 'ContactsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ContactsPage();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [InfoDetailPage]
class InfoDetailRoute extends PageRouteInfo<InfoDetailRouteArgs> {
  InfoDetailRoute({
    required String title,
    required String body,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         InfoDetailRoute.name,
         args: InfoDetailRouteArgs(title: title, body: body, key: key),
         initialChildren: children,
       );

  static const String name = 'InfoDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InfoDetailRouteArgs>();
      return InfoDetailPage(title: args.title, body: args.body, key: args.key);
    },
  );
}

class InfoDetailRouteArgs {
  const InfoDetailRouteArgs({
    required this.title,
    required this.body,
    this.key,
  });

  final String title;

  final String body;

  final Key? key;

  @override
  String toString() {
    return 'InfoDetailRouteArgs{title: $title, body: $body, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InfoDetailRouteArgs) return false;
    return title == other.title && body == other.body && key == other.key;
  }

  @override
  int get hashCode => title.hashCode ^ body.hashCode ^ key.hashCode;
}

/// generated route for
/// [InfoPage]
class InfoRoute extends PageRouteInfo<void> {
  const InfoRoute({List<PageRouteInfo>? children})
    : super(InfoRoute.name, initialChildren: children);

  static const String name = 'InfoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InfoPage();
    },
  );
}

/// generated route for
/// [InfoSectionPage]
class InfoSectionRoute extends PageRouteInfo<InfoSectionRouteArgs> {
  InfoSectionRoute({
    required InfoSection section,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         InfoSectionRoute.name,
         args: InfoSectionRouteArgs(section: section, key: key),
         initialChildren: children,
       );

  static const String name = 'InfoSectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InfoSectionRouteArgs>();
      return InfoSectionPage(section: args.section, key: args.key);
    },
  );
}

class InfoSectionRouteArgs {
  const InfoSectionRouteArgs({required this.section, this.key});

  final InfoSection section;

  final Key? key;

  @override
  String toString() {
    return 'InfoSectionRouteArgs{section: $section, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InfoSectionRouteArgs) return false;
    return section == other.section && key == other.key;
  }

  @override
  int get hashCode => section.hashCode ^ key.hashCode;
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [MessageTemplatePage]
class MessageTemplateRoute extends PageRouteInfo<void> {
  const MessageTemplateRoute({List<PageRouteInfo>? children})
    : super(MessageTemplateRoute.name, initialChildren: children);

  static const String name = 'MessageTemplateRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MessageTemplatePage();
    },
  );
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfilePage();
    },
  );
}

/// generated route for
/// [SosHistoryDetailPage]
class SosHistoryDetailRoute extends PageRouteInfo<SosHistoryDetailRouteArgs> {
  SosHistoryDetailRoute({
    required int id,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         SosHistoryDetailRoute.name,
         args: SosHistoryDetailRouteArgs(id: id, key: key),
         initialChildren: children,
       );

  static const String name = 'SosHistoryDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SosHistoryDetailRouteArgs>();
      return SosHistoryDetailPage(id: args.id, key: args.key);
    },
  );
}

class SosHistoryDetailRouteArgs {
  const SosHistoryDetailRouteArgs({required this.id, this.key});

  final int id;

  final Key? key;

  @override
  String toString() {
    return 'SosHistoryDetailRouteArgs{id: $id, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SosHistoryDetailRouteArgs) return false;
    return id == other.id && key == other.key;
  }

  @override
  int get hashCode => id.hashCode ^ key.hashCode;
}

/// generated route for
/// [SosHistoryPage]
class SosHistoryRoute extends PageRouteInfo<void> {
  const SosHistoryRoute({List<PageRouteInfo>? children})
    : super(SosHistoryRoute.name, initialChildren: children);

  static const String name = 'SosHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SosHistoryPage();
    },
  );
}

/// generated route for
/// [SosPage]
class SosRoute extends PageRouteInfo<void> {
  const SosRoute({List<PageRouteInfo>? children})
    : super(SosRoute.name, initialChildren: children);

  static const String name = 'SosRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SosPage();
    },
  );
}
