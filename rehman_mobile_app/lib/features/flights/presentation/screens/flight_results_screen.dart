import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app/theme.dart';
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
      final parsed = DateFormat('dd-MM-yyyy').parseStrict(dateStr);
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (_) {
      return dateStr;
    }
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
            expandedHeight: 120,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: 20),
                ),
                onPressed: () => _showFilters(context, searchState.flights),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.heroGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(56, 0, 56, 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              params?['departureCode'] ?? 'ISB',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(
                                Icons.flight,
                                color: Colors.white.withValues(alpha: 0.8),
                                size: 20,
                              ),
                            ),
                            Text(
                              params?['arrivalCode'] ?? 'KHI',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDisplayDate(params?['outboundDate']),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Search Progress
          if (searchState.isSearching)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        searchState.currentProvider.isNotEmpty
                            ? 'Searching ${searchState.currentProvider}... (${searchState.processedCount}/${searchState.totalProviders})'
                            : 'Searching ${searchState.processedCount}/${searchState.totalProviders} providers...',
                        style: const TextStyle(
                          fontSize: 14,
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
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    if (_selectedStops.isNotEmpty)
                      ..._selectedStops.map((s) => Chip(
                            label: Text(
                              s == 0 ? 'Direct' : s == 1 ? '1 Stop' : '2+ Stops',
                              style: const TextStyle(fontSize: 12),
                            ),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              setState(() => _selectedStops.remove(s));
                            },
                            visualDensity: VisualDensity.compact,
                          )),
                    if (_selectedAirlines.isNotEmpty)
                      ..._selectedAirlines.map((a) => Chip(
                            label: Text(
                              a.length > 15 ? '${a.substring(0, 15)}...' : a,
                              style: const TextStyle(fontSize: 12),
                            ),
                            deleteIcon: const Icon(Icons.close, size: 16),
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
                      child: const Chip(
                        label: Text('Clear All', style: TextStyle(fontSize: 12, color: AppColors.error)),
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filteredFlights.length} flight${filteredFlights.length != 1 ? 's' : ''} found',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showSortOptions(context),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      icon: const Icon(Icons.sort, size: 18),
                      label: const Text('Sort'),
                    ),
                  ],
                ),
              ),
            ),

          // Flight List or States
          if (searchState.isSearching && searchState.flights.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.all(16),
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
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final flight = filteredFlights[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FlightCard(
                        flight: flight,
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
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 24),
            const Text(
              'No flights found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try different dates or airports',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 24),
            const Text(
              'No matching flights',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your filters',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 24),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
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
          padding: const EdgeInsets.all(24),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Stops',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
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
                const SizedBox(height: 20),
                const Text(
                  'Airlines',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
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
              const SizedBox(height: 24),
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
                  const SizedBox(width: 12),
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
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, size: 20, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
