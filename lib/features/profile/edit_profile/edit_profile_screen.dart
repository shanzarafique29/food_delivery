
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/features/profile/edit_profile/controller/edit_profile_controller.dart';
import 'package:get/get.dart';


class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final EditProfileController controller =
      Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 13,
                      color: Colors.black,
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        'My profile',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 13),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Information',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 7),

                    GetBuilder<EditProfileController>(
                      builder: (controller) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              // PROFILE IMAGE
                              GestureDetector(
                                onTap:
                                    controller.pickImage,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(7),
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    color:
                                        const Color(0xFFFFB5C5),
                                    child: controller
                                                .profileImageBytes !=
                                            null
                                        ? Image.memory(
                                            controller
                                                .profileImageBytes!,
                                            fit: BoxFit.cover,
                                          )
                                        : controller
                                                    .profileImageUrl !=
                                                null &&
                                            controller
                                                .profileImageUrl!
                                                .isNotEmpty
                                        ? Image.network(
                                            controller
                                                .profileImageUrl!,
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(
                                            Icons.person,
                                            size: 23,
                                            color:
                                                Color(0xFFFF3B1F),
                                          ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    // NAME - NOT EDITABLE
                                    Text(
                                      controller
                                              .nameController
                                              .text
                                              .isEmpty
                                          ? 'Your name'
                                          : controller
                                              .nameController
                                              .text,
                                      style:
                                          const TextStyle(
                                        fontSize: 10,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 2),

                                    // EMAIL - NOT EDITABLE
                                    Text(
                                      controller.userEmail,
                                      style:
                                          const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    // PHONE
                                    Row(
                                          children: [
                                            // Flag
                                            Obx(
                                              () => Text(
                                                controller.countryFlag.value,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 7),

                                            // Country code
                                            Obx(
                                              () => Text(
                                                controller.countryCode.value,
                                                style: const TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 5),

                                            // Country dropdown arrow
                                            GestureDetector(
                                              onTap: () {
                                                showCountryPicker(
                                                  context: context,
                                                  showPhoneCode: true,
                                                  onSelect: (Country country) {
                                                    controller.changeCountry(
                                                      code: '+${country.phoneCode}',
                                                      flag: country.flagEmoji,
                                                    );
                                                  },
                                                );
                                              },
                                              child: const Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 14,
                                                color: Colors.grey,
                                              ),
                                            ),

                                            const SizedBox(width: 14),

                                            // Phone number
                                            Expanded(
                                              child: TextField(
                                                controller: controller.phoneController,
                                                keyboardType: TextInputType.phone,
                                                maxLength: 10,
                                                style: const TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.grey,
                                                ),
                                                decoration: const InputDecoration(
                                                  hintText: '7654231895',
                                                  hintStyle: TextStyle(
                                                    fontSize: 9,
                                                    color: Colors.grey,
                                                  ),
                                                  counterText: '',
                                                  border: InputBorder.none,
                                                  isDense: true,
                                                  contentPadding: EdgeInsets.zero,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                      const Divider(
                                        height: 1,
                                        thickness: 0.7,
                                        color: Color(0xFFD9D9D9),
                                      ),

                                      const SizedBox(height: 4),

                                      // ================= ADDRESS =================
                                      TextField(
                                        controller: controller.addressController,
                                        keyboardType: TextInputType.streetAddress,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: 'No address added',
                                          hintStyle: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _paymentItem(
                            index: 0,
                            title: 'Card',
                            icon: Icons.credit_card,
                            iconBackground:
                                const Color(0xFFFF8A24),
                          ),

                          const Divider(
                            height: 1,
                            thickness: 0.6,
                            color:
                                Color(0xFFE5E5E5),
                          ),

                          _paymentItem(
                            index: 1,
                            title: 'Bank account',
                            icon:
                                Icons.account_balance,
                            iconBackground:
                                const Color(0xFFFF4B91),
                          ),

                          const Divider(
                            height: 1,
                            thickness: 0.6,
                            color:
                                Color(0xFFE5E5E5),
                          ),

                          _paymentItem(
                            index: 2,
                            title: 'Paypal',
                            icon: Icons.paypal,
                            iconBackground:
                                const Color(0xFF1746FF),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(32, 0, 32, 20),
              child: Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : controller.updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColor.primary,
                      disabledBackgroundColor:
                          AppColor.primary,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                    ),
                    child:
                        controller.isLoading.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Update',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentItem({
    required int index,
    required String title,
    required IconData icon,
    required Color iconBackground,
  }) {
    return Obx(
      () => SizedBox(
        height: 38,
        child: Row(
          children: [
            Radio<int>(
              value: index,
              groupValue: controller
                  .selectedPaymentMethod.value,
              onChanged: (value) {
                if (value != null) {
                  controller
                      .changePaymentMethod(value);
                }
              },
              activeColor: AppColor.primary,
              materialTapTargetSize:
                  MaterialTapTargetSize.shrinkWrap,
            ),

            const SizedBox(width: 2),

            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 12,
              ),
            ),

            const SizedBox(width: 8),

            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

