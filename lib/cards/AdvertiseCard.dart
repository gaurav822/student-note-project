import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_notes/Models/admodel.dart';

class AdvertiseCard extends StatelessWidget {
  final Advertise advertise;
  AdvertiseCard(this.advertise);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    height: 200,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: advertise.image,
                          fit: BoxFit.fill,
                          width: Get.width,
                          height: Get.height,
                        )),
                  ),
                );
              });
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(spreadRadius: .5, color: Colors.white)]),
            height: 220,
            width: Get.width * .8,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: advertise.image,
                    fit: BoxFit.cover,
                    width: Get.width,
                    height: Get.height,
                  ),
                ),
                // Align(
                //   alignment: Alignment.topCenter,
                //   child: Text(advertise.title,
                //       style: GoogleFonts.ubuntu(
                //           textStyle: TextStyle(
                //               fontSize: 20,
                //               fontWeight: FontWeight.w600,
                //               color: Colors.))),
                // ),
              ],
            )),
      ),
    );
  }
}
