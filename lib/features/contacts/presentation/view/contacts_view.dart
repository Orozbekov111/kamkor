import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/theme/app_spacing.dart';
import 'package:kamkor/core/utils/launcher.dart';
import 'package:kamkor/core/widgets/card_group.dart';
import 'package:kamkor/core/widgets/state_views/empty_view.dart';
import 'package:kamkor/core/widgets/state_views/error_view.dart';
import 'package:kamkor/core/widgets/state_views/loading_view.dart';
import 'package:kamkor/features/contacts/domain/entities/contact.dart';
import 'package:kamkor/features/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:kamkor/features/contacts/presentation/widgets/contact_form_sheet.dart';

class ContactsView extends StatelessWidget {
  const ContactsView({super.key});

  void _openForm(BuildContext context, {Contact? contact}) {
    final bloc = context.read<ContactsBloc>();
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: ContactFormSheet(contact: contact),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Contact contact) async {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final bloc = context.read<ContactsBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.contacts_delete_title),
        content: Text(l.contacts_delete_message(contact.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.cancel),
          ),
          // Destructive: a text button in the muted (non-SOS) error tone with
          // an icon — never a solid red fill (red belongs to SOS only).
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: scheme.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            icon: const Icon(Icons.delete_outline),
            label: Text(l.contacts_delete),
          ),
        ],
      ),
    );
    if (confirmed ?? false) bloc.add(ContactDeleted(contact.id));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.contacts_title),
        // Single, always-available add entry. The empty state shows its own
        // centered CTA; adding a bottom FAB on top of it duplicated the same
        // action, so the header "+" is the one persistent way to add.
        actions: [
          IconButton(
            onPressed: () => _openForm(context),
            icon: const Icon(Icons.person_add_alt_1),
            tooltip: l.contacts_add,
          ),
        ],
      ),
      body: BlocConsumer<ContactsBloc, ContactsState>(
        listenWhen: (prev, curr) => prev.op != curr.op,
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          switch (state.op) {
            case ContactsOp.saveSuccess:
              messenger.showSnackBar(
                SnackBar(content: Text(l.contacts_saved)),
              );
              context.read<ContactsBloc>().add(const ContactsOpReset());
            case ContactsOp.deleteSuccess:
              messenger.showSnackBar(
                SnackBar(content: Text(l.contacts_deleted)),
              );
              context.read<ContactsBloc>().add(const ContactsOpReset());
            case ContactsOp.deleteFailure:
              messenger.showSnackBar(
                SnackBar(content: Text(contactsErrorText(l, state.opError))),
              );
              context.read<ContactsBloc>().add(const ContactsOpReset());
            // Save failures surface as an errorText inside the form sheet.
            case ContactsOp.none:
            case ContactsOp.saving:
            case ContactsOp.saveFailure:
            case ContactsOp.deleting:
              break;
          }
        },
        builder: (context, state) {
          return switch (state.status) {
            ContactsStatus.initial ||
            ContactsStatus.loading =>
              const LoadingView(),
            ContactsStatus.failure => ErrorView(
                message: contactsErrorText(l, state.loadError),
                retryLabel: l.retry,
                onRetry: () =>
                    context.read<ContactsBloc>().add(const ContactsRequested()),
              ),
            ContactsStatus.ready => state.contacts.isEmpty
                ? EmptyView(
                    icon: Icons.contacts_outlined,
                    message: l.contacts_empty_message,
                    actionLabel: l.contacts_add,
                    actionIcon: Icons.person_add_alt_1,
                    onAction: () => _openForm(context),
                  )
                : _ContactsList(
                    contacts: state.contacts,
                    onEdit: (c) => _openForm(context, contact: c),
                    onDelete: (c) => _confirmDelete(context, c),
                  ),
          };
        },
      ),
    );
  }
}

class _ContactsList extends StatelessWidget {
  const _ContactsList({
    required this.contacts,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Contact> contacts;
  final ValueChanged<Contact> onEdit;
  final ValueChanged<Contact> onDelete;

  Future<void> _call(BuildContext context, Contact contact) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await Launcher.dial(contact.phoneNumber);
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(l.error_call_failed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    // Grouped-card list — the same container Profile, Info and the emergency
    // numbers use, so every list in the app reads as one system.
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xxl,
      ),
      children: [
        CardGroup(
          rows: [
            for (final contact in contacts)
              AppTile(
                icon: Icons.person_outline,
                title: contact.name,
                subtitle: contact.phoneNumber,
                // Calling is the primary action for a trusted contact, so it
                // gets both the row tap and a visible call button; edit/delete
                // live in the overflow menu.
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.call, color: scheme.primary),
                      tooltip: l.emergency_call,
                      onPressed: () => unawaited(_call(context, contact)),
                    ),
                    PopupMenuButton<void>(
                      tooltip: l.contacts_actions,
                      itemBuilder: (_) => [
                        PopupMenuItem<void>(
                          onTap: () => unawaited(_call(context, contact)),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.call_outlined),
                            title: Text(l.emergency_call),
                          ),
                        ),
                        PopupMenuItem<void>(
                          onTap: () => onEdit(contact),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.edit_outlined),
                            title: Text(l.contacts_edit),
                          ),
                        ),
                        // Destructive: muted (non-SOS) error tone + icon, not
                        // colour alone.
                        PopupMenuItem<void>(
                          onTap: () => onDelete(contact),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            iconColor: scheme.error,
                            textColor: scheme.error,
                            leading: const Icon(Icons.delete_outline),
                            title: Text(l.contacts_delete),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () => unawaited(_call(context, contact)),
              ),
          ],
        ),
      ],
    );
  }
}
