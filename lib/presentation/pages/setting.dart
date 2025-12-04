import 'dart:io';
import 'package:auth_app/presentation/pages/saya.dart';
import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  File? _avatarFile;

  Widget _buildPengaturanItem({
    required String title,
    required Widget rightChild,
    required Color titleColor,
    required Color backgroundColor,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            rightChild,
          ],
        ),
      ),
    );
  }

  Widget _buildBottomItem({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color titleColor,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: titleColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        title: const Text(
          'Pengaturan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            const SizedBox(height: 10),

            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _avatarFile != null
                        ? FileImage(_avatarFile!)
                        : null,
                    child: _avatarFile == null
                        ? const Icon( Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Itami',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'itamiomw@gmail.com',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  _buildPengaturanItem(
                    title: 'Saya', titleColor: Colors.white, backgroundColor: Colors.deepOrange, 
                    rightChild: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                    onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const Saya())),
                  ),
                  const SizedBox(height: 8),
                  _buildPengaturanItem(
                    title: 'Akun', titleColor: Colors.black, backgroundColor: const Color(0xFFFFF0E3),
                    rightChild: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  _buildPengaturanItem(
                    title: 'Asupan Kalori', titleColor: Colors.black, backgroundColor: const Color(0xFFFFF0E3),
                    rightChild: const Text('3400 Cal', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w600, fontSize: 16)),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            const Divider(thickness: 1, color: Colors.grey, indent: 24, endIndent: 24), 

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  _buildBottomItem(title: 'Tentang Aplikasi', icon: Icons.info_outline, iconColor: Colors.deepOrange, titleColor: Colors.black, onTap: () {}),
                  const SizedBox(height: 10),
                  _buildBottomItem(title: 'Keluar', icon: Icons.logout, iconColor: Colors.red, titleColor: Colors.red, onTap: () {}),
                  const SizedBox(height: 10),
                  _buildBottomItem(title: 'Hapus Akun dan Keluar', icon: Icons.delete_forever, iconColor: Colors.red, titleColor: Colors.red, onTap: () {}),
                ],
              ),
            ),

            const Spacer(), 

            const Text(
              'Version: 0.0.6',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}