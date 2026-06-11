
import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class BottomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const BottomNavBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 16, 
      color: AppColors.white, 
      elevation: 8, 
      shadowColor: AppColors.grey.withOpacity(0.2),
      clipBehavior: Clip.antiAlias, 
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildItem(Icons.home, 'ទំព័រដើម', 0),
            buildItem(Icons.folder, 'ឯកសារ', 1),

            const SizedBox(width: 80), 

            buildItem(Icons.notifications_none, 'ជូនដំណឹង', 2),
            buildItem(Icons.account_circle_outlined, 'គណនី', 3),
          ],
        ),
      ),
    );
  }

  Widget buildItem(IconData icon, String label, int index) {
    final bool isSelected = selectedIndex == index;
    final Color color = isSelected ? AppColors.darkBlue : AppColors.grey;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: isSelected ? 32 : 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}