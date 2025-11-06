// lib/features/auth/data/datasources/auth_remote_data_source.dart

import '../../../../core/network/api_client.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;
  AuthRemoteDataSource({required this.apiClient});

  /// Giả sử API của bạn trả JSON mà login_response_model.dart parse được.
  Future<UserModel> login(String email, String password) async {
    final request = LoginRequestModel(email: email, password: password);
    final response = await apiClient.post(
      '/auth/login', // chỉnh đường dẫn theo API bạn
      data: request.toJson(),
    );

    // Nếu bạn đã có LoginResponseModel class, dùng nó:
    try {
      // response là Dio Response; response.data thường là Map<String, dynamic>
      final data = response.data;
      // Nếu bạn đã có LoginResponseModel.fromJson:
      // final loginResp = LoginResponseModel.fromJson(data);
      // return UserModel.fromJson(loginResp.toJson()); // nếu loginResp có toJson

      // Nếu không, map trực tiếp data -> UserModel
      return UserModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      // bọc lỗi để gọi bên ngoài xử lý
      throw Exception('Login failed: $e');
    }
  }
}
