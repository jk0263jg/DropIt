# api-server

DropIt 메인 REST API 서버 (회원 · 마이페이지 · 나눔 게시판 · 후기 · 즐겨찾기 · 수거함 조회).

- Java 21 / Spring Boot 3.5.5 / Gradle
- Spring Data JPA, Spring Security(BCryptPasswordEncoder), springdoc-openapi, Cloudinary
- 기본 프로필은 `prod` (PostgreSQL) — `src/main/resources/application-prod.properties`

## 실행

환경변수는 [.env.example](.env.example) 참고. (Spring Boot는 `.env`를 자동으로 읽지 않으므로 셸/IDE에서 환경변수로 설정합니다.)

```bash
export DB_HOST=localhost DB_PORT=5432 DB_NAME=clothing DB_USER=<user> DB_PASS=<password>
export CLOUDINARY_URL=cloudinary://<api_key>:<api_secret>@<cloud_name>
./gradlew bootRun
```

- 테이블은 `ddl-auto=update`로 자동 생성되고, 최초 실행 시 `전국_의류수거함.csv`가 DB에 적재됩니다.
- API 문서: `http://localhost:8080/swagger-ui/index.html`

### Docker

```bash
docker build -t dropit-api .
docker run -p 8080:8080 --env-file .env dropit-api
```

## 구조

```
src/main/java/com/example/clothing_backend
├── user     회원가입 · 로그인 · 아이디/비밀번호 찾기 · 마이페이지, REST 컨트롤러(ApiController)
├── board    나눔 게시판, 즐겨찾기(Wish)
├── marker   수거함(ClothingBin) · 후기(MarkerPost) · CSV 적재(ClothingBinLoader)
└── global   Security / CORS / Cache / 예외 처리 / Cloudinary 이미지 업로드
```
