import 'package:circle_flags/circle_flags.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/themes/app_border_radius.dart';
import 'package:google_contacts_app/app/themes/app_colors.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/form_validation.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({
    super.key,
    required this.controller,
    required this.selectedCountry,
    required this.onCountryChanged,
    this.hintText,
    this.validator,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final Rx<Country> selectedCountry;
  final ValueChanged<Country> onCountryChanged;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final bool readOnly;

  void _showCountryPicker(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      useSafeArea: true,
      countryListTheme: CountryListThemeData(
        searchTextStyle: AppTextStyles.bodyMedium,
        inputDecoration: InputDecoration(
          hintText: AppStrings.T.search,
        ),
      ),
      onSelect: onCountryChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final country = selectedCountry.value;

      return TextFormField(
        controller: controller,
        readOnly: readOnly,
        enabled: !readOnly,
        keyboardType: TextInputType.phone,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: AppTextStyles.bodyMedium,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: readOnly
            ? null
            : validator ??
                  (value) => Validator.validatePhoneNumber(value, dialCode: country.phoneCode),
        decoration: InputDecoration(
          labelText: hintText ?? AppStrings.T.enterMobileNumber,
          labelStyle: AppTextStyles.bodyMedium,
          prefixIcon: _CountryCodePrefixIcon(
            country: country,
            onTap: readOnly ? null : () => _showCountryPicker(context),
          ),
        ),
      );
    });
  }
}

class _CountryCodePrefixIcon extends StatelessWidget {
  const _CountryCodePrefixIcon({required this.country, this.onTap});

  final Country country;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.outlineVariant;

    return SizedBox(
      width: Rs.dp(96),
      child: Padding(
        padding: EdgeInsets.only(left: Rs.dp(12)),
        child: Row(
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: AppBorderRadius.allMd,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleFlag(country.countryCode, size: Rs.dp(20)),
                  SizedBox(width: Rs.dp(6)),
                  Text(
                    '+${country.phoneCode}',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface),
                  ),
                  if (onTap != null) ...[
                    SizedBox(width: Rs.dp(4)),
                    Icon(Icons.keyboard_arrow_down, size: Rs.dp(18), color: AppColors.onSurface),
                  ],
                ],
              ),
            ),
            SizedBox(width: Rs.dp(8)),
            Container(width: 1, height: Rs.dp(28), color: borderColor),
          ],
        ),
      ),
    );
  }
}
