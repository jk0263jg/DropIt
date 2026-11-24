# marker-service

수거함 마커 조회 전용 서비스. 반경 조회와 지도 화면 범위(bounds) 조회를 제공합니다.

- Java 17 / Spring Boot 3.5.3 / Gradle
- Spring Data JPA + MySQL 8 (반경 검색에 `ST_Distance_Sphere` 사용)

## 실행

환경변수는 [.env.example](.env.example) 참고.

```bash
export DB_URL="jdbc:mysql://localhost:3306/board?serverTimezone=Asia/Seoul"
export DB_USERNAME=<user> DB_PASSWORD=<password>
# 최초 1회: 테이블이 없으면 ddl-auto=validate 에서 실패하므로 update 로 생성
SPRING_JPA_HIBERNATE_DDL_AUTO=update ./gradlew bootRun
```

DB가 비어 있으면 `전국_의류수거함.csv`를 읽어 적재합니다.
