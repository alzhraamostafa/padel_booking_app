import 'package:flutter/material.dart';
import '../main.dart';
import '../models/models.dart';
import 'home_screen.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Court court;
  final DateTime date;
  final String time;
  final int duration;
  final double totalAmount;

  const BookingConfirmationScreen({
    super.key,
    required this.court,
    required this.date,
    required this.time,
    required this.duration,
    required this.totalAmount,
  });

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnim = Tween<double>(begin: 0.4, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 1, curve: Curves.easeOut)),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _formattedDate {
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'];
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final d = widget.date;
    return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}';
  }

  String get _bookingId {
    return 'BK${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // Success animation
              AnimatedBuilder(
                animation: _controller,
                builder: (_, __) => Transform.scale(
                  scale: _scaleAnim.value,
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppTheme.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedBuilder(
                animation: _fadeAnim,
                builder: (_, child) => Opacity(opacity: _fadeAnim.value, child: child),
                child: Column(
                  children: [
                    const Text(
                      'Booking Confirmed!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your court has been reserved.\nSee you on the court! 🎾',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppTheme.textMid,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              // Booking card
              AnimatedBuilder(
                animation: _fadeAnim,
                builder: (_, child) => Opacity(opacity: _fadeAnim.value, child: child),
                child: _buildBookingCard(),
              ),
              const Spacer(),
              // Add to calendar button
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 18, color: AppTheme.textDark),
                      SizedBox(width: 8),
                      Text(
                        'Add to Calendar',
                        style: TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const HomeScreen(),
                    transitionsBuilder: (_, anim, __, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                  (_) => false,
                ),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'Back to Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Text(widget.court.emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.court.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        widget.court.location,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.success,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '✓ Confirmed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Dashed divider
          _buildDashedDivider(),
          // Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _DetailRow(icon: Icons.calendar_today_outlined, label: 'Date', value: _formattedDate),
                const SizedBox(height: 14),
                _DetailRow(icon: Icons.access_time_rounded, label: 'Time', value: '${widget.time} • ${widget.duration} hr'),
                const SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.confirmation_number_outlined,
                  label: 'Booking ID',
                  value: _bookingId,
                ),
                const SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.payments_outlined,
                  label: 'Total Paid',
                  value: 'SAR ${widget.totalAmount.toInt()}',
                  valueStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return Row(
      children: List.generate(
        30,
        (index) => Expanded(
          child: Container(
            height: 1,
            color: index.isEven ? AppTheme.border : Colors.transparent,
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textLight),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppTheme.textMid),
        ),
        const Spacer(),
        Text(
          value,
          style: valueStyle ??
              const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
        ),
      ],
    );
  }
}