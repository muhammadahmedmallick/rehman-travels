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
            leading: AppBackButton(),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: AppIconSize.lg),
                ),
                onPressed: () => _showFilters(context, searchState.flights),
              ),
              AppGap.hSm,
            ],
            title: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                params?['tripType'] == 'multi'
                    ? _multiCityRoute(params)
                    : '${params?['departureCode'] ?? 'ISB'}  ${(params?['tripType'] == 'round-trip') ? '⇄' : '→'}  ${params?['arrivalCode'] ?? 'KHI'}',
                style: AppTextStyles.titleSm.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                (params?['tripType'] == 'round-trip' && params?['inboundDate'] != null)
                    ? '${_formatDisplayDate(params?['outboundDate'])}  -  ${_formatDisplayDate(params?['inboundDate'])}'
                    : _formatDisplayDate(params?['outboundDate']),
                style: AppTextStyles.bodySm.copyWith(color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
              ),
            ]),
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
          padding: const EdgeInsets.all(AppSpacing.lg),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              AppGap.lg,
              Text(
                'Stops',
                style: AppTextStyles.titleMd,
              ),
              AppGap.sm,
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  FilterChip(
                    label: const Text('Direct'),
                    selected: tempStops.contains(0),
                    onSelected: (selected) {
                      setModalState(() {
                        if (selected) {
                          tempStops.add(0);
                        } else {
                          tempStops.remove(0);
                        }
                      });
                    },
                    selectedColor: AppColors.primaryLight,
                    checkmarkColor: AppColors.primary,
                  ),
                  FilterChip(
                    label: const Text('1 Stop'),
                    selected: tempStops.contains(1),
                    onSelected: (selected) {
                      setModalState(() {
                        if (selected) {
                          tempStops.add(1);
                        } else {
                          tempStops.remove(1);
                        }
                      });
                    },
                    selectedColor: AppColors.primaryLight,
                    checkmarkColor: AppColors.primary,
                  ),
                  FilterChip(
                    label: const Text('2+ Stops'),
                    selected: tempStops.contains(2),
                    onSelected: (selected) {
                      setModalState(() {
                        if (selected) {
                          tempStops.add(2);
                        } else {
                          tempStops.remove(2);
                        }
                      });
                    },
                    selectedColor: AppColors.primaryLight,
                    checkmarkColor: AppColors.primary,
                  ),
                ],
              ),
              if (availableAirlines.isNotEmpty) ...[
                AppGap.lg,
                Text(
                  'Airlines',
                  style: AppTextStyles.titleMd,
                ),
                AppGap.sm,
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: availableAirlines.map((airline) {
                    return FilterChip(
                      label: Text(
                        airline.length > 20 ? '${airline.substring(0, 20)}...' : airline,
                      ),
                      selected: tempAirlines.contains(airline),
                      onSelected: (selected) {
                        setModalState(() {
                          if (selected) {
                            tempAirlines.add(airline);
                          } else {
                            tempAirlines.remove(airline);
                          }
                        });
                      },
                      selectedColor: AppColors.primaryLight,
                      checkmarkColor: AppColors.primary,
                    );
                  }).toList(),
                ),
              ],
              AppGap.lg,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setModalState(() {
                          tempStops = {};
                          tempAirlines = {};
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                  AppGap.hMd,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedStops = tempStops;
                          _selectedAirlines = tempAirlines;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sort By',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            AppGap.sm,
            _SortOption(
              icon: Icons.arrow_downward,
              title: 'Price: Low to High',
              isSelected: _currentSort == 'price_asc',
              onTap: () {
                setState(() => _currentSort = 'price_asc');
                ref.read(flightSearchProvider.notifier).sortFlights('price_asc');
                Navigator.pop(context);
              },
            ),
            _SortOption(
              icon: Icons.arrow_upward,
              title: 'Price: High to Low',
              isSelected: _currentSort == 'price_desc',
              onTap: () {
                setState(() => _currentSort = 'price_desc');
                ref.read(flightSearchProvider.notifier).sortFlights('price_desc');
                Navigator.pop(context);
              },
            ),
            _SortOption(
              icon: Icons.access_time,
              title: 'Duration: Shortest',
              isSelected: _currentSort == 'duration',
              onTap: () {
                setState(() => _currentSort = 'duration');
                ref.read(flightSearchProvider.notifier).sortFlights('duration');
                Navigator.pop(context);
              },
            ),
            _SortOption(
              icon: Icons.schedule,
              title: 'Departure: Earliest',
              isSelected: _currentSort == 'departure',
              onTap: () {
                setState(() => _currentSort = 'departure');
                ref.read(flightSearchProvider.notifier).sortFlights('departure');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOption({
    required this.icon,
    required this.title,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm + 6),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
              )
            : null,
        child: Row(
          children: [
            Icon(
              icon,
              size: AppIconSize.xl - 2,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.sm + 6),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.titleMd.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, size: AppIconSize.lg, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
