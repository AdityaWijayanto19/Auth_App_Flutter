import 'dart:io';
import 'package:auth_app/presentation/pages/ubahPassword.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../service/auth_service.dart';

class Akun extends StatefulWidget {
  const Akun({super.key});

  @override
  State<Akun> createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  Map<String, dynamic>? _profile;
  bool _loading = true;
  File? _avatarFile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await AuthService().getProfile();
    setState(() {
      _profile = data;
      _loading = false;
    });
  }

  /// ============= PICK IMAGE (UPLOAD AVATAR) ===================
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery);

    if (result != null) {
      final file = File(result.path);

      setState(() {
        _avatarFile = file;
      });

      // /// Upload ke Supabase
      await AuthService().updateProfile(newAvatarFile: file);

      /// Refresh UI
      await _loadProfile();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto profil berhasil diupdate!')),
      );
    }
  }

  /// ============= EDIT NAME DIALOG ===================
  Future<void> _editNameDialog() async {
    final controller = TextEditingController(
      text: _profile?['full_name'] ?? '',
    );

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Ubah Nama'),
          content: TextField(
            controller: controller,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: 'Masukkan nama baru',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrange, width: 2.0),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () async {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  await AuthService().updateProfile(fullName: newName);
                  await _loadProfile();
                }
                if (!mounted) return;
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nama berhasil diupdate!')),
                );
              },
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  /// ============= UI ===================
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final email = _profile?['email'] ?? '';
    final name = _profile?['full_name'] ?? '';
    final avatar = _profile?['avatar_url'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        title: const Text(
          'Akun',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            /// AVATAR + CAMERA BUTTON
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _avatarFile != null
                        ? FileImage(_avatarFile!)
                        : (avatar != null ? NetworkImage(avatar) : null)
                              as ImageProvider?,
                    child: avatar == null && _avatarFile == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.deepOrange,
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 13),

            /// EMAIL
            Text(
              email,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.deepOrange,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 28),

            /// ========== NAMA =============
            InkWell(
              onTap: _editNameDialog,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 30.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.person, color: Colors.deepOrange),
                        SizedBox(width: 10),
                        Text(
                          'Nama',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),

            /// ========== UBAH PASSWORD =============
            InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UbahPassword()),
                );

                if (result == true) {
                  _loadProfile();
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 30.0,
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.mode_edit_outline_sharp,
                      color: Colors.deepOrange,
                    ),
                    SizedBox(width: 10),
                    Text('Ubah Password'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
