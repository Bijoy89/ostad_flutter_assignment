import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/Task_count_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../providers/new_task_list_provider.dart';
import '../widgets/CenteredCircularProgress.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/taskcard.dart';
import 'add_new_task_screen.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  bool _getTaskCountInProgress = false;
  List<TaskCountModel> _taskCountList = [];

  @override
  void initState() {
    super.initState();

    ///  Run provider & API calls after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getTaskCountList();
      context.read<New_task_listProvider>().getNewTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildTaskSummaryListView(),

            Consumer<New_task_listProvider>(
              builder: (context, provider, _) {
                return Visibility(
                  visible: !provider.getNewTasklistINProgress,
                  replacement: const SizedBox(
                    height: 200,
                    child: CenteredCircularProgress(),
                  ),
                  child: ListView.separated(
                    itemCount: provider.newTaskList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskModel: provider.newTaskList[index],
                        refreshList: () {
                          provider.getNewTaskList();
                          _getTaskCountList();
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTaskButton,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onTapAddNewTaskButton() {
    Navigator.pushNamed(context, AddNewTaskScreen.name);
  }

  Widget _buildTaskSummaryListView() {
    return SizedBox(
      height: 60,
      child: Visibility(
        visible: !_getTaskCountInProgress,
        replacement: const CenteredCircularProgress(),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _taskCountList.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(left: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _taskCountList[index].sum.toString(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      _taskCountList[index].id,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _getTaskCountList() async {
    setState(() => _getTaskCountInProgress = true);

    final NetworkResponse response =
    await NetworkCaller.getRequest(Urls.taskCountUrl);

    if (response.isSuccess) {
      _taskCountList = (response.body['data'] as List)
          .map((e) => TaskCountModel.fromJson(e))
          .toList();
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }

    setState(() => _getTaskCountInProgress = false);
  }
}
