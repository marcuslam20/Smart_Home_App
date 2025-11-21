// lib/screens/device_action_page.dart
import 'package:flutter/material.dart';

class DeviceActionPage extends StatefulWidget {
  final Map<String, dynamic> device;
  const DeviceActionPage({super.key, required this.device});

  @override
  State<DeviceActionPage> createState() => _DeviceActionPageState();
}

class _DeviceActionPageState extends State<DeviceActionPage> {
  String? selectedSwitch;
  String? selectedMode;
  String? selectedHoldTime;
  String? selectedDirection;

  // Mở rộng chi tiết khi bấm vào tiêu đề
  final Set<String> expandedSections = {};

  final Map<String, List<Map<String, dynamic>>> actionConfig = {
    "Switch": [
      {"label": "On", "value": "on"},
      {"label": "Off", "value": "off"},
    ],
    "Mode": [
      {"label": "Click", "value": "click"},
      {"label": "Press & Hold", "value": "press"},
    ],
    "Hold time": [
      {"label": "0.5s", "value": "0.5s"},
      {"label": "1.0s", "value": "1.0s"},
      {"label": "1.5s", "value": "1.5s"},
      {"label": "2.0s", "value": "2.0s"},
    ],
    "Upper": [
      {"label": "Thực hiện", "value": "upper"},
    ],
    "Bottom": [
      {"label": "Thực hiện", "value": "bottom"},
    ],
    "Auto": [
      {"label": "Thực hiện", "value": "auto"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final deviceName = widget.device['name'] as String;
    final isFingerbot = deviceName.contains('Fingerbot');
    final List<String> actions = isFingerbot
        ? ["Switch", "Mode", "Hold time", "Upper", "Bottom", "Auto"]
        : ["Switch"];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          deviceName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _canConfirm()
                ? () {
                    final result = {
                      'device': widget.device,
                      'action': {
                        'switch': selectedSwitch,
                        'mode': selectedMode,
                        'hold_time': selectedHoldTime,
                        'direction': selectedDirection,
                      },
                    };
                    Navigator.of(context).pop(result);
                  }
                : null,
            child: Text(
              "Xác nhận",
              style: TextStyle(
                color: _canConfirm() ? Colors.red : Colors.red.withOpacity(0.4),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final title = actions[index];
          final options = actionConfig[title]!;
          final isExpanded = expandedSections.contains(title);
          final hasSelection = _getSelectedValue(title) != null;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Tiêu đề + icon tick + mũi tên (bấm vào đây để mở)
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    setState(() {
                      if (isExpanded) {
                        expandedSections.remove(title);
                      } else {
                        expandedSections.add(title);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (hasSelection)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.red,
                            size: 24,
                          ),
                        const SizedBox(width: 8),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),

                // Nội dung chi tiết (chỉ hiện khi mở rộng)
                if (isExpanded)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xFFE5E5E5), width: 0.5),
                      ),
                    ),
                    child: Column(
                      children: options.map((opt) {
                        final value = opt['value'] as String;
                        final isSelected = _getSelectedValue(title) == value;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _setValue(title, value);
                              // Tự động thu gọn sau khi chọn (giống Tuya)
                              // expandedSections.remove(title);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    opt['label'],
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.black54,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check,
                                    color: Colors.red,
                                    size: 28,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  dynamic _getSelectedValue(String title) {
    return switch (title) {
      "Switch" => selectedSwitch,
      "Mode" => selectedMode,
      "Hold time" => selectedHoldTime,
      "Upper" => selectedDirection == "upper" ? "upper" : null,
      "Bottom" => selectedDirection == "bottom" ? "bottom" : null,
      "Auto" => selectedDirection == "auto" ? "auto" : null,
      _ => null,
    };
  }

  void _setValue(String title, String value) {
    setState(() {
      switch (title) {
        case "Switch":
          selectedSwitch = value;
          break;
        case "Mode":
          selectedMode = value;
          break;
        case "Hold time":
          selectedHoldTime = value;
          break;
        case "Upper":
          selectedDirection = "upper";
          break;
        case "Bottom":
          selectedDirection = "bottom";
          break;
        case "Auto":
          selectedDirection = "auto";
          break;
      }
    });
  }

  bool _canConfirm() =>
      selectedSwitch != null ||
      selectedMode != null ||
      selectedHoldTime != null ||
      selectedDirection != null;

  void _confirm() {
    final result = {
      'device': widget.device,
      'action': {
        'switch': selectedSwitch,
        'mode': selectedMode,
        'hold_time': selectedHoldTime,
        'direction': selectedDirection,
      },
    };
    Navigator.pop(context, result);
  }
}
