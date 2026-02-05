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
import '../../../../data/models/leave_model.dart';
import '../cubit/leaves_cubit.dart';
import '../cubit/leaves_state.dart';

class LeavesPage extends StatefulWidget {
  const LeavesPage({super.key});

  @override
  State<LeavesPage> createState() => _LeavesPageState();
}

class _LeavesPageState extends State<LeavesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMyLeaves();
  }

  void _loadMyLeaves() {
    // Default load
    context.read<LeavesCubit>().loadLeaves();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Requests'),
        // Add tab bar only if admin/employee logic requires distinction
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Leaves'),
            Tab(text: 'Approval Requests'),
          ],
          onTap: (index) {
            if (index == 0) {
              context.read<LeavesCubit>().loadLeaves();
            } else {
              context.read<LeavesCubit>().loadLeaves(isPendingOnly: true);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement Request Leave form
        },
        icon: const Icon(Icons.add),
        label: const Text('Request Leave'),
        backgroundColor: AppColors.primary,
      ),
      body: BlocBuilder<LeavesCubit, LeavesState>(
        builder: (context, state) {
          if (state is LeavesLoading) {
            return const LoadingWidget(message: 'Loading leaves...');
          }

          if (state is LeavesError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => _loadMyLeaves(),
            );
          }

          if (state is LeavesLoaded) {
            if (state.leaves.isEmpty) {
              return EmptyStateWidget(
                title: 'No Leaves Found',
                message: 'There are no leave requests to display.',
                icon: Icons.date_range,
              );
            }

            return ListView.separated(
              padding: Responsive.getPagePadding(context).copyWith(bottom: 80),
              itemCount: state.leaves.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final leave = state.leaves[index];
                return _buildLeaveCard(leave);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLeaveCard(LeaveModel leave) {
    return EnterpriseCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(leave.employeeName, style: AppTextStyles.h4),
                _buildStatusChip(leave.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${leave.type.name.toUpperCase()} • ${DateFormat('MMM dd').format(leave.startDate)} - ${DateFormat('MMM dd').format(leave.endDate)}',
              style: AppTextStyles.bodyMedium,
            ),
            if (leave.reason.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                leave.reason,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (leave.status == LeaveStatus.pending) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 100,
                    height: 36,
                    child: OutlinedButton(
                      onPressed: () {
                        // Implement reject
                      },
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 100,
                    height: 36,
                    child: EnterpriseButton(
                      text: 'Approve',
                      onPressed: () {
                        context.read<LeavesCubit>().approveLeave(
                          leave.id,
                          'Admin',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(LeaveStatus status) {
    Color color;
    switch (status) {
      case LeaveStatus.approved:
        color = AppColors.success;
        break;
      case LeaveStatus.pending:
        color = AppColors.warning;
        break;
      case LeaveStatus.rejected:
        color = AppColors.error;
        break;
      case LeaveStatus.cancelled:
        color = AppColors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
