# web

DropIt 웹 클라이언트 (Vue 3 + Vite + Pinia).

## 실행

```bash
npm ci
cp .env.example .env     # VITE_NAVER_MAP_CLIENT_ID, VITE_API_BASE_URL 입력
npm run dev              # http://localhost:5173
npm run build            # dist/ 생성
```

> 백엔드 CORS 허용 origin이 `http://localhost:5173`입니다. 다른 주소로 띄우면 api-server의 `SecurityConfig`를 수정하세요.

## 구조

```
src/
├── views/        라우터와 연결되는 페이지 (홈 지도, 나눔, 즐겨찾기, 로그인/회원가입, 마이페이지 …)
├── components/   common · map · share · ui
├── layouts/      MainLayout, SidebarLayout
├── stores/       Pinia (수거함, 즐겨찾기, 인증, 게시판)
├── services/     axios API 호출, 네이버 지도/지오코딩 연동
├── composables/  현재 위치, 검색, 상세 패널 로직
└── router/
```

폴더별 역할 상세는 [docs/web-structure.txt](../docs/web-structure.txt) 참고.
