import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/enterprise_card.dart';
import '../../../../core/widgets/enterprise_button.dart';
import '../../../../data/models/attendance_model.dart';
import '../cubit/attendance_cubit.dart';
import '../cubit/attendance_state.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  void initState() {
    super.initState();
    context.read<AttendanceCubit>().loadTodayAttendance();
  }

  void _showClockInDialog() {
    // Basic mock user selection for now
    // Ideally this would be automatic for the logged in user or a selection for admin

    final TextEditingController idController = TextEditingController();
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clock In'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: 'Employee ID'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Employee Name'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (idController.text.isNotEmpty &&
                  nameController.text.isNotEmpty) {
                context.read<AttendanceCubit>().checkIn(
                  idController.text,
                  nameController.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Clock In'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<AttendanceCubit>().loadTodayAttendance(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showClockInDialog,
        icon: const Icon(Icons.timer),
        label: const Text('Clock In'),
        backgroundColor: AppColors.primary,
      ),
      body: BlocBuilder<AttendanceCubit, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const LoadingWidget(message: 'Loading attendance...');
          }

          if (state is AttendanceError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () =>
                  context.read<AttendanceCubit>().loadTodayAttendance(),
            );
          }

          if (state is AttendanceLoaded) {
            final attendance = state.attendanceList;

            if (attendance.isEmpty) {
              return EmptyStateWidget(
                title: 'No Attendance Records',
                message: 'No one has clocked in today yet.',
                icon: Icons.access_time,
                action: EnterpriseButton(
                  text: 'Clock In',
                  onPressed: _showClockInDialog,
                ),
              );
            }

            return ListView.separated(
              padding: Responsive.getPagePadding(context).copyWith(bottom: 80),
              itemCount: attendance.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final record = attendance[index];
                return _buildAttendanceCard(record);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAttendanceCard(AttendanceModel record) {
    final timeFormat = DateFormat('hh:mm a');

    return EnterpriseCard(
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: _getStatusColor(record.status).withOpacity(0.1),
          child: Icon(
            _getStatusIcon(record.status),
            color: _getStatusColor(record.status),
            size: 20,
          ),
        ),
        title: Text(record.employeeName, style: AppTextStyles.h4),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                _buildTimeInfo('In', record.checkIn, timeFormat),
                const SizedBox(width: 24),
                _buildTimeInfo('Out', record.checkOut, timeFormat),
              ],
            ),
            if (record.workDuration != null) ...[
              const SizedBox(height: 8),
              Text(
                'Duration: ${record.workDuration!.inHours}h ${record.workDuration!.inMinutes.remainder(60)}m',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
        trailing: _buildStatusChip(record.status),
        onTap: () {
          // Maybe show details or allow edit/checkout if admin
          if (record.checkOut == null) {
            _showCheckOutDialog(record);
          }
        },
      ),
    );
  }

  void _showCheckOutDialog(AttendanceModel record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Check Out ${record.employeeName}?'),
        content: const Text(
          'Are you sure you want to clock out for this employee?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<AttendanceCubit>().checkOut(record.id);
              Navigator.pop(context);
            },
            child: const Text('Clock Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(String label, DateTime? time, DateFormat fmt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint),
        ),
        Text(
          time != null ? fmt.format(time) : '--:--',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: time != null ? AppColors.textPrimary : AppColors.textHint,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(AttendanceStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor(status).withOpacity(0.2)),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: _getStatusColor(status),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return AppColors.success;
      case AttendanceStatus.late:
        return AppColors.warning;
      case AttendanceStatus.absent:
        return AppColors.error;
      case AttendanceStatus.halfDay:
        return AppColors.info;
    }
  }

  IconData _getStatusIcon(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Icons.check_circle;
      case AttendanceStatus.late:
        return Icons.access_time;
      case AttendanceStatus.absent:
        return Icons.cancel;
      case AttendanceStatus.halfDay:
        return Icons.timelapse;
    }
  }
}
