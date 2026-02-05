import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/dashboard_state.dart';

class RecentActivityList extends StatelessWidget {
  final List<ActivityLog> activities;

  const RecentActivityList({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Recent Activity', style: AppTextStyles.h3),
          ),
          const Divider(height: 1),
          if (activities.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No recent activity',
                  style: AppTextStyles.bodyMedium,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: _getColorForType(
                      activity.type,
                    ).withOpacity(0.1),
                    child: Icon(
                      _getIconForType(activity.type),
                      color: _getColorForType(activity.type),
                      size: 20,
                    ),
                  ),
                  title: Text(activity.title, style: AppTextStyles.bodyLarge),
                  subtitle: Text(
                    activity.subtitle,
                    style: AppTextStyles.bodySmall,
                  ),
                  trailing: Text(
                    _formatTime(activity.timestamp),
                    style: AppTextStyles.caption,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'attendance':
        return AppColors.success;
      case 'leave':
        return AppColors.warning;
      case 'payroll':
        return AppColors.secondary;
      default:
        return AppColors.primary;
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'attendance':
        return Icons.access_time;
      case 'leave':
        return Icons.event_busy;
      case 'payroll':
        return Icons.attach_money;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
