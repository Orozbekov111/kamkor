import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/theme/app_spacing.dart';
import 'package:kamkor/core/utils/validators.dart';
import 'package:kamkor/core/widgets/app_button.dart';
import 'package:kamkor/core/widgets/app_text_field.dart';
import 'package:kamkor/features/auth/domain/entities/user.dart';
import 'package:kamkor/features/profile/presentation/bloc/profile_bloc.dart';

/// Bottom-sheet form to edit the current user's profile.
class ProfileEditSheet extends StatefulWidget {
  const ProfileEditSheet({required this.user, super.key});

  final User user;

  @override
  State<ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<ProfileEditSheet> {
  late final TextEditingController _name =
      TextEditingController(text: widget.user.name);
  late final TextEditingController _surname =
      TextEditingController(text: widget.user.surname);
  late final TextEditingController _phone =
      TextEditingController(text: widget.user.phoneNumber);
  late final TextEditingController _address =
      TextEditingController(text: widget.user.address);

  String? _nameError;
  String? _phoneError;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const ProfileOpReset());
  }

  @override
  void dispose() {
    _name.dispose();
    _surname.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  void _submit() {
    final l = AppLocalizations.of(context);
    final name = _name.text.trim();
    final phone = _phone.text.trim();
    setState(() {
      _nameError =
          Validators.isNotBlank(name) ? null : l.profile_name_required;
      _phoneError = phone.isEmpty || Validators.isValidPhone(phone)
          ? null
          : l.contacts_phone_invalid;
    });
    if (_nameError != null || _phoneError != null) return;
    // Empty optional fields are sent as null (left unchanged), not blanked.
    context.read<ProfileBloc>().add(
          ProfileSubmitted(
            name: name,
            surname: _text(_surname),
            phoneNumber:
                phone.isEmpty ? null : Validators.normalizePhone(phone),
            address: _text(_address),
          ),
        );
  }

  String? _text(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == ProfileOpStatus.success) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final saving = state.isSaving;
        final backendError = state.status == ProfileOpStatus.failure
            ? profileErrorText(l, state.error)
            : null;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.profile_edit_title, style: theme.textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.xl),
                  AppTextField(
                    controller: _name,
                    label: l.profile_name_label,
                    errorText: _nameError,
                    enabled: !saving,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _surname,
                    label: l.profile_surname_label,
                    enabled: !saving,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _phone,
                    label: l.profile_phone_label,
                    errorText: _phoneError,
                    enabled: !saving,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _address,
                    label: l.profile_address_label,
                    enabled: !saving,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                  ),
                  if (backendError != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      backendError,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: l.profile_save,
                    loading: saving,
                    onPressed: saving ? null : _submit,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

String profileErrorText(AppLocalizations l, ProfileError error) =>
    switch (error) {
      ProfileError.none => '',
      ProfileError.network => l.error_network,
      ProfileError.timeout => l.error_timeout,
      ProfileError.validation => l.profile_invalid,
      ProfileError.server => l.error_server,
      ProfileError.unknown => l.error_unknown,
    };
