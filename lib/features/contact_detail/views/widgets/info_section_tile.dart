import 'package:flutter/material.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';

class DetailInfoTile extends StatelessWidget {
  const DetailInfoTile({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.onLongPress,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isInteractive = onTap != null || onLongPress != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Rs.dp(16),
                vertical: Rs.dp(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: AppTextStyles.detailLabel.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: Rs.dp(4)),
                        Text(
                          value,
                          style: AppTextStyles.detailValue.copyWith(
                            color: isInteractive
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isInteractive)
                    Icon(
                      Icons.chevron_right,
                      size: Rs.dp(20),
                      color: colorScheme.onSurfaceVariant,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: Rs.dp(16),
            endIndent: Rs.dp(16),
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
      ],
    );
  }
}

class DetailSection extends StatelessWidget {
  const DetailSection({
    super.key,
    required this.tiles,
    this.title,
  });

  final String? title;
  final List<DetailInfoTile> tiles;

  @override
  Widget build(BuildContext context) {
    if (tiles.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: Rs.dp(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                Rs.dp(16),
                Rs.dp(8),
                Rs.dp(16),
                Rs.dp(6),
              ),
              child: Text(
                title!,
                style: AppTextStyles.sectionHeader.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Rs.dp(16)),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Rs.dp(12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: Rs.dp(10),
                    offset: Offset(0, Rs.dp(2)),
                  ),
                ],
              ),
              child: Material(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(Rs.dp(12)),
                clipBehavior: Clip.antiAlias,
                child: Column(mainAxisSize: MainAxisSize.min, children: tiles),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
