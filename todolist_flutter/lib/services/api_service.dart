import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.3:8000/api';
  String? token;

  // Login
  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      token = data['token'];
    } else {
      throw Exception('Login gagal: ${response.body}');
    }
  }

  //  Register 
  Future<void> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      token = data['token'];
    } else {
      throw Exception('Registrasi gagal: ${response.body}');
    }
  }

  //  Fetch Tasks
  Future<List<Task>> fetchTasks() async {
    _checkToken();

    final response = await http.get(
      Uri.parse('$baseUrl/todos'),
      headers: _authHeaders(),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Token tidak valid atau kadaluwarsa');
    } else {
      throw Exception('Gagal mengambil tugas: ${response.body}');
    }
  }

  //  Add Task
  Future<void> addTask(Task task) async {
    _checkToken();

    final response = await http.post(
      Uri.parse('$baseUrl/todos'),
      headers: _authHeaders(),
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Gagal menyimpan tugas: ${response.body}');
    }
  }

  // Update Task 
  Future<void> updateTask(Task task) async {
    _checkToken();

    final response = await http.put(
      Uri.parse('$baseUrl/todos/${task.id}'),
      headers: _authHeaders(),
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui tugas: ${response.body}');
    }
  }

  // Delete Task
  Future<void> deleteTask(int id) async {
    _checkToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/todos/$id'),
      headers: _authHeaders(),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus tugas: ${response.body}');
    }
  }

  // Logout 
  Future<void> logoutFromServer() async {
    if (token == null) return;

    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: _authHeaders(),
    );

    
    token = null;

    if (response.statusCode != 200) {
      throw Exception('Logout gagal: ${response.body}');
    }
  }

  
  void logout() {
    token = null;
  }


  void _checkToken() {
    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login terlebih dahulu');
    }
  }

  Map<String, String> _authHeaders() => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
}
