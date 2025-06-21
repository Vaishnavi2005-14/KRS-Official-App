import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:krs_app/services/auth.dart';

class Waiting extends StatefulWidget {
  const Waiting({super.key});

  @override
  State<Waiting> createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> with TickerProviderStateMixin {
  bool isApproved = false;
  bool showButton = false;
  bool isDeactivated = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final AuthService _authService = AuthService();

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

    _checkAccountStatus();
  }

  void _checkAccountStatus() async {
    while (mounted && !isApproved && !isDeactivated) {
      try {
        final isAuth = await _authService.isAuthenticated();

        if (!isAuth) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
          return;
        }

        final status = await _authService.getUserStatus();

        if (status == 'active') {
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
          break;
        } else if (status == 'inactive') {
          if (mounted) {
            setState(() {
              isDeactivated = true;
              showButton = true;
            });
            _fadeController.forward();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Your account has been deactivated. Contact admin.',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          break;
        }

        await Future.delayed(const Duration(seconds: 60));
      } catch (e) {
        await Future.delayed(const Duration(seconds: 60));
      }
    }
  }

  void _handleButtonPress() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  String _getTitle() {
    if (isDeactivated) return 'Account Deactivated';
    if (isApproved) return 'Account Approved!';
    return 'Waiting for Approval';
  }

  String _getDescription() {
    if (isDeactivated) {
      return 'Your account has been deactivated by the admin team. Please contact support for assistance.';
    }
    if (isApproved) {
      return 'Your account has been reviewed and approved by our admin team. Please login again to access the app.';
    }
    return 'Your account is currently being reviewed by our administrators. You will receive access once your account is approved.';
  }

  Color _getTitleColor() {
    if (isDeactivated) return Colors.red[700]!;
    if (isApproved) return Colors.green[700]!;
    return Colors.grey[700]!;
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
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Color(0xff040E1E)),
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
                        : isDeactivated
                        ? Icon(
                          Icons.error_outline,
                          size: 100,
                          color: Colors.red[400],
                        )
                        : Lottie.asset(
                          "assets/loader_2.json",
                          repeat: true,
                          animate: true,
                        ),
              ),
              const SizedBox(height: 32),

              Text(
                _getTitle(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getTitleColor(),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              Text(
                _getDescription(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              if (!isApproved && !isDeactivated) ...[
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
                      onPressed: _handleButtonPress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDeactivated
                                ? Colors.red[600]
                                : const Color(0xffE5A122),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.login_rounded),
                          const SizedBox(width: 8),
                          Text(
                            'Login Again',
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

              if (!showButton && !isApproved && !isDeactivated)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _logout(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFFE5A122), width: 2),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Color(0xFFE5A122),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
