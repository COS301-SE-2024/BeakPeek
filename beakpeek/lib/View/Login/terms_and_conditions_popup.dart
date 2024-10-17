import 'package:beakpeek/Controller/Azure/login.dart';
import 'package:beakpeek/Styles/global_styles.dart';
import 'package:beakpeek/config_azure.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localstorage/localstorage.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';

class TermsAndConditionsPopup extends StatefulWidget {
  const TermsAndConditionsPopup(
      {super.key, required this.guest, required this.outerContext});
  final bool guest;
  final BuildContext outerContext;
  @override
  TermsAndConditionsPopupState createState() => TermsAndConditionsPopupState();
}

class TermsAndConditionsPopupState extends State<TermsAndConditionsPopup> {
  PDFDocument? document;
  bool viewTandC = false;
  void loadPdfT() {
    setState(() {
      viewTandC = true;
    });
  }

  @override
  void initState() {
    loadPDf();
    super.initState();
  }

  void loadPDf() async {
    document =
        await PDFDocument.fromAsset('assets/Legal/BeakPeekTermsOfUse.pdf');
  }

  void loadCookie() async {
    setState(() {
      PDFDocument.fromAsset('assets/Legal/BeakPeekCookiePolicy.pdf')
          .then((value) => document);
    });
    loadPdfT();
  }

  void loadPriv() async {
    setState(() {
      PDFDocument.fromAsset('assets/Legal/BeakPeekPrivacyPolicy.pdf')
          .then((value) => document);
    });
    loadPdfT();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
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
                '''By clicking accept you agree to all terms stipulated in the documents below:''',
                style: GlobalStyles.contentPrimary(context)
                    .copyWith(fontWeight: FontWeight.w400)
                    .copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Center(
            child: SizedBox(
              width: screenWidth * 0.7,
              child: OutlinedButton(
                onPressed: () {
                  loadPdfT();
                },
                style: GlobalStyles.buttonSecondaryOutlined(context),
                child: Text(
                  'Terms and Conditions',
                  style: GlobalStyles.secondaryButtonText(context),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Center(
            child: SizedBox(
              width: screenWidth * 0.7,
              child: OutlinedButton(
                onPressed: () {
                  loadCookie();
                },
                style: GlobalStyles.buttonSecondaryOutlined(context),
                child: Text(
                  'Cookie Policy',
                  style: GlobalStyles.secondaryButtonText(context),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Center(
            child: SizedBox(
              width: screenWidth * 0.7,
              child: OutlinedButton(
                onPressed: () {
                  loadCookie();
                },
                style: GlobalStyles.buttonSecondaryOutlined(context),
                child: Text(
                  'Privacy Policy',
                  style: GlobalStyles.secondaryButtonText(context),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Center(
            child: SizedBox(
              width: screenWidth * 0.7,
              child: OutlinedButton(
                onPressed: () {
                  if (widget.guest) {
                    loggedIN = false;
                    Navigator.pop(context);
                    context.go('/home');
                  } else {
                    localStorage.setItem('termsAndCondition', 'true');
                    Navigator.pop(context);
                    loginFunction(widget.outerContext);
                  }
                },
                style: GlobalStyles.buttonSecondaryOutlined(context),
                child: Text(
                  'Accept All',
                  style: GlobalStyles.secondaryButtonText(context),
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.05),
          viewTandC
              ? SizedBox(
                  height: screenHeight * 0.4,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: (screenHeight * 0.5).floor(),
                        child: PDFViewer(
                          document: document!,
                          zoomSteps: 2,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(
                  height: 0,
                ),
        ],
      ),
    );
  }
}
