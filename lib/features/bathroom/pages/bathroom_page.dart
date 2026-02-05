import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/bathroom_cubit.dart';
import '../cubit/bathroom_state.dart';

class BathroomPage extends StatelessWidget {
  const BathroomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bathroom Request'),
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
      body: BlocBuilder<BathroomCubit, BathroomState>(
        builder: (context, state) {
          if (state is BathroomLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BathroomError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is BathroomStatusLoaded) {
            return _buildContent(context, state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, BathroomStatusLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStatusCard(state),
          const SizedBox(height: 24),
          _buildActionButton(context, state),
          const SizedBox(height: 24),
          const Text(
            'Waiting List',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: state.queue.isEmpty
                ? const Center(child: Text('Waiting list is empty'))
                : ListView.builder(
                    itemCount: state.queue.length,
                    itemBuilder: (context, index) {
                      final entry = state.queue[index];
                      // Format duration simply
                      final duration = DateTime.now().difference(
                        entry.joinedAt,
                      );
                      return ListTile(
                        leading: CircleAvatar(child: Text(entry.user.name[0])),
                        title: Text(entry.user.name),
                        subtitle: Text(
                          'Waiting for ${duration.inMinutes} mins',
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BathroomStatusLoaded state) {
    final color = state.isOccupied ? Colors.red : Colors.green;
    final text = state.isOccupied ? 'Occupied' : 'Vacant';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            state.isOccupied ? Icons.lock : Icons.lock_open,
            size: 48,
            color: color,
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (state.isOccupied && state.currentUserInBathroom != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'By: ${state.currentUserInBathroom!.name}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, BathroomStatusLoaded state) {
    if (state.isMeInBathroom) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () => context.read<BathroomCubit>().leave(),
        child: const Text('I am done, Leave Bathroom'),
      );
    }

    if (state.isMeInQueue) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () => context.read<BathroomCubit>().leave(),
        child: const Text('Leave Waiting List'),
      );
    }

    // Default: Request entry
    // If occupied -> "Join Waiting List"
    // If vacant -> "Go to Bathroom"

    final label = state.isOccupied ? 'Join Waiting List' : 'Go to Bathroom';
    final color = state.isOccupied ? Colors.orange : Colors.blue;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () => context.read<BathroomCubit>().requestEntry(),
      child: Text(label),
    );
  }
}
