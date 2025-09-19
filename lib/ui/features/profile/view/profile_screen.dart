import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_flash/ui/features/theme/view_model/theme/theme_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 50,
              // TODO: Add user profile image
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'John Doe', // TODO: Replace with user name
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'john.doe@example.com', // TODO: Replace with user email
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const SizedBox(height: 32.0),
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: state.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    final themeCubit = context.read<ThemeCubit>();
                    themeCubit.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
