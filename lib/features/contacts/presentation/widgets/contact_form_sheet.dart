import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/theme/app_spacing.dart';
import 'package:kamkor/core/utils/validators.dart';
import 'package:kamkor/core/widgets/app_button.dart';
import 'package:kamkor/core/widgets/app_text_field.dart';
import 'package:kamkor/features/contacts/domain/entities/contact.dart';
import 'package:kamkor/features/contacts/presentation/bloc/contacts_bloc.dart';

/// Bottom-sheet form to create ([contact] == null) or edit a trusted contact.
class ContactFormSheet extends StatefulWidget {
  const ContactFormSheet({this.contact, super.key});

  final Contact? contact;

  @override
  State<ContactFormSheet> createState() => _ContactFormSheetState();
}

class _ContactFormSheetState extends State<ContactFormSheet> {
  late final TextEditingController _name =
      TextEditingController(text: widget.contact?.name);
  late final TextEditingController _phone =
      TextEditingController(text: widget.contact?.phoneNumber);

  String? _nameError;
  String? _phoneError;

  bool get _isEditing => widget.contact != null;

  @override
  void initState() {
    super.initState();
    // Drop any stale mutation outcome from a previous form session.
    context.read<ContactsBloc>().add(const ContactsOpReset());
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  /// Imports a name + phone from the device address book via the native
  /// picker. On Android the picker needs READ_CONTACTS to read the phone; iOS's
  /// picker is permissionless.
  Future<void> _pickFromDevice() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    if (Platform.isAndroid && !await _ensureContactsPermission()) {
      messenger.showSnackBar(
        SnackBar(content: Text(l.contacts_permission_denied)),
      );
      return;
    }

    final fc.Contact? picked;
    try {
      picked = await fc.FlutterContacts.native.showPicker(
        properties: {fc.ContactProperty.name, fc.ContactProperty.phone},
      );
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l.contacts_pick_failed)));
      return;
    }
    if (picked == null || !mounted) return;

    final number = await _resolveNumber(picked.phones);
    if (!mounted) return;

    setState(() {
      final name = (picked!.displayName ?? '').trim();
      if (name.isNotEmpty) {
        _name.text = name;
        _nameError = null;
      }
      if (number != null) {
        _phone.text = number;
        _phoneError = null;
      }
    });
  }

  Future<bool> _ensureContactsPermission() async {
    if (await fc.FlutterContacts.permissions.has(fc.PermissionType.read)) {
      return true;
    }
    final status =
        await fc.FlutterContacts.permissions.request(fc.PermissionType.read);
    return status == fc.PermissionStatus.granted ||
        status == fc.PermissionStatus.limited;
  }

  /// Returns the single phone, lets the user pick when there are several, or
  /// null when the contact has none.
  Future<String?> _resolveNumber(List<fc.Phone> phones) async {
    if (phones.isEmpty) return null;
    if (phones.length == 1) return phones.first.number;
    final l = AppLocalizations.of(context);
    return showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l.contacts_pick_number_title),
        children: [
          for (final phone in phones)
            SimpleDialogOption(
              onPressed: () => Navigator.of(ctx).pop(phone.number),
              child: Text(phone.number),
            ),
        ],
      ),
    );
  }

  void _submit() {
    final l = AppLocalizations.of(context);
    final name = _name.text.trim();
    final phone = _phone.text.trim();
    setState(() {
      _nameError =
          Validators.isNotBlank(name) ? null : l.contacts_name_required;
      _phoneError = !Validators.isNotBlank(phone)
          ? l.contacts_phone_required
          : (Validators.isValidPhone(phone) ? null : l.contacts_phone_invalid);
    });
    if (_nameError != null || _phoneError != null) return;
    context.read<ContactsBloc>().add(
          ContactSaved(
            id: widget.contact?.id,
            name: name,
            phoneNumber: Validators.normalizePhone(phone),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return BlocConsumer<ContactsBloc, ContactsState>(
      listenWhen: (prev, curr) => prev.op != curr.op,
      listener: (context, state) {
        if (state.op == ContactsOp.saveSuccess) Navigator.of(context).pop();
      },
      builder: (context, state) {
        final saving = state.isSaving;
        final backendError = state.op == ContactsOp.saveFailure
            ? _errorText(l, state.opError)
            : null;
        return Padding(
          // Lift the sheet above the keyboard.
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _isEditing ? l.contacts_edit_title : l.contacts_add_title,
                    style: theme.textTheme.titleLarge,
                  ),
                  // Import shortcut — only when creating, so the user can
                  // pull a name + number from the phone book instead of typing.
                  if (!_isEditing) ...[
                    const SizedBox(height: AppSpacing.lg),
                    OutlinedButton.icon(
                      onPressed:
                          saving ? null : () => unawaited(_pickFromDevice()),
                      icon: const Icon(Icons.contacts_outlined),
                      label: Text(l.contacts_pick_from_device),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  AppTextField(
                    controller: _name,
                    label: l.contacts_name_label,
                    errorText: _nameError,
                    enabled: !saving,
                    autofocus: !_isEditing,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _phone,
                    label: l.contacts_phone_label,
                    hint: l.contacts_phone_hint,
                    errorText: _phoneError ?? backendError,
                    enabled: !saving,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: l.contacts_save,
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

/// Maps a contacts error to a localized message (shared with the list view).
String contactsErrorText(AppLocalizations l, ContactsError error) =>
    _errorText(l, error);

String _errorText(AppLocalizations l, ContactsError error) => switch (error) {
      ContactsError.none => '',
      ContactsError.duplicatePhone => l.contacts_duplicate_phone,
      ContactsError.validation => l.contacts_invalid,
      ContactsError.network => l.error_network,
      ContactsError.timeout => l.error_timeout,
      ContactsError.server => l.error_server,
      ContactsError.unknown => l.error_unknown,
    };
