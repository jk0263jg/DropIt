# API 요약 (backend/api-server)

Base path: `/api` · 응답: JSON · 실행 후 `/swagger-ui/index.html` 에서 springdoc 문서 확인

## 사용자

| Method | Path | 설명 |
| --- | --- | --- |
| POST | `/user/register` | 회원가입 |
| POST | `/user/login` | 로그인 (BCrypt 비교) |
| POST | `/user/logout` | 로그아웃 |
| POST | `/user/find-id` | 아이디 찾기 |
| POST | `/user/find-password` | 비밀번호 찾기 (본인 확인) |
| POST | `/user/reset-password` | 비밀번호 재설정 |
| GET | `/user/check-id` · `/user/check-nickname` · `/user/check-email` | 중복 확인 |

## 마이페이지

| Method | Path | 설명 |
| --- | --- | --- |
| GET | `/mypage/info` | 내 정보 조회 |
| POST | `/mypage/uploadProfile` | 프로필 이미지 업로드 (Cloudinary) |
| POST | `/mypage/resetPassword` | 비밀번호 변경 |
| POST | `/mypage/deleteAccount` | 회원 탈퇴 |

## 의류수거함

| Method | Path | 설명 |
| --- | --- | --- |
| GET | `/clothing-bins?lat=&lng=&radiusKm=` | 반경 검색 (MySQL 전용 쿼리) |
| GET | `/clothing-bins/in-bounds?swLat=&swLng=&neLat=&neLng=` | 지도 화면 범위 내 조회 |
| GET | `/markers/{binId}/posts` | 수거함 후기 목록 |
| POST | `/markers/{binId}/posts` | 수거함 후기 작성 |

## 나눔 게시판 · 즐겨찾기

| Method | Path | 설명 |
| --- | --- | --- |
| GET | `/boards` · `/boards/{boardId}` | 목록 / 상세 |
| POST | `/boards` | 작성 |
| PUT | `/boards/{boardId}` | 수정 |
| DELETE | `/boards/{boardId}` | 삭제 |
| POST | `/wish/add/{binId}` | 즐겨찾기 추가 |
| DELETE | `/wish/remove/{binId}` | 즐겨찾기 해제 |
| GET | `/wish/list` | 내 즐겨찾기 목록 |

# backend/marker-service

| Method | Path | 설명 |
| --- | --- | --- |
| GET | `/api/clothing-bins?lat=&lng=&radiusKm=` | 반경 검색 (파라미터 없으면 전체) |
| GET | `/api/clothing-bins/inbounds?swLat=&swLng=&neLat=&neLng=` | 지도 범위 조회 |

# backend/marker-proxy

| Method | Path | 설명 |
| --- | --- | --- |
| GET | `/mid/bins` | marker-service 전체 조회 결과 전달 |
| GET | `/api/proxy/clothing-bins` | 프록시 조회 |
