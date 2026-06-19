import 'package:flutter/material.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/core/widgets/app_action_button.dart';

class ActionButtonRow extends StatelessWidget {
  const ActionButtonRow({
    super.key,
    required this.onCall,
    required this.onSms,
    required this.onEmail,
  });

  final VoidCallback onCall;
  final VoidCallback onSms;
  final VoidCallback onEmail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(Rs.dp(16), Rs.dp(8), Rs.dp(16), Rs.dp(16)),
      child: Row(
        children: [
          Expanded(
            child: AppActionButton(
              icon: Icons.call_outlined,
              label: AppStrings.T.call,
              onTap: onCall,
            ),
          ),
          SizedBox(width: Rs.dp(12)),
          Expanded(
            child: AppActionButton(
              icon: Icons.message_outlined,
              label: AppStrings.T.sms,
              onTap: onSms,
            ),
          ),
          SizedBox(width: Rs.dp(12)),
          Expanded(
            child: AppActionButton(
              icon: Icons.email_outlined,
              label: AppStrings.T.email,
              onTap: onEmail,
            ),
          ),
        ],
      ),
    );
  }
}
