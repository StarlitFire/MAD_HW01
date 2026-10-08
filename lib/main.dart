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
  double ans = 0;

  void _triggerAction(String actionName) {}

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
                      Text(
                        "$ans",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Row(
                        children: [
                          CalcButton(
                            label: 'AC',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
                            width: 75,
                          ),
                          CalcButton(
                            label: '±',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
                            width: 75,
                          ),
                          CalcButton(
                            label: '%',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
                            width: 75,
                          ),
                          CalcButton(
                            label: '÷',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
                            width: 75,
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          CalcButton(
                            label: '7',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
                            width: 75,
                          ),
                          CalcButton(
                            label: '8',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
                            width: 75,
                          ),
                          CalcButton(
                            label: '9',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
                            width: 75,
                          ),
                          CalcButton(
                            label: 'x',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
                            width: 75,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CalcButton(
                            label: '4',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
                            width: 75,
                          ),
                          CalcButton(
                            label: '5',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
                            width: 75,
                          ),
                          CalcButton(
                            label: '6',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
                            width: 75,
                          ),
                          CalcButton(
                            label: '-',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
                            width: 75,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CalcButton(
                            label: '1',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
                            width: 75,
                          ),
                          CalcButton(
                            label: '2',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
                            width: 75,
                          ),
                          CalcButton(
                            label: '3',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
                            width: 75,
                          ),
                          CalcButton(
                            label: '+',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
                            width: 75,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CalcButton(
                            label: '0',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
                            width: 150,
                          ),
                          CalcButton(
                            label: '.',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
                            width: 75,
                          ),
                          CalcButton(
                            label: '=',
                            isDark: widget.isDark,
                            onPressed: () => _triggerAction(''),
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
