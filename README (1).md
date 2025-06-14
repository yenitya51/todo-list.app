
# TODO LIST APP

**To-Do List App** adalah aplikasi manajemen tugas berbasis **Flutter** dengan backend **Laravel API**. Pengguna dapat menambahkan, mengedit, menyelesaikan, dan menghapus tugas yang disertai judul, deskripsi, prioritas, dan deadline. Aplikasi ini mendukung login & register, serta dilengkapi tampilan modern dan responsif untuk pengalaman pengguna yang nyaman.


## Fitur Aplikasi
    1. Login dan Register
    2. Menambahkan tugas
    3. Mengedit tugas
    4. Menandai tugas sebagai selesai
    5. Hapus tugas
    6. Logout

## Halaman Aplikasi
    1. Splash screen
    2. Login
    3. Register
    4. My Tasks (daftar tugas)
    5. Add/Edit Task (menambah/mengedit tugas)
## Database
    Jenis   : mySQL
    Nama    : todo_app
    Tabel   : - users
              - todos
## API (Laravel)
| Method | Endpoint          | Deskripsi                       |
| ------ | ----------------- | ------------------------------- |
| POST   | `/api/login`      | Login user                      |
| POST   | `/api/register`   | Registrasi user baru            |
| POST   | `/api/logout`     | Logout user                     |
| GET    | `/api/todos`      | Mengambil semua tugas           |
| POST   | `/api/todos`      | Menambahkan tugas baru          |
| PUT    | `/api/todos/{id}` | Mengupdate tugas berdasarkan ID |
| DELETE | `/api/todos/{id}` | Menghapus tugas berdasarkan ID  |

## Software yang Digunakan
- Flutter SDK (^3.6.1)
- Laravel 12 (Backend API)
- Laragon (MySQL)
- Visual Studio Code
## Cara Instalasi
- Laravel (Backend)
    ```bash
    cd todolist_laravel
    composer install
    cp .env.example .env
    php artisan key:generate
    ```
- Edit file **.env**
    ```bash
    DB_DATABASE=todo_app
    DB_USERNAME=root
    DB_PASSWORD=
    ```
- Import database:
    1. Buka phpMyAdmin
    2. Buat database baru dengan nama **todo_app**
    3. Import file **todo_app.sql** dari folder **database/**
    4. Jalankan migrasi dan server Laravel:
    ```bash
    php artisan migrate
    php artisan serve
- Flutter (Frontend)
```bash
    cd todolist_flutter
    flutter pub get
    flutter run
```

## Cara Menjalankan
1. Jalankan Laravel dengan 
    ```bash
    php artisan serve atau php artisan serve --host=0.0.0.0 --port=8000
2. Jalankan Flutter dengan
    ```bash
    flutter run
3. Aplikasi akan menampilkan halaman Login atau Register
4. Setelah login, akan tampil halaman daftar tugas
5. Pastikan base URL di Flutter sesuai dengan alamat backend
(http://127.0.0.1:8000 atau http://10.0.2.2:8000 untuk emulator Android)
## Demo

Video demo ToDo List [klik disini](https://drive.google.com/file/d/1giZ5T111TUGjH4ttt0gwOp8avnYVe920/view?usp=drive_link)


## Identitas Pembuat
- Nama    : Yeni Tyastuti
- Kelas   : XI RPL 1
- Mapel   : Pemrograman Perangkat Bergerak