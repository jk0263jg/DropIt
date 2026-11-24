import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:microstone_clothing_bin/loginPage/loginMainPage.dart';
import 'package:microstone_clothing_bin/logo.dart';

class BottomIcon3 extends StatefulWidget {
  const BottomIcon3({super.key});

  @override
  State<BottomIcon3> createState() => _BottomIcon3State();
}

class _BottomIcon3State extends State<BottomIcon3> {
  bool isLoading = true;
  bool isLoggedIn = false;
  String? userId;
  String? email;
  String? nickname;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://backend-project-smcp.onrender.com/api/user/info?userId=123",
        ), // 🔹 로그인 상태 확인 API
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          isLoggedIn = data["isLoggedIn"] ?? false;
          userId = data["userId"];
          email = data["email"];
          nickname = data["nickname"];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoggedIn = false;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoggedIn = false;
        isLoading = false;
      });
    }
  }

  // 회원정보 표시 TextField 스타일
  Widget _buildInfoField(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: TextEditingController(text: value),
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.deepPurple),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.deepPurple),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.deepPurple, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  // 보라색 버튼 스타일
  Widget _buildPurpleButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 로그인 안 된 경우
    if (!isLoggedIn) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Logo(),
              SizedBox(height: 64),
              const Text("로그인 후 사용 가능한 페이지입니다."),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                child: const Text("로그인하기"),
              ),
            ],
          ),
        ),
      );
    }

    // 로그인 될 경우
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Logo(),
              const SizedBox(height: 32),

              // 구분선
              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 16),

              // 회원정보
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "회원정보",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),

              // 아이디
              _buildInfoField("아이디", userId),
              const SizedBox(height: 16),

              // 이메일
              _buildInfoField("이메일", email),
              const SizedBox(height: 16),

              // 닉네임
              _buildInfoField("닉네임", nickname),
              const SizedBox(height: 32),

              // 버튼들
              _buildPurpleButton("비밀번호 변경", () {
                // 비밀번호 변경 API
              }),
              const SizedBox(height: 16),
              _buildPurpleButton("로그아웃", () {
                // 로그아웃 API
              }),
              const SizedBox(height: 16),
              _buildPurpleButton("회원탈퇴", () {
                // 회원탈퇴 API
              }),
            ],
          ),
        ),
      ),
    );
  }
}
