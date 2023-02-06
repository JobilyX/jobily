import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget ratingBar(
    {required double startRate,
    double size = 15,
    void Function(double)? onRatingUpdate}) {
  double current = startRate;
  return RatingBar(
    initialRating: current,
    minRating: 1, ignoreGestures: onRatingUpdate == null ? true : false,
    direction: Axis.horizontal,
    allowHalfRating: false,
    itemCount: 5,
    itemSize: size,
    itemPadding: EdgeInsets.symmetric(horizontal: 2.0.w),
    ratingWidget: RatingWidget(
      full: const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      empty: Icon(
        Icons.star,
        color: Colors.grey[100],
      ),
      half: const Icon(Icons.start),
    ),
    onRatingUpdate: onRatingUpdate ??
        (rating) {
          current = rating;
        },
    // updateOnDrag: true,
  );
}

// Widget showRatingBar({required double startRate}) {
//   return RatingBar(
//     initialRating: startRate,
//     minRating: 0,
//     ignoreGestures: true,
//     direction: Axis.horizontal,
//     allowHalfRating: false,
//     itemCount: 5,
//     itemSize: 15.r,
//     itemPadding: EdgeInsets.symmetric(horizontal: 2.0.w),
//     ratingWidget: RatingWidget(
//       full: const Icon(
//         Icons.star,
//         color: Colors.amber,
//       ),
//       empty: Icon(
//         Icons.star,
//         color: Colors.grey[100],
//       ),
//       half: Image.asset(star),
//     ),
//     onRatingUpdate: (rating) {
//       none();
//     },
//     // updateOnDrag: true,
//   );
// }
