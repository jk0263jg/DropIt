# mobile

DropIt Flutter 앱 (패키지명 `microstone_clothing_bin`).

## 실행

```bash
flutter pub get
cp dart-define.example.json dart-define.json   # NAVER_MAP_CLIENT_ID 입력 (git 제외됨)
flutter run --dart-define-from-file=dart-define.json
```

Android는 `android/app/src/main/AndroidManifest.xml`의 `com.naver.maps.map.CLIENT_ID` 값(`YOUR_NAVER_MAP_CLIENT_ID`)도 발급받은 Client ID로 바꿔야 합니다.

## 구조

```
lib/
├── main.dart            네이버 지도 초기화, 스플래시, 하단 탭 4개
├── Home/                지도 · 마커 · 수거함 상세
├── Sharing/ Writing/    나눔 목록, 글쓰기(사진 업로드 · 지도 위치 지정)
├── join/                회원가입(약관 동의) · 아이디/비밀번호 찾기
├── loginPage/           로그인 화면
└── config/              서버 주소 상수와 HTTP 호출 (mySQLConnector.dart)
```

> `config/mySQLConnector.dart`는 이름과 달리 DB에 직접 접속하지 않고 api-server를 HTTP로 호출합니다.
