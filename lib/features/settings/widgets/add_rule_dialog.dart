import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hiddify/core/localization/translations.dart';
import 'package:hiddify/features/settings/widgets/settings_input_dialog.dart';
import 'package:hiddify/singbox/model/singbox_rule.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddRuleDialog extends HookConsumerWidget {
  const AddRuleDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // using english strings as fallback since we can't generate translations easily
    const tTitle = "Add Routing Rule";
    const tDomain = "Domain";
    const tDomainHint = "e.g. google.com or domain:.google.com";
    const tOutbound = "Outbound";
    const tAdd = "Add";
    const tCancel = "Cancel";

    final domainController = TextEditingController();
    RuleOutbound selectedOutbound = RuleOutbound.proxy;

    return AlertDialog(
      title: const Text(tTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: domainController,
              decoration: const InputDecoration(
                labelText: tDomain,
                hintText: tDomainHint,
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(16),
            DropdownButtonFormField<RuleOutbound>(
              value: selectedOutbound,
              decoration: const InputDecoration(
                labelText: tOutbound,
                border: OutlineInputBorder(),
              ),
              items: RuleOutbound.values.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedOutbound = value;
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(tCancel),
        ),
        ElevatedButton(
          onPressed: () {
            final domain = domainController.text.trim();
            if (domain.isEmpty) return;

            final rule = SingboxRule(
              domains: domain,
              outbound: selectedOutbound,
            );
            Navigator.of(context).pop(rule);
          },
          child: const Text(tAdd),
        ),
      ],
    );
  }
}
