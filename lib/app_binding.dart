import 'package:get/get.dart';
import 'package:crud_barang/data/dao/barang_dao.dart';
import 'package:crud_barang/data/database/db_helper.dart';
import 'package:crud_barang/data/repo/barang_repo.dart';
import 'package:crud_barang/presentation/controller/barang_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DbHelper());

    Get.put(BarangDao(Get.find<DbHelper>()));
    Get.put<BarangRepo>(BarangRepoImpl(Get.find<BarangDao>()));
    Get.put(BarangController(Get.find<BarangRepo>()));
  }
}
