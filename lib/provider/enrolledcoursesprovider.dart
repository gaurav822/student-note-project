import 'package:flutter/cupertino.dart';
import 'package:student_notes/Models/enrolled_course_model.dart';

class EnrolledCourseProvider extends ChangeNotifier {
  List<EnrolledCourse> enrolledCourses = [];

  List<EnrolledCourse> getEnrolledCourses() => enrolledCourses;

  void addnewCourse(EnrolledCourse encourse) {
    enrolledCourses.add(encourse);
    notifyListeners();
  }

  void deleteCourse(EnrolledCourse course) {
    enrolledCourses.remove(course);
    notifyListeners();
  }

  void setMyCourses(List<EnrolledCourse> courses) {
    enrolledCourses = courses;
    notifyListeners();
  }
}
