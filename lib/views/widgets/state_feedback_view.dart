import 'package:flutter/material.dart';

class StateFeedbackView extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final bool isLoading;
  final String? actionLabel;
  final VoidCallback? onAction;

  const StateFeedbackView({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.isLoading = false,
    this.actionLabel,
    this.onAction,
  });

  factory StateFeedbackView.loading({
    String message = 'Memuat data...',
  }) {
    return StateFeedbackView(
      title: message,
      isLoading: true,
    );
  }

  factory StateFeedbackView.empty({
    String title = 'Data tidak ditemukan',
    String? subtitle,
    IconData icon = Icons.search_off_rounded,
  }) {
    return StateFeedbackView(
      icon: icon,
      title: title,
      subtitle: subtitle,
    );
  }

  factory StateFeedbackView.error({
    required String message,
    VoidCallback? onRetry,
  }) {
    return StateFeedbackView(
      icon: Icons.cloud_off_rounded,
      title: 'Terjadi Kesalahan',
      subtitle: message,
      actionLabel: onRetry != null ? 'Coba Lagi' : null,
      onAction: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const CircularProgressIndicator()
            else if (icon != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: colorScheme.primary,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}