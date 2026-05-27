import 'package:flutter/material.dart';

const kIndigo = Color(0xFF3949AB);
const kBackground = Color(0xFFF4F6FF);
const kWhite = Colors.white;

class Catatan {
  final String judul;
  final String isi;
  final String kategori;
  final DateTime dibuatPada;

  Catatan({
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.dibuatPada,
  });
}

String _formatTanggal(DateTime dt) {
  final namaBulan = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
  ];

  return '${dt.day} ${namaBulan[dt.month - 1]} ${dt.year}';
}

Color _kategoriColor(String kategori) {
  switch (kategori) {
    case 'Kuliah':
      return Colors.indigo;
    case 'Tugas':
      return Colors.orange;
    case 'Pribadi':
      return Colors.teal;
    default:
      return Colors.grey;
  }
}

class TugasMandiri2App extends StatelessWidget {
  const TugasMandiri2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tugas Mandiri 2',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: kIndigo,
        scaffoldBackgroundColor: kBackground,

        appBarTheme: const AppBarTheme(
          backgroundColor: kIndigo,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),

        floatingActionButtonTheme:
        const FloatingActionButtonThemeData(
          backgroundColor: kIndigo,
          foregroundColor: Colors.white,
        ),
      ),

      home: const TugasMandiri2Home(),
    );
  }
}

class TugasMandiri2Home extends StatefulWidget {
  const TugasMandiri2Home({super.key});

  @override
  State<TugasMandiri2Home> createState() =>
      _TugasMandiri2HomeState();
}

class _TugasMandiri2HomeState
    extends State<TugasMandiri2Home> {
  final List<Catatan> _catatan = [
    Catatan(
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget dan Form',
      kategori: 'Kuliah',
      dibuatPada: DateTime.now(),
    ),

    Catatan(
      judul: 'Tugas Mobile',
      isi: 'Mengerjakan modul praktikum',
      kategori: 'Tugas',
      dibuatPada:
      DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  String _filterKategori = 'Semua';

  final _filterOpsi = const [
    'Semua',
    'Kuliah',
    'Tugas',
    'Pribadi',
    'Lainnya',
  ];

  Future<void> _tambahCatatan() async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TambahCatatanPage(),
      ),
    );

    if (hasil is Catatan) {
      setState(() {
        _catatan.add(hasil);
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Catatan "${hasil.judul}" berhasil ditambahkan',
          ),
          backgroundColor: kIndigo,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filterKategori == 'Semua'
        ? _catatan
        : _catatan
        .where(
          (c) => c.kategori == _filterKategori,
    )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Kategori'),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pop();
          },
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: Colors.white,
                value: _filterKategori,
                iconEnabledColor: Colors.white,
                style: const TextStyle(
                  color: Colors.black,
                ),
                items: _filterOpsi.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (v) {
                  setState(() {
                    _filterKategori = v!;
                  });
                },
                icon: const Icon(Icons.filter_list),
              ),
            ),
          ),
        ],
      ),

      body: filtered.isEmpty
          ? const _EmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final c = filtered[index];

          return Container(
            margin:
            const EdgeInsets.only(bottom: 14),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(20),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: ListTile(
              contentPadding:
              const EdgeInsets.all(16),

              leading: Container(
                width: 14,
                decoration: BoxDecoration(
                  color: _kategoriColor(
                    c.kategori,
                  ),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
              ),

              title: Text(
                c.judul,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              subtitle: Padding(
                padding:
                const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color: _kategoriColor(
                          c.kategori,
                        ).withOpacity(0.12),

                        borderRadius:
                        BorderRadius.circular(
                          10,
                        ),
                      ),

                      child: Text(
                        c.kategori,
                        style: TextStyle(
                          color: _kategoriColor(
                            c.kategori,
                          ),
                          fontSize: 11,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _formatTanggal(
                        c.dibuatPada,
                      ),
                    ),
                  ],
                ),
              ),

              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  setState(() {
                    _catatan.remove(c);
                  });

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        '${c.judul} dihapus',
                      ),
                      backgroundColor:
                      Colors.redAccent,
                    ),
                  );
                },
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        DetailCatatanPage(
                          catatan: c,
                        ),
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahCatatan,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.note_alt_outlined,
              size: 60,
              color: Colors.indigo,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Tidak Ada Catatan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Tambahkan catatan baru terlebih dahulu',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class TambahCatatanPage extends StatefulWidget {
  const TambahCatatanPage({super.key});

  @override
  State<TambahCatatanPage> createState() =>
      _TambahCatatanPageState();
}

class _TambahCatatanPageState
    extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();

  final _judulCtrl = TextEditingController();
  final _isiCtrl = TextEditingController();

  String _kategori = 'Kuliah';

  final _kategoriOpsi = const [
    'Kuliah',
    'Tugas',
    'Pribadi',
    'Lainnya',
  ];

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      Catatan(
        judul: _judulCtrl.text,
        isi: _isiCtrl.text,
        kategori: _kategori,
        dibuatPada: DateTime.now(),
      ),
    );
  }

  InputDecoration fieldStyle(
      String label,
      IconData icon,
      ) {
    return InputDecoration(
      labelText: label,

      prefixIcon: Icon(
        icon,
        color: kIndigo,
      ),

      filled: true,
      fillColor: Colors.indigo.withOpacity(0.05),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan'),
      ),

      body: Form(
        key: _formKey,

        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(20),

                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),

              child: Column(
                children: [
                  TextFormField(
                    controller: _judulCtrl,
                    decoration: fieldStyle(
                      'Judul',
                      Icons.title,
                    ),
                    validator: (v) {
                      if (v == null ||
                          v.trim().isEmpty) {
                        return 'Judul wajib diisi';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField(
                    value: _kategori,
                    decoration: fieldStyle(
                      'Kategori',
                      Icons.category,
                    ),
                    items: _kategoriOpsi.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (v) {
                      setState(() {
                        _kategori = v!;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _isiCtrl,
                    maxLines: 5,
                    decoration: fieldStyle(
                      'Isi Catatan',
                      Icons.notes,
                    ),
                    validator: (v) {
                      if (v == null ||
                          v.trim().isEmpty) {
                        return 'Isi wajib diisi';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 54,
              child: FilledButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Simpan Catatan',
                ),

                style: FilledButton.styleFrom(
                  backgroundColor: kIndigo,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      16,
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

class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;

  const DetailCatatanPage({
    super.key,
    required this.catatan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,

      appBar: AppBar(
        title: const Text('Detail Catatan'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Colors.indigo,
                    Color(0xFF5C6BC0),
                  ],
                ),

                borderRadius:
                BorderRadius.circular(24),
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius:
                      BorderRadius.circular(10),
                    ),

                    child: Text(
                      catatan.kategori,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    catatan.judul,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    _formatTanggal(
                      catatan.dibuatPada,
                    ),
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(20),

                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                  ),
                ],
              ),

              child: Text(
                catatan.isi,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.7,
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,

              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },

                icon:
                const Icon(Icons.arrow_back),

                label: const Text('Kembali'),

                style: FilledButton.styleFrom(
                  backgroundColor: kIndigo,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      16,
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