import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/theme.dart';
import '../providers/visa_provider.dart';

class VisaServicesScreen extends ConsumerStatefulWidget {
  const VisaServicesScreen({super.key});

  @override
  ConsumerState<VisaServicesScreen> createState() => _VisaServicesScreenState();
}

class _VisaServicesScreenState extends ConsumerState<VisaServicesScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visaState = ref.watch(visaListProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: visaState.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2))
                : visaState.error != null
                    ? _buildError(visaState.error!)
                    : _buildContent(visaState),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1B4B), Color(0xFF252670)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(children: [
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.article_outlined, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Visa Services', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.3)),
                Text('Easy processing for all countries', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.5))),
              ])),
            ]),
          ),

          // Search
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => ref.read(visaListProvider.notifier).setSearchQuery(v),
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search country or visa type...',
                hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          ref.read(visaListProvider.notifier).setSearchQuery('');
                        },
                        child: Icon(Icons.close_rounded, color: AppColors.textHint, size: 18),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.08), shape: BoxShape.circle),
            child: const Icon(Icons.error_outline_rounded, size: 32, color: AppColors.error),
          ),
          const SizedBox(height: 16),
          const Text('Failed to load visa services', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(error, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () => ref.read(visaListProvider.notifier).refresh(), child: const Text('Try Again')),
        ]),
      ),
    );
  }

  Widget _buildContent(VisaListState visaState) {
    final filteredVisas = visaState.filteredVisas;

    return RefreshIndicator(
      onRefresh: () => ref.read(visaListProvider.notifier).refresh(),
      color: AppColors.primary,
      child: filteredVisas.isEmpty
          ? ListView(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(color: AppColors.surfaceLight, shape: BoxShape.circle),
                    child: Icon(Icons.search_off_rounded, size: 28, color: AppColors.textHint),
                  ),
                  const SizedBox(height: 12),
                  Text('No visa services found', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                ])),
              ),
            ])
          : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: filteredVisas.length,
              itemBuilder: (context, index) {
                final visa = filteredVisas[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _VisaCard(visa: visa, onTap: () => context.push('/visa/details', extra: visa.urlLink)),
                );
              },
            ),
    );
  }
}

class _VisaCard extends StatelessWidget {
  final VisaService visa;
  final VoidCallback onTap;

  const _VisaCard({required this.visa, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 3))],
        ),
        child: Row(children: [
          // Image
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
            ),
            clipBehavior: Clip.antiAlias,
            child: visa.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: visa.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => const Center(child: Icon(Icons.public_rounded, color: AppColors.primary, size: 24)),
                    errorWidget: (_, _, _) => const Center(child: Icon(Icons.public_rounded, color: AppColors.primary, size: 24)),
                  )
                : const Center(child: Icon(Icons.public_rounded, color: AppColors.primary, size: 24)),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(visa.packageTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
            if (visa.countryName != null) ...[
              const SizedBox(height: 4),
              Row(children: [
                Icon(Icons.location_on_outlined, size: 13, color: AppColors.textHint),
                const SizedBox(width: 3),
                Text(visa.countryName!, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ]),
            ],
          ])),

          // Arrow
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.primary),
          ),
        ]),
      ),
    );
  }
}
