import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../data/models/leave_model.dart';
import '../../../../domain/repositories/leave_repository.dart';

class LeaveRequestsPage extends StatefulWidget {
  const LeaveRequestsPage({super.key});

  @override
  State<LeaveRequestsPage> createState() => _LeaveRequestsPageState();
}

class _LeaveRequestsPageState extends State<LeaveRequestsPage> {
  late Future<List<LeaveModel>> _leavesFuture;

  @override
  void initState() {
    super.initState();
    _loadLeaves();
  }

  void _loadLeaves() {
    final repository = context.read<LeaveRepository>();
    _leavesFuture = repository.getAllLeaves();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/dashboard');
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<LeaveModel>>(
        future: _leavesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: 'Loading leave requests...');
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final leaves = snapshot.data ?? [];

          return ListView.builder(
            padding: Responsive.getPagePadding(context),
            itemCount: leaves.length,
            itemBuilder: (context, index) {
              final leave = leaves[index];
              final dateFormat = DateFormat('MMM dd, yyyy');

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(
                      leave.status,
                    ).withOpacity(0.2),
                    child: Icon(
                      _getTypeIcon(leave.type),
                      color: _getStatusColor(leave.status),
                      size: 20,
                    ),
                  ),
                  title: Text(leave.employeeName),
                  subtitle: Text(
                    '${leave.type.name.toUpperCase()} - ${leave.daysCount} days',
                    style: AppTextStyles.bodySmall,
                  ),
                  trailing: Chip(
                    label: Text(
                      leave.status.name.toUpperCase(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: _getStatusColor(leave.status),
                      ),
                    ),
                    backgroundColor: _getStatusColor(
                      leave.status,
                    ).withOpacity(0.1),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Duration', style: AppTextStyles.labelMedium),
                          Text(
                            '${dateFormat.format(leave.startDate)} - ${dateFormat.format(leave.endDate)}',
                            style: AppTextStyles.bodyMedium,
                          ),
                          const SizedBox(height: 12),
                          Text('Reason', style: AppTextStyles.labelMedium),
                          Text(leave.reason, style: AppTextStyles.bodyMedium),
                          const SizedBox(height: 12),
                          Text(
                            'Requested On',
                            style: AppTextStyles.labelMedium,
                          ),
                          Text(
                            dateFormat.format(leave.requestDate),
                            style: AppTextStyles.bodyMedium,
                          ),
                          if (leave.approvedBy != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Approved By',
                              style: AppTextStyles.labelMedium,
                            ),
                            Text(
                              leave.approvedBy!,
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                          if (leave.rejectionReason != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Rejection Reason',
                              style: AppTextStyles.labelMedium,
                            ),
                            Text(
                              leave.rejectionReason!,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.pending:
        return AppColors.warning;
      case LeaveStatus.approved:
        return AppColors.success;
      case LeaveStatus.rejected:
        return AppColors.error;
      case LeaveStatus.cancelled:
        return AppColors.grey;
    }
  }

  IconData _getTypeIcon(LeaveType type) {
    switch (type) {
      case LeaveType.sick:
        return Icons.local_hospital;
      case LeaveType.casual:
        return Icons.event;
      case LeaveType.annual:
        return Icons.beach_access;
      case LeaveType.unpaid:
        return Icons.money_off;
      case LeaveType.emergency:
        return Icons.emergency;
    }
  }
}
