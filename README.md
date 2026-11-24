
# **Digital Library Management System**

---

Digital Library Management System merupakan aplikasi perpustakaan berbasis web untuk mengelola koleksi buku, ketersediaan stok, akun pengguna, serta pengajuan dan pemantauan peminjaman buku. Aplikasi menggunakan Java, JSP, Jakarta Servlet, dan PostgreSQL.

## **Fitur Utama**

---

### **1. Student**

---

- Registrasi, login, dan logout.
- Pencarian buku berdasarkan judul atau penulis.
- Melihat informasi buku, stok, dan status ketersediaan.
- Mengajukan, mengubah, dan membatalkan permintaan peminjaman sesuai statusnya.
- Memantau riwayat dan status peminjaman.

### **2. Admin**

---

- Mengelola koleksi buku melalui operasi CRUD.
- Mengelola stok, informasi, dan status ketersediaan buku.
- Menyetujui atau menolak pengajuan peminjaman.
- Memperbarui status pengembalian dan memantau riwayat peminjaman.
- Memfilter permintaan berdasarkan status `pending`, `approved`, `rejected`, dan `returned`.

## **Tech Stack**

---

| Kategori | Teknologi |
| --- | --- |
| Programming Language | Java 11 |
| Presentation Layer | JSP, JSTL, HTML, CSS, JavaScript |
| Backend | Jakarta Servlet 5.0 |
| Database | PostgreSQL |
| Database Connectivity | JDBC |
| Password Hashing | BCrypt |
| JSON Serialization | Gson |
| Build Tool | Apache Maven |
| Application Server | Apache Tomcat 10.x |
| Local Development | Cargo Maven Plugin |

## **System Architecture**

---

Project memisahkan tanggung jawab antarkomponen melalui pendekatan MVC dan Data Access Object (DAO).

- **Model:** merepresentasikan entitas `User`, `Book`, dan `BorrowRequest`.
- **View:** halaman JSP untuk antarmuka student dan admin.
- **Controller:** Servlet untuk menangani request, autentikasi, pengelolaan buku, dan peminjaman.
- **DAO:** mengelola akses serta operasi data pada PostgreSQL melalui JDBC.
- **Utility:** konfigurasi koneksi database, pengolahan tanggal, dan hashing password.

## **Database Design**

---

| Tabel | Keterangan |
| --- | --- |
| `users` | Informasi akun dan role pengguna. |
| `books` | Informasi koleksi buku, stok, dan ketersediaan. |
| `borrow_requests` | Relasi pengguna dan buku, tanggal peminjaman dan pengembalian, status, serta catatan admin. |

Skema database menggunakan primary key, foreign key, check constraint, index, dan trigger untuk memperbarui timestamp `updated_at`.

## **Project Structure**

---

```text
Digital-Library-Management-System/
├── database/
│   ├── schema.sql
│   └── seed.sql
├── src/main/
│   ├── java/com/library/
│   │   ├── dao/
│   │   ├── model/
│   │   ├── servlet/
│   │   └── util/
│   ├── resources/
│   └── webapp/
│       ├── META-INF/
│       ├── WEB-INF/
│       └── *.jsp
├── pom.xml
├── run.bat
├── setup_database.bat
├── setup_server.bat
└── README.md
```

## **How to Run**

---

### **1. Prerequisites**

---

- JDK 11 atau lebih baru
- Apache Maven
- PostgreSQL

### **2. Clone Repository**

---

```bash
git clone https://github.com/rahmaasakinahh/Digital-Library-Management-System.git
cd Digital-Library-Management-System
```

### **3. Setup Database**

---

Buat database PostgreSQL baru bernama `library_db`, kemudian jalankan:

```bash
psql -U postgres -d library_db -f database/schema.sql
```

Jika diperlukan, jalankan `database/seed.sql` untuk memuat data contoh setelah memeriksa isinya.

Pada Windows, tersedia juga `setup_database.bat` untuk membantu inisialisasi database.

> **Warning:** `schema.sql` menghapus tabel yang sudah ada sebelum membuat ulang skema. Gunakan database development baru atau lakukan backup terlebih dahulu.

### **4. Database Configuration**

---

Buat atau sesuaikan `src/main/resources/config.properties` dengan konfigurasi PostgreSQL lokal:

```properties
db.url=jdbc:postgresql://localhost:5432/library_db
db.username=YOUR_DB_USERNAME
db.password=YOUR_DB_PASSWORD
db.driver=org.postgresql.Driver
```

Sesuaikan pula konfigurasi database pada `src/main/webapp/META-INF/context.xml` jika digunakan. Jangan commit kredensial asli ke repository publik.

### **5. Build and Run**

---

```bash
mvn clean package
mvn cargo:run
```

Pada Windows, aplikasi juga dapat dijalankan menggunakan `run.bat` setelah konfigurasi selesai.

Akses aplikasi melalui:

http://localhost:8080/library-system/

---
