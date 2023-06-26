import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../gen/colors.gen.dart';
import '../theme/input_decoration.dart';

class PhoneInput extends StatelessWidget {
  const PhoneInput({
    required String title,
    required FocusNode focus,
    required TextEditingController controller,
    required bool isLoading,
    required String buttonText,
    required VoidCallback onEnter,
    String? errorText,
    super.key,
  })  : _title = title,
        _focus = focus,
        _controller = controller,
        _isLoading = isLoading,
        _buttonText = buttonText,
        _onEnter = onEnter,
        _errorText = errorText;

  final String _title;
  final FocusNode _focus;
  final TextEditingController _controller;
  final bool _isLoading;
  final String _buttonText;
  final VoidCallback _onEnter;
  final String? _errorText;

  @override
  Widget build(BuildContext context) {
    final errorText = _errorText;

    return Column(
      children: [
        Text(
          _title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 26),
        TextField(
          focusNode: _focus,
          controller: _controller,
          keyboardType: TextInputType.phone,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                letterSpacing: 1.5,
              ),
          inputFormatters: [
            MaskTextInputFormatter(
              mask: '+ ### ### ### ### ###',
              filter: {'#': RegExp('[0-9]')},
            ),
          ],
          decoration: phoneInputDecoration(
            hintText: '+ --- --- --- --- ---',
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  letterSpacing: 1.5,
                ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 16),
          Text(
            errorText,
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.bodyMedium?.copyWith(
                  color: AppColors.red,
                ),
          ),
        ],
        const SizedBox(height: 67),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _onEnter,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Text(_buttonText),
          ),
        ),
      ],
    );
  }
}
