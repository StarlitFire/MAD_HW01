import 'package:flutter/material.dart';

void main() {
  runApp(const Calculator());
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode
          ? ThemeData.dark(useMaterial3: false)
          : ThemeData.light(useMaterial3: false),
      home: CalcControlScreen(
        isDark: isDarkMode,
        onToggleTheme: () => setState(() => isDarkMode = !isDarkMode),
      ),
    );
  }
}

class CalcControlScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;
  const CalcControlScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<CalcControlScreen> createState() => _CalcControlScreenState();
}

class _CalcControlScreenState extends State<CalcControlScreen> {
  bool divideZeroError = false;
  bool isInputNum = false;
  double ans = 0;
  String currNum = '';
  double prevNum = 0;
  // Max Digits displayed in calculator
  int numDigits = 10;
  String prevAction = '';

  //Turns the current number from a string to a double
  double _parseCurrentNumber() {
    final value = currNum.isEmpty
        ? ans.toString()
        : currNum.endsWith('.')
        ? '${currNum}0'
        : currNum;
    return double.parse(value);
  }

  // Adds to the current number input
  void _triggerNum(String button) {
    if (button == '.') {
      if (isInputNum && currNum.contains('.')) return;

      setState(() {
        if (divideZeroError || !isInputNum) {
          ans = 0;
          currNum = '0.';
          isInputNum = true;
          divideZeroError = false;
        } else if (currNum == '0') {
          currNum = '0.';
        } else {
          currNum += '.';
        }
      });
      return;
    }

    if (currNum.replaceAll(RegExp(r'[^0-9]'), '').length >= numDigits) {
      return;
    }

    if (divideZeroError || !isInputNum) {
      setState(() {
        ans = 0;
        currNum = button;
        isInputNum = true;
        divideZeroError = false;
      });
    } else if (currNum == '0') {
      if (button == '0') {
        return;
      } else {
        setState(() {
          currNum = button;
        });
      }
    } else {
      setState(() {
        currNum = currNum + button;
      });
    }
  }

  // Swaps the sign of the current number
  void _switchSign() {
    if (isInputNum) {
      if (currNum == '0') {
        return;
      } else if (currNum[0] != '-') {
        setState(() {
          currNum = '-$currNum';
        });
      } else {
        setState(() {
          currNum.substring(1);
        });
      }
    } else {
      setState(() {
        ans *= -1;
      });
    }
  }

  // Clears the calculator
  void _clearCalc() {
    setState(() {
      ans = 0;
      currNum = '';
      prevNum = 0;
      prevAction = '';
      isInputNum = false;
      divideZeroError = false;
    });
  }

  // Multiplies the previous number with the current number
  void _multiply() {
    setState(() {
      ans = prevNum * _parseCurrentNumber();
      isInputNum = false;
      prevNum = ans;
    });
  }

  // Adds the previous number with the current number
  void _add() {
    setState(() {
      ans = prevNum + _parseCurrentNumber();
      isInputNum = false;
      prevNum = ans;
    });
  }

  // Subtracts the previous Number with the current Number
  void _subtract() {
    setState(() {
      ans = prevNum - _parseCurrentNumber();
      isInputNum = false;
      prevNum = ans;
    });
  }

  // Gets the prev Number divided by current Number
  void _divide() {
    if (_parseCurrentNumber() == 0) {
      setState(() {
        divideZeroError = true;
      });
    } else {
      setState(() {
        ans = prevNum / _parseCurrentNumber();
        isInputNum = false;
        prevNum = ans;
      });
    }
  }

  // Gets the percent of the current number.
  void _percent() {
    if (currNum == '') return;

    setState(() {
      currNum = '${_parseCurrentNumber() / 100.00}';
    });
  }

  // Triggers the corresponding function
  void _triggerAction(String actionName) {
    // %
    if (actionName == '%') {
      _percent();
      return;
    }
    // Checks if there wasn't a previous action
    if (prevAction == '') {
      setState(() {
        prevAction = actionName;
        prevNum = _parseCurrentNumber();
        ans = prevNum;
        isInputNum = false;
      });

      return;
    }
    // =
    if (actionName == '=') {
      if (prevAction != '') {
        _triggerAction(prevAction);
        prevAction = '';
      }
      return;
    }
    // + / - / x / ÷
    if (prevAction == '+') {
      _add();
    } else if (prevAction == '-') {
      _subtract();
    } else if (prevAction == 'x') {
      _multiply();
    } else if (prevAction == '÷') {
      _divide();
    }
    prevAction = actionName;
  }

  // Calculator Widget
  @override
  Widget build(BuildContext context) {
    final screenBg = widget.isDark
        ? const Color.fromARGB(230, 63, 35, 221)
        : const Color(0xFFE0E5EC);
    final cardBg = widget.isDark ? const Color(0xFF282A36) : Colors.white;

    return Scaffold(
      backgroundColor: screenBg,
      appBar: AppBar(
        title: const Text(
          'Calculator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: widget.isDark ? 0.3 : 0.08,
                    ),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Current Number
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.only(bottom: 20),
                        child: Text(
                          divideZeroError
                              ? "Cannot Divide by Zero"
                              : isInputNum
                              ? currNum
                              : (ans == ans.truncateToDouble())
                              ? "${ans.truncate()}"
                              : ans
                                    .toStringAsFixed(numDigits)
                                    .replaceFirst(RegExp(r'\.?0+$'), ''),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          CalcButton(
                            label: 'AC',
                            isDark: widget.isDark,
                            onPressed: () => _clearCalc(),
                            width: 75,
                          ),
                          CalcButton(
                            label: '±',
                            isDark: widget.isDark,
                            onPressed: () => _switchSign(),
                            width: 75,
                          ),
                          CalcButton(
                            label: '%',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction('%'),
                            width: 75,
                          ),
                          CalcButton(
                            label: '÷',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction('÷'),
                            width: 75,
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          CalcButton(
                            label: '7',
                            isDark: widget.isDark,
                            onPressed: () => _triggerNum('7'),
                            width: 75,
                          ),
                          CalcButton(
                            label: '8',
                            isDark: widget.isDark,
                            onPressed: () => _triggerNum('8'),
                            width: 75,
                          ),
                          CalcButton(
                            label: '9',
                            isDark: widget.isDark,
                            onPressed: () => _triggerNum('9'),
                            width: 75,
                          ),
                          CalcButton(
                            label: 'x',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction('x'),
                            width: 75,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CalcButton(
                            label: '4',
                            isDark: widget.isDark,
                            onPressed: () => _triggerNum('4'),
                            width: 75,
                          ),
                          CalcButton(
                            label: '5',
                            isDark: widget.isDark,
                            onPressed: () => _triggerNum('5'),
                            width: 75,
                          ),
                          CalcButton(
                            label: '6',
                            isDark: widget.isDark,
                            onPressed: () => _triggerNum('6'),
                            width: 75,
                          ),
                          CalcButton(
                            label: '-',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction('-'),
                            width: 75,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CalcButton(
                            label: '1',
                            isDark: widget.isDark,
                            onPressed: () => _triggerNum('1'),
                            width: 75,
                          ),
                          CalcButton(
                            label: '2',
                            isDark: widget.isDark,
                            onPressed: () => _triggerNum('2'),
                            width: 75,
                          ),
                          CalcButton(
                            label: '3',
                            isDark: widget.isDark,
                            onPressed: () => _triggerNum('3'),
                            width: 75,
                          ),
                          CalcButton(
                            label: '+',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction('+'),
                            width: 75,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CalcButton(
                            label: '0',
                            isDark: widget.isDark,
                            onPressed: () => _triggerNum('0'),
                            width: 150,
                          ),
                          CalcButton(
                            label: '.',
                            isDark: widget.isDark,
                            onPressed: () => _triggerNum('.'),
                            width: 75,
                          ),
                          CalcButton(
                            label: '=',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction('='),
                            width: 75,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Calculator Button
class CalcButton extends StatefulWidget {
  final String label;
  final bool isDark;
  final VoidCallback onPressed;
  final double width;

  const CalcButton({
    super.key,
    required this.label,
    required this.isDark,
    required this.onPressed,
    required this.width,
  });

  @override
  State<CalcButton> createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isDark
        ? const Color(0xFF222430)
        : const Color(0xFFE0E5EC);

    final darkShadow = widget.isDark ? Colors.black87 : const Color(0xFFA3B1C6);
    final lightShadow = widget.isDark ? const Color(0xFF2F3244) : Colors.white;

    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) {
        setState(() => isPressed = true);
      },
      onTapUp: (_) {
        setState(() => isPressed = false);
      },
      onTapCancel: () {
        setState(() => isPressed = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.width,
        height: 75,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: null,
          boxShadow: isPressed
              ? [
                  BoxShadow(
                    color: darkShadow.withValues(alpha: 0.5),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                  BoxShadow(
                    color: lightShadow.withValues(alpha: 0.5),
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                  ),
                ]
              : [
                  BoxShadow(
                    color: darkShadow.withValues(alpha: 0.7),
                    offset: const Offset(8, 8),
                    blurRadius: 16,
                  ),
                  BoxShadow(
                    color: lightShadow.withValues(alpha: 0.9),
                    offset: const Offset(-8, -8),
                    blurRadius: 16,
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 1.1,
                color: widget.isDark ? Colors.white54 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
