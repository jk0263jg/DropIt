package com.example.board.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

@Setter
@Getter
@NoArgsConstructor
@ToString
public class User {
    private int userId;
    private String email;
    private String id;
    private String nickname;
    private String password;
    private LocalDateTime redate;

    private String profileImage;     // 파일명
    private byte[] profileImageBlob; // BLOB
}
