import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Game area dimensions
  static final int rowCount = 20;
  static final int columnCount = 20;

  // Game state
  List<int> snakePosition = [45, 65, 85, 105, 125];
  int food = 0;
  int direction = 2; // 0: up, 1: right, 2: down, 3: left
  bool isPlaying = false;
  int score = 0;
  Timer? timer;
  double gameSpeed = 0.2; // seconds per move - lower = faster

  @override
  void initState() {
    super.initState();
    // Don't auto-start the game, wait for user input
    setState(() {
      // Start with a horizontal snake in the middle of the screen
      int middle = (rowCount * columnCount) ~/ 2 + columnCount ~/ 2;
      // Position snake horizontally so it doesn't immediately hit itself
      snakePosition = [middle, middle + 1, middle + 2, middle + 3, middle + 4];
      direction = 3; // Start moving left
      score = 0;
      isPlaying = false;
      generateFood();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // Method to handle Space key press or Start button
  void toggleGameState() {
    setState(() {
      isPlaying = !isPlaying;

      if (isPlaying) {
        // Resume or start the game
        timer?.cancel(); // Cancel any existing timer
        timer = Timer.periodic(
          Duration(milliseconds: (gameSpeed * 1000).round()),
          (timer) {
            updateSnake();
          },
        );
      } else {
        // Pause the game
        timer?.cancel();
      }
    });
  }

  // Method to start a new game
  void startGame() {
    setState(() {
      // Start with a horizontal snake in the middle of the screen
      int middle = (rowCount * columnCount) ~/ 2 + columnCount ~/ 2;
      // Position snake horizontally so it doesn't immediately hit itself
      snakePosition = [middle, middle + 1, middle + 2, middle + 3, middle + 4];
      direction = 3; // Start moving left
      score = 0;
      generateFood();
    });

    // Ensure the game is playing
    if (!isPlaying) {
      toggleGameState();
    }
  }

  void generateFood() {
    final random = Random();
    // Keep generating positions until we find one not occupied by the snake
    do {
      food = random.nextInt(rowCount * columnCount);
    } while (snakePosition.contains(food));
  }

  void updateSnake() {
    if (!isPlaying) return;

    setState(() {
      // Calculate new head position based on direction
      int newHead;
      switch (direction) {
        case 0: // Up
          newHead = snakePosition.first - columnCount;
          if (newHead < 0) newHead += rowCount * columnCount; // Wrap around
          break;
        case 1: // Right
          newHead = snakePosition.first + 1;
          if (newHead % columnCount == 0) newHead -= columnCount; // Wrap around
          break;
        case 2: // Down
          newHead = snakePosition.first + columnCount;
          if (newHead >= rowCount * columnCount)
            newHead -= rowCount * columnCount; // Wrap around
          break;
        case 3: // Left
          newHead = snakePosition.first - 1;
          if ((snakePosition.first) % columnCount == 0)
            newHead += columnCount; // Wrap around
          break;
        default:
          newHead = snakePosition.first;
      }

      // Check collision with self (game over)
      if (snakePosition.contains(newHead)) {
        gameOver();
        return;
      }

      // Add new head to snake
      snakePosition.insert(0, newHead);

      // Check if snake ate food
      if (newHead == food) {
        // Increase score
        score += 10;

        // Speed up slightly (make game harder as score increases)
        if (gameSpeed > 0.05) {
          gameSpeed -= 0.01;
          timer?.cancel();
          timer = Timer.periodic(
            Duration(milliseconds: (gameSpeed * 1000).round()),
            (timer) {
              updateSnake();
            },
          );
        }

        // Generate new food
        generateFood();
      } else {
        // Remove tail if no food was eaten
        snakePosition.removeLast();
      }
    });
  }

  void gameOver() {
    setState(() {
      isPlaying = false;
    });

    timer?.cancel();

    // Show game over dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: backgroundColor.withOpacity(0.9),
            title: const Text(
              'Game Over',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Your score: $score',
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  startGame();
                },
                child: const Text(
                  'Play Again',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Main Menu',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void changeDirection(int newDirection) {
    // Prevent 180-degree turns (which would be an instant game over)
    if ((direction == 0 && newDirection == 2) ||
        (direction == 2 && newDirection == 0) ||
        (direction == 1 && newDirection == 3) ||
        (direction == 3 && newDirection == 1)) {
      return;
    }

    setState(() {
      direction = newDirection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (_, KeyEvent event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
              event.logicalKey == LogicalKeyboardKey.keyW) {
            if (isPlaying) changeDirection(0);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
              event.logicalKey == LogicalKeyboardKey.keyD) {
            if (isPlaying) changeDirection(1);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
              event.logicalKey == LogicalKeyboardKey.keyS) {
            if (isPlaying) changeDirection(2);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
              event.logicalKey == LogicalKeyboardKey.keyA) {
            if (isPlaying) changeDirection(3);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.space ||
              event.logicalKey == LogicalKeyboardKey.escape) {
            // Pause/Resume game
            toggleGameState();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('Snake Game'),
          backgroundColor: primaryColor,
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  'Score: $score',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Play/Pause button
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: toggleGameState,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPlaying ? Colors.red : Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: Text(
                    isPlaying ? 'PAUSE' : 'START',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Keyboard controls help text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Controls: Arrow Keys or WASD, Space to Pause',
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              // Game board - now wrapped in Expanded to use available space
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columnCount,
                        ),
                        itemCount: rowCount * columnCount,
                        itemBuilder: (context, index) {
                          if (snakePosition.contains(index)) {
                            return _buildSnakePart(index);
                          } else if (index == food) {
                            return _buildFood();
                          } else {
                            return _buildEmptySpace();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Button controls for mobile play
        bottomNavigationBar: SizedBox(
          height: 180,
          child: Container(
            color: backgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Up button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_buildDirectionButton(Icons.arrow_upward, 0)],
                ),
                const SizedBox(height: 5),
                // Left, Right buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDirectionButton(Icons.arrow_back, 3),
                    const SizedBox(width: 60), // Space between left and right
                    _buildDirectionButton(Icons.arrow_forward, 1),
                  ],
                ),
                const SizedBox(height: 5),
                // Down button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_buildDirectionButton(Icons.arrow_downward, 2)],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            timer?.cancel();
            Navigator.pop(context);
          },
          backgroundColor: primaryColor,
          child: const Icon(Icons.home),
        ),
      ),
    );
  }

  Widget _buildDirectionButton(IconData icon, int buttonDirection) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: () => changeDirection(buttonDirection),
      ),
    );
  }

  Widget _buildSnakePart(int index) {
    // Head of the snake
    if (index == snakePosition.first) {
      return Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(2),
        ),
      );
    }
    // Body of the snake
    else {
      return Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.green.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      );
    }
  }

  Widget _buildFood() {
    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildEmptySpace() {
    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
