import 'package:flutter/material.dart';
import '../main.dart';
import '../models/models.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final Court court;
  const BookingScreen({super.key, required this.court});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedTime;
  int _duration = 1; // hours
  late List<TimeSlot> _slots;

  @override
  void initState() {
    super.initState();
    _slots = generateTimeSlots();
  }

  double get _totalAmount => widget.court.pricePerHour * _duration;

  List<DateTime> get _availableDates {
    return List.generate(14, (i) => DateTime.now().add(Duration(days: i)));
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final wd = d.weekday - 1;
    return '${days[wd]}, ${d.day} ${months[d.month - 1]}';
  }

  String _shortDay(DateTime d) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[d.weekday - 1];
  }

  void _proceed() {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a time slot'),
          backgroundColor: AppTheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          court: widget.court,
          date: _selectedDate,
          time: _selectedTime!,
          duration: _duration,
          totalAmount: _totalAmount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        title: const Text('Select Date & Time'),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.border),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Court pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.court.emoji, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.court.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textDark,
                              ),
                            ),
                            Text(
                              widget.court.location,
                              style: const TextStyle(fontSize: 12, color: AppTheme.textMid),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Date selection
                  const Text(
                    'Select Date',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 76,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _availableDates.length,
                      itemBuilder: (context, index) {
                        final date = _availableDates[index];
                        final isSelected = date.day == _selectedDate.day &&
                            date.month == _selectedDate.month;
                        final isToday = index == 0;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedDate = date),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 10),
                            width: 56,
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.primary : AppTheme.cardBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? AppTheme.primary : AppTheme.border,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _shortDay(date),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white.withOpacity(0.7)
                                        : AppTheme.textLight,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected ? Colors.white : AppTheme.textDark,
                                  ),
                                ),
                                if (isToday)
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppTheme.accent : AppTheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Duration selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Duration',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                          letterSpacing: -0.4,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Row(
                          children: [
                            _DurationButton(
                              icon: Icons.remove,
                              onTap: () {
                                if (_duration > 1) setState(() => _duration--);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '$_duration hr',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textDark,
                                ),
                              ),
                            ),
                            _DurationButton(
                              icon: Icons.add,
                              onTap: () {
                                if (_duration < 4) setState(() => _duration++);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  // Time slots
                  const Text(
                    'Available Times',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _slots.length,
                    itemBuilder: (context, index) {
                      final slot = _slots[index];
                      final isSelected = _selectedTime == slot.time;
                      return GestureDetector(
                        onTap: slot.isAvailable
                            ? () => setState(() => _selectedTime = slot.time)
                            : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: !slot.isAvailable
                                ? AppTheme.surface
                                : isSelected
                                    ? AppTheme.primary
                                    : AppTheme.cardBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: !slot.isAvailable
                                  ? AppTheme.border
                                  : isSelected
                                      ? AppTheme.primary
                                      : AppTheme.border,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              slot.time,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: !slot.isAvailable
                                    ? AppTheme.textLight
                                    : isSelected
                                        ? Colors.white
                                        : AppTheme.textDark,
                                decoration: !slot.isAvailable
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Bottom summary bar
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              border: Border(top: BorderSide(color: AppTheme.border)),
            ),
            child: Column(
              children: [
                if (_selectedTime != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_formatDate(_selectedDate)} • $_selectedTime • $_duration hr',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMid,
                        ),
                      ),
                      Text(
                        'SAR ${_totalAmount.toInt()}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                GestureDetector(
                  onTap: _proceed,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _selectedTime != null ? AppTheme.primary : AppTheme.border,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Continue to Payment',
                        style: TextStyle(
                          color: _selectedTime != null ? Colors.white : AppTheme.textLight,
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
        ],
      ),
    );
  }
}

class _DurationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _DurationButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        child: Icon(icon, size: 18, color: AppTheme.textDark),
      ),
    );
  }
}