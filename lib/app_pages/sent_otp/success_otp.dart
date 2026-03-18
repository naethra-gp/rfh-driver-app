import 'package:flutter/material.dart';

class SuccessOtp extends StatefulWidget {
  const SuccessOtp({super.key});

  @override
  State<SuccessOtp> createState() => _SuccessOtpState();
}

class _SuccessOtpState extends State<SuccessOtp> {
  @override
  void initState() {
    super.initState();

    // Navigate to deliveryDashboard after a 3-second delay
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushNamedAndRemoveUntil(
          context, 'deliveryDashboard', (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              height: 100,
              width: 100,
              image: AssetImage('assets/logos/success_tick.png'),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'DC-Code Verification Successful',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
