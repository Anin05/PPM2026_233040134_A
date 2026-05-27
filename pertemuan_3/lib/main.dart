import 'package:flutter/material.dart';
import 'tugas_mandiri_1.dart' as tm1;
import 'tugas_mandiri_2.dart' as tm2;
import 'tugas_mandiri_3.dart' as tm3;

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
  final jam  = dt.hour.toString().padLeft(2, '0');
  final menit = dt.minute.toString().padLeft(2, '0');
  return '${dt.day} ${namaBulan[dt.month - 1]} ${dt.year} • $jam:$menit';
}

// ─── Theme Constants ──────────────────────────────────────────────────────────
const kIndigo     = Color(0xFF3F51B5);
const kIndigoDark = Color(0xFF303F9F);
const kIndigoLight = Color(0xFFE8EAF6);
const kWhite      = Colors.white;

// ─── Entry Point ──────────────────────────────────────────────────────────────
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum Pertemuan 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: kIndigo,
        useMaterial3: true,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: kIndigo,
          foregroundColor: kWhite,
          centerTitle: false,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: kWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
          iconTheme: IconThemeData(color: kWhite),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LauncherScreen(),
        '/base_app': (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/tambah':
            return MaterialPageRoute(builder: (_) => const TambahCatatanPage());
          case '/detail':
            final catatan = settings.arguments as Catatan;
            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(catatan: catatan),
            );
        }
        return null;
      },
    );
  }
}

// ─── Launcher Screen ──────────────────────────────────────────────────────────
class LauncherScreen extends StatelessWidget {
  const LauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FF),
      body: CustomScrollView(
        slivers: [
          // Hero AppBar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: kIndigo,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [kIndigoDark, kIndigo, Color(0xFF5C6BC0)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: kWhite.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Pemrograman Mobile 2026',
                            style: TextStyle(color: kWhite, fontSize: 12, letterSpacing: 0.8),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Praktikum 3',
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Stateful Widget · Form · Validasi · Navigasi',
                          style: TextStyle(color: Color(0xFFBBC8FF), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Menu Cards
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _SectionLabel(label: 'Aplikasi Utama'),
                const SizedBox(height: 10),
                _MenuCard(
                  title: 'Catatan Mahasiswa',
                  subtitle: 'Tambah, lihat, dan hapus catatan',
                  icon: Icons.sticky_note_2_rounded,
                  accentColor: kIndigo,
                  badgeText: null,
                  onTap: () => Navigator.pushNamed(context, '/base_app'),
                ),
                const SizedBox(height: 20),
                const _SectionLabel(label: 'Tugas Mandiri'),
                const SizedBox(height: 10),
                _MenuCard(
                  title: 'Tugas 1 – Edit Catatan',
                  subtitle: 'Populate form dengan data lama untuk diedit',
                  icon: Icons.drive_file_rename_outline_rounded,
                  accentColor: const Color(0xFFF57F17),
                  badgeText: 'T1',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const tm1.TugasMandiri1App()),
                  ),
                ),
                const SizedBox(height: 12),
                _MenuCard(
                  title: 'Tugas 2 – Filter Kategori',
                  subtitle: 'Dropdown filter di AppBar berdasarkan kategori',
                  icon: Icons.filter_list_rounded,
                  accentColor: const Color(0xFF00897B),
                  badgeText: 'T2',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const tm2.TugasMandiri2App()),
                  ),
                ),
                const SizedBox(height: 12),
                _MenuCard(
                  title: 'Tugas 3 – Validasi Email',
                  subtitle: 'Field email dengan validasi Regex di form',
                  icon: Icons.mark_email_read_rounded,
                  accentColor: const Color(0xFF7B1FA2),
                  badgeText: 'T3',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const tm3.TugasMandiri3App()),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        color: Color(0xFF9E9E9E),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final String? badgeText;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.badgeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kWhite,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border(left: BorderSide(color: accentColor, width: 4)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accentColor, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 3),
                    Text(subtitle,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 12.5)),
                  ],
                ),
              ),
              if (badgeText != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeText!,
                    style: const TextStyle(
                        color: kWhite,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ] else
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Home Page (Base App) ─────────────────────────────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Catatan> _catatan = [
    Catatan(
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation.',
      kategori: 'Kuliah',
      dibuatPada: DateTime.now(),
    ),
  ];

  Future<void> _bukaTambahCatatan() async {
    final hasil = await Navigator.pushNamed(context, '/tambah');
    if (hasil is Catatan) {
      setState(() => _catatan.add(hasil));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Catatan "${hasil.judul}" berhasil ditambahkan'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: kIndigo,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FF),
      appBar: AppBar(
        title: const Text('Catatan Mahasiswa'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_catatan.length} catatan',
                  style: const TextStyle(color: kWhite, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _catatan.isEmpty
          ? const _EmptyState()
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _catatan.length,
        itemBuilder: (context, i) {
          final c = _catatan[i];
          return _CatatanCard(
            catatan: c,
            onDelete: () {
              setState(() => _catatan.removeAt(i));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${c.judul}" dihapus'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            onTap: () =>
                Navigator.pushNamed(context, '/detail', arguments: c),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaTambahCatatan,
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

  const _CatatanCard({
    required this.catatan,
    required this.onDelete,
    required this.onTap,
  });

  Color _kategoriColor(String k) {
    switch (k) {
      case 'Kuliah': return kIndigo;
      case 'Tugas':  return const Color(0xFFF57F17);
      case 'Pribadi': return const Color(0xFF00897B);
      default:       return Colors.grey;
    }
  }

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
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
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
                    Row(
                      children: [
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
                      ],
                    ),
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
              color: kIndigoLight,
              shape: BoxShape.circle,
            ),
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

// ─── Tambah Catatan ───────────────────────────────────────────────────────────
class TambahCatatanPage extends StatefulWidget {
  const TambahCatatanPage({super.key});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey    = GlobalKey<FormState>();
  final _judulCtrl  = TextEditingController();
  final _isiCtrl    = TextEditingController();
  String _kategori  = 'Kuliah';
  final _opsiKategori = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

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
        dibuatPada: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FF),
      appBar: AppBar(title: const Text('Tambah Catatan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildFormCard(children: [
              _styledField(
                controller: _judulCtrl,
                label: 'Judul Catatan',
                icon: Icons.title_rounded,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                  if (v.trim().length < 3) return 'Minimal 3 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: const Icon(Icons.label_rounded, color: kIndigo),
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
                controller: _isiCtrl,
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
                icon: const Icon(Icons.save_rounded, color: kWhite),
                label: const Text('Simpan Catatan',
                    style: TextStyle(
                        color: kWhite,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard({required List<Widget> children}) {
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
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
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
class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;
  const DetailCatatanPage({super.key, required this.catatan});

  Color _kategoriColor(String k) {
    switch (k) {
      case 'Kuliah': return kIndigo;
      case 'Tugas':  return const Color(0xFFF57F17);
      case 'Pribadi': return const Color(0xFF00897B);
      default:       return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _kategoriColor(catatan.kategori);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FF),
      appBar: AppBar(title: const Text('Detail Catatan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.25),
                      border: Border.all(color: kWhite.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(catatan.kategori,
                        style: const TextStyle(
                            color: kWhite,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 10),
                  Text(catatan.judul,
                      style: const TextStyle(
                          color: kWhite,
                          fontSize: 22,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          color: Color(0xFFBBC8FF), size: 14),
                      const SizedBox(width: 4),
                      Text(_formatTanggal(catatan.dibuatPada),
                          style: const TextStyle(
                              color: Color(0xFFBBC8FF), fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Isi card
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
                  Text(catatan.isi,
                      style: const TextStyle(
                          fontSize: 15, height: 1.7, color: Color(0xFF424242))),
                ],
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: kIndigo, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.arrow_back_rounded, color: kIndigo),
                label: const Text('Kembali ke Daftar',
                    style: TextStyle(
                        color: kIndigo, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}