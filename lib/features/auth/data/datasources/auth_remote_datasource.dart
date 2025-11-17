// lib/features/auth/data/datasources/auth_remote_data_source.dart

import '../../../../core/network/api_client.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;
  AuthRemoteDataSource({required this.apiClient});

  /// Giả sử API của bạn trả JSON mà login_response_model.dart parse được.
  Future<LoginResponseModel> login(String username, String password) async {
    final response = await apiClient.post(
      '/api/auth/login',
      data: {"username": username, "password": password},
    );

    return LoginResponseModel.fromJson(response.data);
  }
}
