package com.example.board.controller;

import com.example.board.dto.LoginInfo;
import com.example.board.dto.User;
import com.example.board.service.Userservice;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
public class UserController {

    private final Userservice userservice;

    // http://localhost:8081/userRegForm
    // classpath:/templates/userRegForm.html
    // 회원가입 폼
    @GetMapping("/userRegForm")
    public String userRegform() {
        return "userRegForm";
    }

    // 회원가입 처리
    @PostMapping("/userReg")
    public String userReg(
            @RequestParam("id") String id,
            @RequestParam("password") String password,
            @RequestParam("password_check") String password_check,
            @RequestParam("nickname") String nickname,
            @RequestParam("email") String email
    ) {
        if (!password.equals(password_check)) {
            throw new RuntimeException("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
        }
        if (!email.contains("@")) {
            throw new RuntimeException("올바른 이메일 형식을 입력하세요.");
        }
        if (id.matches(".*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*")) {
            throw new RuntimeException("아이디에는 한글을 사용할 수 없습니다.");
        }
        if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[\\W_]).{8,20}$")) {
            throw new RuntimeException("비밀번호는 8~20자리이며, 영문 대소문자, 숫자, 특수문자를 모두 포함해야 합니다.");
        }
        if (userservice.checkDuplicate("id", id)) {
            throw new RuntimeException("이미 사용 중인 아이디입니다.");
        }
        if (userservice.checkDuplicate("nickname", nickname)) {
            throw new RuntimeException("이미 사용 중인 닉네임입니다.");
        }

        userservice.addUser(email, id, password, nickname);
        return "redirect:welcome";
    }

    @GetMapping("/welcome")
    public String welcome() {
        return "welcome";
    }

    @GetMapping("/loginform")
    public String loginform() {
        return "loginform";
    }

    // 로그인
    @PostMapping("/login")
    public String login(
            @RequestParam("id") String id,
            @RequestParam("password") String password,
            HttpSession session
    ) {
        try {
            User user = userservice.getUser(id);
            if (user.getPassword().equals(password)) {
                // Base64 이미지 변환
                String base64Image = userservice.getProfileImageBase64(user.getId());
                if (base64Image != null) {
                    user.setProfileImage(base64Image);
                }

                // 세션 저장
                session.setAttribute("loginUser", user);
                LoginInfo loginInfo = new LoginInfo(user.getUserId(), user.getId(), user.getNickname());
                loginInfo.setRoles(userservice.getRoles(user.getUserId()));
                session.setAttribute("loginInfo", loginInfo);
            } else {
                return "redirect:/loginform?error=true";
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return "redirect:/loginform?error=true";
        }
        return "redirect:/share";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/share";
    }

    // 아이디 찾기 폼
    @GetMapping("/findIdForm")
    public String findIdForm() {
        return "findIdForm";
    }

    // 아이디 찾기 처리
    @PostMapping("/findId")
    public String findId(
            @RequestParam("nickname") String nickname,
            @RequestParam("email") String email,
            Model model) {

        String foundId = userservice.findIdByNicknameAndEmail(nickname, email);

        if (foundId == null) {
            model.addAttribute("findError", "등록된 아이디가 없습니다.");
        } else {
            model.addAttribute("foundId", foundId);
        }

        // 결과도 같은 폼 페이지로 반환 → alert 팝업 처리
        return "findIdForm";
    }

    // 비밀번호 찾기 폼
    @GetMapping("/findPwForm")
    public String findPwForm() {
        return "findPwForm";
    }

    // 비밀번호 찾기 처리
    @PostMapping("/findPw")
    public String findPw(
            @RequestParam("id") String id,
            @RequestParam("email") String email,
            Model model) {

        String foundPw = userservice.findPwByIdAndEmail(id, email);

        if (foundPw == null) {
            model.addAttribute("findError", "등록된 정보가 없습니다.");
        } else {
            model.addAttribute("foundPw", foundPw);
        }

        return "findPwForm";
    }
}
