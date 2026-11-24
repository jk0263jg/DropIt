package com.example.board.controller;

import com.example.board.dto.User;
import com.example.board.service.Userservice;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequiredArgsConstructor
public class MyPageController {

    private final Userservice userservice;

    // 마이페이지 진입
    @GetMapping("/mypage")
    public String myPage(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/loginform";
        }
        model.addAttribute("loginUser", loginUser);
        return "mypage";
    }

    // 프로필 이미지 업로드
    @PostMapping("/mypage/uploadProfile")
    public String uploadProfile(@RequestParam("profileImage") MultipartFile file,
                                HttpSession session,
                                Model model) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/loginform";

        if (file == null || file.isEmpty()) {
            model.addAttribute("error", "파일을 선택해주세요.");
            model.addAttribute("loginUser", loginUser);
            return "mypage";
        }

        try {
            // DB에 byte[] 저장 후 Base64 반환
            String base64Image = userservice.saveProfileImage(file, loginUser.getId());
            // 세션 업데이트
            loginUser.setProfileImage(base64Image);
            session.setAttribute("loginUser", loginUser);

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "프로필 이미지 저장 실패");
            model.addAttribute("loginUser", loginUser);
            return "mypage";
        }

        return "redirect:/mypage";
    }

    // 비밀번호 재설정
    @PostMapping("/mypage/resetPassword")
    public String resetPassword(@RequestParam("newPassword") String newPassword,
                                @RequestParam("newPasswordCheck") String newPasswordCheck,
                                HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/loginform";
        }

        if (!newPassword.equals(newPasswordCheck)) {
            model.addAttribute("error", "비밀번호가 일치하지 않습니다.");
            model.addAttribute("loginUser", loginUser);
            return "mypage";
        }

        if (!newPassword.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[\\W_]).{8,20}$")) {
            model.addAttribute("error", "비밀번호 규칙을 확인하세요 (8~20자리, 영문 대소문자+숫자+특수문자).");
            model.addAttribute("loginUser", loginUser);
            return "mypage";
        }

        userservice.updatePassword(loginUser.getId(), loginUser.getEmail(), newPassword);
        session.invalidate(); // 비밀번호 변경 후 로그아웃
        return "redirect:/loginform?resetSuccess=true";
    }

    // 회원 탈퇴
    @PostMapping("/mypage/deleteAccount")
    public String deleteAccount(HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/loginform";
        }

        userservice.deleteUser(loginUser.getId());
        session.invalidate();
        return "redirect:/goodbye";
    }
}
