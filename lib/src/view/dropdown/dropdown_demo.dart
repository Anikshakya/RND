import 'package:flutter/material.dart';
import 'package:rnd/src/view/dropdown/custom_dropdown.dart';

class DropDownDemo extends StatelessWidget {
  const DropDownDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Dropdown')),
      body: Center(
        child: CustomDropdown<String>(
          items: const ['Item 1', 'Item 2', 'Item 3', 'Item 1', 'Item 2', 'Item 3', 'Item 1', 'Item 2', 'Item 3', 'Item 1', 'Item 2', 'Item 3'],
          value: 'Item 1',
          animationType: DropdownAnimation.slideDown,
          onChanged: (value, index) async{
            if(index == 2){
              await Future.delayed(
                const Duration(milliseconds: 300)
              );
              // ignore: use_build_context_synchronously
              showAboutDialog(context: context);
            }
            debugPrint('Selected: $value');
            debugPrint('Index: $index');
          },
          itemBuilder: (context, item) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(item),
          ),
          hint: const Text('Select an item'),
          width: 200,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Custom Container'),
                Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
