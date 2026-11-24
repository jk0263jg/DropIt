import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'FindPwPage2.dart';
import 'Find_Er.dart';

class FindPwPage1 extends StatefulWidget {
  const FindPwPage1({Key? key}) : super(key: key);

  @override
  State<FindPwPage1> createState() => _FindPwPage1State();
}

class _FindPwPage1State extends State<FindPwPage1> {
  final TextEditingController _idController = TextEditingController();
  bool _isLoading = false;

  /// 🧭 서버에 ID 존재 여부 확인
  Future<bool> _checkUserExists(String userId) async {
    try {
      // 실제 API 주소로 교체하세요
      final url = Uri.parse(
        'https://backend-project-smcp.onrender.com/api/user/check-id?userId=$userId',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // 예: {"exists": true} 또는 {"exists": false} 형태라고 가정
        if (data['exists'] == true) {
          return true;
        } else {
          return false;
        }
      } else {
        debugPrint('서버 오류: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('ID 확인 중 오류 발생: $e');
      return false;
    }
  }

  /// ✅ 다음 단계 이동
  Future<void> _goToNextPage() async {
    final id = _idController.text.trim();

    if (id.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("아이디를 입력해주세요.")));
      return;
    }

    setState(() => _isLoading = true);
    final exists = await _checkUserExists(id);
    setState(() => _isLoading = false);

    if (exists) {
      // ✅ ID 존재 → 비밀번호 재설정 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ResetPwPage(userId: id)),
      );
    } else {
      // ❌ ID 없음 → 오류 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FindErrorPage()),
      );
    }
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
          "비밀번호 재설정",
          style: TextStyle(
            color: Color(0xFF673AB7),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              "아이디",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                hintText: "아이디 입력",
                hintStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF673AB7)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFF673AB7),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _goToNextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF673AB7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "다음으로",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
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
