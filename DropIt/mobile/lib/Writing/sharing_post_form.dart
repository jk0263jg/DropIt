import 'package:flutter/material.dart';
import 'dart:io';
import 'photo_upload_section.dart';
import 'form_input.dart';
import 'form_textarea.dart';
import 'map_location_section.dart';
import 'submit_button.dart';
import 'package:microstone_clothing_bin/config/mySQLConnector.dart'; // BoardService 포함 파일

class SharingPostForm extends StatefulWidget {
  const SharingPostForm({Key? key}) : super(key: key);

  @override
  State<SharingPostForm> createState() => _SharingPostFormState();
}

class _SharingPostFormState extends State<SharingPostForm> {
  String title = '';
  String description = '';
  String photoPath = ''; // UI용
  String address = ''; // UI용

  void handleTitleChange(String value) {
    setState(() {
      title = value;
    });
  }

  void handleDescriptionChange(String value) {
    setState(() {
      description = value;
    });
  }

  void handlePhotoSelect(File file) {
    setState(() {
      photoPath = file.path;
    });
    debugPrint('Photo selected: $photoPath');
  }

  void handleLocationSelect(String selectedAddress) {
    setState(() {
      address = selectedAddress;
    });
    debugPrint('Address selected: $address');
  }

  Future<void> handleSubmit() async {
    if (!isFormValid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("모든 항목을 입력해주세요.")));
      return;
    }

    try {
      // ✅ Board 모델에 맞게 수정 (photo, address 제거)
      final board = Board(
        title: title,
        content: "$description\n\n[주소] $address\n[사진경로] $photoPath",
        author: "익명", // 로그인 기능 있으면 실제 사용자명으로 변경
      );

      final result = await BoardService().createBoard(board);
      debugPrint("게시글 작성 성공: ${result.toJson()}");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("게시글이 성공적으로 등록되었습니다.")));

      // 입력 초기화
      setState(() {
        title = '';
        description = '';
        photoPath = '';
        address = '';
      });
    } catch (e) {
      debugPrint("게시글 작성 실패: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("게시글 등록 실패: $e")));
    }
  }

  bool get isFormValid {
    return title.trim().isNotEmpty &&
        description.trim().isNotEmpty &&
        address.trim().isNotEmpty &&
        photoPath.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PhotoUploadSection(onPhotoSelect: handlePhotoSelect),
                      FormInput(
                        label: '제목',
                        placeholder: '글 제목을 입력하세요',
                        value: title,
                        onChange: handleTitleChange,
                      ),
                      FormTextarea(
                        label: '자세한 설명',
                        placeholder: '나눔할 물품에 대한 내용을 작성해주세요.',
                        value: description,
                        onChange: handleDescriptionChange,
                      ),
                      MapLocationSection(
                        onLocationSelect: handleLocationSelect,
                      ),
                      SubmitButton(
                        onClick: handleSubmit,
                        disabled: !isFormValid,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
