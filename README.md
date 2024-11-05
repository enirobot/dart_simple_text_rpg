# 🎮 텍스트 기반 RPG 게임

## 프로젝트 소개

이 프로젝트는 Dart로 구현된 텍스트 기반 RPG 게임입니다.

## 📦 필요 환경

- Dart SDK
- 최소 Dart 3.5.4 이상

## 🚀 시작하기

### 1. 리포지토리 클론
```bash
git clone https://github.com/enirobot/dart_simple_text_rpg.git
cd dart_simple_text_rpg
```

### 2. 종속성 설치
```bash
dart pub get
```

### 3. 게임 실행
```bash
dart run
```

## 📁 프로젝트 구조

- `bin/dart_simple_text_rpg.dart`: 게임의 메인 로직
- `assets/character.json`: 캐릭터 초기 설정
- `assets/monsters.json`: 몬스터 데이터
- `assets/results.json`: 게임 결과 저장

## ⚙️ 기능 설명

### 주요 기능

1. **캐릭터 생성 및 초기화**
   - 사용자는 게임 시작 시 캐릭터의 이름을 입력합니다.
   - 이름은 한글 또는 영문 대소문자만 허용됩니다.
   - 캐릭터의 초기 상태는 파일로부터 불러옵니다.

2. **몬스터 생성**
   - 다양한 몬스터가 파일로부터 불러와집니다.
   - 각 몬스터는 이름, 체력, 공격력 등의 속성을 가집니다.

3. **전투 시스템**
   - 플레이어는 몬스터와의 전투에서 공격, 방어, 아이템 사용 등의 행동을 선택할 수 있습니다.
   - 아이템은 전투 중 한 번 사용할 수 있으며, 사용 시 공격력이 두 배로 증가합니다.

4. **몬스터 방어력 증가**
   - 몬스터는 매 세 번째 턴마다 방어력이 2씩 증가합니다.

5. **게임 결과 저장**
   - 게임 종료 후 결과를 파일에 저장할 수 있습니다.
   - 저장되는 정보에는 캐릭터의 이름, 남은 체력, 공격력, 방어력, 게임 결과(승리/패배), 처리한 몬스터 수, 저장된 시간이 포함됩니다.

### 도전 기능

1. **캐릭터 보너스 체력**
   - 게임 시작 시 30% 확률로 캐릭터의 체력이 10 증가합니다.

2. **전투 시 캐릭터의 아이템 사용 기능 추가**
   - 전투 중 사용자가 `3`을 입력하면 아이템을 사용합니다.
   - 아이템 사용 시 한 턴 동안 캐릭터의 공격력이 두 배로 변경됩니다.

3. **몬스터의 방어력 증가 기능 추가**
   - 몬스터의 방어력이 특정 턴마다 2씩 증가합니다.

## 🧩 코드 구조

### 주요 클래스

- **Character**: 플레이어 캐릭터의 상태와 행동을 정의합니다.
- **Monster**: 몬스터의 속성과 행동을 정의합니다.
- **Game**: 게임의 전반적인 로직과 흐름을 관리합니다.

### 파일 입출력

- 캐릭터와 몬스터의 초기 상태는 JSON 파일(`assets/character.json`, `assets/monsters.json`)로부터 불러옵니다.
- 게임 결과는 `assets/results.json`에 저장됩니다.

## 📄 JSON 파일 구조 예시

### character.json
```json
{
  "health": 50,
  "attack": 10,
  "defense": 5
}
```

### monsters.json
```json
[
  {
    "name": "큰거미",
    "health": 20,
    "maxAttack": 10
  },
  {
    "name": "빗자루",
    "health": 30,
    "maxAttack": 10
  },
  {
    "name": "드래곤",
    "health": 40,
    "maxAttack": 10
  }
]
```

### results.json
```json
[{
  "character": {
    "name": "kim",
    "health": 36,
    "attack": 20,
    "defense": 5,
    "hasUsedItem": true
  },
  "result": "승리",
  "defeatedMonsters": 3,
  "timestamp": "2024-11-05T16:38:09.794382"
}]
```