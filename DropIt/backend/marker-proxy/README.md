# marker-proxy

marker-service 앞단에서 마커 데이터를 대신 호출해 전달하는 중간 서버.

- Java 21 / Spring Boot 3.5.4 / Gradle
- `RestTemplate`으로 marker-service 호출, 캐시 설정(`CacheConfig`, `@Cacheable`) 포함
- 업스트림 주소는 `marker/MarkerService.java`, `marker/MarkerApiService.java`에 정의되어 있으니 실행 환경에 맞게 수정하세요.

```bash
./gradlew bootRun
```
