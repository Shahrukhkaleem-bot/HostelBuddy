import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Sign-in button styled after Google's own: a light pill, the G mark, and
/// "Sign in with Google" in near-black. Sizes and colours follow Google's
/// identity guidance rather than the app's own button style.
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  // Google's neutral button surface and text colour.
  static const Color _surface = Color(0xFFF2F2F2);
  static const Color _pressed = Color(0xFFE6E6E6);
  static const Color _label = Color(0xFF1F1F1F);
  static const Color _blue = Color(0xFF4285F4);
  static const double _height = 48;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: _surface,
        borderRadius: BorderRadius.circular(_height / 2),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          highlightColor: _pressed,
          splashColor: _pressed,
          child: SizedBox(
            height: _height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: isLoading
                        ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(_blue),
                          )
                        : const Icon(
                            FontAwesomeIcons.google,
                            size: 20,
                            color: _blue,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isLoading ? 'Signing in…' : 'Sign in with Google',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _label,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
