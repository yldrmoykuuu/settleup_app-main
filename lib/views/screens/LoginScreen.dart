import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settleup_app/core/components/InputTextField.dart';
import 'package:settleup_app/core/theme/app_spacing.dart';
import 'package:settleup_app/core/theme/app_text_style.dart';
import 'package:settleup_app/viewmodels/auth_viewmodel.dart';
import 'package:settleup_app/views/screens/RegisterScreen.dart';
import 'package:settleup_app/views/widgets/gradient_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(AuthViewModel vm) async {
    setState(() => _errorText = null);

    final error = await vm.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (!mounted) return;

    if (error != null) {
      setState(() => _errorText = error);
    }
    // Başarılı girişte AuthWrapper, authStateChanges akışı üzerinden
    // otomatik olarak Dashboard'a yönlendirir.
  }

  Future<void> _handleForgotPassword(AuthViewModel vm) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      setState(() => _errorText = "Şifreni sıfırlamak için önce email gir");
      return;
    }

    final error = await vm.resetPassword(email);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error ?? "Şifre sıfırlama bağlantısı email adresine gönderildi",
        ),
      ),
    );
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

                          if (_errorText != null) ...[
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              _errorText!,
                              style: TextStyle(color: colorScheme.error),
                            ),
                          ],

                          const SizedBox(height: AppSpacing.md),

                          GradientButton(
                            text: "Giriş Yap",
                            isLoading: vm.isLoading,
                            onTap: () => _handleLogin(vm),
                          ),

                          Center(
                            child: TextButton(
                              onPressed: vm.isLoading
                                  ? null
                                  : () => _handleForgotPassword(vm),
                              child: const Text("Şifremi Unuttum"),
                            ),
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
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            const TextSpan(text: "Hesabın yok mu? "),
                            TextSpan(
                              text: "Kayıt Ol",
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
            Icons.savings_rounded,
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
          "Arkadaşlarınla harcamaları kolayca paylaş",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
