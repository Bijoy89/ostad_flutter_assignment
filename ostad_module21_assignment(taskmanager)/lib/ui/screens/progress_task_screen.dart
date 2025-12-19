import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/progress_task_list_provider.dart';
import '../widgets/CenteredCircularProgress.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/taskcard.dart';

class ProgressTaskListScreen extends StatelessWidget {
  const ProgressTaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProgressTaskListProvider()
        ..getProgressTaskList(),
      child: const _ProgressTaskListView(),
    );
  }
}

class _ProgressTaskListView extends StatelessWidget {
  const _ProgressTaskListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProgressTaskListProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const CenteredCircularProgress();
          }

          if (provider.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showSnackBarMessage(context, provider.errorMessage!);
            });
          }

          return ListView.separated(
            itemCount: provider.taskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: provider.taskList[index],
                refreshList: provider.getProgressTaskList,
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 8),
          );
        },
      ),
    );
  }
}
