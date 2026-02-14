import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tracko/core/theme/app_colors.dart';
import 'package:tracko/core/constants/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

class ModernHabitCard extends StatelessWidget {
  final String habitName;
  final bool isCompleted;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Color? habitColor;
  final List<Widget>? labels;

  const ModernHabitCard({
    super.key,
    required this.habitName,
    required this.isCompleted,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.habitColor,
    this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkSurface : Colors.white;

    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onEdit(),
            backgroundColor: AppColors.info,
            foregroundColor: Colors.white,
            icon: Iconsax.edit,
            label: 'Edit',
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          ),
          const Gap(8),
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            icon: Iconsax.trash,
            label: 'Delete',
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: AppConstants.paddingSM,
          horizontal: AppConstants.paddingMD,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          border: Border.all(
            color: isCompleted
                ? AppColors.success.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            width: isCompleted ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppConstants.radiusLG),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMD),
              child: Row(
                children: [
                  // Checkbox/Indicator
                  AnimatedContainer(
                    duration: AppConstants.animationNormal,
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.success
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted
                            ? AppColors.success
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),

                  const Gap(16),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habitName,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: isCompleted
                                ? Colors.grey.shade500
                                : null,
                          ),
                        ),
                        if (labels != null && labels!.isNotEmpty) ...[
                          const Gap(8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: labels!,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const Gap(8),

                  // Color Indicator
                  if (habitColor != null)
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: habitColor,
                        borderRadius: BorderRadius.circular(2),
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

// Label Chip Widget
class HabitLabelChip extends StatelessWidget {
  final String label;
  final Color color;

  const HabitLabelChip({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
