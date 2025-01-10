<img src = "image/title.png">
<br>
<br>

# 🍎 Stock Signal 프로젝트 소개

### “초보 투자자들이 쉽고 안전하게, 주식 투자의 경험을 쌓도록 돕습니다.”
주식 투자에 어려움을 겪는 주린이(주식+어린이)를 위해, 기존 MTS의 복잡한 요소를 개선한 간편한 주식 관리 시스템을 제공합니다. 

<br>


## 🏋🏻‍♀️ Team '더레드'
| 팀 | 이름 | 전공 | 역할  | 깃허브 아이디 |
|----| ----- | ----- | -------- | ------- |
| 팀장 | 유수민 | 컴퓨터공학전공 | 백엔드 개발  | proysm |
| 팀원 | 홍원준 | 컴퓨터공학전공 | 백엔드 개발  | price126 |
| 팀원 | 신예빈 | 컴퓨터공학전공 | IOS 개발  | ShinYEB |
| 팀원 | 김윤서 | 경영학과 | Android 개발  | yunssup |

<br>


## 1. 개발 환경 및 기술 스택

##### Back-end
<img src="https://img.shields.io/badge/Spring-228B22?style=for-the-badge&logo=Spring&logoColor=green"> <img src="https://img.shields.io/badge/SpringBoot-6DB33F?style=for-the-badge&logo=SpringBoot&logoColor=yellow"> <img src="https://img.shields.io/badge/Java-007396?style=for-the-badge&logo=Java&logoColor=white">
<br>
<img src="https://img.shields.io/badge/Spring%20Security-6DB33F?style=for-the-badge&logo=Spring%20Security&logoColor=white"> <img src="https://img.shields.io/badge/JWT-000000?style=for-the-badge&logo=JSON%20Web%20Tokens&logoColor=white"> <img src="https://img.shields.io/badge/QueryDSL-00BFFF?style=for-the-badge&logo=QueryDSL&logoColor=white">

##### Database
<img src="https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=MySQL&logoColor=white">

##### CI/CD & DevOps
<img src="https://img.shields.io/badge/GitHub%20Actions-2088FF?style=for-the-badge&logo=GitHub%20Actions&logoColor=white"> <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=Docker&logoColor=white"> <img src="https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=Amazon%20AWS&logoColor=white">

##### Design
<img src="https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white">

##### IOS
<img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=Apple&logoColor=white"> <img src="https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white"> <img src="https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white">

##### Android
<img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=Android&logoColor=white"> <img src="https://img.shields.io/badge/Kotlin-0095D5?&style=for-the-badge&logo=kotlin&logoColor=white"> <img src="https://img.shields.io/badge/android%20studio-346ac1?style=for-the-badge&logo=android%20studio&logoColor=white">


#### AI
<img src="https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54"> <img src="https://img.shields.io/badge/PyTorch-%23EE4C2C.svg?style=for-the-badge&logo=PyTorch&logoColor=white"> <img src="https://img.shields.io/badge/numpy-%23013243.svg?style=for-the-badge&logo=numpy&logoColor=white"> <img src="https://img.shields.io/badge/pandas-%23150458.svg?style=for-the-badge&logo=pandas&logoColor=white"> 

##### Tools
<img src="https://img.shields.io/badge/Swagger-85EA2D?style=for-the-badge&logo=Swagger&logoColor=black">

<br>


## 2. 시스템 아키텍처

```
📌 백엔드 아키텍처
```
<img src = "image/backend.png" width=800px>

```
📌 CI/CD 아키텍처
```
<img src = "image/ci_cd.png" width=800px>
<br>


## 3. 프로젝트 디렉토리 구조

<details>
<summary>back/src 구조 확인하기</summary>
<div markdown="1">

```
.
├── main
│   ├── generated
│   ├── java
│   │   └── com
│   │       └── thered
│   │           └── stocksignal
│   │               ├── apiPayload
│   │               ├── app
│   │               │   ├── controller
│   │               │   └── dto
│   │               │       ├── kakao
│   │               │       ├── kis
│   │               │       └── user
│   │               ├── config
│   │               ├── domain
│   │               │   ├── entity
│   │               │   ├── enums
│   │               │   └── session
│   │               ├── jwt
│   │               ├── repository
│   │               ├── service
│   │               │   ├── company
│   │               │   ├── kakao
│   │               │   ├── myBalance
│   │               │   ├── news
│   │               │   ├── scenario
│   │               │   ├── trade
│   │               │   └── user
│   │               ├── util
│   │               └── websocket
│   └── resources
│       ├── static
│       └── templates
└── test
    └── java
        └── com
            └── thered
                └── stocksignal

```

</div>
</details>

<details>
<summary>ios/src 구조 확인하기</summary>
<div markdown="1">

```
.
├── Application
│   ├── AppDelegate
│   ├── Assets
│   ├── LaunchScreen
│   ├── Config
│   ├── Info
│   ├── Model
│   └── SceneDelegate
├── Data
│   ├── Network
│   └── Repositories
├── Domain
│   ├── Entities
│   ├── Interfaces
│   └── UseCases
└── Presentation
    ├── Alarm
    ├── Chatbot
    ├── Home
    ├── Intro
    ├── Login
    ├── Main
    ├── MyPage
    ├── NewScenario
    ├── Practice
    ├── Search
    └── StockDetail
```

</div>
</details>

<details>
<summary>android/src 구조 확인하기</summary>
<div markdown="1">

```
.
├── application
│   ├── GlobalApplication.kt
│   ├── u
│   └── ui
│       └── theme
├── data
│   ├── database
│   ├── network
│   └── repositories
├── domain
│   ├── entites
│   ├── interfaces
│   └── usecases
└── presentation
    ├── alarm
    ├── chatbot
    ├── home
    ├── login
    ├── main
    ├── mypage
    ├── mystock
    ├── newscenario
    ├── search
    └── stockinfo
```

</div>
</details>

<br>


## 4. 주요 기술 설명

```
1. 30일 AI 예측 그래프
```

- GRU 모델을 기반으로 30일치 예상 주가 그래프를 생성하여 제공합니다.

- 사용자는 AI 예측 그래프를 통해 주가의 흐름을 파악하고 매매 타이밍을 학습할 수 있습니다.


```
2. 자동매매 시나리오 작성
```

- 3가지 종류의 자동매매 시나리오를 생성할 수 있습니다.

- 각 시나리오는 언제든 구성 가능하며, 각 종목 별로 개별 시나리오를 적용할 수 있습니다.


```
3. 과거 데이터로 투자 연습 (시뮬레이션)
```

- 과거의 주식 정보(90일)을 이용하여 투자 연습 가능

<br>

## 📱 데모 영상
[🔗 데모 영상 확인](https://proysm.notion.site/DEMO-154b4ca715b080b2ad95d1168621a154?pvs=4 "데모 영상 확인")

<br>

## 📪 개발 문서
[🔗 API 명세서 확인](https://proysm.notion.site/API-154b4ca715b0809ca43ceb2a9155b000?pvs=4 "API 명세서")

[🔗 ERD 확인](https://proysm.notion.site/ERD-154b4ca715b080c1ad52e0d5af006fe0?pvs=4 "ERD")

<br>

## 🎀 한국투자증권 API
[🔗 한국투자 Open API](https://apiportal.koreainvestment.com/login "한국투자 Open API")

[🔗 모의투자 가능한 API](https://proysm.notion.site/API-154b4ca715b080878daacd626ce86a3b?pvs=4 "한국투자증권 Open API")

<br>

## 🌴 Branch Style
| 이름 | 설명 |
| --- | --- |
| main | PR을 거쳐 오류가 없는 브랜치 |
| prod | 배포에 사용되는 브랜치 |
| back | 백엔드 개발에 사용되는 브랜치 |
| ios | ios 개발에 사용되는 브랜치 |
| android | android 개발에 사용되는 브랜치 |
| -feat-이슈번호 | 기능 개발에 사용되는 브랜치 |
| -update-이슈번호 | 기능 업데이트에 사용되는 브랜치 |
| -refactor-이슈번호 | 리팩토링에 사용되는 브랜치 |
| -bug-이슈번호 | 버그 해결에 사용되는 브랜치 |

<br>

## 🎯 Commit Convention
| 제목 | 설명 |
| --- | --- |
| Feat : | 새로운 기능 추가 |
| Fix : | 버그 수정 |
| Docs : | 문서 수정 |
| Update : | 기타 업데이트 |
| Style : | 코드 포맷 변경, 세미콜론 누락, 코드 변경 없음 |
| Refactor : | 프로덕션 코드 리팩터링 |

