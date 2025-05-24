import 'package:flutter/material.dart';
import 'package:krs_app/screens/loadingsc.dart';

class LoaderProvider with ChangeNotifier {
  bool _isLoading = false;
  OverlayEntry? _overlayEntry;

  bool get isLoading => _isLoading;

  void showLoader(BuildContext context) {
    if (!_isLoading) {
      _isLoading = true;
      _overlayEntry = _createOverlayEntry(context);
      Overlay.of(context).insert(_overlayEntry!);
      notifyListeners();
    }
  }

  void hideLoader() {
    if (_isLoading) {
      _isLoading = false;
      _overlayEntry?.remove();
      _overlayEntry = null;
      notifyListeners();
    }
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              ModalBarrier(
                color: Colors.black.withAlpha(180),
                dismissible: false,
              ),
              // Centered loader
              const Center(child: LoadingWidget()),
            ],
          ),
    );
  }
}
