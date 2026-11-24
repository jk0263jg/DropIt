package com.example.board.service;

import com.example.board.dao.UserDao;
import com.example.board.dto.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.Base64;
import java.util.List;

@Service
@RequiredArgsConstructor
public class Userservice {

    private final UserDao userDao;

    // 회원가입
    @Transactional
    public User addUser(String email, String id, String password, String nickname) {
        User user = userDao.addUser(email, id, password, nickname);
        userDao.mappingUserRole(user.getUserId());
        return user;
    }

    // 사용자 조회
    @Transactional
    public User getUser(String id) {
        return userDao.getUserById(id);
    }

    // 역할 조회
    @Transactional(readOnly = true)
    public List<String> getRoles(int userId) {
        return userDao.getRoles(userId);
    }

    // 아이디 찾기
    @Transactional(readOnly = true)
    public String findIdByNicknameAndEmail(String nickname, String email) {
        return userDao.findIdByNicknameAndEmail(nickname, email);
    }

    // 비밀번호 찾기
    @Transactional(readOnly = true)
    public String findPwByIdAndEmail(String id, String email) {
        return userDao.findPwByIdAndEmail(id, email);
    }

    // 아이디/닉네임 중복 확인
    @Transactional(readOnly = true)
    public boolean checkDuplicate(String type, String value) {
        return userDao.existsByField(type, value);
    }

    @Transactional(readOnly = true)
    public boolean isNicknameExists(String nickname) {
        return userDao.isNicknameExists(nickname);
    }

    // 프로필 이미지 저장 (id 기준) → Base64로 세션 저장용 반환
    @Transactional
    public String saveProfileImage(MultipartFile file, String id) {
        try {
            byte[] bytes = file.getBytes();
            String filename = file.getOriginalFilename();
            userDao.saveProfileImage(id, bytes, filename);
            return "data:image/png;base64," + Base64.getEncoder().encodeToString(bytes);
        } catch (Exception e) {
            throw new RuntimeException("프로필 이미지 저장 실패", e);
        }
    }

    // 프로필 이미지 조회 → Base64 문자열 반환
    @Transactional(readOnly = true)
    public String getProfileImageBase64(String id) {
        // DAO에서 이름 변경된 메서드 사용
        byte[] imageBytes = userDao.getProfileImageBlob(id);
        if (imageBytes != null && imageBytes.length > 0) {
            return "data:image/png;base64," + Base64.getEncoder().encodeToString(imageBytes);
        }
        return null;
    }

    // 회원 탈퇴
    @Transactional
    public void deleteUser(String id) {
        userDao.deleteUser(id);
    }

    // 비밀번호 재설정
    @Transactional
    public void updatePassword(String id, String email, String newPassword) {
        userDao.updatePassword(id, email, newPassword);
    }
}
