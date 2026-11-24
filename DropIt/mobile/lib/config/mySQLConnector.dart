import 'dart:convert';
import 'package:http/http.dart' as http;

/// ✅ 서버 기본 URL
const String baseUrl = "https://backend-json-74js.onrender.com";

/// =======================================================
/// 🧩 로그인 / 사용자 서비스
/// =======================================================
class LoginService {
  /// 🔐 로그인
  Future<Map<String, dynamic>?> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/api/user/login");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("로그인 실패: ${response.body}");
    }
  }

  /// 🔑 비밀번호 재설정 (마이페이지용)
  Future<bool> resetPassword(String email) async {
    final url = Uri.parse("$baseUrl/api/mypage/resetPassword");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["success"] == true ||
          data["message"]?.toString().contains("성공") == true;
    } else {
      throw Exception("비밀번호 재설정 실패: ${response.body}");
    }
  }
}

/// =======================================================
/// 🧩 회원가입 / 중복 확인 서비스
/// =======================================================
class RegisterService {
  /// ✅ 공통 응답 처리 함수
  bool _isAvailableResponse(String body) {
    try {
      final data = jsonDecode(body);

      if (data["available"] == true || data["available"] == "true") return true;
      if (data["exists"] == false || data["exists"] == "false") return true;
      if (data["success"] == true || data["result"] == "ok") return true;
      if (data["message"] != null &&
          data["message"].toString().contains("사용 가능"))
        return true;

      return false;
    } catch (_) {
      return false;
    }
  }

  /// ✅ 이메일 중복 체크
  Future<bool> checkEmail(String email) async {
    if (email.isEmpty) return false;
    final url = Uri.parse("$baseUrl/api/user/check-email?email=$email");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return _isAvailableResponse(response.body);
    } else {
      throw Exception("이메일 중복 확인 실패: ${response.body}");
    }
  }

  /// ✅ 아이디 중복 체크
  Future<bool> checkUsername(String username) async {
    if (username.isEmpty) return false;
    final url = Uri.parse("$baseUrl/api/user/check-id?username=$username");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return _isAvailableResponse(response.body);
    } else {
      throw Exception("아이디 중복 확인 실패: ${response.body}");
    }
  }

  /// ✅ 닉네임 중복 체크
  Future<bool> checkNickname(String nickname) async {
    if (nickname.isEmpty) return false;
    final url = Uri.parse(
      "$baseUrl/api/user/check-nickname?nickname=$nickname",
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return _isAvailableResponse(response.body);
    } else {
      throw Exception("닉네임 중복 확인 실패: ${response.body}");
    }
  }

  /// ✅ 회원가입
  Future<Map<String, dynamic>?> register({
    required String email,
    required String username,
    required String password,
    required String nickname,
  }) async {
    final url = Uri.parse("$baseUrl/api/user/register");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "username": username,
        "password": password,
        "nickname": nickname,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("회원가입 실패: ${response.body}");
    }
  }
}

/// =======================================================
/// 🧩 마이페이지 관련 서비스
/// =======================================================
class MyPageService {
  /// 프로필 사진 업로드
  Future<bool> uploadProfile(String userId, String imageUrl) async {
    final url = Uri.parse("$baseUrl/api/mypage/uploadProfile");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId, "imageUrl": imageUrl}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["success"] == true;
    } else {
      throw Exception("프로필 업로드 실패: ${response.body}");
    }
  }

  /// 회원 탈퇴
  Future<bool> deleteAccount(String userId) async {
    final url = Uri.parse("$baseUrl/api/mypage/deleteAccount");
    final response = await http.delete(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["success"] == true ||
          data["message"]?.toString().contains("삭제") == true;
    } else {
      throw Exception("회원 탈퇴 실패: ${response.body}");
    }
  }
}

/// =======================================================
/// 🧩 게시판 모델 및 서비스
/// =======================================================
class Board {
  final int? id;
  final String title;
  final String content;
  final String? author;
  final DateTime? createdAt;

  Board({
    this.id,
    required this.title,
    required this.content,
    this.author,
    this.createdAt,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'content': content, 'author': author};
  }
}

class BoardService {
  final String _boardUrl = "$baseUrl/api/boards"; // ✅ 수정 완료

  /// 게시글 목록 조회
  Future<List<Board>> fetchBoards() async {
    final response = await http.get(Uri.parse(_boardUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Board.fromJson(json)).toList();
    } else {
      throw Exception("게시글 목록 불러오기 실패: ${response.statusCode}");
    }
  }

  /// 게시글 검색
  Future<List<Board>> searchBoards(String keyword) async {
    final uri = Uri.parse("$_boardUrl?search=$keyword");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Board.fromJson(json)).toList();
    } else {
      throw Exception("게시글 검색 실패: ${response.statusCode}");
    }
  }

  /// 게시글 작성
  Future<Board> createBoard(Board board) async {
    final response = await http.post(
      Uri.parse(_boardUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(board.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Board.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("게시글 작성 실패: ${response.statusCode}");
    }
  }

  /// 게시글 상세 조회
  Future<Board> fetchBoardDetail(int id) async {
    final response = await http.get(Uri.parse("$_boardUrl/$id"));
    if (response.statusCode == 200) {
      return Board.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("게시글 상세 조회 실패: ${response.statusCode}");
    }
  }
}
