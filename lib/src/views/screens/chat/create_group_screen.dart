import 'package:flutter/material.dart';
import 'package:flutter_chat/core/constant/app_colors.dart';
import 'package:flutter_chat/src/controllers/chat/chat_controller.dart';
import 'package:flutter_chat/src/views/widgets/custom_text_field.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();

    // Clear fields when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.clearGroupFields();
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F52BA)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "New Group",
          style: TextStyle(
            color: const Color(0xFF0F52BA),
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Obx(
              () => ElevatedButton(
                onPressed: chatController.isCreatingGroup.value
                    ? null
                    : () => chatController.createGroup(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4E2FC),
                  foregroundColor: const Color(0xFF0F52BA),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 0.5.h,
                  ),
                ),
                child: chatController.isCreatingGroup.value
                    ? SizedBox(
                        height: 2.h,
                        width: 2.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF0F52BA),
                          ),
                        ),
                      )
                    : Text(
                        "Create",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
          child: Form(
            key: chatController.groupFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add Group Photo Section
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            _showPhotoSelectionDialog(context, chatController),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Obx(
                              () => Container(
                                width: 25.w,
                                height: 25.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFD4E2FC),
                                  image:
                                      chatController
                                          .groupImagePath
                                          .value
                                          .isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            chatController.groupImagePath.value,
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child:
                                    chatController.groupImagePath.value.isEmpty
                                    ? Icon(
                                        Icons.camera_alt_rounded,
                                        size: 10.w,
                                        color: const Color(0xFF5A739C),
                                      )
                                    : null,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF0F52BA),
                                border: Border.all(
                                  color: AppColors.white,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 4.w,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      Text(
                        "Add group photo",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),

                // Group Name Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Group Name",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Obx(
                      () => Text(
                        "${chatController.groupNameLength.value}/50",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                CustomTextField(
                  controller: chatController.groupNameController,
                  hintText: "What's your group about?",
                  maxLength: 50,
                  onChanged: (val) {
                    chatController.groupNameLength.value = val.length;
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Group name is required";
                    }
                    if (value.trim().length > 50) {
                      return "Group name cannot exceed 50 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 3.h),

                // Description Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Description (Optional)",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Obx(
                      () => Text(
                        "${chatController.groupDescriptionLength.value}/200",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                CustomTextField(
                  controller: chatController.groupDescriptionController,
                  hintText: "Add a purpose or rules...",
                  maxLines: 4,
                  maxLength: 200,
                  onChanged: (val) {
                    chatController.groupDescriptionLength.value = val.length;
                  },
                  validator: (value) {
                    if (value != null && value.trim().length > 200) {
                      return "Description cannot exceed 200 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 3.h),

                // Add Members Section
                Text(
                  "Add Members",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: () =>
                      _showContactSelectionBottomSheet(context, chatController),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F7FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF0066FF),
                          ),
                          child: Icon(
                            Icons.person_add_alt_1_rounded,
                            size: 6.w,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select contacts",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                  color: const Color(0xFF0F52BA),
                                ),
                              ),
                              SizedBox(height: 0.3.h),
                              Text(
                                "Tap to add participants",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 4.w,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 1.5.h),

                // Selected Members List
                Obx(() {
                  if (chatController.selectedMembers.isEmpty) {
                    return Text(
                      "No members selected yet",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                        fontSize: 11.sp,
                      ),
                    );
                  }

                  return Container(
                    height: 11.h,
                    margin: EdgeInsets.only(top: 0.5.h),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: chatController.selectedMembers.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final user = chatController.selectedMembers[index];
                        return Padding(
                          padding: EdgeInsets.only(right: 4.w),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 0.8.h,
                                  right: 0.8.w,
                                ),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.grey.shade200,
                                      backgroundImage: const NetworkImage(
                                        "https://i.pinimg.com/736x/3c/2b/ad/3c2badd0b9688bcb810ef699afc3f7c1.jpg",
                                      ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    SizedBox(
                                      width: 14.w,
                                      child: Text(
                                        user.fullName.split(' ').first,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    chatController.toggleMemberSelection(user),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPhotoSelectionDialog(
    BuildContext context,
    ChatController chatController,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        final presets = [
          {
            "name": "Work",
            "url":
                "https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=150",
          },
          {
            "name": "Friends",
            "url":
                "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=150",
          },
          {
            "name": "Family",
            "url":
                "https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=150",
          },
          {
            "name": "Gaming",
            "url":
                "https://images.unsplash.com/photo-1538481199705-c710c4e965fc?w=150",
          },
          {
            "name": "Design",
            "url":
                "https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?w=150",
          },
          {
            "name": "Coding",
            "url":
                "https://images.unsplash.com/photo-1607799279861-4dd421887fb3?w=150",
          },
        ];

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Select Group Photo",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: presets.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final preset = presets[index];
                return GestureDetector(
                  onTap: () {
                    chatController.groupImagePath.value = preset["url"]!;
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(preset["url"]!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        preset["name"]!,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            Obx(
              () => chatController.groupImagePath.value.isNotEmpty
                  ? TextButton(
                      onPressed: () {
                        chatController.groupImagePath.value = "";
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Remove Photo",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }

  void _showContactSelectionBottomSheet(
    BuildContext context,
    ChatController chatController,
  ) {
    final RxString searchQuery = "".obs;

    // Load users if list is empty
    if (chatController.allUsers.isEmpty) {
      chatController.getAllUsers();
    }

    Get.bottomSheet(
      Container(
        height: 75.h,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.symmetric(vertical: 1.5.h),
              width: 12.w,
              height: 0.6.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Contacts",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F52BA),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "Done",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F52BA),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            // Search Input
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: TextField(
                onChanged: (value) => searchQuery.value = value,
                style: TextStyle(fontSize: 12.sp),
                decoration: InputDecoration(
                  hintText: "Search contacts...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.2.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            // List of Users
            Expanded(
              child: Obx(() {
                if (chatController.isLoading.value &&
                    chatController.allUsers.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Retrieve and map selected user IDs synchronously inside the Obx builder
                // to register selectedMembers as a dependency and optimize lookups.
                final selectedIds = chatController.selectedMembers
                    .map((m) => m.id)
                    .toSet();

                final filteredUsers = chatController.allUsers.where((user) {
                  return user.fullName.toLowerCase().contains(
                    searchQuery.value.toLowerCase(),
                  );
                }).toList();

                if (filteredUsers.isEmpty) {
                  return Center(
                    child: Text(
                      "No contacts found",
                      style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                    ),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    final isSelected = selectedIds.contains(user.id);

                    return ListTile(
                      onTap: () => chatController.toggleMemberSelection(user),
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: const NetworkImage(
                          "https://i.pinimg.com/736x/3c/2b/ad/3c2badd0b9688bcb810ef699afc3f7c1.jpg",
                        ),
                      ),
                      title: Text(
                        user.fullName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      trailing: Icon(
                        isSelected
                            ? Icons.check_circle
                            : Icons.radio_button_off,
                        color: isSelected
                            ? const Color(0xFF0F52BA)
                            : Colors.grey.shade400,
                        size: 6.w,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
