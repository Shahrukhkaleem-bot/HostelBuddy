import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_config.dart';

/// Real Google sign-in through Supabase, plus the signed-in user's profile row.
///
/// Sign-in is native on Android: Google returns an ID token, which Supabase
/// exchanges for a session. The session is stored by supabase_flutter, so the
/// user stays signed in across restarts.
class AuthService extends ChangeNotifier {
  AuthService._();
  static final AuthService instance = AuthService._();

  static SupabaseClient get client => Supabase.instance.client;

  /// Row from `public.profiles` for the signed-in user, or null when signed out.
  Map<String, dynamic>? profile;
  bool _googleReady = false;

  Session? get session => client.auth.currentSession;
  User? get user => client.auth.currentUser;
  bool get isSignedIn => session != null;

  /// 'student' or 'manager', or null when the user has not chosen yet.
  String? get role {
    final value = profile?['role'];
    return value is String && value.isNotEmpty ? value : null;
  }

  String get displayName {
    final fromProfile = profile?['full_name'];
    if (fromProfile is String && fromProfile.isNotEmpty) return fromProfile;
    final fromToken = user?.userMetadata?['full_name'];
    if (fromToken is String && fromToken.isNotEmpty) return fromToken;
    return user?.email ?? 'Guest';
  }

  String? get avatarUrl {
    final fromProfile = profile?['avatar_url'];
    if (fromProfile is String && fromProfile.isNotEmpty) return fromProfile;
    final fromToken = user?.userMetadata?['avatar_url'];
    if (fromToken is String && fromToken.isNotEmpty) return fromToken;
    return null;
  }

  /// Phone and city as saved on the profile, or null when not filled in.
  String? get phone {
    final value = profile?['phone'];
    return value is String && value.isNotEmpty ? value : null;
  }

  String? get city {
    final value = profile?['city'];
    return value is String && value.isNotEmpty ? value : null;
  }

  /// Call once before `runApp`.
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
    // Keep the cached profile in step with sign-in/sign-out.
    client.auth.onAuthStateChange.listen((state) {
      if (state.session == null) {
        instance.profile = null;
        instance.notifyListeners();
      }
    });
    if (instance.isSignedIn) await instance.loadProfile();
  }

  Future<void> _ensureGoogleReady() async {
    if (_googleReady) return;
    await GoogleSignIn.instance.initialize(
      serverClientId: SupabaseConfig.googleServerClientId,
    );
    _googleReady = true;
  }

  /// Signs in with Google. Returns null on success, or a message to show.
  /// Returns [cancelled] when the user dismissed the Google sheet.
  static const String cancelled = 'cancelled';

  Future<String?> signInWithGoogle() async {
    if (!SupabaseConfig.isGoogleConfigured) {
      return 'Google sign-in is not configured yet. Add the Google Web client '
          'id to lib/core/supabase_config.dart.';
    }
    try {
      // Web has no native account sheet: hand off to Google in the browser and
      // let Supabase redirect back here with a session.
      if (kIsWeb) {
        await client.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: Uri.base.origin,
        );
        return null;
      }
      await _ensureGoogleReady();
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        return 'Google did not return an ID token. Check that the Android '
            'OAuth client uses this app\'s package name and SHA-1.';
      }
      await client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );
      await loadProfile();
      notifyListeners();
      return null;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) return cancelled;
      return 'Google sign-in failed: ${error.description ?? error.code.name}';
    } on AuthException catch (error) {
      return 'Supabase rejected the sign-in: ${error.message}';
    } catch (error) {
      return 'Sign-in failed: $error';
    }
  }

  Future<void> signOut() async {
    try {
      if (!kIsWeb) await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Signing out of Supabase matters more than clearing the Google cache.
    }
    await client.auth.signOut();
    profile = null;
    notifyListeners();
  }

  /// Reads the profile row, creating it if the signup trigger has not run yet.
  Future<void> loadProfile() async {
    final id = user?.id;
    if (id == null) return;
    try {
      final rows = await client.from('profiles').select().eq('id', id).limit(1);
      if (rows.isEmpty) {
        profile = await client
            .from('profiles')
            .upsert({
              'id': id,
              'email': user?.email,
              'full_name': user?.userMetadata?['full_name'],
              'avatar_url': user?.userMetadata?['avatar_url'],
            })
            .select()
            .single();
      } else {
        profile = Map<String, dynamic>.from(rows.first);
      }
      notifyListeners();
    } on PostgrestException catch (error) {
      debugPrint('Could not load profile: ${error.message}');
    }
  }

  /// Saves the details the user typed into the profile form. Returns null on
  /// success, or a message to show.
  Future<String?> saveProfileDetails({
    String? fullName, String? phone, String? city,
  }) async {
    final id = user?.id;
    if (id == null) return 'You are signed out. Please sign in again.';
    try {
      profile = await client
          .from('profiles')
          .upsert({
            'id': id,
            'email': user?.email,
            if (fullName != null) 'full_name': fullName,
            if (phone != null) 'phone': phone,
            if (city != null) 'city': city,
          })
          .select()
          .single();
      notifyListeners();
      return null;
    } on PostgrestException catch (error) {
      return 'Could not save your profile: ${error.message}';
    }
  }

  /// Stores the chosen role. Returns null on success, or a message to show.
  Future<String?> saveRole(String value) async {
    final id = user?.id;
    if (id == null) return 'You are signed out. Please sign in again.';
    try {
      profile = await client
          .from('profiles')
          .upsert({'id': id, 'role': value, 'email': user?.email})
          .select()
          .single();
      notifyListeners();
      return null;
    } on PostgrestException catch (error) {
      return 'Could not save your role: ${error.message}';
    }
  }
}
