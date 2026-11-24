# 개발 과정

프로젝트는 아래 순서로 구조가 바뀌어 왔고, 이 저장소에는 각 영역의 **가장 최신 버전**만 정리해 두었습니다.
(날짜는 원본 파일의 최종 수정일 기준)

## 0. 초기 프로토타입 (2025.06 ~ 09)

메인 서버를 만들기 전에 기능별로 작게 나눠 만들어 보았고, 코드는 [`backend/prototypes`](../backend/prototypes)에 남겨 두었습니다.

| 시기 | 프로토타입 | 해본 것 |
| --- | --- | --- |
| 2025.06 | `public-data-client` | 공공데이터포털 전국 의류수거함 위치 정보 API 호출 → 마커 JSON 변환 → 네이버 지도 표시 |
| 2025.09경 | `cloth-area-jwt` | CSV(약 1.4만 건) DB 적재, 조회 API, JWT 로그인/회원가입(Spring Security + BCrypt) |
| 2025.08 ~ 09 | `board-user` | 게시판 CRUD, 회원/마이페이지/즐겨찾기, JdbcTemplate DAO 직접 구현, 이미지 업로드 |

이 세 가지(수거함 데이터 + 인증 + 게시판/회원)를 한 서버로 합친 것이 아래 1단계입니다.

## 1. 서버 렌더링 → JSON REST API

| 단계 | 내용 | 시점 |
| --- | --- | --- |
| Thymeleaf 서버 | Spring Boot + Thymeleaf 템플릿(로그인, 게시판, 마이페이지 등)과 Spring Security 폼 로그인으로 화면까지 서버에서 렌더링 | 2025.09 |
| API 컨트롤러 추가 | 웹/앱 클라이언트 분리를 위해 `*ApiController`와 API 전용 로그인 핸들러를 추가 | 2025.09 |
| **JSON REST 전환 (현재 `api-server`)** | 템플릿 제거, REST 응답만 제공. 이미지는 Cloudinary, 운영 DB는 PostgreSQL(Render), Docker 배포, springdoc 문서화 | 2025.11 |

## 2. 마커 조회 분리

마커 조회를 메인 API와 분리한 구조도 함께 구성했습니다.

- `marker-service` — 반경 조회 / 지도 범위(bounds) 조회 전용 서비스
- `marker-proxy` — marker-service 앞단 중간 서버(캐시 설정 포함)
- `api-server`에도 같은 조회 API(`/clothing-bins`, `/clothing-bins/in-bounds`)가 포함되어 있습니다.

## 3. 클라이언트

- **mobile (Flutter)** — 지도·마커 화면에서 시작해 API 연동, 로그인/회원가입, 나눔 글쓰기 화면을 추가
- **web (Vue 3)** — 홈 지도, 현재 위치, 지역 검색(시/도 동의어 처리), 나눔 게시판, 회원/마이페이지 화면 구현

## 저장소 정리 내역

- 흩어져 있던 12개 폴더(중복·이전 버전·실험 코드 포함)를 영역별 최신 버전 5개 모듈로 통합
- API 키·DB 비밀번호 등 민감 정보를 코드에서 제거하고 환경변수/예시 파일(`*.example`)로 분리
- 깨져 있던 CSV 파일명(`#Uc804#Uad6d...`)을 `전국_의류수거함.csv`로 복원 (`ClothingBinLoader`가 참조하는 이름)
