import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cancelled_task_list_provider.dart';
import '../widgets/CenteredCircularProgress.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/taskcard.dart';

class CancelledTaskListScreen extends StatelessWidget {
  const CancelledTaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CancelledTaskListProvider()
        ..getCancelledTaskList(),
      child: const _CancelledTaskListView(),
    );
  }
}

class _CancelledTaskListView extends StatelessWidget {
  const _CancelledTaskListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CancelledTaskListProvider>(
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
                refreshList: provider.getCancelledTaskList,
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 8),
          );
        },
      ),
    );
  }
}
