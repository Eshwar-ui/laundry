import 'dart:io';

import 'package:customer_app/core/routes/app_routes.dart';
import 'package:customer_app/core/theme/app_colors.dart';
import 'package:customer_app/core/theme/app_text_theme.dart';
import 'package:customer_app/core/utils/validators.dart';
import 'package:customer_app/presentation/widgets/common/custom_button.dart';
import 'package:customer_app/presentation/widgets/common/custom_text_field.dart';
import 'package:customer_app/presentation/widgets/common/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../../presentation/providers/auth_provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _logger = Logger();
  File? _imageFile;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.updateProfile(
        name: _nameController.text,
        email: _emailController.text,
      );

      if (success) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Your Profile'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Almost there!',
                  style: AppTextTheme.headlineMedium.copyWith(color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Let\'s get your name and email set up.',
                  style: AppTextTheme.bodyLarge.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  prefixIcon: Icons.person_outline_rounded,
                  validator: Validators.validateName,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter your email address',
                  prefixIcon: Icons.email_outlined,
                  validator: Validators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 40),
                authProvider.isLoading
                    ? const LoadingWidget()
                    : CustomButton(
                        text: 'Continue',
                        onPressed: _submit,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
