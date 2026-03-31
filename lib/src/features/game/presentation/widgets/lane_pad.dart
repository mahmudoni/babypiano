import 'package:flutter/material.dart';

class LanePad extends StatelessWidget {
  const LanePad({
    super.key,
    required this.label,
    required this.helper,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final String helper;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 140),
      scale: isActive ? 0.97 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? color.withValues(alpha: 0.92)
                  : Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(30),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: color.withValues(
                    alpha: isActive ? 0.28 : 0.14,
                  ),
                  blurRadius: isActive ? 22 : 14,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  label,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: isActive ? Colors.white : color,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  helper,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isActive
                        ? Colors.white.withValues(alpha: 0.94)
                        : const Color(0xFF556273),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
