import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../../core/app_mode.dart'; // Corrected path
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authProvider).value;
    final uiMode = ref.watch(uiModeProvider);

    if (authUser == null) return const Center(child: Text('Not logged in'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: CachedNetworkImageProvider(authUser.image),
                ),
                if (authUser.isPremium)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: Colors.blue, shape: BoxShape.circle),
                    child: const Icon(Icons.verified,
                        color: Colors.white, size: 24),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text('${authUser.name}, ${authUser.age}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(authUser.job,
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 32),
            _buildSection(context, 'Account Settings', [
              _buildSwitchListTile(
                title: 'Premium Subscription',
                subtitle:
                    authUser.isPremium ? 'Active (Pro Tier)' : 'Free Tier',
                value: authUser.isPremium,
                icon: Icons.star,
                color: Colors.orange,
                onChanged: (val) {
                  if (val) {
                    _showUpgradeDialog(context, ref);
                  } else {
                    ref.read(authProvider.notifier).togglePremium();
                  }
                },
              ),
            ]),
            _buildSection(context, 'App Experience', [
              _buildModeSelector(context, ref, uiMode),
              _buildListTile(
                title: 'Theme Settings',
                subtitle: 'Toggle dark/light mode',
                icon: Icons.brightness_6,
                onTap:
                    () {}, // Handled automatically by system theme for this demo
              ),
            ]),
            _buildSection(context, 'Security', [
              _buildListTile(
                title: 'Logout',
                icon: Icons.logout,
                color: Colors.red,
                onTap: () => _showLogoutConfirm(context, ref),
              ),
            ]),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
        ),
        ...children,
      ],
    );
  }

  Widget _buildListTile(
      {required String title,
      String? subtitle,
      required IconData icon,
      Color? color,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.pink),
      title: Text(title,
          style: TextStyle(fontWeight: FontWeight.w500, color: color)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildSwitchListTile(
      {required String title,
      required String subtitle,
      required bool value,
      required IconData icon,
      required Color color,
      required Function(bool) onChanged}) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      secondary: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle,
          style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildModeSelector(
      BuildContext context, WidgetRef ref, UIMode currentMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('UI Build Mode',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          SegmentedButton<UIMode>(
            segments: const [
              ButtonSegment(
                  value: UIMode.lightMode,
                  label: Text('Light'),
                  icon: Icon(Icons.flash_on)),
              ButtonSegment(
                  value: UIMode.performanceMode,
                  label: Text('Fast'),
                  icon: Icon(Icons.speed)),
              ButtonSegment(
                  value: UIMode.premiumMode,
                  label: Text('Pro'),
                  icon: Icon(Icons.workspace_premium)),
            ],
            selected: {currentMode},
            onSelectionChanged: (val) =>
                ref.read(uiModeProvider.notifier).state = val.first,
          ),
        ],
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, size: 60, color: Colors.orange),
            const SizedBox(height: 16),
            const Text('Upgrade to Pro',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Get unlimited swipes and super-likes!',
                textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).togglePremium();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Confirm Purchase (\$0.00)'), // Fake payment
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirm(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout?'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                ref.read(authProvider.notifier).logout();
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
