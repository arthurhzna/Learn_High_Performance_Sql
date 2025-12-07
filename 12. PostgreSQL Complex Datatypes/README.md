# Panduan Lengkap: Cara Menentukan Tipe Data di PostgreSQL

Dokumen ini memberikan aturan praktis dan checklist untuk memilih tipe data yang tepat di PostgreSQL. Gunakan ini sebagai panduan saat merancang skema database.

## Prinsip Umum (Decision Checklist)
1. Apakah nilainya bilangan bulat (integer) atau desimal (floating/fixed)?
2. Perlukan keakuratan numerik absolut (uang/akuntansi)? Gunakan `NUMERIC/DECIMAL`.
3. Perlukah rentang besar atau performance tinggi pada operasi numerik (scientific)? Pertimbangkan `DOUBLE PRECISION` atau `REAL`.
4. Apakah panjang teks perlu dibatasi? Gunakan `VARCHAR(n)`; jika tidak, gunakan `TEXT`.
5. Perlukah penyimpanan titik waktu global (dengan timezone) atau hanya tanggal lokal/time? Gunakan `TIMESTAMPTZ` untuk instants; `DATE`/`TIME`/`TIMETZ` bila sesuai.
6. Apakah nilai bersifat enum terbatas? Pertimbangkan `ENUM` (Postgres) atau tabel referensi.
7. Apakah data semi-terstruktur? Gunakan `JSONB` (lebih cepat untuk query) atau `JSON`.
8. Perlukah identitas auto-increment? Gunakan `SERIAL`/`BIGSERIAL` atau `GENERATED ... AS IDENTITY`.
9. Apakah kolom akan diindeks dan sering dipakai pada WHERE/JOIN? Pilih tipe dan ukuran yang mendukung indexing efisien.
10. Pertimbangkan `NULL` vs `NOT NULL`, default values, dan constraints (`CHECK`, `UNIQUE`, `REFERENCES`).

## Numeric
- Gunakan `SMALLINT`, `INTEGER`, `BIGINT` untuk bilangan bulat. Pilih ukuran menurut rentang nilai supaya hemat storage.
  - `SMALLINT`: -32768 .. 32767
  - `INTEGER`: -2147483648 .. 2147483647
  - `BIGINT`: -9,223... .. +9,223...
- Gunakan `NUMERIC(p,s)` / `DECIMAL(p,s)` untuk fixed-point yang *presisi* (uang, akuntansi):
  - `p` = precision (total digits), `s` = scale (digits after decimal)
  - Contoh: `NUMERIC(12,2)` untuk nilai sampai 9999999999.99
- Gunakan `REAL` / `DOUBLE PRECISION` untuk perhitungan floating (perkiraan) di mana presisi mutlak tidak diperlukan.
- Hindari `MONEY` untuk logika bisnis kritis; `NUMERIC` lebih aman.
- Untuk auto-increment id gunakan `SERIAL`/`BIGSERIAL` atau modern `GENERATED ALWAYS AS IDENTITY`.

## Character / Text
- `CHAR(n)`: fixed-length; PostgreSQL akan padding spasi. Gunakan hanya bila memang perlu fixed-width.
- `VARCHAR(n)`: batasi panjang input (validasi di level DB). Cocok untuk kode, nomor telepon berformat, dsb.
- `TEXT` / `VARCHAR` (tanpa n): tidak ada batas panjang praktis — gunakan untuk konten panjang (artikel, komentar).
- Pilih `VARCHAR(n)` bila ingin enforcement batas panjang secara otomatis.
- Pertimbangkan ` COLLATE ` jika butuh aturan perbandingan/urut khusus.

## Boolean
- Gunakan `BOOLEAN` untuk nilai true/false. Acceptable input: `TRUE`, `FALSE`, `t`, `f`, `1`, `0`, `yes`, `no`.
- Tetapkan `DEFAULT` bila perlu (mis. `DEFAULT FALSE`) dan `NOT NULL` bila kolom wajib memiliki nilai.

## Date / Time / Timestamp / Interval
- `DATE`: simpan tanggal (YYYY-MM-DD). Gunakan untuk tanggal kalender tanpa waktu.
- `TIME [WITHOUT TIME ZONE]`: simpan waktu lokal (jam:menit:detik) tanpa zona.
- `TIME WITH TIME ZONE` (`timetz`): waktu-of-day + offset.
- `TIMESTAMP WITH TIME ZONE` (`timestamptz`): **rekomendasi umum** untuk pencatatan waktu kejadian; menyimpan instant yang konsisten antar zona.
- `TIMESTAMP WITHOUT TIME ZONE`: gunakan jika menyimpan waktu lokal tanpa mengkonversi antar timezone.
- `INTERVAL`: durasi (mis. `INTERVAL '1 day'`, `INTERVAL '2 hours 30 minutes'`).
- Format input: lebih aman gunakan ISO (`YYYY-MM-DD`, `HH24:MI:SS`, `YYYY-MM-DD HH24:MI:SS+TZ`).

## JSON / JSONB / Arrays
- `JSONB`: simpan data semi-terstruktur, diindeks, dan efisien untuk query; lebih sering direkomendasikan dari `JSON`.
- `JSON`: menyimpan raw JSON (text); `JSONB` biasanya lebih baik untuk operasi query/indeks.
- Gunakan `ARRAY` tipe (mis. `TEXT[]`, `INTEGER[]`) bila skema menyimpan list sederhana; pertimbangkan normalisasi (table child) jika list besar atau sering dicari/di-join.

## UUID, BYTEA, ENUM, XML
- `UUID`: gunakan untuk identifier unik global (kolom PK). Hasilkan dengan fungsi `gen_random_uuid()` (extension `pgcrypto`) atau `uuid-ossp`.
- `BYTEA`: simpan data biner (file, gambar kecil). Untuk file besar, pertimbangkan object storage.
- `ENUM`: cocok bila nilai terbatas dan stabil (status order: 'new','paid','shipped'). Hati-hati: menambah nilai enum memerlukan ALTER TYPE.

## Indexing & Storage Pertimbangan
- Lebih kecil ukuran kolom = lebih cepat index dan I/O. Gunakan tipe yang pas, jangan oversize.
- Untuk teks panjang (`TEXT`/`VARCHAR` besar), index penuh bisa mahal; gunakan trigram/GIN/GiST atau materialized columns jika perlu pencarian teks.
- Saat menyimpan angka besar dan sering dihitung, `DOUBLE PRECISION` lebih cepat tetapi tidak aman untuk uang.

## Constraints & Validation
- Gunakan `NOT NULL` bila nilai wajib.
- Gunakan `CHECK` untuk batasan khusus (mis. `CHECK (age >= 0)`).
- Gunakan `UNIQUE` untuk nilai yang harus unik.
- Gunakan `REFERENCES` untuk foreign keys.

## Contoh Keputusan Cepat (Rule-of-Thumb)
- ID auto-increment kecil → `SERIAL` atau `INTEGER` PK
- Uang/akuntansi → `NUMERIC(p,s)`
- Pengukuran ilmiah (perkiraan) → `DOUBLE PRECISION`
- Nama/teks panjang → `TEXT`
- Email/kode pos (terbatas panjang) → `VARCHAR(n)`
- Storing event timestamps → `TIMESTAMPTZ`
- Data semi-terstruktur → `JSONB`

## Performance Tips
- Hindari VARCHAR besar bila kolom diindeks; pilih panjang yang realistis.
- Untuk JOIN pada kolom numerik, gunakan integer-type bila mungkin (lebih cepat dari text compare).
- Pertimbangkan partial indexes dan expression indexes untuk query kompleks.

## Contoh: Schema kecil rekomendasi
```sql
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(320) NOT NULL UNIQUE,
  full_name TEXT,
  balance NUMERIC(12,2) NOT NULL DEFAULT 0.00,
  metadata JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

## Referensi
- PostgreSQL official docs — Data Types: https://www.postgresql.org/docs/current/datatype.html

---

Beri tahu jika ingin saya masukkan contoh-contoh lain (mis. perhitungan NUMERIC vs DOUBLE PRECISION, ukuran storage per tipe, atau checklist printable).
