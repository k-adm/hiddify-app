import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hiddify/features/common/nested_app_bar.dart';
import 'package:hiddify/features/config_option/data/config_option_repository.dart';
import 'package:hiddify/features/settings/widgets/add_rule_dialog.dart';
import 'package:hiddify/singbox/model/singbox_rule.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomRulesPage extends HookConsumerWidget {
  const CustomRulesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(ConfigOptions.customRules);
    final notifier = ref.read(ConfigOptions.customRules.notifier);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const NestedAppBar(
            title: Text("Custom Routing Rules"),
          ),
          if (rules.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text("No custom rules defined"),
              ),
            )
          else
            SliverList.builder(
              itemCount: rules.length,
              itemBuilder: (context, index) {
                final rule = rules[index];
                return Dismissible(
                  key: ValueKey(rule),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) async {
                    final newRules = List<SingboxRule>.from(rules)..removeAt(index);
                    await notifier.update(newRules);
                  },
                  child: ListTile(
                    title: Text(rule.domains ?? "Unknown"),
                    subtitle: Text("Outbound: ${rule.outbound.name.toUpperCase()}"),
                    leading: const Icon(Icons.rule),
                  ),
                );
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newRule = await showDialog<SingboxRule>(
            context: context,
            builder: (context) => const AddRuleDialog(),
          );

          if (newRule != null) {
            final newRules = List<SingboxRule>.from(rules)..add(newRule);
            await notifier.update(newRules);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
