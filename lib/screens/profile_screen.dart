import 'package:flutter/material.dart';
import '../main.dart';
import '../models/models.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 24),
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildStatsRow(),
              const SizedBox(height: 24),
              _buildSection('Account', [
                _MenuItem(icon: Icons.person_outline_rounded, label: 'Edit Profile', onTap: () {}),
                _MenuItem(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () {}),
                _MenuItem(icon: Icons.credit_card_outlined, label: 'Payment Methods', onTap: () {}),
              ]),
              const SizedBox(height: 16),
              _buildSection('Preferences', [
                _MenuItem(icon: Icons.language_outlined, label: 'Language', trailing: 'English', onTap: () {}),
                _MenuItem(icon: Icons.dark_mode_outlined, label: 'Dark Mode', onTap: () {}),
              ]),
              const SizedBox(height: 16),
              _buildSection('Support', [
                _MenuItem(icon: Icons.help_outline_rounded, label: 'Help Center', onTap: () {}),
                _MenuItem(icon: Icons.star_outline_rounded, label: 'Rate the App', onTap: () {}),
                _MenuItem(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy', onTap: () {}),
              ]),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const LoginScreen(),
                    transitionsBuilder: (_, anim, __, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                  (_) => false,
                ),
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.error.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.error.withOpacity(0.15)),
                  ),
                  child: const Center(
                    child: Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.error,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Padel Court v1.0.0',
                  style: TextStyle(fontSize: 12, color: AppTheme.textLight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'AH',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ahmed Al-Rashidi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'ahmed@example.com',
                  style: TextStyle(fontSize: 13, color: AppTheme.textMid),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '⚡ Active Member',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.edit_outlined, size: 18, color: AppTheme.textLight),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _StatCard(emoji: '🎾', value: '${sampleBookings.length}', label: 'Sessions'),
        const SizedBox(width: 12),
        _StatCard(emoji: '⏱', value: '${sampleBookings.length * 60}', label: 'Minutes'),
        const SizedBox(width: 12),
        _StatCard(emoji: '🏆', value: '2', label: 'Courts'),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textLight,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final isLast = entry.key == items.length - 1;
              return Column(
                children: [
                  entry.value,
                  if (!isLast)
                    Divider(
                      height: 1,
                      color: AppTheme.border,
                      indent: 52,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  const _StatCard({required this.emoji, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppTheme.textLight),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.textDark),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textDark,
                ),
              ),
            ),
            if (trailing != null) ...[
              Text(
                trailing!,
                style: const TextStyle(fontSize: 13, color: AppTheme.textLight),
              ),
              const SizedBox(width: 6),
            ],
            const Icon(Icons.chevron_right_rounded, size: 18, color: AppTheme.textLight),
          ],
        ),
      ),
    );
  }
}