/// REST endpoint paths, relative to AppConfig.baseUrl.
abstract final class ApiEndpoints {
  // Access-link auth flow.
  static const validateAccessLink = 'access-link/validate';
  static const authAccessLink = 'access-link/auth';

  // Public reference data.
  static const crisisCenters = 'info/crisis-centers';
  static const psychologicalHelp = 'info/psychological-help';
  static const emergencyInstructions = 'info/emergency-instructions';
  static const privacyPolicy = 'info/privacy-policy';

  /// Paths reachable without an auth token.
  static const publicPaths = <String>[
    validateAccessLink,
    authAccessLink,
    crisisCenters,
    psychologicalHelp,
    emergencyInstructions,
    privacyPolicy,
  ];
}
