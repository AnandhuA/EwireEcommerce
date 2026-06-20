import 'package:ewire_ecommerce/core/themes/theme_extensions.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: 'Search products...',
        fillColor: context.primary.withValues(alpha: 0.1),
        filled: true,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: ValueListenableBuilder(
          valueListenable: widget.controller,
          builder: (_, _, _) {
            return widget.controller.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      widget.controller.clear();
                      widget.onClear();
                    },
                    icon: const Icon(Icons.clear),
                  )
                : const SizedBox.shrink();
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
