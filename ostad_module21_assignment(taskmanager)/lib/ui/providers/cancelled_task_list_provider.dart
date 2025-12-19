import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class CancelledTaskListProvider extends ChangeNotifier {
  bool _loading = false;
  String? _errorMessage;
  List<TaskModel> _taskList = [];

  bool get loading => _loading;
  List<TaskModel> get taskList => _taskList;
  String? get errorMessage => _errorMessage;

  Future<void> getCancelledTaskList() async {
    _loading = true;
    notifyListeners();

    final response =
    await NetworkCaller.getRequest(Urls.cancelledTasksUrl);

    if (response.isSuccess) {
      _taskList = (response.body['data'] as List)
          .map((e) => TaskModel.fromJson(e))
          .toList();
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _loading = false;
    notifyListeners();
  }
}
