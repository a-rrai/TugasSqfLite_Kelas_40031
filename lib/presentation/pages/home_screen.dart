import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crud_barang/model/barang.dart';
import 'package:crud_barang/presentation/controller/barang_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showFormDialog(BuildContext context, BarangController ctr, {Barang? barang}) {
    final namaController = TextEditingController(text: barang?.nama ?? '');
    final stokController = TextEditingController(
      text: barang != null ? barang.stok.toString() : '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(barang == null ? "Tambah Barang" : "Edit Barang"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama Barang"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: stokController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Stok Barang"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                final nama = namaController.text.trim();
                final stok = int.tryParse(stokController.text.trim()) ?? 0;

                if (nama.isEmpty) {
                  Get.snackbar("Peringatan", "Nama barang tidak boleh kosong");
                  return;
                }

                if (barang == null) {
                  // Create
                  ctr.tambahBarang(Barang(nama: nama, stok: stok));
                } else {
                  // Update
                  ctr.editBarang(barang.copyWith(nama: nama, stok: stok));
                }

                Navigator.pop(context); 
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<BarangController>();
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text(
              "LIST BARANG",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (ctr.barangList.isEmpty) {
                  return const Center(child: Text("Data Belum Ada"));
                }

                return ListView.builder(
                  itemCount: ctr.barangList.length,
                  itemBuilder: (context, index) {
                    final barang = ctr.barangList[index];
                    return Card(
                      child: ListTile(
                        title: Text(barang.nama),
                        subtitle: Text("Stok Barang: ${barang.stok}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Tombol Edit
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showFormDialog(context, ctr, barang: barang);
                              },
                            ),
                            // Tombol Delete
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                if (barang.id != null) {
                                  ctr.hapusBarang(barang.id!);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      // Tombol Tambah 
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(context, ctr),
        child: const Icon(Icons.add),
      ),
    );
  }
}