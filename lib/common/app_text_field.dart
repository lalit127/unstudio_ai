import 'package:unstudio_ai/common/common_import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final bool? isEnabled;

  const AppTextField({
    super.key,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.isEnabled = true,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.fillColor,
    this.validator,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText; // Start with the given obscureText state
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color:
                        state.hasError ? AppColors.dangerDark : AppColors.black,
                    offset: Offset(3, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                enabled: widget.isEnabled,
                controller: widget.controller,
                obscureText: _obscure,
                keyboardType: widget.keyboardType,
                // validator: widget.validator,
                onChanged: (value) {
                  widget.onChanged?.call(value);
                  state.didChange(value);
                },
                style: AppTextStyles(
                  context,
                ).display17W500.copyWith(color: Colors.grey),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  filled: true,
                  fillColor: widget.fillColor ?? Colors.white,
                  hintStyle: AppTextStyles(context).display17W500,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          state.hasError
                              ? AppColors.dangerDark
                              : AppColors.black,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          state.hasError
                              ? AppColors.dangerDark
                              : AppColors.black,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          state.hasError
                              ? AppColors.dangerDark
                              : AppColors.black,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          state.hasError
                              ? AppColors.dangerDark
                              : AppColors.black,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon:
                      widget.obscureText
                          ? GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                _obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          )
                          : null,
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 5.0),
                child: Text(
                  state.errorText ?? '',
                  style: AppTextStyles(
                    context,
                  ).display14W400.copyWith(color: Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }
}
