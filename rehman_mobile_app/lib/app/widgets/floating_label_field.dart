import 'package:flutter/material.dart';
import '../theme.dart';

/// A 56-pt-tall input shell with a floating label that slides up + shrinks
/// + goes uppercase as soon as the field has a value or is focused. The
/// resting state shows the label vertically centred (no value), the
/// active state lifts it into the border so the value reads clearly.
///
/// Use it as a non-editable display (tap → opens a bottom sheet for
/// airport pick / date pick) by passing `readOnly: true` and an
/// `onTap`. Use it as an editable field by wiring `controller` /
/// `onChanged` (no `onTap` needed).
///
/// Variants:
///   • `mono: true` switches the value to a tabular-numerals font so
///     phone numbers / dates / IDs line up neatly.
///   • `state: FieldState.error` paints the red error border + helper.
///   • `trailing` slot for chevrons, units, clear-buttons.
enum FieldState { normal, error }

class FloatingLabelField extends StatefulWidget {
  final String label;
  final String? value;
  final String? placeholder;
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  final String? helper;
  final String? error;
  final bool mono;
  final bool readOnly;
  final FieldState state;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final int? maxLines;

  const FloatingLabelField({
    super.key,
    required this.label,
    this.value,
    this.placeholder,
    this.icon,
    this.leading,
    this.trailing,
    this.helper,
    this.error,
    this.mono = false,
    this.readOnly = false,
    this.state = FieldState.normal,
    this.controller,
    this.onChanged,
    this.onTap,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  State<FloatingLabelField> createState() => _FloatingLabelFieldState();
}

class _FloatingLabelFieldState extends State<FloatingLabelField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_isFocused != _focusNode.hasFocus) {
        setState(() => _isFocused = _focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool get _hasValue {
    final v = widget.controller?.text ?? widget.value ?? '';
    return v.isNotEmpty;
  }

  bool get _isError => widget.state == FieldState.error || widget.error != null;
  bool get _isActive => _isFocused || _hasValue;

  Color get _accent => _isError
      ? AppColors.error
      : _isFocused
          ? AppColors.primary
          : AppColors.border;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: widget.onTap == null
              ? null
              : () {
                  // Tap-to-open shells (date pickers, airport sheets) still
                  // need to flash the focused state so the floating label
                  // animates up — request focus then let the parent open
                  // whatever bottom sheet they want.
                  _focusNode.requestFocus();
                  widget.onTap!();
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _accent, width: 1.5),
              boxShadow: _isFocused && !_isError
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.10),
                        blurRadius: 0,
                        spreadRadius: 4,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  const SizedBox(width: 10),
                ] else if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: 18,
                    color: _isFocused
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(child: _buildBody(context)),
                if (widget.trailing != null) ...[
                  const SizedBox(width: 8),
                  widget.trailing!,
                ],
              ],
            ),
          ),
        ),
        if (widget.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 12, color: AppColors.error),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    widget.error!,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )
        else if (widget.helper != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              widget.helper!,
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    // Stack the label over the value so the label can float UP into the
    // border on focus / when populated. We render the value on top so it
    // takes the keyboard hits when editable.
    final labelStyle = TextStyle(
      fontSize: _isActive ? 11 : 14,
      fontWeight: _isActive ? FontWeight.w700 : FontWeight.w400,
      color: _isError
          ? AppColors.error
          : _isFocused
              ? AppColors.primary
              : AppColors.textSecondary,
      letterSpacing: _isActive ? 0.6 : -0.05,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Floating label. -10pt lifts it into the border, the white pill
        // background covers the border line so it reads as a notch.
        AnimatedPositioned(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          top: _isActive ? -10 : 18,
          left: 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: _isActive
                ? const EdgeInsets.symmetric(horizontal: 4)
                : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: _isActive ? AppColors.cardBg : Colors.transparent,
            ),
            child: Text(
              _isActive ? widget.label.toUpperCase() : widget.label,
              style: labelStyle,
            ),
          ),
        ),

        // Value (read-only mode shows the text; editable mode shows the
        // TextField). Top-align so the value sits in the centre.
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerLeft,
            child: _buildValueOrField(),
          ),
        ),
      ],
    );
  }

  Widget _buildValueOrField() {
    final valueStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      letterSpacing: widget.mono ? 0.3 : -0.05,
      fontFeatures: widget.mono
          ? const [FontFeature.tabularFigures()]
          : null,
      height: 1.1,
    );

    if (widget.readOnly || widget.controller == null) {
      // Display-only: show value if present, otherwise the placeholder
      // (only when active so the resting state is clean).
      if (_hasValue) {
        return Text(
          widget.value ?? widget.controller?.text ?? '',
          style: valueStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      }
      if (_isFocused && (widget.placeholder ?? '').isNotEmpty) {
        return Text(
          widget.placeholder!,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textHint,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      }
      return const SizedBox.shrink();
    }

    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      onChanged: (v) {
        // Triggers a rebuild so the label state tracks the controller's
        // text without the parent having to wire a listener.
        setState(() {});
        widget.onChanged?.call(v);
      },
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      style: valueStyle,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        hintText: _isFocused ? widget.placeholder : null,
        hintStyle: TextStyle(
          fontSize: 14,
          color: AppColors.textHint,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
