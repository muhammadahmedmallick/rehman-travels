import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/price_models.dart';
import '../services/umrah_api_service.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/error_dialog.dart';

/// Package detail screen for displaying Umrah package information
class PackageDetailScreen extends StatefulWidget {
  final String slug;

  const PackageDetailScreen({
    Key? key,
    required this.slug,
  }) : super(key: key);

  @override
  State<PackageDetailScreen> createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen> {
  final UmrahApiService apiService = UmrahApiService();
  PackageContent? packageContent;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPackageContent();
  }

  Future<void> _loadPackageContent() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final content = await apiService.getPackageContent(widget.slug);
      if (mounted) {
        setState(() {
          packageContent = content;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  void _goToCalculator() {
    Navigator.of(context).pushNamed('/calculator');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Package Details'),
        elevation: 0,
        backgroundColor: const Color(0xFF1a73e8),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Color(0xFFD32F2F),
                      ),
                      const SizedBox(height: 16),
                      const Text('Failed to load package'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadPackageContent,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : packageContent == null
                  ? const Center(child: Text('No package data available'))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Banner image
                          if (packageContent!.images?.banner != null &&
                              packageContent!.images!.banner!.isNotEmpty)
                            Image.network(
                              packageContent!.images!.banner!,
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: 250,
                                  color: const Color(0xFFF0F0F0),
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            )
                          else
                            Container(
                              width: double.infinity,
                              height: 250,
                              color: const Color(0xFFF0F0F0),
                              child: const Icon(
                                Icons.card_travel,
                                size: 100,
                                color: Color(0xFF1a73e8),
                              ),
                            ),
                          // Content section
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  packageContent!.title ?? 'Umrah Package',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF202124),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Price
                                if (packageContent!.meta?.price != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1a73e8)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Starting from ﷼ ${packageContent!.meta!.price}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1a73e8),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 24),
                                // Description
                                if (packageContent!.content != null)
                                  _ContentRenderer(
                                    content: packageContent!.content!,
                                  ),
                                const SizedBox(height: 24),
                                // Includes/Excludes
                                if (packageContent!.meta?.includes != null &&
                                    packageContent!.meta!.includes!
                                        .isNotEmpty) ...[
                                  const Text(
                                    'What\'s Included',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF202124),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ..._buildBulletList(
                                    packageContent!.meta!.includes!,
                                    Icons.check_circle,
                                    const Color(0xFF1B7D34),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                                if (packageContent!.meta?.excludes != null &&
                                    packageContent!.meta!.excludes!
                                        .isNotEmpty) ...[
                                  const Text(
                                    'What\'s Not Included',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF202124),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ..._buildBulletList(
                                    packageContent!.meta!.excludes!,
                                    Icons.cancel,
                                    const Color(0xFFD32F2F),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                                // Book button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _goToCalculator,
                                    icon: const Icon(Icons.shopping_cart),
                                    label: const Text(
                                      'Book This Package',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFF1B7D34),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Customize button
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: _goToCalculator,
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Customize Package',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  List<Widget> _buildBulletList(
    List<String> items,
    IconData icon,
    Color color,
  ) {
    return items
        .map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 20, color: color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF5F6368),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }
}

class _ContentRenderer extends StatelessWidget {
  final ContentFormat content;

  const _ContentRenderer({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (content.markdown != null && content.markdown!.isNotEmpty) {
      return MarkdownBody(
        data: content.markdown!,
        styleSheet: MarkdownStyleSheet(
          h1: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF202124),
          ),
          h2: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF202124),
          ),
          h3: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF202124),
          ),
          p: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF5F6368),
            height: 1.6,
          ),
          em: const TextStyle(
            fontStyle: FontStyle.italic,
            color: Color(0xFF5F6368),
          ),
          strong: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF202124),
          ),
          blockquote: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF5F6368),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    if (content.html != null && content.html!.isNotEmpty) {
      // For now, just render the text portion
      // In a production app, you might use flutter_html package
      return Text(
        content.html!,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF5F6368),
          height: 1.6,
        ),
      );
    }

    return const Text('No content available');
  }
}
