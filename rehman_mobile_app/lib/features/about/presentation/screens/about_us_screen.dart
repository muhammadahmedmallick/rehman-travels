import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/app_back_button.dart';
import '../../../branches/presentation/providers/branch_provider.dart';

class AboutUsScreen extends ConsumerStatefulWidget {
  const AboutUsScreen({super.key});

  @override
  ConsumerState<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends ConsumerState<AboutUsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final isCollapsed = _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight - 20);
    if (isCollapsed != _isCollapsed) {
      setState(() {
        _isCollapsed = isCollapsed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: AppBackButton(),
            title: AnimatedOpacity(
              opacity: _isCollapsed ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                'About Rehman Travels',
                style: AppTextStyles.titleMd.copyWith(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.heroGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: AppPadding.card,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: const Icon(
                            Icons.flight_takeoff,
                            color: Colors.white,
                            size: AppIconSize.xxl,
                          ),
                        ),
                        AppGap.md,
                        Text(
                          'About Rehman Travels',
                          style: AppTextStyles.h2.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        AppGap.xs,
                        Text(
                          'Your Trusted Partner in Travel',
                          style: AppTextStyles.bodyLg.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Overview
                  _buildSectionCard(
                    context,
                    icon: Icons.business,
                    title: 'Who We Are',
                    child: Text(
                      'Rehman Travels has established itself as a premier travel agency renowned for its comprehensive services and customer-centric approach. With a robust network of partners and a team of experienced professionals, Rehman Travels is committed to making every journey seamless, enjoyable, and memorable.\n\nWhether planning a business trip, a family vacation, or a solo adventure, Rehman Travels is your trusted partner in travel, offering a wide range of services to cater to all your travel needs.',
                      style: AppTextStyles.bodyLg.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ),

                  AppGap.md,

                  // Services Section Title
                  Text(
                    'Our Services',
                    style: AppTextStyles.h3,
                  ),
                  AppGap.md,

                  // Services Grid
                  _buildServiceCard(
                    context,
                    icon: Icons.flight,
                    title: 'Flight Booking',
                    description:
                        'Rehman Travels provides hassle-free flight booking services, offering competitive rates on domestic and international flights. With a user-friendly online booking system and a dedicated team of travel experts, we ensure the flight booking process is smooth and straightforward. Using advanced technology and partnerships with major airlines, Rehman Travels ensures that customers get the best deals and the most convenient flight schedules.',
                    color: AppColors.info,
                  ),

                  AppGap.sm,

                  _buildServiceCard(
                    context,
                    icon: Icons.article_outlined,
                    title: 'Visa Assistance',
                    description:
                        'Navigating the complexities of visa applications can be daunting. Rehman Travels simplifies this process by offering professional visa assistance services, ensuring that every step of the application is handled with precision and expertise. We provide accurate and up-to-date information on visa requirements for a wide range of destinations.',
                    color: AppColors.secondary,
                  ),

                  AppGap.sm,

                  _buildServiceCard(
                    context,
                    icon: Icons.hotel,
                    title: 'Hotel Reservations',
                    description:
                        'Finding the right accommodation is crucial for a comfortable travel experience. Rehman Travels offers extensive hotel reservation services designed to meet diverse needs and preferences. With a global network of hotel partners, we offer an impressive array of accommodation options from luxury resorts to budget-friendly lodgings.',
                    color: AppColors.accent,
                  ),

                  AppGap.sm,

                  _buildServiceCard(
                    context,
                    icon: Icons.mosque,
                    title: 'Umrah & Hajj Packages',
                    description:
                        'For those undertaking the sacred journeys of Umrah and Hajj, Rehman Travels offers specialized packages that are meticulously designed to ensure a smooth and enriching pilgrimage experience. Our comprehensive packages include flights, accommodations, guided tours, and additional services.',
                    color: const Color(0xFFD4AF37),
                  ),

                  AppGap.sm,

                  _buildServiceCard(
                    context,
                    icon: Icons.tour,
                    title: 'Customized Tour Packages',
                    description:
                        'Rehman Travels excels in creating customized tour packages tailored to individual preferences and interests. Whether you are looking for an adventurous trek, a relaxing beach holiday, or a cultural exploration, we craft personalized itineraries that go beyond the ordinary.',
                    color: AppColors.warning,
                  ),

                  AppGap.sm,

                  _buildServiceCard(
                    context,
                    icon: Icons.directions_car,
                    title: 'Car Rentals',
                    description:
                        'For travelers who prefer the flexibility of exploring destinations at their own pace, Rehman Travels offers reliable and comprehensive car rental services. We provide a range of vehicles to suit different preferences and needs, coupled with competitive rental rates.',
                    color: Colors.purple,
                  ),

                  AppGap.sm,

                  _buildServiceCard(
                    context,
                    icon: Icons.business_center,
                    title: 'Corporate Travel Management',
                    description:
                        'Rehman Travels understands the unique needs of business travelers and offers specialized corporate travel management services. Our comprehensive services include flight and hotel bookings, itinerary management, and 24/7 support.',
                    color: AppColors.primaryDark,
                  ),

                  AppGap.sm,

                  _buildServiceCard(
                    context,
                    icon: Icons.public,
                    title: 'World Tours & Pakistan Tours',
                    description:
                        'Whether you\'re dreaming of exploring global destinations or discovering the hidden gems of Pakistan, we provide tailored packages that cater to various interests, budgets, and travel styles.',
                    color: AppColors.success,
                  ),

                  AppGap.sm,

                  _buildServiceCard(
                    context,
                    icon: Icons.store,
                    title: 'Franchise Opportunities',
                    description:
                        'Rehman Travels presents lucrative franchising opportunities for entrepreneurs looking to enter the dynamic and rewarding travel industry. As a franchisee, you gain immediate access to a trusted brand that customers recognize and trust.',
                    color: Colors.deepOrange,
                  ),

                  AppGap.lg,

                  // Popular Airlines Section
                  _buildPartnersSection(
                    context,
                    icon: Icons.airlines,
                    title: 'Popular Airlines',
                    partners: const [
                      'Emirates',
                      'Qatar Airways',
                      'Etihad Airways',
                      'Turkish Airlines',
                      'PIA',
                      'Saudi Airlines',
                      'British Airways',
                      'Fly Dubai',
                      'Air Arabia',
                      'AirBlue',
                      'AirSial',
                      'Fly Jinnah',
                      'Serene Air',
                      'Gulf Air',
                      'Oman Air',
                      'Kuwait Airways',
                      'Kenya Airways',
                      'Cathay Pacific',
                      'Singapore Airlines',
                      'Thai Airways',
                      'Lufthansa',
                      'KLM Airlines',
                      'American Airlines',
                      'Air Canada',
                      'Air China',
                      'Air Asia',
                      'Air Malindo',
                      'Austrian Airlines',
                      'SriLankan Airlines',
                      'Ryanair',
                      'EasyJet',
                    ],
                  ),

                  AppGap.md,

                  // Popular Hotels Section
                  _buildPartnersSection(
                    context,
                    icon: Icons.hotel,
                    title: 'Popular Hotels',
                    partners: const [
                      'Pullman Zamzam Makkah',
                      'Swissotel Makkah',
                      'Fairmont Clock Tower Makkah',
                      'Hilton Makkah Convention Hotel',
                      'Makkah Millennium Hotel',
                      'Dar Al Tawhid Intercontinental',
                      'Movenpick Hajar Tower',
                      'Makarim Ajyad Hotel',
                      'Pullman Zamzam Madina',
                      'Dar Al Hijra Intercontinental',
                      'Madinah Hilton Hotel',
                      'Dar Al Taqwa',
                      'Al Haram Hotel',
                      'Anjum Hotel',
                      'Al Marwa Rayhaan By Rotana',
                      'Serena Hotel Islamabad',
                      'Marriott Hotel Islamabad',
                      'Marriott Hotel Karachi',
                      'Serena Hotel Quetta',
                      'Serena Hotel Faisalabad',
                      'Serena Hotel Gilgit',
                      'Serena Hotel Hunza',
                      'Serena Hotel Swat',
                      'Serena Hotel Khaplu',
                      'Serena Hotel Shigar Fort',
                    ],
                  ),

                  AppGap.lg,

                  // Our Branches Section
                  _buildBranchesSection(),

                  AppGap.lg,

                  // Contact Section
                  _buildContactSection(),

                  AppGap.lg,

                  // Website Link
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Visit us at',
                          style: AppTextStyles.bodyLg.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        AppGap.xs,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            'www.rehmantravel.com',
                            style: AppTextStyles.titleMd.copyWith(
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: AppIconSize.xl,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                title,
                style: AppTextStyles.titleLg,
              ),
            ],
          ),
          AppGap.md,
          child,
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.soft,
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(
            icon,
            color: color,
            size: AppIconSize.xl,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.titleMd.copyWith(
            fontSize: 16,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Text(
              description,
              style: AppTextStyles.bodyLg.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnersSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<String> partners,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  icon,
                  color: AppColors.accent,
                  size: AppIconSize.xl,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                title,
                style: AppTextStyles.titleLg,
              ),
            ],
          ),
          AppGap.md,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: partners.map((partner) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm + 4,
                  vertical: AppSpacing.xs + 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  partner,
                  style: AppTextStyles.bodyMd.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchesSection() {
    final branchState = ref.watch(branchProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.secondary,
                  size: AppIconSize.xl,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Our Branches',
                style: AppTextStyles.titleLg,
              ),
            ],
          ),
          AppGap.md,
          if (branchState.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2.5,
                ),
              ),
            )
          else if (branchState.error != null)
            Center(
              child: Padding(
                padding: AppPadding.cardLg,
                child: Column(
                  children: [
                    Text(
                      branchState.error!,
                      style: AppTextStyles.bodyLg.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppGap.sm,
                    TextButton(
                      onPressed: () => ref.read(branchProvider.notifier).refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else
            ...branchState.branches.map((branch) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _buildBranchCard(branch),
                )),
        ],
      ),
    );
  }

  Widget _buildBranchCard(Branch branch) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Branch name + flag
          Row(
            children: [
              Text(
                branch.flagEmoji,
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  branch.branchName,
                  style: AppTextStyles.titleMd.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: AppIconSize.md,
                color: AppColors.textHint,
              ),
              AppGap.hSm,
              Expanded(
                child: Text(
                  branch.branchAddress,
                  style: AppTextStyles.bodyLg.copyWith(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Action buttons
          Row(
            children: [
              if (branch.hasPhone)
                Expanded(
                  child: GestureDetector(
                    onTap: () => _launchUrl('tel:${branch.branchPhone}'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.phone_outlined,
                            size: AppIconSize.md,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            branch.branchPhone,
                            style: AppTextStyles.labelLg.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (branch.hasPhone && branch.hasMap)
                AppGap.hSm,
              if (branch.hasMap)
                GestureDetector(
                  onTap: () => _launchUrl(branch.mapAddress),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Icon(
                      Icons.map_outlined,
                      size: AppIconSize.lg - 2,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      width: double.infinity,
      padding: AppPadding.screenHLg,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm + 2),
                ),
                child: const Icon(
                  Icons.headset_mic_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              AppGap.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need Assistance?',
                      style: AppTextStyles.titleMd.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'We\'re here to help 24/7',
                      style: AppTextStyles.bodyLg.copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          AppGap.md,

          // Contact Buttons Row
          Row(
            children: [
              Expanded(
                child: _buildContactButton(
                  icon: Icons.phone_outlined,
                  label: 'Call Us',
                  color: AppColors.primary,
                  onTap: () => _launchUrl('tel:+‪+923111786785‬'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildContactButton(
                  icon: Icons.chat_outlined,
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  onTap: () => _launchUrl('https://wa.me/‪+923111786785‬'),
                ),
              ),
            ],
          ),

          AppGap.md,

          // Divider
          Container(
            height: 1,
            color: AppColors.divider,
          ),

          AppGap.md,

          // Social Media Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Follow us',
                style: AppTextStyles.bodyLg.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textHint,
                ),
              ),
              AppGap.hLg,
              _buildSocialIcon(
                icon: Icons.facebook,
                color: const Color(0xFF1877F2),
                onTap: () => _launchUrl('https://www.facebook.com/rehmantravelofficial'),
              ),
              AppGap.hMd,
              _buildSocialIcon(
                icon: Icons.camera_alt_outlined,
                color: const Color(0xFFE4405F),
                onTap: () => _launchUrl('https://www.instagram.com/rehmantravelsofficial'),
              ),
              AppGap.hMd,
              _buildSocialIconText(
                text: 'X',
                color: Colors.black,
                onTap: () => _launchUrl('https://twitter.com/rehmantravel'),
              ),
              AppGap.hMd,
              _buildSocialIcon(
                icon: Icons.play_circle_outline,
                color: const Color(0xFFFF0000),
                onTap: () => _launchUrl('https://youtube.com/@rehmantravel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.sm + 2),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: AppIconSize.lg - 2),
            AppGap.hSm,
            Text(
              label,
              style: AppTextStyles.labelLg.copyWith(
                fontSize: 13,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: AppIconSize.lg - 2),
      ),
    );
  }

  Widget _buildSocialIconText({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.titleSm.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
