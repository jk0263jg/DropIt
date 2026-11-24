package com.example.board.controller;

import com.example.board.service.WishService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/wish")
public class WishController {

    private final WishService wishService;

    public WishController(WishService wishService) {
        this.wishService = wishService;
    }

    // 즐겨찾기 추가
    @PostMapping("/add")
    @ResponseBody
    public String addWish(@RequestParam String userId, @RequestParam Long binId) {
        wishService.addWish(userId, binId);
        return "success";
    }

    // 즐겨찾기 삭제
    @PostMapping("/remove")
    @ResponseBody
    public String removeWish(@RequestParam String userId, @RequestParam Long binId) {
        wishService.removeWish(userId, binId);
        return "success";
    }

    // 회원 즐겨찾기 조회
    @GetMapping("/list")
    @ResponseBody
    public List<Long> getWishes(@RequestParam String userId) {
        return wishService.getUserWishes(userId).stream()
                .map(w -> w.getBinId())
                .toList();
    }
}
