// lib/screens/create_scene_page.dart
import 'package:flutter/material.dart';
import 'package:smart_curtain_app/features/home/presentation/pages/add_task_page.dart';

class CreateScenePage extends StatefulWidget {
  final Map<String, dynamic>? scheduleData;

  const CreateScenePage({super.key, this.scheduleData});

  @override
  State<CreateScenePage> createState() => _CreateScenePageState();
}

class _CreateScenePageState extends State<CreateScenePage> {
  late String displayTitle;
  late String displaySubtitle;

  // Danh sách hành động Then (sẽ nhận từ DeviceActionPage)
  final List<Map<String, dynamic>> _thenActions = [];

  @override
  void initState() {
    super.initState();
    _processScheduleData();
  }

  void _processScheduleData() {
    if (widget.scheduleData == null) {
      displayTitle = "Chưa chọn điều kiện";
      displaySubtitle = "";
      return;
    }

    final data = widget.scheduleData!;
    final type = data['type'] as String;
    final time = data['time'] as TimeOfDay?;
    final repeat = data['repeat'] as String? ?? "Chỉ một lần";

    if (type == "Mặt trời mọc") {
      displayTitle = "Mặt trời mọc";
      displaySubtitle = repeat;
    } else if (type == "Hoàng hôn") {
      displayTitle = "Hoàng hôn";
      displaySubtitle = repeat;
    } else {
      final hour = time?.hour.toString().padLeft(2, '0') ?? '--';
      final minute = time?.minute.toString().padLeft(2, '0') ?? '--';
      displayTitle = "Lịch trình : $hour:$minute";
      displaySubtitle = repeat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Hủy bỏ",
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ),
        leadingWidth: 80,
        title: const Text(
          "Tạo Ngữ cảnh thông minh",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // ==================== IF ====================
            _buildSection(
              title: "If",
              subtitle: "Khi bất kỳ điều kiện nào được đáp ứng",
              addButtonColor: Colors.red,
              child: _buildConditionItem(
                icon: Icons.access_time,
                iconColor: Colors.blue,
                title: displayTitle,
                subtitle: displaySubtitle,
              ),
            ),

            const SizedBox(height: 20),

            // ==================== THEN ====================
            _buildSection(
              title: "Then",
              addButtonColor: Colors.red,
              child: _thenActions.isEmpty
                  ? _buildAddTaskPlaceholder()
                  : Column(
                      children: _thenActions.map((action) {
                        final device = action['device'] as Map<String, String>;
                        final act = action['action'] as Map<String, dynamic>;
                        final deviceName = device['name']!;
                        final isOffline = device['status'] == "Ngoại tuyến";

                        // Tạo text hành động
                        String actionText = "";
                        if (act['switch'] == 'on')
                          actionText = "Switch : On";
                        else if (act['switch'] == 'off')
                          actionText = "Switch : Off";
                        else if (act['direction'] == 'upper')
                          actionText = "Upper";
                        else if (act['direction'] == 'bottom')
                          actionText = "Bottom";
                        else if (act['direction'] == 'auto')
                          actionText = "Auto";
                        else if (act['mode'] != null)
                          actionText = "Mode : ${act['mode']}";
                        else if (act['hold_time'] != null)
                          actionText = "Hold time : ${act['hold_time']}";

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
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
                          child: Row(
                            children: [
                              Icon(
                                deviceName.contains("Fingerbot")
                                    ? Icons.smart_toy_outlined
                                    : Icons.lightbulb_outline,
                                size: 32,
                                color: isOffline
                                    ? Colors.grey
                                    : Colors.orange[700],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      actionText,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "$deviceName${isOffline ? " | Offline" : ""}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isOffline
                                            ? Colors.orange[700]
                                            : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
              onAddPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddTaskPage()),
                );

                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    _thenActions.add(result);
                  });
                }
              },
            ),

            const SizedBox(height: 20),
            _buildOptionRow(
              title: "Precondition",
              value: "Cả ngày",
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildOptionRow(title: "Display Area", onTap: () {}),

            const Spacer(),

            // Nút Lưu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _thenActions.isEmpty
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Ngữ cảnh đã được tạo thành công!"),
                          ),
                        );
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3B30),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Lưu",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Cập nhật _buildSection để hỗ trợ onAddPressed riêng cho Then
  Widget _buildSection({
    required String title,
    String? subtitle,
    required Color addButtonColor,
    required Widget child,
    VoidCallback? onAddPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: 36,
              height: 36,
              child: FloatingActionButton(
                heroTag: title,
                backgroundColor: addButtonColor,
                mini: true,
                onPressed:
                    onAddPressed ??
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddTaskPage()),
                      );
                    },
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 12),
        ] else
          const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildConditionItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildAddTaskPlaceholder() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Text(
          "Thêm tác vụ",
          style: TextStyle(color: Colors.grey[400], fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildOptionRow({
    required String title,
    String? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
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
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            if (value != null)
              Text(
                value,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
