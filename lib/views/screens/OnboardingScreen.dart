import 'package:flutter/material.dart';
import 'package:settleup_app/core/theme/app_spacing.dart';
import 'package:settleup_app/core/theme/app_text_style.dart';
import 'package:settleup_app/views/widgets/gradient_button.dart';
import 'package:settleup_app/views/widgets/onboarding_dots.dart';

class _OnboardingPageData {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
  });
}

const _pages = [
  _OnboardingPageData(
    icon: Icons.groups_rounded,
    title: "Harcamaları Birlikte Yönet",
    description:
        "Arkadaşlarınla ortak yaptığın harcamaları tek bir yerde topla, hiçbir masrafı unutma.",
  ),
  _OnboardingPageData(
    icon: Icons.pie_chart_rounded,
    title: "Kim Kime Ne Kadar Borçlu?",
    description:
        "Grup bakiyelerini anında gör, kimin alacaklı kimin borçlu olduğunu net bir şekilde takip et.",
  ),
  _OnboardingPageData(
    icon: Icons.handshake_rounded,
    title: "Kolayca Hesabı Kapat",
    description:
        "Tek dokunuşla ödemeleri dengele, aranızdaki hesabı adil ve hızlı bir şekilde kapatın.",
  ),
];

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinished;

  const OnboardingScreen({super.key, required this.onFinished});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  bool get _isLastPage => _currentPage == _pages.length - 1;

  void _goToNext() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
                child: Opacity(
                  opacity: _isLastPage ? 0 : 1,
                  child: TextButton(
                    onPressed: _isLastPage ? null : widget.onFinished,
                    child: const Text("Geç"),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary,
                                colorScheme.primary.withValues(alpha: 0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Icon(
                            page.icon,
                            size: 64,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.title.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            OnboardingDots(count: _pages.length, activeIndex: _currentPage),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: GradientButton(
                text: _isLastPage ? "Hemen Başla" : "İleri",
                isLoading: false,
                onTap: _isLastPage ? widget.onFinished : _goToNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
