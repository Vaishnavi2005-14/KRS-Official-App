import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Waiting extends StatefulWidget {
  const Waiting({super.key});

  @override
  State<Waiting> createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> with TickerProviderStateMixin {
  bool isApproved = false;
  bool showButton = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _simulateAdminApproval();
  }

  void _simulateAdminApproval() async {
    await Future.delayed(const Duration(seconds: 8));
    if (mounted) {
      setState(() {
        isApproved = true;
      });
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        setState(() {
          showButton = true;
        });
        _fadeController.forward();
      }
    }
  }

  void _navigateToMainApp() {
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              SizedBox(
                height: 200,
                width: 200,
                child:
                    isApproved
                        ? Lottie.asset(
                          "assets/loader_1.json",
                          repeat: false,
                          animate: true,
                        )
                        : Lottie.asset(
                          "assets/loader_2.json",
                          repeat: true,
                          animate: true,
                        ),
              ),
              const SizedBox(height: 32),

              Text(
                isApproved ? 'Account Approved!' : 'Waiting for Approval',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isApproved ? Colors.green[700] : Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                isApproved
                    ? 'Your account has been reviewed and approved by our admin team. You can now access the full features of the app.'
                    : 'Your account is being reviewed by our admin team. This usually takes a few minutes. Please wait while we verify your information.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Status indicator
              if (!isApproved) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      "assets/loader.json",
                      repeat: true,
                      width: s.width * 0.1,
                    ),
                    Text(
                      'Reviewing your account...',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],

              const Spacer(flex: 2),
              if (showButton)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _navigateToMainApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffE5A122),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_forward_rounded),
                          const SizedBox(width: 8),
                          Text(
                            'Continue to App',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
