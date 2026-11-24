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
public class Wish {
    private Long id;
    private String userId;  // User.id 기준
    private Long binId;
    private LocalDateTime createdAt;
}
