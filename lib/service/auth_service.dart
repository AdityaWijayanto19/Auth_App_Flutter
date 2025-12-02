import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService._internal();

  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;

  // sign in menggunakan email dan password signInWithPassword()
  Future<AuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      // parameter pada fungsi ini harus mengisi sesuai pada parameter fungsi parent nya
      email: email,
      password: password,
    );
  }

  // sign up
  Future<void> signUpWithProfile({
    required String email,
    required String password,
    required String fullName,
    File? avatarFile,
  }) async {
    // create data user
    final authResponse = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    // jika data user tidak berhasil create ke supabase
    final user = authResponse.user;
    if (user == null) {
      // jika user kosong, maka akan melempar kan text
      throw AuthException('User gagal terbuat');
    }

    final userId = user.id;

    // kalo ada avatar upload ke storage
    String? avatarUrl;
    if (avatarFile != null) {
      final fileExt = avatarFile.path.split('.').last;
      final filePath = 'avatars/$userId.$fileExt';

      await _supabase.storage
          .from('avatars')
          .upload(
            filePath,
            avatarFile,
            fileOptions: const FileOptions(upsert: true),
          );

      avatarUrl = _supabase.storage.from('avatars').getPublicUrl(filePath);
    }

    // masukkan data ke tabel profiles
    await _supabase.from('profiles').insert({
      'id': userId,
      'full_name': fullName,
      'avatar_url': avatarUrl,
    });
  }

  // sign out/keluar
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // dapatkan id user yang sedang login
  Future<Map<String, dynamic>?> getProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final result = await _supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return result;
  }

  // fungsi update data user/profile
  Future<void> updateProfile({
    required String fullName,
    File? newAvatarFile,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw AuthException('Tidak ada user yang login.');
    }

    String? avatarUrl;
    if (newAvatarFile != null) {
      final fileExt = newAvatarFile.path.split('.').last;
      final filePath = 'avatars/${user.id}.$fileExt';

      await _supabase.storage
          .from('avatars')
          .upload(
            filePath,
            newAvatarFile,
            fileOptions: const FileOptions(upsert: true),
          );

      avatarUrl = _supabase.storage.from('avatars').getPublicUrl(filePath);
    }

    final updateData = <String, dynamic>{'full_name': fullName};

    if (avatarUrl != null) {
      updateData['avatar_url'] = avatarUrl;
    }

    await _supabase.from('profiles').update(updateData).eq('id', user.id);
  }

  // ubah password
  Future<void> changePassword(String newPassword) async {
    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  // lupa password via email
  Future<void> sendPasswordResetEmail(
    String email, {
    String? redirectUrl,
  }) async {
    await _supabase.auth.resetPasswordForEmail(email, redirectTo: redirectUrl);
  }
}
