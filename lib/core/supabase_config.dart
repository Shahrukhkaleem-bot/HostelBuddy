/// Supabase settings for the app.
///
/// Only values that are safe to ship inside an APK belong here. The anon key is
/// a public client key: it identifies the project, and Row Level Security is
/// what actually protects the data.
///
/// NEVER put the service_role key or the database password in this file (or
/// anywhere else in `lib/`). The service_role key bypasses Row Level Security,
/// and anything shipped in the app can be extracted from the APK.
class SupabaseConfig {
  static const String url = 'https://jegdiogqnehlzkdrbomp.supabase.co';

  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImplZ2Rpb2dxbmVobHprZHJib21wIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk4ODMzMzgsImV4cCI6MjEwNTQ1OTMzOH0.I-SmYyhW1J0lCAxdUOHA1WHSxx6jwPAXl1HfDSMlgAc';

  /// The **Web** OAuth client id from Google Cloud Console — not the Android
  /// one. Android's native sign-in sends this as `serverClientId` so that the
  /// resulting ID token is issued for the same client Supabase verifies
  /// against. Paste it here, or pass it at build time with
  /// `--dart-define=GOOGLE_SERVER_CLIENT_ID=...`.
  ///
  /// The matching client *secret* belongs only in the Supabase dashboard
  /// (Authentication → Providers → Google). Never put it in the app.
  ///
  /// The Android client for this app is
  /// `285226459021-na1o6eku6nhso0f421q7hoa4d7qsgqco.apps.googleusercontent.com`
  /// (package `com.hostelbuddy.hostel_buddy` + the signing certificate SHA-1).
  /// Android matches it automatically, so the app never names it — but it must
  /// be listed in Supabase's "Authorized Client IDs" alongside the web one.
  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue:
        '285226459021-fhfjusjeol6552jbmgbcqdg9tqmnuk5o.apps.googleusercontent.com',
  );

  static bool get isGoogleConfigured => googleServerClientId.isNotEmpty;
}
