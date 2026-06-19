import 'package:flutter/material.dart';
import 'package:google_contacts_app/app/themes/app_border_radius.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:shimmer/shimmer.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  static const int _placeholderCount = 10;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = colorScheme.surfaceContainerHighest;
    final highlightColor = colorScheme.surface;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: Rs.dp(8)),
        itemCount: _placeholderCount,
        separatorBuilder: (_, __) => SizedBox(height: Rs.dp(4)),
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.symmetric(horizontal: Rs.dp(16)),
          child: Row(
            children: [
              CircleAvatar(radius: Rs.dp(24)),
              SizedBox(width: Rs.dp(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: Rs.dp(16),
                      width: Rs.dp(160),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppBorderRadius.allSm,
                      ),
                    ),
                    SizedBox(height: Rs.dp(8)),
                    Container(
                      height: Rs.dp(12),
                      width: Rs.dp(120),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppBorderRadius.allSm,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
