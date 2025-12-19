import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/completed_task_list_provider.dart';
import '../widgets/CenteredCircularProgress.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/taskcard.dart';

class CompletedTaskListScreen extends StatelessWidget {
  const CompletedTaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompletedTaskListProvider()
        ..getCompletedTaskList(),
      child: const _CompletedTaskListView(),
    );
  }
}

class _CompletedTaskListView extends StatelessWidget {
  const _CompletedTaskListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CompletedTaskListProvider>(
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
                refreshList: provider.getCompletedTaskList,
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 8),
          );
        },
      ),
    );
  }
}
