import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          "Daftar Rekap Keuangan",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("Rekap Keuangan $index"),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      backgroundColor: Colors.indigo,
                      onPressed: () {
                        showBarModalBottomSheet(
                          expand: false,
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                            height: MediaQuery.of(context).size.height / 2,
                            color: Colors.white,
                            child: TambahRekapKeuangan(),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TambahRekapKeuangan extends StatefulWidget {
  const TambahRekapKeuangan({super.key});

  @override
  State<TambahRekapKeuangan> createState() => _TambahRekapKeuanganState();
}

class _TambahRekapKeuanganState extends State<TambahRekapKeuangan> {
  final _formKey = GlobalKey<FormState>();
  final _judulDraftController = TextEditingController();
  final _tanggalController = TextEditingController();

  @override
  void initState() {
    _tanggalController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Tambah Rekap Keuangan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Judul Draft tidak boleh kosong';
                  }
                  return null;
                },
                controller: _judulDraftController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  labelText: "Judul Draft",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _tanggalController,
                readOnly: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Tanggal tidak boleh kosong';
                  }
                  return null;
                },
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 365 * 3)),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    _tanggalController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                  }
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  labelText: "Tanggal",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print('valid');
                        }
                        print([
                          _judulDraftController.text,
                          _tanggalController.text,
                        ]);
                      },
                      child: Text(
                        'Simpan',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.resolveWith(
                          (_) => RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
