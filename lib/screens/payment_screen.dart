import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../models/models.dart';
import 'booking_confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Court court;
  final DateTime date;
  final String time;
  final int duration;
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.court,
    required this.date,
    required this.time,
    required this.duration,
    required this.totalAmount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _cardNumberController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isLoading = false;
  int _selectedPaymentMethod = 0; // 0=card, 1=apple, 2=stc

  String get _formattedDate {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final d = widget.date;
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  void _pay() async {
    if (_selectedPaymentMethod == 0) {
      if (_cardNumberController.text.length < 19 ||
          _expiryController.text.length < 5 ||
          _cvvController.text.length < 3 ||
          _cardNameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please fill in all card details'),
            backgroundColor: AppTheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => BookingConfirmationScreen(
            court: widget.court,
            date: widget.date,
            time: widget.time,
            duration: widget.duration,
            totalAmount: widget.totalAmount,
          ),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
        (route) => route.isFirst,
      );
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        title: const Text('Payment'),
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
                  _buildOrderSummary(),
                  const SizedBox(height: 28),
                  _buildPaymentMethods(),
                  const SizedBox(height: 28),
                  if (_selectedPaymentMethod == 0) _buildCardForm(),
                  if (_selectedPaymentMethod != 0) _buildAltPayment(),
                ],
              ),
            ),
          ),
          _buildPayButton(),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 16),
          _SummaryRow(label: 'Court', value: widget.court.name),
          const SizedBox(height: 8),
          _SummaryRow(label: 'Date', value: _formattedDate),
          const SizedBox(height: 8),
          _SummaryRow(label: 'Time', value: widget.time),
          const SizedBox(height: 8),
          _SummaryRow(label: 'Duration', value: '${widget.duration} hour${widget.duration > 1 ? "s" : ""}'),
          const SizedBox(height: 8),
          _SummaryRow(
            label: 'Rate',
            value: 'SAR ${widget.court.pricePerHour.toInt()}/hr',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppTheme.border),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                ),
              ),
              Text(
                'SAR ${widget.totalAmount.toInt()}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _PaymentMethodChip(
              label: '💳 Card',
              isSelected: _selectedPaymentMethod == 0,
              onTap: () => setState(() => _selectedPaymentMethod = 0),
            ),
            const SizedBox(width: 10),
            _PaymentMethodChip(
              label: '🍎 Apple Pay',
              isSelected: _selectedPaymentMethod == 1,
              onTap: () => setState(() => _selectedPaymentMethod = 1),
            ),
            const SizedBox(width: 10),
            _PaymentMethodChip(
              label: '📱 STC Pay',
              isSelected: _selectedPaymentMethod == 2,
              onTap: () => setState(() => _selectedPaymentMethod = 2),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Card Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 12),
        // Card preview
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PADEL COURT',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text('P', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  _cardNumberController.text.isEmpty
                      ? '•••• •••• •••• ••••'
                      : _cardNumberController.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('CARDHOLDER', style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1)),
                        Text(
                          _cardNameController.text.isEmpty ? 'FULL NAME' : _cardNameController.text.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('EXPIRES', style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1)),
                        Text(
                          _expiryController.text.isEmpty ? 'MM/YY' : _expiryController.text,
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildInputField(
          label: 'Card Number',
          controller: _cardNumberController,
          hint: '1234 5678 9012 3456',
          keyboardType: TextInputType.number,
          formatter: _CardNumberFormatter(),
          maxLength: 19,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 14),
        _buildInputField(
          label: 'Cardholder Name',
          controller: _cardNameController,
          hint: 'Ahmed Al-Rashidi',
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                label: 'Expiry Date',
                controller: _expiryController,
                hint: 'MM/YY',
                keyboardType: TextInputType.number,
                formatter: _ExpiryFormatter(),
                maxLength: 5,
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildInputField(
                label: 'CVV',
                controller: _cvvController,
                hint: '•••',
                keyboardType: TextInputType.number,
                maxLength: 3,
                isObscure: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.lock_rounded, size: 14, color: AppTheme.success),
            const SizedBox(width: 6),
            Text(
              'Your payment is secured with 256-bit encryption',
              style: TextStyle(fontSize: 12, color: AppTheme.textMid),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAltPayment() {
    final method = _selectedPaymentMethod == 1 ? 'Apple Pay' : 'STC Pay';
    final icon = _selectedPaymentMethod == 1 ? '🍎' : '📱';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            'Pay with $method',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You will be redirected to complete\nyour payment securely',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppTheme.textMid, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    TextInputFormatter? formatter,
    int? maxLength,
    bool isObscure = false,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isObscure,
            maxLength: maxLength,
            onChanged: onChanged,
            inputFormatters: formatter != null ? [formatter] : null,
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.textDark,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppTheme.textLight, fontSize: 15),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              counterText: '',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: GestureDetector(
        onTap: _isLoading ? null : _pay,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: AppTheme.accent),
                  )
                : Text(
                    'Pay SAR ${widget.totalAmount.toInt()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textMid)),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textDark),
        ),
      ],
    );
  }
}

class _PaymentMethodChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _PaymentMethodChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : AppTheme.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.primary : AppTheme.border,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.textMid,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.length > 16) return oldValue;
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll('/', '');
    if (text.length > 4) return oldValue;
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(text[i]);
    }
    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}