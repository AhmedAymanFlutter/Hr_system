import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../../data/models/user_model.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/dashboard_analytics_card.dart';
import '../widgets/recent_activity_list.dart';
import '../widgets/attendance_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final authState = context.read<AuthCubit>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DashboardCubit>().refresh(user: user);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.go('/login');
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<DashboardCubit>().refresh(user: user);
          },
          child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return const LoadingWidget(message: 'Loading dashboard...');
              }

              if (state is DashboardError) {
                return CustomErrorWidget(
                  message: state.message,
                  onRetry: () {
                    context.read<DashboardCubit>().loadDashboardData(
                      user: user,
                    );
                  },
                );
              }

              if (state is DashboardLoaded) {
                if (user?.role == UserRole.employee) {
                  return _buildEmployeeDashboard(context, state.stats, user!);
                }
                return _buildAdminDashboard(context, state.stats, isMobile);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAdminDashboard(
    BuildContext context,
    DashboardStats stats,
    bool isMobile,
  ) {
    final crossAxisCount = Responsive.getGridCrossAxisCount(context);

    return SingleChildScrollView(
      padding: Responsive.getPagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Text(
            'Welcome back!',
            style: isMobile ? AppTextStyles.h2 : AppTextStyles.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Here\'s what\'s happening today',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Analytics Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: Responsive.getCardSpacing(context),
            mainAxisSpacing: Responsive.getCardSpacing(context),
            childAspectRatio: isMobile ? 1.4 : 1.6,
            children: [
              DashboardAnalyticsCard(
                title: 'Total Employees',
                value: stats.totalEmployees.toString(),
                icon: Icons.people,
                color: AppColors.primary,
                trend: stats.trends['employees'],
                onTap: () => context.go('/employees'),
              ),
              DashboardAnalyticsCard(
                title: 'Present Today',
                value: stats.presentToday.toString(),
                icon: Icons.check_circle,
                color: AppColors.success,
                trend: stats.trends['attendance'],
                onTap: () => context.go('/attendance'),
              ),
              DashboardAnalyticsCard(
                title: 'Pending Leaves',
                value: stats.pendingLeaves.toString(),
                icon: Icons.pending_actions,
                color: AppColors.warning,
                onTap: () => context.go('/leaves'),
              ),
              DashboardAnalyticsCard(
                title: 'Monthly Payroll',
                value: '\$${stats.monthlyPayroll.toStringAsFixed(0)}',
                icon: Icons.attach_money,
                color: AppColors.secondary,
                trend: stats.trends['payroll'],
                onTap: () => context.go('/payroll'),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Charts & Activity Row
          if (!isMobile)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 2, child: AttendanceChart()),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: RecentActivityList(activities: stats.recentActivity),
                ),
              ],
            )
          else ...[
            const AttendanceChart(),
            const SizedBox(height: 24),
            RecentActivityList(activities: stats.recentActivity),
          ],
        ],
      ),
    );
  }

  Widget _buildEmployeeDashboard(
    BuildContext context,
    DashboardStats stats,
    UserModel user,
  ) {
    return SingleChildScrollView(
      padding: Responsive.getPagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: user.profileImage != null
                      ? NetworkImage(user.profileImage!)
                      : null,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: user.profileImage == null
                      ? Text(
                          user.name[0].toUpperCase(),
                          style: AppTextStyles.h2.copyWith(color: Colors.white),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning,',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        user.name,
                        style: AppTextStyles.h2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Check In/Out Action
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.greyLight),
            ),
            child: Column(
              children: [
                Text(
                  stats.isCheckedIn
                      ? 'You are checked in'
                      : 'You are checked out',
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handled by generic button in real app, mock check-in here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            stats.isCheckedIn ? 'Checked Out!' : 'Checked In!',
                          ),
                        ),
                      );
                      // In real app, call cubit.checkIn()
                      context.read<DashboardCubit>().refresh(user: user);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: stats.isCheckedIn
                          ? AppColors.error
                          : AppColors.success,
                      foregroundColor: Colors.white,
                      textStyle: AppTextStyles.h3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(stats.isCheckedIn ? Icons.logout : Icons.login),
                    label: Text(
                      stats.isCheckedIn ? 'Check Out' : 'Check In Now',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Personal Stats
          Row(
            children: [
              Expanded(
                child: _buildMiniStatCard(
                  'Pending Leaves',
                  stats.pendingLeaves.toString(),
                  Icons.calendar_month,
                  AppColors.warning,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMiniStatCard(
                  'Net Pay',
                  '\$${stats.monthlyPayroll.toStringAsFixed(0)}',
                  Icons.attach_money,
                  AppColors.secondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // My Tasks
          Text('My Tasks', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stats.assignedTasks.length,
            itemBuilder: (context, index) {
              final task = stats.assignedTasks[index];
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.greyLight),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: task.isCompleted
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.primary.withOpacity(0.1),
                    child: Icon(
                      task.isCompleted ? Icons.check : Icons.work,
                      color: task.isCompleted
                          ? AppColors.success
                          : AppColors.primary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    task.title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: task.isCompleted
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Due: ${task.deadline.day}/${task.deadline.month}',
                    style: AppTextStyles.bodySmall,
                  ),
                  trailing: task.isCompleted
                      ? const Icon(Icons.check_circle, color: AppColors.success)
                      : const Icon(
                          Icons.circle_outlined,
                          color: AppColors.textSecondary,
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyles.bodySmall),
          Text(value, style: AppTextStyles.h3),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.business, size: 48, color: AppColors.white),
                const SizedBox(height: 16),
                Text(
                  'HR System',
                  style: AppTextStyles.h2.copyWith(color: AppColors.white),
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthAuthenticated) {
                      return Text(
                        state.user.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white.withOpacity(0.9),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.dashboard,
            title: 'Dashboard',
            route: '/dashboard',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.people,
            title: 'Employees',
            route: '/employees',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.calendar_today,
            title: 'Attendance',
            route: '/attendance',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.beach_access,
            title: 'Leave Requests',
            route: '/leaves',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.attach_money,
            title: 'Payroll',
            route: '/payroll',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.wc,
            title: 'Bathroom',
            route: '/bathroom',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.task,
            title: 'Tasks',
            route: '/tasks',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.campaign,
            title: 'Announcements',
            route: '/announcements',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.calendar_month,
            title: 'Calendar',
            route: '/calendar',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.reviews,
            title: 'Reviews',
            route: '/reviews',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.attach_money,
            title: 'Expenses',
            route: '/expenses',
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final bool isSelected =
        GoRouter.of(context).routerDelegate.currentConfiguration.uri.path ==
        route;

    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primary : null),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary : null,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }
}
