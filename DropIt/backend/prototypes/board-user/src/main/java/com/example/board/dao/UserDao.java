package com.example.board.dao;

import com.example.board.dto.User;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.namedparam.*;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.jdbc.core.simple.SimpleJdbcInsertOperations;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Repository
public class UserDao {

    private final NamedParameterJdbcTemplate jdbcTemplate;
    private final SimpleJdbcInsertOperations insertUser;

    public UserDao(DataSource dataSource) {
        jdbcTemplate = new NamedParameterJdbcTemplate(dataSource);
        insertUser = new SimpleJdbcInsert(dataSource)
                .withTableName("`user`")
                .usingGeneratedKeyColumns("user_id")
                .usingColumns("email", "id", "password", "nickname", "redate");
    }

    // 회원가입
    @Transactional
    public User addUser(String email, String id, String password, String nickname) {
        User user = new User();
        user.setEmail(email);
        user.setId(id);
        user.setPassword(password);
        user.setNickname(nickname);
        user.setRedate(LocalDateTime.now());

        SqlParameterSource params = new BeanPropertySqlParameterSource(user);
        Number number = insertUser.executeAndReturnKey(params);
        user.setUserId(number.intValue());
        return user;
    }

    // 유저 권한 매핑
    @Transactional
    public void mappingUserRole(int userId) {
        String sql = "INSERT INTO user_role(user_id, role_id) VALUES (:userId, 1)";
        jdbcTemplate.update(sql, new MapSqlParameterSource("userId", userId));
    }

    // 사용자 조회 (id 기준) → 없으면 null 반환
    @Transactional(readOnly = true)
    public User getUserById(String id) {
        String sql = "SELECT user_id, email, id, password, redate, nickname, " +
                "profile_image_blob AS profileImageBlob, profile_image_name AS profileImageName " +
                "FROM `user` WHERE id = :id";
        MapSqlParameterSource params = new MapSqlParameterSource("id", id);
        try {
            return jdbcTemplate.queryForObject(sql, params, BeanPropertyRowMapper.newInstance(User.class));
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    // 역할 조회
    @Transactional(readOnly = true)
    public List<String> getRoles(int userId) {
        String sql = "SELECT r.role_name " +
                "FROM user_role ur, role r " +
                "WHERE ur.role_id = r.role_id AND ur.user_id = :userId";
        return jdbcTemplate.query(sql, Map.of("userId", userId), (rs, rowNum) -> rs.getString(1));
    }

    // 아이디 찾기
    @Transactional(readOnly = true)
    public String findIdByNicknameAndEmail(String nickname, String email) {
        String sql = "SELECT id FROM `user` WHERE nickname = :nickname AND email = :email";
        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("nickname", nickname)
                .addValue("email", email);
        try {
            return jdbcTemplate.queryForObject(sql, params, String.class);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    // 비밀번호 찾기
    @Transactional(readOnly = true)
    public String findPwByIdAndEmail(String id, String email) {
        String sql = "SELECT password FROM `user` WHERE id = :id AND email = :email";
        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("id", id)
                .addValue("email", email);
        try {
            return jdbcTemplate.queryForObject(sql, params, String.class);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    // 특정 필드 존재 여부 확인 (화이트리스트)
    @Transactional(readOnly = true)
    public boolean existsByField(String field, String value) {
        String column;
        switch (field) {
            case "id": column = "id"; break;
            case "nickname": column = "nickname"; break;
            case "email": column = "email"; break;
            default: throw new IllegalArgumentException("허용되지 않은 필드: " + field);
        }
        String sql = "SELECT COUNT(*) FROM `user` WHERE " + column + " = :value";
        MapSqlParameterSource params = new MapSqlParameterSource("value", value);
        Integer count = jdbcTemplate.queryForObject(sql, params, Integer.class);
        return count != null && count > 0;
    }

    // 닉네임 존재 여부
    @Transactional(readOnly = true)
    public boolean isNicknameExists(String nickname) {
        String sql = "SELECT COUNT(*) FROM `user` WHERE nickname = :nickname";
        Integer count = jdbcTemplate.queryForObject(sql, new MapSqlParameterSource("nickname", nickname), Integer.class);
        return count != null && count > 0;
    }

    // 프로필 이미지 저장
    @Transactional
    public void saveProfileImage(String id, byte[] imageBytes, String filename) {
        String sql = "UPDATE `user` SET profile_image_blob = :imageBlob, profile_image_name = :filename WHERE id = :id";
        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("imageBlob", imageBytes)
                .addValue("filename", filename)
                .addValue("id", id);
        jdbcTemplate.update(sql, params);
    }

    // 프로필 이미지 조회
    @Transactional(readOnly = true)
    public byte[] getProfileImageBlob(String id) {
        String sql = "SELECT profile_image_blob FROM `user` WHERE id = :id";
        try {
            return jdbcTemplate.queryForObject(sql, new MapSqlParameterSource("id", id), byte[].class);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    // 프로필 이미지 파일명 조회
    @Transactional(readOnly = true)
    public String getProfileImageName(String id) {
        String sql = "SELECT profile_image_name FROM `user` WHERE id = :id";
        try {
            return jdbcTemplate.queryForObject(sql, new MapSqlParameterSource("id", id), String.class);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    // 회원 탈퇴
    @Transactional
    public void deleteUser(String id) {
        String sql = "DELETE FROM `user` WHERE id = :id";
        jdbcTemplate.update(sql, Map.of("id", id));
    }

    // 비밀번호 재설정
    @Transactional
    public void updatePassword(String id, String email, String newPassword) {
        String sql = "UPDATE `user` SET password = :password WHERE id = :id AND email = :email";
        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("password", newPassword)
                .addValue("id", id)
                .addValue("email", email);
        jdbcTemplate.update(sql, params);
    }
}
