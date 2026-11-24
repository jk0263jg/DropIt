import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:microstone_clothing_bin/loginPage/loginMainPage.dart';

class FindIdPage2 extends StatefulWidget {
  final String email;

  const FindIdPage2({Key? key, required this.email}) : super(key: key);

  @override
  State<FindIdPage2> createState() => _FindIdPage2State();
}

class _FindIdPage2State extends State<FindIdPage2> {
  String? _username;
  bool _isLoading = true;

  final String baseUrl = "https://backend-json-74js.onrender.com";

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    try {
      final url = Uri.parse("$baseUrl/api/user/find-id?email=${widget.email}");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _username = data["username"];
        });
      }
    } catch (e) {
      debugPrint("아이디 찾기 오류: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _maskUsername(String username) {
    if (username.length <= 3) return username;
    final visible = username.substring(0, 3);
    return "$visible*******";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "아이디 찾기",
          style: TextStyle(
            color: Color(0xFF673AB7),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF673AB7)),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "입력하신 정보와\n일치하는 아이디 목록입니다.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      _username != null
                          ? _maskUsername(_username!)
                          : "해당 이메일로 가입된 계정이 없습니다.",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF673AB7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "로그인 화면으로 돌아가기",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white, // ✅ 버튼 텍스트 화이트
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
    );
  }
}
