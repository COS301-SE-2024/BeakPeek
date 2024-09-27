import 'package:beakpeek/Styles/global_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:localstorage/localstorage.dart';

class TermsAndConditionsPopup extends StatelessWidget {
  TermsAndConditionsPopup({required this.login, super.key});
  final Function login;
  final _flutterMediaDownloaderPlugin = MediaDownload();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: screenHeight * 0.05),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Terms and Conditions',
            style: GlobalStyles.smallHeadingPrimary(context),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: screenWidth * 0.8,
            child: Text(
              '''By clicking accept you agree to all terms and conditions set in the documents below:''',
              style: GlobalStyles.contentPrimary(context)
                  .copyWith(fontWeight: FontWeight.w400)
                  .copyWith(fontSize: 14),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        OutlinedButton(
          onPressed: () {
            localStorage.setItem('termsAndCondition', 'true');
            login(context);
          },
          style: GlobalStyles.buttonPrimaryOutlined(context),
          child: const Text('Accept'),
        ),
        const SizedBox(height: 10.0),
        Center(
          child: OutlinedButton(
            onPressed: () async {
              _flutterMediaDownloaderPlugin.downloadMedia(context,
                  'https://github.com/COS301-SE-2024/BeakPeek/blob/documention/doc/Legal/BeakPeekTermsOfUse.pdf');
              _flutterMediaDownloaderPlugin.downloadMedia(context,
                  'https://github.com/COS301-SE-2024/BeakPeek/blob/documention/doc/Legal/BeakPeekCookiePolicy.pdf');
              _flutterMediaDownloaderPlugin.downloadMedia(context,
                  'https://github.com/COS301-SE-2024/BeakPeek/blob/documention/doc/Legal/BeakPeekPrivacyPolicy.pdf');
            },
            style: GlobalStyles.buttonSecondaryOutlined(context),
            child: const Text('Terms and conditions'),
          ),
        ),
        SizedBox(height: screenHeight * 0.05),
      ],
    );
  }
}
