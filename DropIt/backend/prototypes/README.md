# prototypes — 초기 백엔드 학습·실험 버전

`api-server`로 합쳐지기 전에 단계별로 만들었던 백엔드입니다. 각각 독립 실행되며, 메인 서버가 어떤 시행착오를 거쳐 만들어졌는지 보여주기 위해 남겨 두었습니다.
(모두 Gradle 프로젝트이며 비밀번호·키는 환경변수로 분리했습니다. 각 폴더의 `.env.example` 참고)

| 폴더 | 시기(원본 파일 날짜) | 내용 | 스택 |
| --- | --- | --- | --- |
| [`public-data-client`](public-data-client) | 2025.06 | 공공데이터포털 「전국 의류수거함 위치 정보」 API(odcloud)를 호출해 수거함 위도·경도·주소를 가져와 `/api/box/markers`로 내려주고, 네이버 지도(`map.html`)에 표시하는 첫 실험 | Spring Boot, RestTemplate, Jackson |
| [`board-user`](board-user) | 2025.08 ~ 09 | 나눔 게시판 CRUD + 회원가입/로그인/아이디·비밀번호 찾기/마이페이지(프로필 사진, 비밀번호 변경, 탈퇴)/즐겨찾기. DAO 계층을 `JdbcTemplate`으로 직접 작성 | Spring Boot 3.5, Thymeleaf, Spring JDBC, MySQL |
| [`cloth-area-jwt`](cloth-area-jwt) | 2025.09경 | 전국 의류수거함 CSV(약 1.4만 건)를 DB에 적재하고 조회 API 제공 + **JWT 기반 회원가입/로그인**(Spring Security, BCrypt, 토큰 유효시간 1시간) | Spring Boot 3.5, JPA, Spring Security, jjwt, MySQL |

## 실행 시 참고

- `board-user`: 이미지 업로드 경로가 Windows 기준 `C:/upload/`로 코드에 고정되어 있습니다 (`WebConfig`, `BoardController`). 다른 환경에서는 수정이 필요합니다.
- `cloth-area-jwt`: `JWT_SECRET`(32자 이상 권장)을 환경변수로 지정해야 기동됩니다.
- `public-data-client`: 공공데이터포털에서 발급받은 서비스키를 `PUBLIC_DATA_API_KEY`로 지정하세요. `pom.xml`과 `build.gradle`이 함께 있으니 Gradle(`./gradlew bootRun`)을 기준으로 실행하세요.
- 지도 테스트 페이지(`map.html`, `webtest.html`)의 `YOUR_NAVER_MAP_CLIENT_ID`는 발급받은 네이버 지도 Client ID로 바꿔야 합니다.
