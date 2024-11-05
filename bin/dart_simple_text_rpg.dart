import 'dart:io';
import 'dart:convert';
import 'dart:math';

class Character {
  String name;
  int health;
  int attack;
  int defense;
  bool hasUsedItem = false;
  bool isDefending = false;

  Character(this.name, this.health, this.attack, this.defense);

  void attackMonster(Monster monster) {
    int damage = max(0, attack - monster.defense);
    monster.health -= damage;
    print('$name이(가) ${monster.name}에게 $damage의 데미지를 입혔습니다.');
  }

  void defend() {
    final random = Random();
    isDefending = true;
    if (random.nextInt(100) < 1) {
      health += 5;
      print('$name이(가) 방어를 통해 체력을 5 회복했습니다! 현재 체력: $health');
    } else {
      print('$name이(가) 방어 자세를 취했습니다.');
    }
  }


  void useItem() {
    if (!hasUsedItem) {
      attack *= 2;
      hasUsedItem = true;
      print('아이템을 사용하여 공격력이 2배 증가했습니다!');
    } else {
      print('이미 아이템을 사용했습니다.');
    }
  }

  void showStatus() {
    print('$name - 체력: $health, 공격력: $attack, 방어력: $defense');
  }
}

class Monster {
  String name;
  int health;
  int attack;
  int defense = 0;
  int turnCounter = 0;

  Monster(this.name, this.health, this.attack);

  void attackCharacter(Character character) {
    if (character.isDefending) {
      print('$name의 공격을 ${character.name}이(가) 방어했습니다!');
      character.isDefending = false;  // 방어 상태 해제
    } else {
      int damage = max(0, attack - character.defense);
      character.health -= damage;
      print('$name이(가) ${character.name}에게 $damage의 데미지를 입혔습니다.');
    }
    print('${character.name} - 체력: ${character.health}, 공격력: ${character.attack}, 방어력: ${character.defense}');
    print('$name - 체력: $health, 공격력: $attack, 방어력: $defense');
  }

  void increaseDefenseEveryThreeTurns() {
    turnCounter++;
    if (turnCounter % 3 == 0) {
      defense += 2;
      print('$name의 방어력이 증가했습니다! 현재 방어력: $defense');
      turnCounter = 0;
    }
  }

  void showStatus() {
    print('$name - 체력: $health, 공격력: $attack, 방어력: $defense');
  }
}

class Game {
  Character character;
  late List<Monster> monsters;
  int defeatedMonsters = 0;

  Game(this.character, List<Monster> monsterTemplates) {
    monsters = monsterTemplates.map((m) => Monster(m.name, m.health, max(m.attack, character.defense))).toList();
  }

  void startGame() {
    print('\n게임을 시작합니다!');
    character.showStatus();
    while (character.health > 0 && monsters.isNotEmpty) {
      Monster monster = getRandomMonster();
      print('\n새로운 몬스터가 나타났습니다!');
      print('${monster.name} - 체력: ${monster.health}, 공격력: ${monster.attack}, 방어력: ${monster.defense}');
      battle(monster);

      if (character.health <= 0) {
        print('\n게임 오버! 패배하였습니다.');
        saveResult(character, false);
        return;
      }

      if (monsters.isEmpty) {
        print('\n축하합니다! 모든 몬스터를 물리쳤습니다.');
        saveResult(character, true);
        return;
      }

      while (true) {
        print('\n다음 몬스터와 싸우시겠습니까? (y/n):');
        String? input = stdin.readLineSync()?.toLowerCase();
        if (input == 'y') {
          break;
        } else if (input == 'n') {
          print('\n게임을 종료합니다.');
          saveResult(character, false);
          return;
        } else {
          print('\n잘못된 입력입니다. y 또는 n만 입력해주세요.');
        }
      }
    }
  }

  void battle(Monster monster) {
    while (character.health > 0 && monster.health > 0) {
      print('\n${character.name}의 턴');
      print('행동을 선택하세요 (1: 공격, 2: 방어, 3: 아이템 사용):');
      String? action = stdin.readLineSync();

      switch (action) {
        case '1':
          character.attackMonster(monster);
          break;
        case '2':
          character.defend();
          break;
        case '3':
          character.useItem();
          break;
        default:
          print('\n잘못된 선택입니다.');
          continue;
      }

      if (monster.health > 0) {
        print('\n${monster.name}의 턴');
        monster.attackCharacter(character);
        monster.increaseDefenseEveryThreeTurns();
      } else {
        print('\n${monster.name}을(를) 물리쳤습니다!');
        monsters.remove(monster);
        defeatedMonsters++;
      }

      character.isDefending = false;
    }
  }

  Monster getRandomMonster() {
    Random random = Random();
    return monsters[random.nextInt(monsters.length)];
  }

  void saveResult(Character character, bool victory) {
    print('\n결과를 저장하시겠습니까? (y/n)');
    String? input = stdin.readLineSync();
    if (input != null && input.toLowerCase() == 'y') {
      final newResult = {
        'character': {
          'name': character.name,
          'health': character.health,
          'attack': character.attack,
          'defense': character.defense,
          'hasUsedItem': character.hasUsedItem
        },
        'result': victory ? '승리' : '패배',
        'defeatedMonsters': defeatedMonsters,
        'timestamp': DateTime.now().toIso8601String()
      };

      final file = File('assets/results.json');
      List<Map<String, dynamic>> results = [];

      if (file.existsSync()) {
        String contents = file.readAsStringSync();
        if (contents.isNotEmpty) {
          results = List<Map<String, dynamic>>.from(jsonDecode(contents));
        }
      }

      results.add(newResult);

      file.writeAsStringSync(jsonEncode(results), mode: FileMode.write);
      print('\n결과가 저장되었습니다.');
    }
  }
}

Future<void> loadCharacterStats() async {
  try {
    final file = File('assets/character.json');
    final contents = await file.readAsString();
    final data = jsonDecode(contents);

    String name = getCharacterName();
    int health = data['health'];
    int attack = data['attack'];
    int defense = data['defense'];

    character = Character(name, health, attack, defense);
    applyBonusHealth(character);
  } catch (e) {
    print('\n캐릭터 데이터를 불러오는 데 실패했습니다: $e');
    exit(1);
  }
}

Future<void> loadMonsterStats() async {
  try {
    final file = File('assets/monsters.json');
    final contents = await file.readAsString();
    final List<dynamic> data = jsonDecode(contents);

    for (var monsterData in data) {
      String name = monsterData['name'];
      int health = monsterData['health'];
      int maxAttack = monsterData['maxAttack'];

      Random random = Random();
      int attack = random.nextInt(maxAttack) + 5;

      monsters.add(Monster(name, health, attack));
    }
  } catch (e) {
    print('\n몬스터 데이터를 불러오는 데 실패했습니다: $e');
    exit(1);
  }
}

String getCharacterName() {
  print('\n캐릭터의 이름을 입력하세요: ');
  while (true) {
    String? name = stdin.readLineSync();
    if (name != null && RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(name)) {
      return name;
    } else {
      print('\n유효한 이름을 입력하세요 (한글 또는 영문만 허용됩니다):');
    }
  }
}

void applyBonusHealth(Character character) {
  final random = Random();
  if (random.nextInt(100) < 30) {
    character.health += 10;
    print('\n보너스 체력을 얻었습니다! 현재 체력: ${character.health}');
  }
}

late Character character;
List<Monster> monsters = [];

void main() async {
  await loadCharacterStats();
  await loadMonsterStats();
  Game game = Game(character, monsters);
  game.startGame();
}