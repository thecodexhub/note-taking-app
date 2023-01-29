import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;

/// {@template sign_in_with_magic_link_failure}
/// Thrown during sign in with magic link flow if any failure occurs.
/// {@endtemplate}
class SignInWithMagicLinkFailure implements Exception {
  /// {@macro sign_in_with_magic_link_failure}
  const SignInWithMagicLinkFailure({
    this.message = 'An unknown error occurred.',
  });

  /// The associated error message
  final String message;
}

/// Thrown during the logout process if a failure occurs.
class SignOutFailure implements Exception {}

/// {@template update_profile_failure}
/// Thrown during profile update if any failure occurs.
/// {@endtemplate}
class UpdateProfileFailure implements Exception {
  /// {@macro update_profile_failure}
  const UpdateProfileFailure({
    this.message = 'An unknown error occurred.',
  });

  /// The associated error message
  final String message;
}

/// {@template fetch_profile_failure}
/// Thrown during profile fetch if any failure occurs.
/// {@endtemplate}
class FetchProfileFailure implements Exception {
  /// {@macro fetch_profile_failure}
  const FetchProfileFailure({
    this.message = 'An unknown error occurred.',
  });

  /// The associated error message
  final String message;
}

/// {@template authentication_repository}
/// Repository that manages the user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    required supabase_flutter.SupabaseClient client,
  }) : _client = client;

  final supabase_flutter.SupabaseClient _client;

  /// Whether or not the current environment is Web.
  /// Should only be overriden for testing purpose. Otherwise,
  /// defaults to [kIsWeb].
  @visibleForTesting
  bool isWeb = kIsWeb;

  /// URL that auth providers are permitted to redirect to post authentication.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const redirectUrl = 'io.supabase.flutterquickstart://login-callback/';

  /// Profiles table name.
  @visibleForTesting
  static const profilesTable = 'profiles';

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user {
    return _client.auth.onAuthStateChange.map((authState) {
      final session = authState.session;
      final user = session == null ? User.empty : session.user.toUser;
      return user;
    });
  }

  /// Returns the current user
  /// Defaults to [User.empty] if there is no current user.
  User get currentUser {
    return _client.auth.currentUser?.toUser ?? User.empty;
  }

  /// Creates the login flow with the magiclink
  ///
  /// Throws a [SignInWithMagicLinkFailure] if any exception occurs.
  Future<void> signInWithMagicLink({required String email}) async {
    try {
      await _client.auth.signInWithOtp(
        email: email,
        emailRedirectTo: isWeb ? null : redirectUrl,
      );
    } on supabase_flutter.AuthException catch (error) {
      throw SignInWithMagicLinkFailure(message: error.message);
    } catch (_) {
      throw const SignInWithMagicLinkFailure();
    }
  }

  /// Updates user's information into the `profiles` table.
  Future<void> updateProfile({
    required String username,
    required String fullName,
  }) async {
    final updates = {
      'id': currentUser.id,
      'username': username,
      'full_name': fullName,
      'updated_at': DateTime.now().toIso8601String(),
    };

    try {
      await _client.from(profilesTable).upsert(updates);
    } on supabase_flutter.PostgrestException catch (error) {
      throw UpdateProfileFailure(message: error.message);
    } catch (_) {
      throw const UpdateProfileFailure();
    }
  }

  /// Fetches user's information from the `profiles` table.
  Future<User> getProfile() async {
    try {
      final profile = await _client
          .from(profilesTable)
          .select<supabase_flutter.PostgrestMap>()
          .eq('id', currentUser.id)
          .single();
      return User.fromMap(profile).copyWith(email: currentUser.email);
    } on supabase_flutter.PostgrestException catch (error) {
      throw FetchProfileFailure(message: error.message);
    } catch (_) {
      throw const FetchProfileFailure();
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [SignOutFailure] if an exception occurs.
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (_) {
      throw SignOutFailure();
    }
  }
}

extension on supabase_flutter.User {
  User get toUser {
    return User(id: id, email: email);
  }
}
