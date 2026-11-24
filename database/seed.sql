-- Digital Library System - Sample Seed Data
-- PostgreSQL

-- Insert sample users (passwords are hashed but for demo purposes, we'll use plain text)
-- In production, use proper password hashing (BCrypt, etc.)
INSERT INTO users (username, password, role, full_name, email) VALUES
('admin', 'admin123', 'admin', 'Library Administrator', 'admin@library.com'),
('john_doe', 'student123', 'student', 'John Doe', 'john.doe@student.ac.id'),
('jane_smith', 'student123', 'student', 'Jane Smith', 'jane.smith@student.ac.id'),
('bob_wilson', 'student123', 'student', 'Bob Wilson', 'bob.wilson@student.ac.id'),
('alice_brown', 'student123', 'student', 'Alice Brown', 'alice.brown@student.ac.id');

-- Insert sample books (Indonesian literature and popular books)
INSERT INTO books (title, author, category, stock, status, isbn, publisher, publication_year, description) VALUES
('Laskar Pelangi', 'Andrea Hirata', 'Fiksi', 5, 'available', '978-979-2200-01-5', 'Bentang Pustaka', 2005, 'Novel tentang perjuangan anak-anak Belitung untuk mendapatkan pendidikan.'),
('Bumi Manusia', 'Pramoedya Ananta Toer', 'Fiksi Sejarah', 4, 'available', '978-979-4616-38-9', 'Lentera Dipantara', 2005, 'Novel pertama dari Tetralogi Buru yang menceritakan kehidupan pada masa kolonial Belanda.'),
('Perahu Kertas', 'Dee Lestari', 'Fiksi Romantis', 6, 'available', '978-979-4338-52-8', 'Bentang Pustaka', 2009, 'Kisah cinta dua remaja yang dipertemukan takdir di Jakarta.'),
('Negeri 5 Menara', 'Ahmad Fuadi', 'Inspiratif', 7, 'available', '978-602-8519-66-4', 'Gramedia Pustaka Utama', 2009, 'Kisah inspiratif tentang perjuangan santri meraih mimpi.'),
('Sang Pemimpi', 'Andrea Hirata', 'Fiksi', 3, 'available', '978-979-2200-02-2', 'Bentang Pustaka', 2006, 'Sekuel Laskar Pelangi tentang mimpi dan perjuangan Ikal dan kawan-kawan.'),
('Ayat-Ayat Cinta', 'Habiburrahman El Shirazy', 'Fiksi Religius', 8, 'available', '978-979-4338-01-6', 'Republika', 2004, 'Novel tentang kehidupan mahasiswa Indonesia di Mesir dan dilema cinta.'),
('Ronggeng Dukuh Paruk', 'Ahmad Tohari', 'Fiksi', 4, 'available', '978-979-4616-42-6', 'Gramedia Pustaka Utama', 2003, 'Trilogi tentang kehidupan seorang ronggeng di desa Dukuh Paruk.'),
('Cantik Itu Luka', 'Eka Kurniawan', 'Fiksi', 2, 'available', '978-979-2200-13-8', 'Gramedia Pustaka Utama', 2002, 'Novel epik yang menggabungkan sejarah Indonesia dengan realisme magis.'),
('Seperti Dendam, Rindu Harus Dibayar Tuntas', 'Eka Kurniawan', 'Fiksi', 3, 'available', '978-602-0305-82-4', 'Gramedia Pustaka Utama', 2014, 'Novel tentang dendam dan balas dendam di sebuah kota kecil.'),
('Pulang', 'Leila S. Chudori', 'Fiksi Sejarah', 5, 'available', '978-602-0305-45-9', 'Kepustakaan Populer Gramedia', 2012, 'Kisah eksil politik pasca peristiwa 1965.'),
('Edensor', 'Andrea Hirata', 'Fiksi', 4, 'available', '978-979-2200-03-9', 'Bentang Pustaka', 2007, 'Kelanjutan perjalanan Ikal ke Eropa untuk mengejar mimpinya.'),
('Maryamah Karpov', 'Andrea Hirata', 'Fiksi', 6, 'available', '978-602-8519-82-4', 'Bentang Pustaka', 2008, 'Kisah cinta masa kecil di Belitung yang penuh kenangan.'),
('Supernova: Ksatria, Puteri, dan Bintang Jatuh', 'Dee Lestari', 'Fiksi Filosofis', 5, 'available', '978-979-4338-11-5', 'Truedee Pustaka Sejati', 2001, 'Novel filosofis tentang pencarian jati diri dan cinta.'),
('Di Bawah Lindungan Ka''bah', 'Hamka', 'Fiksi Religius', 7, 'available', '978-979-4616-25-9', 'Gema Insani', 2007, 'Novel klasik tentang perjuangan cinta yang dilandasi iman.'),
('Tenggelamnya Kapal Van Der Wijck', 'Hamka', 'Fiksi Klasik', 4, 'available', '978-979-4616-26-6', 'Bulan Bintang', 2013, 'Novel klasik tentang pertentangan adat dan cinta di Minangkabau.'),
('Gadis Kretek', 'Ratih Kumala', 'Fiksi', 6, 'available', '978-602-0305-67-1', 'Gramedia Pustaka Utama', 2012, 'Kisah tentang cinta, kretek, dan industri rokok Indonesia.'),
('Hujan', 'Tere Liye', 'Fiksi Fantasi', 8, 'available', '978-602-0676-36-4', 'Gramedia Pustaka Utama', 2016, 'Novel fantasi tentang petualangan di dunia paralel.'),
('Bumi', 'Tere Liye', 'Fiksi Fantasi', 5, 'available', '978-602-0676-24-1', 'Gramedia Pustaka Utama', 2014, 'Awal dari serial Bumi tentang remaja dengan kekuatan khusus.'),
('O', 'Eka Kurniawan', 'Fiksi', 0, 'unavailable', '978-602-0305-98-5', 'Gramedia Pustaka Utama', 2016, 'Kumpulan cerpen dari penulis peraih Man Booker Prize.'),
('Lelaki Harimau', 'Eka Kurniawan', 'Fiksi', 3, 'available', '978-602-0305-36-7', 'Gramedia Pustaka Utama', 2004, 'Novel pendek tentang pembunuhan dan dendam yang tertunda.');

-- Insert sample borrow requests
INSERT INTO borrow_requests (user_id, book_id, borrow_date, return_date, status, admin_notes) VALUES
-- Approved requests
(2, 1, '2025-11-01', '2025-11-15', 'approved', 'Approved by admin'),
(3, 5, '2025-11-05', '2025-11-19', 'approved', 'Approved by admin'),
(4, 9, '2025-11-08', '2025-11-22', 'approved', NULL),
-- Pending requests
(2, 3, '2025-11-12', '2025-11-26', 'pending', NULL),
(3, 7, '2025-11-13', '2025-11-27', 'pending', NULL),
(5, 10, '2025-11-14', '2025-11-28', 'pending', NULL),
(4, 12, '2025-11-14', '2025-11-28', 'pending', NULL),
-- Rejected requests
(2, 19, '2025-11-10', '2025-11-24', 'rejected', 'Book currently unavailable - out of stock'),
-- Returned requests
(3, 2, '2025-10-20', '2025-11-03', 'returned', 'Returned on time'),
(5, 6, '2025-10-25', '2025-11-08', 'returned', 'Returned on time');

-- Display summary
SELECT 'Database seeded successfully!' as message;
SELECT 'Users created: ' || COUNT(*) as summary FROM users;
SELECT 'Books created: ' || COUNT(*) as summary FROM books;
SELECT 'Borrow requests created: ' || COUNT(*) as summary FROM borrow_requests;
