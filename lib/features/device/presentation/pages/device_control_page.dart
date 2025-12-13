// lib/features/device/presentation/pages/device_control_page.dart
import 'package:flutter/material.dart';
import '../../domain/entities/device_entity.dart';

class DeviceControlPage extends StatefulWidget {
  final DeviceEntity device;
  const DeviceControlPage({Key? key, required this.device}) : super(key: key);

  @override
  State<DeviceControlPage> createState() => _DeviceControlPageState();
}

class _DeviceControlPageState extends State<DeviceControlPage>
    with TickerProviderStateMixin {
  double _position = 0.0; // 0.0 = mở hoàn toàn, 1.0 = đóng hoàn toàn
  bool _isRunning = false;

  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  /// Hàm cập nhật vị trí rèm dựa vào thiết bị thật
  void _updateDevicePosition(double newPosition) {
    setState(() {
      _position = newPosition.clamp(0.0, 1.0);
    });
  }

  void _sendCommand(String command) {
    if (_isRunning && command != 'STOP') return;

    setState(() => _isRunning = command != 'STOP');

    if (_isRunning)
      _pulseController.repeat(reverse: true);
    else {
      _pulseController.stop();
      _pulseController.reset();
    }

    // Gửi lệnh tới thiết bị
    switch (command) {
      case 'OPEN':
        // TODO: Gọi API / SDK thiết bị để mở rèm
        break;
      case 'CLOSE':
        // TODO: Gọi API / SDK thiết bị để đóng rèm
        break;
      case 'STOP':
        // TODO: Gọi API / SDK thiết bị để dừng motor
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayPercent = (100 - (_position * 100)).toInt();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.device.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),

          // THANH RAY + MOTOR NHẤP NHÁY
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 60),
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  left: 30 + _position * 200,
                  child: Row(
                    children: [
                      _MotorDot(active: _isRunning),
                      const SizedBox(width: 12),
                      _MotorDot(active: _isRunning),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),

          // RÈM DỌC – bám tốc độ motor thật
          Expanded(
            child: AnimatedAlign(
              alignment: Alignment.topCenter,
              heightFactor: _position,
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1 + 0.2 * _position),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CustomPaint(
                  painter: VerticalCurtainPainter(position: _position),
                  size: Size.infinite,
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // CHỈ SỐ %
          TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: displayPercent.toDouble(),
              end: displayPercent.toDouble(),
            ),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, child) {
              return Column(
                children: [
                  Text(
                    '${value.toInt()}%',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _position == 0
                        ? 'Mở hoàn toàn'
                        : _position == 1
                        ? 'Đóng hoàn toàn'
                        : 'Đang di chuyển',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 40),

          // 3 NÚT NHỎ GỌN Ở DƯỚI RÈM – NẰM GIỮA
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SmallButton(
                icon: Icons.keyboard_arrow_up_rounded,
                onTap: () => _sendCommand('OPEN'),
                pulseController: _pulseController,
              ),
              const SizedBox(width: 40),
              _SmallButton(
                icon: Icons.pause_rounded,
                onTap: () => _sendCommand('STOP'),
                pulseController: _pulseController,
              ),
              const SizedBox(width: 40),
              _SmallButton(
                icon: Icons.keyboard_arrow_down_rounded,
                onTap: () => _sendCommand('CLOSE'),
                pulseController: _pulseController,
              ),
            ],
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _MotorDot({required bool active}) {
    return AnimatedOpacity(
      opacity: active ? 1.0 : 0.3,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: Colors.blue.shade600,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _SmallButton({
    required IconData icon,
    required VoidCallback onTap,
    required AnimationController pulseController,
  }) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (_, __) {
        double scale = 1.0 + 0.1 * pulseController.value;
        return Transform.scale(
          scale: scale,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: onTap,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.blue.shade300, width: 1.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.blue.shade700, size: 24),
              ),
            ),
          ),
        );
      },
    );
  }
}

// VẼ RÈM DỌC – sóng mềm theo vị trí
class VerticalCurtainPainter extends CustomPainter {
  final double position;
  VerticalCurtainPainter({this.position = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final path = Path();
    final segments = 22;
    final maxWaveHeight = 40.0;
    final waveHeight =
        maxWaveHeight * (1 - position); // càng đóng, sóng nhỏ hơn

    for (int i = 0; i < segments; i++) {
      double y = i * (size.height / (segments - 1));
      path.moveTo(60, y);
      path.lineTo(size.width - 60, y);

      if (i < segments - 1) {
        double nextY = (i + 1) * (size.height / (segments - 1));
        path.quadraticBezierTo(
          size.width / 2,
          y + waveHeight,
          size.width - 60,
          nextY,
        );
        path.moveTo(60, nextY);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant VerticalCurtainPainter old) =>
      old.position != position;
}
