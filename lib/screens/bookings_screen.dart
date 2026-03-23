import 'package:flutter/material.dart';
import '../main.dart';
import '../models/models.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Booking> get _upcoming =>
      sampleBookings.where((b) => b.date.isAfter(DateTime.now())).toList();

  List<Booking> get _past =>
      sampleBookings.where((b) => b.date.isBefore(DateTime.now())).toList();

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final days = d.difference(DateTime.now()).inDays;
    if (days == 0) return 'Today';
    if (days == 1) return 'Tomorrow';
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: const Text(
                'My Bookings',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                  letterSpacing: -0.8,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.all(2),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppTheme.textMid,
                  labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Past'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBookingsList(_upcoming, isUpcoming: true),
                  _buildBookingsList(_past, isUpcoming: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings, {required bool isUpcoming}) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isUpcoming ? '📅' : '🎾',
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming ? 'No upcoming bookings' : 'No past bookings',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isUpcoming ? 'Book a court and start playing!' : 'Your history will appear here',
              style: const TextStyle(fontSize: 13, color: AppTheme.textMid),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _BookingCard(
            booking: booking,
            isUpcoming: isUpcoming,
            formattedDate: _formatDate(booking.date),
          ),
        );
      },
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final bool isUpcoming;
  final String formattedDate;

  const _BookingCard({
    required this.booking,
    required this.isUpcoming,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Center(
                    child: Text(
                      booking.court.emoji,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.court.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booking.court.location,
                        style: const TextStyle(fontSize: 12, color: AppTheme.textMid),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isUpcoming
                        ? AppTheme.success.withOpacity(0.1)
                        : AppTheme.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isUpcoming ? 'Confirmed' : 'Completed',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isUpcoming ? AppTheme.success : AppTheme.textLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: AppTheme.border,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _InfoChip(icon: Icons.calendar_today_outlined, label: formattedDate),
                const SizedBox(width: 8),
                _InfoChip(icon: Icons.access_time_rounded, label: booking.time),
                const Spacer(),
                Text(
                  'SAR ${booking.totalAmount.toInt()}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
          if (isUpcoming) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppTheme.error.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.error,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Get Directions',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppTheme.textLight),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppTheme.textMid,
          ),
        ),
      ],
    );
  }
}