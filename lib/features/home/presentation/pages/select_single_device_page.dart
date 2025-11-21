// lib/screens/select_single_device_page.dart
import 'package:flutter/material.dart';
import 'package:smart_curtain_app/features/home/presentation/pages/device_action_page.dart';

class SelectSingleDevicePage extends StatelessWidget {
  const SelectSingleDevicePage({super.key});

  // Dữ liệu mẫu – sau này bạn thay bằng API
  final List<Map<String, String>> devices = const [
    {"name": "Osprey Fingerbot", "status": "Ngoại tuyến"},
    {"name": "Đèn phòng khách", "status": "Online"},
    {"name": "Rèm phòng ngủ", "status": "Online"},
    {"name": "Máy lạnh chính", "status": "Online"},
    {"name": "Đèn bàn làm việc", "status": "Online"},
    {"name": "Quạt trần", "status": "Online"},
    {"name": "Công tắc bếp", "status": "Online"},
    {"name": "Cảm biến cửa", "status": "Online"},
    {"name": "Đèn LED trang trí", "status": "Online"},
    {"name": "Máy lọc không khí", "status": "Online"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Chọn thiết bị",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Tất cả thiết bị"
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              "Tất cả thiết bị",
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ),

          // Tag "No Category"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "No Category",
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Danh sách thiết bị
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                final bool isOffline = device["status"] == "Ngoại tuyến";

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DeviceActionPage(device: device),
                        ),
                      );
                      if (result != null) {
                        Navigator.pop(context, result);
                      }
                    },
                    child: Row(
                      children: [
                        // Icon thiết bị
                        Icon(
                          device["name"]!.contains("Fingerbot")
                              ? Icons.smart_toy_outlined
                              : Icons.lightbulb_outline,
                          size: 32,
                          color: isOffline ? Colors.grey : Colors.orange[700],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                device["name"]!,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (isOffline)
                                Text(
                                  "Ngoại tuyến",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.orange[700],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
