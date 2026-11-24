package com.example.board.service;

import com.example.board.dao.WishDao;
import com.example.board.dto.Wish;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WishService {

    private final WishDao wishDao;

    public WishService(WishDao wishDao) {
        this.wishDao = wishDao;
    }

    public void addWish(String userId, Long binId) {
        Wish wish = new Wish();
        wish.setUserId(userId);
        wish.setBinId(binId);
        wishDao.addWish(wish);
    }

    public void removeWish(String userId, Long binId) {
        wishDao.removeWish(userId, binId);
    }

    public List<Wish> getUserWishes(String userId) {
        return wishDao.getUserWishes(userId);
    }
}
