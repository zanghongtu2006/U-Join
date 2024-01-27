import 'package:flutter/material.dart';

class CustomStepProgress extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final double width;
  final Color activeColor;
  final Color inactiveColor;

  const CustomStepProgress({super.key,
    required this.totalSteps,
    required this.currentStep,
    this.width = 400,
    this.activeColor = Colors.indigoAccent,
    this.inactiveColor = Colors.grey,
  });

  Widget _buildStep(int step, bool isActive) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isActive ? activeColor : Colors.transparent,
        border:
            Border.all(color: isActive ? activeColor : inactiveColor, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: TextStyle(fontSize: 14,
            color: isActive ? Colors.white : inactiveColor,
          ),
        ),
      ),
    );
  }

  Widget _buildLine() {
    return Expanded(
      child: Divider(
        color: inactiveColor,
        thickness: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: width,
      child: Row(
        children: List.generate(
          totalSteps * 2 - 1,
              (index) {
            return index % 2 == 0
                ? _buildStep((index ~/ 2) + 1, currentStep > index ~/ 2)
                : _buildLine();
          },
        ),
      ),
    );
  }
}
