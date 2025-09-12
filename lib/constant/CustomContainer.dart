

import 'package:nextgen_learners/constant/import_export.dart';

class CustomContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final String newPage;
  final String img;
  final Color primaryColor;
  final Color secondaryColor;
  final int delay;

  const CustomContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.newPage,
    required this.img,
    required this.primaryColor,
    required this.secondaryColor,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    // Navigation is handled via named routes; data is fetched inside screens.

    return LayoutBuilder(
      builder: (context, constraints) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 1000 + delay),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: GestureDetector(
                onTap: () => Get.toNamed(newPage),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight,
                    maxWidth: constraints.maxWidth,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primaryColor, secondaryColor],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: _buildMainContent(context, value, constraints),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    double animationValue,
    BoxConstraints constraints,
  ) {
    final imageSize = constraints.maxWidth * 0.3;
    final maxImageSize = 100.0;
    final finalImageSize = imageSize > maxImageSize ? maxImageSize : imageSize;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: Duration(milliseconds: 800 + delay),
            curve: Curves.easeOutBack,
            builder: (context, imageScale, child) {
              return Transform.scale(
                scale: imageScale,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: finalImageSize,
                    width: finalImageSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      img,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => const Icon(
                            Icons.error,
                            size: 40,
                            color: Colors.red,
                          ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.fredoka(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.fredoka(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
