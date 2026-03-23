import 'package:flutter/material.dart';
import '../main.dart';
import '../models/models.dart';
import 'court_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Indoor', 'Outdoor', 'Near Me', 'Top Rated'];

  List<Court> get _filteredCourts {
    if (_selectedFilter == 'Indoor') return sampleCourts.where((c) => c.isIndoor).toList();
    if (_selectedFilter == 'Outdoor') return sampleCourts.where((c) => !c.isIndoor).toList();
    if (_selectedFilter == 'Top Rated') {
      final sorted = [...sampleCourts]..sort((a, b) => b.rating.compareTo(a.rating));
      return sorted;
    }
    return sampleCourts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildSearchBar()),
          SliverToBoxAdapter(child: _buildFilters()),
          SliverToBoxAdapter(child: _buildFeaturedSection()),
          SliverToBoxAdapter(child: _buildSectionHeader('All Courts')),
          _buildCourtList(),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppTheme.surface,
      expandedHeight: 100,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.fromLTRB(24, 56, 24, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Good morning 👋',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textMid,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Find your court',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                      letterSpacing: -0.8,
                    ),
                  ),
                ],
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('AH', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(Icons.search_rounded, color: AppTheme.textLight, size: 20),
            const SizedBox(width: 10),
            Text(
              'Search courts, locations...',
              style: TextStyle(color: AppTheme.textLight, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.border,
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppTheme.textMid,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedSection() {
    final featured = sampleCourts[0];
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Featured',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CourtDetailScreen(court: featured)),
            ),
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  // Background pattern
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '⭐ Top Pick',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          featured.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          featured.location,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'SAR ${featured.pricePerHour.toInt()}',
                                  style: const TextStyle(
                                    color: AppTheme.accent,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  ' / hr',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Book Now',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppTheme.textDark,
          letterSpacing: -0.4,
        ),
      ),
    );
  }

  SliverList _buildCourtList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final court = _filteredCourts[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: _CourtCard(court: court),
          );
        },
        childCount: _filteredCourts.length,
      ),
    );
  }
}

class _CourtCard extends StatelessWidget {
  final Court court;
  const _CourtCard({required this.court});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CourtDetailScreen(court: court)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Court icon
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Center(
                  child: Text(court.emoji, style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          court.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Text('⭐', style: TextStyle(fontSize: 10)),
                              const SizedBox(width: 3),
                              Text(
                                court.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      court.location,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textMid,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _Tag(
                          label: court.isIndoor ? 'Indoor' : 'Outdoor',
                          color: court.isIndoor
                              ? const Color(0xFFEFF6FF)
                              : const Color(0xFFF0FDF4),
                          textColor: court.isIndoor
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF16A34A),
                        ),
                        const SizedBox(width: 6),
                        _Tag(
                          label: court.surface,
                          color: const Color(0xFFFFFBEB),
                          textColor: const Color(0xFFD97706),
                        ),
                        const Spacer(),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'SAR ${court.pricePerHour.toInt()}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              const TextSpan(
                                text: '/hr',
                                style: TextStyle(
                                  fontSize: 11,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _Tag({required this.label, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}