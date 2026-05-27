import 'package:flutter/material.dart';

// ─── Model ───────────────────────────────────────────────────────────────────
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

// ─── Helper ───────────────────────────────────────────────────────────────────
String _formatTanggal(DateTime dt) {
  const namaBulan = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];
  final jam   = dt.hour.toString().padLeft(2, '0');
  final menit = dt.minute.toString().padLeft(2, '0');
  return '${dt.day} ${namaBulan[dt.month - 1]} ${dt.year} • $jam:$menit';
}

// ─── Theme Constants ──────────────────────────────────────────────────────────
const kIndigo      = Color(0xFF3F51B5);
const kIndigoDark  = Color(0xFF303F9F);
const kIndigoLight = Color(0xFFE8EAF6);
const kWhite       = Colors.white;

Color _kategoriColor(String k) {
  switch (k) {
    case 'Kuliah':  return kIndigo;
    case 'Tugas':   return const Color(0xFFF57F17);
    case 'Pribadi': return const Color(0xFF00897B);
    default:        return Colors.grey;
  }
}

// ─── App ──────────────────────────────────────────────────────────────────────
class TugasMandiri1App extends StatelessWidget {
  const TugasMandiri1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Mandiri 1 – Edit Catatan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: kIndigo,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: kIndigo,
          foregroundColor: kWhite,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: kWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: kWhite),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TugasMandiri1Home(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/tambah':
            return MaterialPageRoute(builder: (_) => const FormCatatanPage());
          case '/detail':
            final args   = settings.arguments as Map<String, dynamic>;
            final catatan = args['catatan'] as Catatan;
            final index  = args['index'] as int;
            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(catatan: catatan, index: index),
            );
        }
        return null;
      },
    );
  }
}

// ─── Home ─────────────────────────────────────────────────────────────────────
class TugasMandiri1Home extends StatefulWidget {
  const TugasMandiri1Home({super.key});

  @override
  State<TugasMandiri1Home> createState() => _TugasMandiri1HomeState();
}

class _TugasMandiri1HomeState extends State<TugasMandiri1Home> {
  final List<Catatan> _catatan = [
    Catatan(
      judul: 'Belajar Flutter – Tugas 1',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation dengan fitur Edit.',
      kategori: 'Kuliah',
      dibuatPada: DateTime.now(),
    ),
  ];

  Future<void> _bukaTambah() async {
    final hasil = await Navigator.pushNamed(context, '/tambah');
    if (hasil is Catatan) {
      setState(() => _catatan.add(hasil));
      if (!mounted) return;
      _showSnack('Catatan "${hasil.judul}" ditambahkan');
    }
  }

  Future<void> _bukaDetail(Catatan c, int i) async {
    final hasil = await Navigator.pushNamed(
      context, '/detail',
      arguments: {'catatan': c, 'index': i},
    );
    if (hasil is Map<String, dynamic>) {
      final action = hasil['action'];
      if (action == 'update') {
        final updated = hasil['catatan'] as Catatan;
        setState(() => _catatan[i] = updated);
        if (!mounted) return;
        _showSnack('Catatan "${updated.judul}" berhasil diubah');
      } else if (action == 'delete') {
        setState(() => _catatan.removeAt(i));
        if (!mounted) return;
        _showSnack('Catatan berhasil dihapus');
      }
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      backgroundColor: kIndigo,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FF),
      appBar: AppBar(
        title: const Text('Tugas 1 – Edit Catatan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('${_catatan.length} catatan',
                    style:
                    const TextStyle(color: kWhite, fontSize: 12)),
              ),
            ),
          ),
        ],
      ),
      body: _catatan.isEmpty
          ? const _EmptyState()
          : ListView.builder(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _catatan.length,
        itemBuilder: (context, i) {
          final c = _catatan[i];
          return _CatatanCard(
            catatan: c,
            onDelete: () {
              setState(() => _catatan.removeAt(i));
              _showSnack('"${c.judul}" dihapus');
            },
            onTap: () => _bukaDetail(c, i),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaTambah,
        backgroundColor: kIndigo,
        foregroundColor: kWhite,
        icon: const Icon(Icons.add),
        label: const Text('Catatan Baru'),
      ),
    );
  }
}

// ─── Reusable Card ────────────────────────────────────────────────────────────
class _CatatanCard extends StatelessWidget {
  final Catatan catatan;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  const _CatatanCard(
      {required this.catatan, required this.onDelete, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = _kategoriColor(catatan.kategori);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
          child: Row(
            children: [
              Container(
                width: 4, height: 48,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(4)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(catatan.judul,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 4),
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(catatan.kategori,
                            style: TextStyle(
                                color: color,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 8),
                      Text(_formatTanggal(catatan.dibuatPada),
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 11)),
                    ]),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Colors.redAccent),
                onPressed: onDelete,
                tooltip: 'Hapus',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: kIndigoLight, shape: BoxShape.circle),
            child: const Icon(Icons.note_alt_outlined,
                size: 56, color: kIndigo),
          ),
          const SizedBox(height: 20),
          const Text('Belum ada catatan',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF424242))),
          const SizedBox(height: 6),
          const Text('Tekan tombol di bawah untuk membuat catatan baru.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ─── Form Catatan (Tambah & Edit) ─────────────────────────────────────────────
class FormCatatanPage extends StatefulWidget {
  final Catatan? catatan;
  const FormCatatanPage({super.key, this.catatan});

  @override
  State<FormCatatanPage> createState() => _FormCatatanPageState();
}

class _FormCatatanPageState extends State<FormCatatanPage> {
  final _formKey   = GlobalKey<FormState>();
  late final TextEditingController _judulCtrl;
  late final TextEditingController _isiCtrl;
  late String _kategori;
  final _opsiKategori = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    _judulCtrl = TextEditingController(text: widget.catatan?.judul ?? '');
    _isiCtrl   = TextEditingController(text: widget.catatan?.isi ?? '');
    _kategori  = widget.catatan?.kategori ?? 'Kuliah';
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Catatan(
        judul: _judulCtrl.text.trim(),
        isi: _isiCtrl.text.trim(),
        kategori: _kategori,
        dibuatPada: widget.catatan?.dibuatPada ?? DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.catatan != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FF),
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Catatan' : 'Tambah Catatan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _formCard(children: [
              _styledField(
                ctrl: _judulCtrl,
                label: 'Judul Catatan',
                icon: Icons.title_rounded,
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'Judul wajib diisi';
                  if (v.trim().length < 3) return 'Minimal 3 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon:
                  const Icon(Icons.label_rounded, color: kIndigo),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: kIndigoLight.withOpacity(0.5),
                ),
                items: _opsiKategori
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                onChanged: (v) => setState(() => _kategori = v!),
              ),
              const SizedBox(height: 16),
              _styledField(
                ctrl: _isiCtrl,
                label: 'Isi Catatan',
                icon: Icons.notes_rounded,
                maxLines: 5,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Isi catatan wajib diisi'
                    : null,
              ),
            ]),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: _simpan,
                style: FilledButton.styleFrom(
                  backgroundColor: kIndigo,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                icon: Icon(isEdit ? Icons.save_rounded : Icons.add_rounded,
                    color: kWhite),
                label: Text(
                  isEdit ? 'Simpan Perubahan' : 'Simpan Catatan',
                  style: const TextStyle(
                      color: kWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _styledField({
    required TextEditingController ctrl,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kIndigo),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: kIndigoLight.withOpacity(0.5),
      ),
    );
  }
}

// ─── Detail Catatan ───────────────────────────────────────────────────────────
class DetailCatatanPage extends StatefulWidget {
  final Catatan catatan;
  final int index;
  const DetailCatatanPage(
      {super.key, required this.catatan, required this.index});

  @override
  State<DetailCatatanPage> createState() => _DetailCatatanPageState();
}

class _DetailCatatanPageState extends State<DetailCatatanPage> {
  late Catatan _current;
  bool _isUpdated = false;

  @override
  void initState() {
    super.initState();
    _current = widget.catatan;
  }

  Future<void> _bukaEdit() async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => FormCatatanPage(catatan: _current)),
    );
    if (hasil is Catatan) {
      setState(() {
        _current   = hasil;
        _isUpdated = true;
      });
    }
  }

  void _popWithResult(String action) {
    if (action == 'delete') {
      Navigator.pop(context, {'action': 'delete'});
    } else {
      Navigator.pop(
          context, {'action': 'update', 'catatan': _current});
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _kategoriColor(_current.kategori);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FF),
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: _bukaEdit,
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => _popWithResult('delete'),
            tooltip: 'Hapus',
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (_isUpdated) {
            _popWithResult('update');
            return false;
          }
          return true;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kIndigo, Color(0xFF5C6BC0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.25),
                        border:
                        Border.all(color: kWhite.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_current.kategori,
                          style: const TextStyle(
                              color: kWhite,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 10),
                    Text(_current.judul,
                        style: const TextStyle(
                            color: kWhite,
                            fontSize: 22,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Row(children: [
                      const Icon(Icons.access_time_rounded,
                          color: Color(0xFFBBC8FF), size: 14),
                      const SizedBox(width: 4),
                      Text(_formatTanggal(_current.dibuatPada),
                          style: const TextStyle(
                              color: Color(0xFFBBC8FF), fontSize: 12)),
                    ]),
                    if (_isUpdated) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('✏️ Telah diedit',
                            style: TextStyle(
                                color: Colors.amber, fontSize: 11)),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Isi
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Isi Catatan',
                        style: TextStyle(
                            color: kIndigo,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            letterSpacing: 0.5)),
                    const Divider(height: 16),
                    Text(_current.isi,
                        style: const TextStyle(
                            fontSize: 15,
                            height: 1.7,
                            color: Color(0xFF424242))),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (_isUpdated) {
                        _popWithResult('update');
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: kIndigo, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: kIndigo),
                    label: const Text('Kembali',
                        style: TextStyle(
                            color: kIndigo,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _bukaEdit,
                    style: FilledButton.styleFrom(
                      backgroundColor: kIndigo,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.edit_rounded, color: kWhite),
                    label: const Text('Edit',
                        style: TextStyle(
                            color: kWhite,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}