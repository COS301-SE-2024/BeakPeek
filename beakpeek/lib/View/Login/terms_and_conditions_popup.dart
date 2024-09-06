import 'package:beakpeek/Controller/Azure/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:localstorage/localstorage.dart';

class TermsAndConditionsPopup extends StatelessWidget {
  TermsAndConditionsPopup({super.key});

  final _flutterMediaDownloaderPlugin = MediaDownload();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 24.0),
        const SizedBox(height: 4.0),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Terms and conditions',
          ),
        ),
        const SizedBox(height: 2.0),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('able.bradley@gmail.com'),
        ),
        const SizedBox(height: 8.0),
        const Divider(),
        TextButton(
          onPressed: () {
            localStorage.setItem('termsAndCondition', 'true');
            loginFunction(context);
          },
          child: const Text('Accept'),
        ),
        const SizedBox(height: 10.0),
        Center(
          child: ElevatedButton(
            onPressed: () async {
              _flutterMediaDownloaderPlugin.downloadMedia(context,
                  'https://github.com/COS301-SE-2024/BeakPeek/blob/documention/doc/Legal/BeakPeekTermsOfUse.pdf');
              _flutterMediaDownloaderPlugin.downloadMedia(context,
                  'https://github.com/COS301-SE-2024/BeakPeek/blob/documention/doc/Legal/BeakPeekCookiePolicy.pdf');
              _flutterMediaDownloaderPlugin.downloadMedia(context,
                  'https://github.com/COS301-SE-2024/BeakPeek/blob/documention/doc/Legal/BeakPeekPrivacyPolicy.pdf');
            },
            child: const Text('Terms and conditions'),
          ),
        ),
      ],
    );
  }
}
