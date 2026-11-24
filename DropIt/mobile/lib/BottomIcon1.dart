import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:microstone_clothing_bin/Sharing/sharing_item.dart';
import 'package:microstone_clothing_bin/Sharing/write_post_button.dart';
import 'package:microstone_clothing_bin/loginPage/loginMainPage.dart';
import 'package:microstone_clothing_bin/logo.dart';

/// ✅ 게시판 페이지 (BottomIcon1)
class BottomIcon1 extends StatefulWidget {
  const BottomIcon1({super.key});

  @override
  State<BottomIcon1> createState() => _BottomIcon1State();
}

class _BottomIcon1State extends State<BottomIcon1> {
  late Future<List<Map<String, dynamic>>> _boardListFuture;
  List<Map<String, dynamic>> _filteredBoardList = [];
  bool isLoggedIn = true; // 로그인 여부 (임시 true로 설정)
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _boardListFuture = fetchBoardList();
  }

  /// 📡 서버에서 게시글 목록 가져오기
  Future<List<Map<String, dynamic>>> fetchBoardList() async {
    try {
      final response = await http.get(
        Uri.parse('https://backend-project-smcp.onrender.com/api/board'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<Map<String, dynamic>> list = [];

        if (jsonResponse is List) {
          list = List<Map<String, dynamic>>.from(jsonResponse);
        } else if (jsonResponse['data'] is List) {
          list = List<Map<String, dynamic>>.from(jsonResponse['data']);
        }

        setState(() {
          _filteredBoardList = list;
          isLoading = false;
        });

        return list;
      } else {
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('게시글 불러오기 실패: $e');
    }
  }

  /// 🔄 검색/정렬 결과 반영 콜백
  void _updateFilteredList(List<Map<String, dynamic>> newList) {
    setState(() {
      _filteredBoardList = newList;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
              const SizedBox(height: 64),
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

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmall = screenWidth < 640;
    final isMedium = screenWidth < 768;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _boardListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const LoginRequiredPage();
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("게시글이 없습니다."));
          }

          final boardList = snapshot.data!;

          return Container(
            width: isMedium ? double.infinity : 390,
            height: isMedium ? double.infinity : 844,
            constraints: BoxConstraints(
              maxWidth: isMedium ? double.infinity : 390,
              minHeight: isMedium ? screenHeight : 844,
            ),
            child: Stack(
              children: [
                // 메인 콘텐츠
                Positioned(
                  left: isSmall ? 16 : (isMedium ? 20 : 30),
                  top: isSmall ? 16 : (isMedium ? 20 : 67),
                  child: Container(
                    width: isSmall
                        ? screenWidth - 32
                        : (isMedium ? screenWidth - 40 : 330),
                    height: isMedium ? null : 693,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // ✅ 헤더 (검색 + 정렬 + 개수)
                          ListingHeader(
                            boardList: boardList,
                            onUpdate: _updateFilteredList,
                          ),
                          const SizedBox(height: 16),

                          // ✅ 게시글 목록
                          Column(
                            children: _filteredBoardList.map((board) {
                              return SharingItem(
                                image:
                                    board['imageUrl'] ??
                                    'https://via.placeholder.com/150',
                                title: board['title'] ?? '제목 없음',
                                location: board['location'] ?? '위치 정보 없음',
                                distance: board['createdAt'] ?? '작성일 정보 없음',
                              );
                            }).toList(),
                          ),
                          if (isMedium) const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),

                // 📝 글쓰기 버튼
                const WritePostButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 로그인 필요 페이지
class LoginRequiredPage extends StatelessWidget {
  const LoginRequiredPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Logo(),
            const SizedBox(height: 64),
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
}

/// 🔍 ListingHeader 위젯 (검색 + 정렬 + 게시글 개수)
class ListingHeader extends StatefulWidget {
  final List<Map<String, dynamic>> boardList;
  final Function(List<Map<String, dynamic>>) onUpdate;

  const ListingHeader({
    Key? key,
    required this.boardList,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<ListingHeader> createState() => _ListingHeaderState();
}

class _ListingHeaderState extends State<ListingHeader> {
  final TextEditingController _searchController = TextEditingController();
  late List<Map<String, dynamic>> _filteredList;
  String _currentSort = "최신순";

  @override
  void initState() {
    super.initState();
    _filteredList = List.from(widget.boardList);
  }

  /// 🔍 검색
  void _handleSearch() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredList = List.from(widget.boardList);
      });
      widget.onUpdate(_filteredList);
      return;
    }

    final results = widget.boardList.where((board) {
      final title = (board['title'] ?? '').toString().toLowerCase();
      final content = (board['content'] ?? '').toString().toLowerCase();
      return title.contains(query) || content.contains(query);
    }).toList();

    setState(() {
      _filteredList = results;
    });
    widget.onUpdate(_filteredList);
  }

  /// 🔽 정렬
  void _handleSort(String type) {
    List<Map<String, dynamic>> sorted = List.from(_filteredList);

    if (type == '최신순') {
      sorted.sort((a, b) {
        final aTime = DateTime.tryParse(a['createdAt'] ?? '') ?? DateTime(0);
        final bTime = DateTime.tryParse(b['createdAt'] ?? '') ?? DateTime(0);
        return bTime.compareTo(aTime);
      });
    } else if (type == '거리순') {
      sorted.sort((a, b) {
        final aDist = double.tryParse(a['distance']?.toString() ?? '0') ?? 0;
        final bDist = double.tryParse(b['distance']?.toString() ?? '0') ?? 0;
        return aDist.compareTo(bDist);
      });
    }

    setState(() {
      _currentSort = type;
      _filteredList = sorted;
    });
    widget.onUpdate(_filteredList);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 640;

    return Container(
      width: 330,
      margin: EdgeInsets.only(bottom: isSmall ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildSearchField(),
          const SizedBox(height: 16),
          isSmall
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_filteredList.length}개',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF18181B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildSortButton('거리순'),
                        const SizedBox(width: 8),
                        _buildSortButton('최신순'),
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_filteredList.length}개',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF18181B),
                      ),
                    ),
                    Row(
                      children: [
                        _buildSortButton('거리순'),
                        const SizedBox(width: 8),
                        _buildSortButton('최신순'),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onSubmitted: (_) => _handleSearch(),
            decoration: InputDecoration(
              hintText: "검색어를 입력하세요",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _handleSearch,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF673AB7),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("검색", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildSortButton(String text) {
    final isSelected = _currentSort == text;
    return GestureDetector(
      onTap: () => _handleSort(text),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isSelected ? const Color(0xFF673AB7) : const Color(0xFFA3A3A3),
          decoration: isSelected
              ? TextDecoration.underline
              : TextDecoration.none,
        ),
      ),
    );
  }
}
