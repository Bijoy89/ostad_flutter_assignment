import 'package:flutter/cupertino.dart';

import '../../data/models/task_model.dart';
import '../../data/models/user_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../controllers/auth_controller.dart';

//Controller
class New_task_listProvider extends ChangeNotifier {
  bool _getNewTasklistINProgress = false;

  String? _errorMessage;

  List<TaskModel> _newTaskList=[];

 bool get getNewTasklistINProgress => _getNewTasklistINProgress;

  List<TaskModel> get newTaskList => _newTaskList;


  String? get errorMessage => _errorMessage;

  Future<bool> getNewTaskList() async {
    bool isSuccess = false;

    _getNewTasklistINProgress = true;
    notifyListeners();



    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.newTasksUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
   _newTaskList=list;

      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getNewTasklistINProgress = false;
    notifyListeners();

    return isSuccess;
  }


}
