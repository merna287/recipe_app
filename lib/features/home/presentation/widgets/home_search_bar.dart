import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class HomeSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final VoidCallback? onClear;

  const HomeSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.onClear,
  });

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant HomeSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onTextChanged);
      widget.controller?.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasText = widget.controller?.text.isNotEmpty ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceElevated : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: AppSpacing.lg),
                  Icon(
                    Icons.search_rounded,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textTertiary,
                    size: 22,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      onChanged: widget.onChanged,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search recipes, cuisines...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textTertiary,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (hasText)
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textTertiary,
                      ),
                      onPressed: widget.onClear,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: InkWell(
              onTap: widget.onFilterTap,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.tune_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
