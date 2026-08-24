import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/checkout/widget/payment_method_selector.dart';
import 'package:food_delivery/features/profile/controller/edit_profile_controller.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  final EditProfileController controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child:  Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'My profile',
                        style: GoogleSansRoundedStyles.bold(
                          size: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.02),
                ],
              ),
            ),

            SizedBox(height: size.height * 0.02),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Text(
                      'Information',
                      style: GoogleSansRoundedStyles.bold(
                        size: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                   SizedBox(height: size.height * 0.03),
                    Obx(
                      () => Container(
                        width: size.width,
                        height: size.height * 0.25,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: controller.pickImage,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Container(
                                  width: size.width * 0.2,
                                  height: size.width * 0.2,
                                  color:  Color(0xFFFFB5C5),
                                  child: controller.profileImageBytes != null
                                      ? Image.memory(
                                          controller.profileImageBytes!,
                                          fit: BoxFit.cover,
                                        )
                                      : controller.profileImageUrl != null &&
                                            controller
                                                .profileImageUrl!
                                                .isNotEmpty
                                      ? Image.network(
                                          controller.profileImageUrl!,
                                          fit: BoxFit.cover,
                                        )
                                      :  Icon(
                                          Icons.person,
                                          size: 23,
                                          color: AppColor.primary,
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                    controller: controller.nameController,
                                    style:  GoogleSansRoundedStyles.regular(
                                      size: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration:  InputDecoration(
                                      hintText: 'Your Name',
                                      hintStyle: GoogleSansRoundedStyles.regular(
                                      size: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.02),
                                  Text(
                                    controller.userEmail,
                                    style:  GoogleSansRoundedStyles.regular(
                                      size: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                 SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        controller.countryFlag.value,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                       SizedBox(width: 7),
                                      Text(
                                        controller.countryCode.value,
                                        style: GoogleSansRoundedStyles.regular(
                                      size: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                      ),
                                       SizedBox(width: 5),
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
                                        child: Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                       SizedBox(width: size.width*0.02),
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              controller.phoneController,
                                          keyboardType: TextInputType.phone,
                                          maxLength: 13,
                                          style: GoogleSansRoundedStyles.regular(
                                      size: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                          decoration: InputDecoration(
                                            hintText: '7654231895',
                                            hintStyle: GoogleSansRoundedStyles.regular(
                                      size: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
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

                                   Divider(
                                    height: 1,
                                    thickness: 0.8,
                                    color: Color(0xFFD9D9D9),
                                  ),
                                   SizedBox(height: size.height * 0.02),
                                  TextField(
                                    controller: controller.addressController,
                                    keyboardType: TextInputType.streetAddress,
                                    maxLines: 2,
                                    style: GoogleSansRoundedStyles.regular(
                                      size: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'No address added',
                                      hintStyle:GoogleSansRoundedStyles.regular(
                                      size: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
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
                      ),
                    ),

                     SizedBox(height: size.height * 0.05),
                  Text(
                      'Payment Method',
                      style: GoogleSansRoundedStyles.bold(
                                      size: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                    ),
                    SizedBox(height: 7),
                    Obx(
                      () => PaymentMethodSelector(
                        selectedMethod: controller.selectedPaymentMethod.value,
                        onMethodChanged: (val) {
                          controller.changePaymentMethod(val);
                        },
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 20),
              child: Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      disabledBackgroundColor: AppColor.primary.withValues(
                        alpha: 0.6,
                      ),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            width: size.width * 0.9,
                            height: size.height * 0.09,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Update',
                            style: GoogleSansRoundedStyles.bold(
                                      size: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
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
}
