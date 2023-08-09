import 'package:alfred_app/domain/data/task.dart';
import 'package:alfred_app/domain/remote/responses/remote_list.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'tasks_api.g.dart';

@RestApi()
abstract class _TasksAPI {
  factory _TasksAPI(Dio dio) = __TasksAPI;

  @GET('/tasks')
  Future<RemoteList<Task>> getTasks();

  @POST('/tasks')
  Future<Task> createTask(@Body() Map<String, dynamic> task);

  @PUT('/tasks/{id}')
  Future<Task> updateTask(
      @Path('id') int id, @Body() Map<String, dynamic> task);

  @DELETE('/tasks/{id}')
  Future<void> deleteTask(@Path('id') int id);
}

class TasksAPI extends __TasksAPI {
  TasksAPI(Dio dio) : super(dio);

  Future<List<Task>> fetchTasks() async {
    final remoteList = await getTasks();

    return remoteList.data as List<Task>;
  }

  Future<Task> create({
    required String title,
    required DateTime completeBy,
  }) async {
    final body = {
      "data": {
        "title": title,
        "completed": false,
        "completeBy": completeBy.toUtc().toIso8601String(),
      }
    };
    return await createTask(body);
  }

  Future<Task> update(Task task, bool isCompleted) async {
    final body = {
      "data": {
        "title": task.title,
        "completed": isCompleted,
        "completeBy": task.completeBy.toUtc().toIso8601String(),
      }
    };
    return await updateTask(task.id, body);
  }

  Future<void> delete(Task task) async {
    await deleteTask(task.id);
  }
}
