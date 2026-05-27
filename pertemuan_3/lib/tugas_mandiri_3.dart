import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────
class Catatan {
  final String judul;
  final String isi;
  final String kategori;
  final String emailPengirim;
  final DateTime dibuatPada;

  Catatan({
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.emailPengirim,
    required this.dibuatPada,
  });
}

// ─────────────────────────────────────────────────────────────
// HELPER
// ─────────────────────────────────────────────────────────────
String _formatTanggal(DateTime dt) {
  final namaBulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  final hari = dt.day;
  final bulan = namaBulan[dt.month - 1];
  final tahun = dt.year;
  final jam = dt.hour.toString().padLeft(2, '0');
  final menit = dt.minute.toString().padLeft(2, '0');

  return '$hari $bulan $tahun • $jam:$menit';
}

// ─────────────────────────────────────────────────────────────
// COLOR
// ─────────────────────────────────────────────────────────────
const kIndigo = Color(0xFF3F51B5);
const kIndigoDark = Color(0xFF303F9F);
const kIndigoLight = Color(0xFFE8EAF6);
const kWhite = Colors.white;

Color kategoriColor(String kategori) {
  switch (kategori) {
    case 'Kuliah':
      return kIndigo;

    case 'Tugas':
      return Colors.orange;

    case 'Pribadi':
      return Colors.teal;

    default:
      return Colors.grey;
  }
}

// ─────────────────────────────────────────────────────────────
// APP
// ─────────────────────────────────────────────────────────────
class TugasMandiri3App extends StatelessWidget {
  const TugasMandiri3App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tugas Mandiri 3',

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: kIndigo,

        scaffoldBackgroundColor: const Color(0xFFF5F6FF),

        appBarTheme: const AppBarTheme(
          backgroundColor: kIndigo,
          foregroundColor: kWhite,
          elevation: 0,
          centerTitle: false,
        ),

        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: kIndigo,
            foregroundColor: kWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kIndigo,
          foregroundColor: kWhite,
        ),
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const TugasMandiri3Home(),
      },

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/tambah':
            return MaterialPageRoute(
              builder: (_) => const TambahCatatanPage(),
            );

          case '/detail':
            final catatan = settings.arguments as Catatan;

            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(
                catatan: catatan,
              ),
            );
        }

        return null;
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// HOME
// ─────────────────────────────────────────────────────────────
class TugasMandiri3Home extends StatefulWidget {
  const TugasMandiri3Home({super.key});

  @override
  State<TugasMandiri3Home> createState() =>
      _TugasMandiri3HomeState();
}

class _TugasMandiri3HomeState
    extends State<TugasMandiri3Home> {
  final List<Catatan> _catatan = [
    Catatan(
      judul: 'Belajar Flutter',
      isi:
      'Mempelajari Stateful Widget, Form, dan Navigation.',
      kategori: 'Kuliah',
      emailPengirim: 'mahasiswa@unpas.ac.id',
      dibuatPada: DateTime.now(),
    ),
  ];

  Future<void> _bukaTambahCatatan() async {
    final hasil =
    await Navigator.pushNamed(context, '/tambah');

    if (hasil is Catatan) {
      setState(() => _catatan.add(hasil));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: kIndigo,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Catatan "${hasil.judul}" ditambahkan',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text('Tugas 3 • Validasi Email'),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.of(context, rootNavigator: true)
                  .pop(),
        ),
      ),

      body: _catatan.isEmpty
          ? const _EmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _catatan.length,

        itemBuilder: (context, i) {
          final c = _catatan[i];

          return Card(
            elevation: 2,
            margin:
            const EdgeInsets.only(bottom: 14),

            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(18),
            ),

            child: InkWell(
              borderRadius:
              BorderRadius.circular(18),

              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: c,
                );
              },

              child: Padding(
                padding:
                const EdgeInsets.all(16),

                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Container(
                      width: 5,
                      height: 70,

                      decoration: BoxDecoration(
                        color:
                        kategoriColor(c.kategori),

                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [
                          Text(
                            c.judul,

                            style:
                            const TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Row(
                            children: [
                              Container(
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal:
                                  10,
                                  vertical: 4,
                                ),

                                decoration:
                                BoxDecoration(
                                  color:
                                  kategoriColor(
                                    c.kategori,
                                  ).withOpacity(
                                    0.12,
                                  ),

                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    8,
                                  ),
                                ),

                                child: Text(
                                  c.kategori,

                                  style:
                                  TextStyle(
                                    color:
                                    kategoriColor(
                                      c.kategori,
                                    ),

                                    fontSize:
                                    11,

                                    fontWeight:
                                    FontWeight
                                        .w600,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                  width: 8),

                              Expanded(
                                child: Text(
                                  _formatTanggal(
                                    c.dibuatPada,
                                  ),

                                  overflow:
                                  TextOverflow
                                      .ellipsis,

                                  style:
                                  const TextStyle(
                                    fontSize:
                                    11,

                                    color: Colors
                                        .grey,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Row(
                            children: [
                              const Icon(
                                Icons.email,
                                size: 16,
                                color:
                                kIndigo,
                              ),

                              const SizedBox(
                                  width: 6),

                              Expanded(
                                child: Text(
                                  c.emailPengirim,

                                  style:
                                  const TextStyle(
                                    fontSize:
                                    13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      icon: const Icon(
                        Icons
                            .delete_outline_rounded,
                        color:
                        Colors.redAccent,
                      ),

                      onPressed: () {
                        setState(() {
                          _catatan.removeAt(i);
                        });

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          SnackBar(
                            backgroundColor:
                            kIndigo,

                            behavior:
                            SnackBarBehavior
                                .floating,

                            content: Text(
                              'Catatan "${c.judul}" dihapus',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: _bukaTambahCatatan,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// EMPTY STATE
// ─────────────────────────────────────────────────────────────
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

            decoration: const BoxDecoration(
              color: kIndigoLight,
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.note_alt_outlined,
              size: 70,
              color: kIndigo,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Belum ada catatan',

            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Tekan tombol tambah untuk membuat catatan baru.',

            textAlign: TextAlign.center,

            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TAMBAH CATATAN
// ─────────────────────────────────────────────────────────────
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
  final _emailCtrl = TextEditingController();

  String _kategori = 'Kuliah';

  final _kategoriOpsi = const [
    'Kuliah',
    'Tugas',
    'Pribadi',
    'Lainnya'
  ];

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final catatanBaru = Catatan(
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      emailPengirim: _emailCtrl.text.trim(),
      dibuatPada: DateTime.now(),
    );

    Navigator.pop(context, catatanBaru);
  }

  InputDecoration inputStyle({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,

      prefixIcon: Icon(
        icon,
        color: kIndigo,
      ),

      filled: true,
      fillColor: kIndigoLight.withOpacity(0.35),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: const BorderSide(
          color: kIndigo,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text('Tambah Catatan')),

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

                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                children: [
                  TextFormField(
                    controller: _judulCtrl,

                    decoration: inputStyle(
                      label: 'Judul',
                      icon: Icons.title,
                    ),

                    validator: (v) {
                      if (v == null ||
                          v.trim().isEmpty) {
                        return 'Judul wajib diisi';
                      }

                      if (v.trim().length < 3) {
                        return 'Minimal 3 karakter';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _kategori,

                    decoration: inputStyle(
                      label: 'Kategori',
                      icon: Icons.category,
                    ),

                    items: _kategoriOpsi
                        .map(
                          (k) => DropdownMenuItem(
                        value: k,
                        child: Text(k),
                      ),
                    )
                        .toList(),

                    onChanged: (v) {
                      setState(() {
                        _kategori = v!;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType:
                    TextInputType.emailAddress,

                    decoration: inputStyle(
                      label: 'Email Pengirim',
                      icon: Icons.email,
                      hint:
                      'contoh@email.com',
                    ),

                    validator: (v) {
                      if (v == null ||
                          v.trim().isEmpty) {
                        return 'Email wajib diisi';
                      }

                      final regex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );

                      if (!regex.hasMatch(
                        v.trim(),
                      )) {
                        return 'Format email tidak valid';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _isiCtrl,
                    maxLines: 5,

                    decoration: inputStyle(
                      label: 'Isi Catatan',
                      icon: Icons.notes,
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
              height: 52,

              child: FilledButton.icon(
                onPressed: _simpan,

                icon: const Icon(Icons.save),

                label: const Text(
                  'Simpan Catatan',

                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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

// ─────────────────────────────────────────────────────────────
// DETAIL
// ─────────────────────────────────────────────────────────────
class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;

  const DetailCatatanPage({
    super.key,
    required this.catatan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text('Detail Catatan')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    kIndigo,
                    kIndigoDark,
                  ],

                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                borderRadius:
                BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.15),

                      borderRadius:
                      BorderRadius.circular(8),
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

                  const SizedBox(height: 14),

                  Text(
                    catatan.judul,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.white70,
                      ),

                      const SizedBox(width: 6),

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

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(
                        Icons.email,
                        size: 16,
                        color: Colors.white70,
                      ),

                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          catatan.emailPengirim,

                          style:
                          const TextStyle(
                            color:
                            Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

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
                    Colors.black.withOpacity(0.05),

                    blurRadius: 10,

                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Isi Catatan',

                    style: TextStyle(
                      color: kIndigo,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Divider(height: 24),

                  Text(
                    catatan.isi,

                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,

              child: FilledButton.icon(
                onPressed: () =>
                    Navigator.pop(context),

                icon:
                const Icon(Icons.arrow_back),

                label: const Text(
                  'Kembali',

                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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