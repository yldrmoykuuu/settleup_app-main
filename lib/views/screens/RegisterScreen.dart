import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settleup_app/core/components/InputTextField.dart';
import 'package:settleup_app/core/theme/app_spacing.dart';
import 'package:settleup_app/core/theme/app_text_style.dart';
import 'package:settleup_app/viewmodels/auth_viewmodel.dart';
import 'package:settleup_app/views/screens/LoginScreen.dart';
import 'package:settleup_app/views/widgets/gradient_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister(AuthViewModel vm) async {
    final error = await vm.register(
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
    // Başarılı kayıtta AuthWrapper, authStateChanges akışı üzerinden
    // otomatik olarak Dashboard'a yönlendirir.
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHero(context, colorScheme),
                          const SizedBox(height: AppSpacing.xl),

                          InputTextField(
                            hintText: "Kullanıcı adı",
                            controller: usernameController,
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          InputTextField(
                            hintText: "Email",
                            controller: emailController,
                            icon: Icons.mail_outline,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          InputTextField(
                            hintText: "Şifre",
                            controller: passwordController,
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),

                          const SizedBox(height: AppSpacing.md),

                          GradientButton(
                            text: "Kayıt Ol",
                            isLoading: vm.isLoading,
                            onTap: () => _handleRegister(vm),
                          ),
                        ],
                      ),
                    ),
                  ),

                  _buildDivider(context),
                  const SizedBox(height: AppSpacing.md),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            const TextSpan(text: "Zaten hesabın var mı? "),
                            TextSpan(
                              text: "Giriş yap",
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildFooter(context),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.15);
    return Row(
      children: [
        Expanded(child: Divider(color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text("veya", style: Theme.of(context).textTheme.bodySmall),
        ),
        Expanded(child: Divider(color: color)),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Center(
      child: Text(
        "v1.0.0 • OrtakHesap Team",
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  Widget _buildHero(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(
            Icons.group_add_rounded,
            size: 44,
            color: colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          "OrtakHesap",
          style: AppTextStyles.title.copyWith(color: colorScheme.onSurface),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          "Hemen ücretsiz hesap oluştur",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
