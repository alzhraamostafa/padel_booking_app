import 'package:flutter/material.dart';
import '../main.dart';
import '../models/models.dart';
import 'booking_screen.dart';

class CourtDetailScreen extends StatefulWidget {
  final Court court;
  const CourtDetailScreen({super.key, required this.court});

  @override
  State<CourtDetailScreen> createState() => _CourtDetailScreenState();
}

class _CourtDetailScreenState extends State<CourtDetailScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final court = widget.court;
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildHeroAppBar(court),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(court),
                  const SizedBox(height: 20),
                  _buildStats(court),
                  const SizedBox(height: 24),
                  _buildInfoSection(court),
                  const SizedBox(height: 24),
                  _buildAmenities(court),
                  const SizedBox(height: 24),
                  _buildReviewsTeaser(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(court),
    );
  }

  SliverAppBar _buildHeroAppBar(Court court) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: AppTheme.primary,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.white),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => setState(() => _isFavorite = !_isFavorite),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                size: 18,
                color: _isFavorite ? Colors.red : Colors.white,
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppTheme.primary,
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Center(
                child: Text(
                  court.emoji,
                  style: const TextStyle(fontSize: 80),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Court court) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                court.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                  letterSpacing: -0.8,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'SAR ${court.pricePerHour.toInt()}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const TextSpan(
                        text: '/hr',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textMid),
            const SizedBox(width: 4),
            Text(
              court.address,
              style: const TextStyle(fontSize: 13, color: AppTheme.textMid),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('⭐', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              '${court.rating}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${court.reviews} reviews)',
              style: const TextStyle(fontSize: 13, color: AppTheme.textMid),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStats(Court court) {
    return Row(
      children: [
        _StatBox(
          icon: '🏠',
          label: court.isIndoor ? 'Indoor' : 'Outdoor',
          sublabel: 'Type',
        ),
        const SizedBox(width: 12),
        _StatBox(
          icon: '🌿',
          label: 'Artificial',
          sublabel: 'Surface',
        ),
        const SizedBox(width: 12),
        _StatBox(
          icon: '💡',
          label: court.hasLighting ? 'Yes' : 'No',
          sublabel: 'Lighting',
        ),
      ],
    );
  }

  Widget _buildInfoSection(Court court) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${court.name} is one of the premium padel courts in ${court.location}. Featuring ${court.isIndoor ? "a fully enclosed indoor" : "an open-air"} court with professional-grade ${court.surface.toLowerCase()}, it provides an excellent playing experience for all skill levels.',
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textMid,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenities(Court court) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amenities',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: court.amenities
              .map((a) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Text(
                      a,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildReviewsTeaser() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              Text(
                'See all ${widget.court.reviews}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._buildReviewItems(),
        ],
      ),
    );
  }

  List<Widget> _buildReviewItems() {
    final reviews = [
      ('Ahmed K.', '5', 'Amazing court! Very well maintained and the staff are super helpful.'),
      ('Sara M.', '4', 'Great experience overall. Love the indoor facility — will definitely come back.'),
    ];
    return reviews.map((r) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  r.$1,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                Row(
                  children: [
                    Text('⭐ ${r.$2}', style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              r.$3,
              style: const TextStyle(fontSize: 13, color: AppTheme.textMid, height: 1.4),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildBottomBar(Court court) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookingScreen(court: court)),
        ),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              'Book This Court',
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
    );
  }
}

class _StatBox extends StatelessWidget {
  final String icon;
  final String label;
  final String sublabel;

  const _StatBox({required this.icon, required this.label, required this.sublabel});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            Text(
              sublabel,
              style: const TextStyle(fontSize: 11, color: AppTheme.textLight),
            ),
          ],
        ),
      ),
    );
  }
}