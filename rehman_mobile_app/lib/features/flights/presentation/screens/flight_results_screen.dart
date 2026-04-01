import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/app_back_button.dart';
import '../providers/flight_search_provider.dart';
import '../widgets/flight_card.dart';

class FlightResultsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? searchParams;

  const FlightResultsScreen({super.key, this.searchParams});

  @override
  ConsumerState<FlightResultsScreen> createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends ConsumerState<FlightResultsScreen> {
  String _currentSort = 'price_asc';
  Set<int> _selectedStops = {};
  Set<String> _selectedAirlines = {};

  @override
  void initState() {
    super.initState();
    if (widget.searchParams != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(flightSearchProvider.notifier).searchFlights(widget.searchParams!);
      });
    }
  }

  String _formatDisplayDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'Select Date';
    try {
      // Try dd-MM-yyyy first, then yyyy-MM-dd
      DateTime parsed;
      if (dateStr.contains('-') && dateStr.indexOf('-') == 2) {
        parsed = DateFormat('dd-MM-yyyy').parseStrict(dateStr);
      } else {
        parsed = DateFormat('yyyy-MM-dd').parseStrict(dateStr);
      }
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (_) {
      return dateStr;
    }
  }

  String _multiCityTitle(Map<String, dynamic>? params) {
    final legs = params?['legs'] as List?;
    if (legs == null || legs.isEmpty) return 'Multi-City';
    final first = (legs.first as Map)['departureCode'] ?? '';
    final last = (legs.last as Map)['arrivalCode'] ?? '';
    return '$first - $last';
  }

  String _multiCityRoute(Map<String, dynamic>? params) {
    final legs = params?['legs'] as List?;
    if (legs == null || legs.isEmpty) return 'Multi-City';
    final codes = legs.map((l) => (l as Map)['departureCode'] ?? '').toList();
    codes.add((legs.last as Map)['arrivalCode'] ?? '');
    return codes.join('  >  ');
  }

  List<Map<String, dynamic>> _getFilteredFlights(List<Map<String, dynamic>> flights) {
    var filtered = flights;

    if (_selectedStops.isNotEmpty) {
      filtered = filtered.where((f) {
        final stops = (f['stops'] as int?) ?? 0;
        if (_selectedStops.contains(2)) {
          // "2+ Stops" means stops >= 2
          return _selectedStops.contains(stops) || (stops >= 2 && _selectedStops.contains(2));
        }
        return _selectedStops.contains(stops);
      }).toList();
    }

    if (_selectedAirlines.isNotEmpty) {
      filtered = filtered.where((f) {
        final airline = f['airlineName'] as String? ?? '';
        return _selectedAirlines.contains(airline);
      }).toList();
    }

    return filtered;
  }

  Set<String> _getAvailableAirlines(List<Map<String, dynamic>> flights) {
    return flights
        .map((f) => f['airlineName'] as String? ?? '')
        .where((name) => name.isNotEmpty)
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(flightSearchProvider);
    final params = widget.searchParams;
    final filteredFlights = _getFilteredFlights(searchState.flights);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // Sliver App Bar
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            surfaceTintColor: AppColors.primary,
            elevation: 0,
            leading: AppBackButton(),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: AppIconSize.lg),
                ),
                onPressed: () => _showFilters(context, searchState.flights),
              ),
              AppGap.hSm,
            ],
            title: Text('Flight Results', style: AppTextStyles.titleLg.copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                color: AppColors.primary,
                child: Row(children: [
                  // Departure
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(params?['departureCode'] ?? 'ISB', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                    Text(_formatDisplayDate(params?['outboundDate']), style: TextStyle(fontSize: 10, color: Colors.white)),
                  ]),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(children: [
                      Row(children: [
                        Container(width: 5, height: 5, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5))),
                        Expanded(child: Container(height: 1, color: Colors.white)),
                        Transform.rotate(angle: 1.5708, child: Icon(Icons.flight, size: 14, color: Colors.white)),
                        Expanded(child: Container(height: 1, color: Colors.white)),
                        Container(width: 5, height: 5, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
                      ]),
                      const SizedBox(height: 4),
                      Text('${filteredFlights.length} Results Found', style: TextStyle(fontSize: 10, color: Colors.white)),
                    ]),
                  )),
                  // Arrival
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(params?['arrivalCode'] ?? 'KHI', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                    if (params?['inboundDate'] != null)
                      Text(_formatDisplayDate(params?['inboundDate']), style: TextStyle(fontSize: 10, color: Colors.white))
                    else
                      Text(_formatDisplayDate(params?['outboundDate']), style: TextStyle(fontSize: 10, color: Colors.white)),
                  ]),
                ]),
              ),
            ),
          ),

          // Search Progress
          if (searchState.isSearching)
            SliverToBoxAdapter(
              child: Container(
                padding: AppPadding.section,
                color: AppColors.primaryLight,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                    AppGap.hMd,
                    Expanded(
                      child: Text(
                          'Searching',
                        style: AppTextStyles.bodyLg.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Active Filters Indicator
          if (_selectedStops.isNotEmpty || _selectedAirlines.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm + 4, AppSpacing.md, 0),
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    if (_selectedStops.isNotEmpty)
                      ..._selectedStops.map((s) => Chip(
                            label: Text(
                              s == 0 ? 'Direct' : s == 1 ? '1 Stop' : '2+ Stops',
                              style: AppTextStyles.bodyMd,
                            ),
                            deleteIcon: Icon(Icons.close, size: AppIconSize.md),
                            onDeleted: () {
                              setState(() => _selectedStops.remove(s));
                            },
                            visualDensity: VisualDensity.compact,
                          )),
                    if (_selectedAirlines.isNotEmpty)
                      ..._selectedAirlines.map((a) => Chip(
                            label: Text(
                              a.length > 15 ? '${a.substring(0, 15)}...' : a,
                              style: AppTextStyles.bodyMd,
                            ),
                            deleteIcon: Icon(Icons.close, size: AppIconSize.md),
                            onDeleted: () {
                              setState(() => _selectedAirlines.remove(a));
                            },
                            visualDensity: VisualDensity.compact,
                          )),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedStops = {};
                          _selectedAirlines = {};
                        });
                      },
                      child: Chip(
                        label: Text('Clear All', style: AppTextStyles.bodyMd.copyWith(color: AppColors.error)),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Results Header
          if (searchState.flights.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filteredFlights.length} flight${filteredFlights.length != 1 ? 's' : ''} found',
                      style: AppTextStyles.titleSm.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showSortOptions(context),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: AppPadding.card.copyWith(top: 0, bottom: 0),
                      ),
                      icon: Icon(Icons.sort, size: AppIconSize.lg - 2),
                      label: const Text('Sort'),
                    ),
                  ],
                ),
              ),
            ),

          // Flight List or States
          if (searchState.isSearching && searchState.flights.isEmpty)
            SliverPadding(
              padding: AppPadding.cardLg,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildShimmerCard(),
                  childCount: 5,
                ),
              ),
            )
          else if (searchState.flights.isEmpty && !searchState.isSearching)
            SliverFillRemaining(
              child: _buildEmptyState(),
            )
          else if (searchState.error != null && searchState.flights.isEmpty)
            SliverFillRemaining(
              child: _buildErrorState(searchState.error!),
            )
          else if (filteredFlights.isEmpty)
            SliverFillRemaining(
              child: _buildNoFilterResults(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, 4, AppSpacing.md, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final flight = filteredFlights[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
                      child: FlightCard(
                        flight: flight,
                        isCheapest: index == 0,
                        onTap: () {
                          context.push(
                            '/flights/details/${flight['id'] ?? index}',
                            extra: flight,
                          );
                        },
                      ),
                    );
                  },
                  childCount: filteredFlights.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 160,
        margin: const EdgeInsets.only(bottom: AppSpacing.sm + 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.flight_outlined,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            AppGap.lg,
            Text(
              'No flights found',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            AppGap.sm,
            Text(
              'Try different dates or airports',
              style: AppTextStyles.bodyLg.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppGap.lg,
            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('Modify Search'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoFilterResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.filter_list_off,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            AppGap.lg,
            Text(
              'No matching flights',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            AppGap.sm,
            Text(
              'Try adjusting your filters',
              style: AppTextStyles.bodyLg.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppGap.lg,
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _selectedStops = {};
                  _selectedAirlines = {};
                });
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
            ),
            AppGap.lg,
            Text(
              'Something went wrong',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            AppGap.sm,
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLg.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppGap.lg,
            ElevatedButton(
              onPressed: () {
                if (widget.searchParams != null) {
                  ref.read(flightSearchProvider.notifier).searchFlights(widget.searchParams!);
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilters(BuildContext context, List<Map<String, dynamic>> allFlights) {
    final availableAirlines = _getAvailableAirlines(allFlights);
    var tempStops = Set<int>.from(_selectedStops);
    var tempAirlines = Set<String>.from(_selectedAirlines);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Handle
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(children: [
              Text('Filters', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w800)),
              const Spacer(),
              GestureDetector(
                onTap: () { setModalState(() { tempStops = {}; tempAirlines = {}; }); },
                child: Text('Reset', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.error)),
              ),
            ]),
            const SizedBox(height: 20),

            // Stops
            Text('Stops', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            Row(children: [
              _filterChip('Direct', tempStops.contains(0), () => setModalState(() => tempStops.contains(0) ? tempStops.remove(0) : tempStops.add(0))),
              const SizedBox(width: 8),
              _filterChip('1 Stop', tempStops.contains(1), () => setModalState(() => tempStops.contains(1) ? tempStops.remove(1) : tempStops.add(1))),
              const SizedBox(width: 8),
              _filterChip('2+ Stops', tempStops.contains(2), () => setModalState(() => tempStops.contains(2) ? tempStops.remove(2) : tempStops.add(2))),
            ]),

            if (availableAirlines.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text('Airlines', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 8, children: availableAirlines.map((airline) {
                final selected = tempAirlines.contains(airline);
                return _filterChip(
                  airline.length > 18 ? '${airline.substring(0, 18)}...' : airline,
                  selected,
                  () => setModalState(() => selected ? tempAirlines.remove(airline) : tempAirlines.add(airline)),
                );
              }).toList()),
            ],

            const SizedBox(height: 24),
            SizedBox(width: double.infinity, height: 48, child: ElevatedButton(
              onPressed: () { setState(() { _selectedStops = tempStops; _selectedAirlines = tempAirlines; }); Navigator.pop(context); },
              child: const Text('Apply Filters'),
            )),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ]),
        ),
      ),
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.textPrimary)),
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Text('Sort By', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          _sortOption(Icons.trending_down, 'Price: Low to High', 'price_asc'),
          _sortOption(Icons.trending_up, 'Price: High to Low', 'price_desc'),
          _sortOption(Icons.timer_outlined, 'Duration: Shortest', 'duration'),
          _sortOption(Icons.schedule, 'Departure: Earliest', 'departure'),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ]),
      ),
    );
  }

  Widget _sortOption(IconData icon, String title, String sortKey) {
    final isSelected = _currentSort == sortKey;
    return GestureDetector(
      onTap: () {
        setState(() => _currentSort = sortKey);
        ref.read(flightSearchProvider.notifier).sortFlights(sortKey);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: isSelected ? AppColors.primary : AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: isSelected ? AppColors.primary : AppColors.textPrimary))),
          if (isSelected) const Icon(Icons.check_circle, size: 20, color: AppColors.primary),
        ]),
      ),
    );
  }
}
