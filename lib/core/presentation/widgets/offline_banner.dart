import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class OfflineBanner extends StatefulWidget {
  const OfflineBanner({super.key});

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner>
    with SingleTickerProviderStateMixin {
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  late final AnimationController _animController;
  late final Animation<double> _slideAnimation;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      final offline = result.contains(ConnectivityResult.none);
      if (offline != _isOffline) {
        setState(() => _isOffline = offline);
        if (offline) {
          _animController.forward();
        } else {
          _animController.reverse();
        }
      }
    });

    Connectivity().checkConnectivity().then((result) {
      if (result.contains(ConnectivityResult.none)) {
        setState(() => _isOffline = true);
        _animController.forward();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        if (!_isOffline && _animController.isDismissed) {
          return const SizedBox.shrink();
        }
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(_animController),
          child: child,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        color: Colors.grey.shade800,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text(
              'Нет подключения к интернету',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
