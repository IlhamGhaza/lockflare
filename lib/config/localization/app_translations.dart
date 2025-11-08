import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          // App Bar
          'app_title': 'Modern Cryptography',
          
          // Navigation
          'nav_home': 'Home',
          'nav_profile': 'Profile',
          
          // Home Page
          'input_text': 'Input Text',
          'enter_text': 'Enter text here...',
          'enter_text_max': 'Enter text (max 8 characters)...',
          'max_characters': 'Max 8 characters',
          'enter_key': 'Enter key here...',
          'enter_key_max': 'Enter key (max 8 characters)...',
          'enter_key_number': 'Enter key as numbers...',
          'max_input_reached': 'Maximum input reached!',
          'select_algorithm': 'Select Algorithm',
          'choose_algorithm': 'Choose an algorithm',
          'process': 'Process',
          'result': 'Result',
          'results_appear': 'Results will appear here...',
          'steps': 'Steps',
          'steps_appear': 'Steps will appear here after processing...',
          
          // Algorithms
          'algo_sub_perm': 'Substitution + Permutation',
          'algo_perm_comp': 'Permutation + Compaction',
          'algo_block_sub': 'Blocking + Substitution',
          'algo_sub_comp': 'Substitution + Compaction',
          'algo_hill_2x2': 'Hill Cipher (2x2)',
          'algo_hill_2x2_dec': '[Decryption] Hill Cipher (2x2)',
          'algo_hill_3x3': 'Hill Cipher (3x3)',
          'algo_hill_3x3_dec': '[Decryption] Hill Cipher (3x3)',
          
          // Validation Messages
          'error_empty_text': 'Please enter text first.',
          'error_select_algo': 'Please select an algorithm first.',
          'error_empty_key': 'Please enter key for this algorithm.',
          'error_hill_key': 'Please enter key (9 digits for 3x3 or 4 digits for 2x2) for Hill Cipher.',
          'error_hill_3x3_key': 'Key for Hill Cipher 3x3 must be 9 digits.',
          'error_hill_2x2_key': 'Key for Hill Cipher 2x2 must be 4 digits.',
          'error_text_too_long': 'Input too long! Maximum 8 characters (64-bit) for this algorithm.',
          'error_key_too_long': 'Key too long! Maximum 8 characters (64-bit) for this algorithm.',
          'key_max_reached': 'Key has reached maximum (@count digits for @size).',
          'algo_not_recognized': 'Algorithm not recognized.',
          
          // Profile Page
          'about_me': 'About Me',
          'job_title': 'Software Developer | Flutter Enthusiast',
          'bio': 'Passionate about creating beautiful and functional mobile applications using Flutter.',
          'github_stats': 'GitHub Stats',
          'loading_stats': 'Loading GitHub stats...',
          'error_loading_stats': 'Error loading stats',
          'retry': 'Retry',
          'stars': 'Stars',
          'repositories': 'Repositories',
          'followers': 'Followers',
          'dark_mode': 'Dark Mode',
          'buy_coffee': 'Buy Me a Coffee',
        },
        'id_ID': {
          // App Bar
          'app_title': 'Kriptografi Modern',
          
          // Navigation
          'nav_home': 'Beranda',
          'nav_profile': 'Profil',
          
          // Home Page
          'input_text': 'Teks Input',
          'enter_text': 'Masukkan teks di sini...',
          'enter_text_max': 'Masukkan teks (maks 8 karakter)...',
          'max_characters': 'Maks 8 karakter',
          'enter_key': 'Masukkan kunci di sini...',
          'enter_key_max': 'Masukkan kunci (maks 8 karakter)...',
          'enter_key_number': 'Masukkan kunci berupa angka...',
          'max_input_reached': 'Sudah mencapai maksimum input!',
          'select_algorithm': 'Pilih Algoritma',
          'choose_algorithm': 'Pilih sebuah algoritma',
          'process': 'Proses',
          'result': 'Hasil',
          'results_appear': 'Hasil akan muncul di sini...',
          'steps': 'Langkah-langkah',
          'steps_appear': 'Langkah-langkah akan muncul di sini setelah diproses...',
          
          // Algorithms
          'algo_sub_perm': 'Substitusi + Permutasi',
          'algo_perm_comp': 'Permutasi + Compaction',
          'algo_block_sub': 'Blocking + Substitusi',
          'algo_sub_comp': 'Substitusi + Compaction',
          'algo_hill_2x2': 'Hill Cipher (2x2)',
          'algo_hill_2x2_dec': '[Dekripsi] Hill Cipher (2x2)',
          'algo_hill_3x3': 'Hill Cipher (3x3)',
          'algo_hill_3x3_dec': '[Dekripsi] Hill Cipher (3x3)',
          
          // Validation Messages
          'error_empty_text': 'Masukkan teks terlebih dahulu.',
          'error_select_algo': 'Pilih algoritma terlebih dahulu.',
          'error_empty_key': 'Masukkan kunci untuk algoritma ini.',
          'error_hill_key': 'Masukkan kunci (9 angka untuk 3x3 atau 4 angka untuk 2x2) untuk Hill Cipher.',
          'error_hill_3x3_key': 'Kunci untuk Hill Cipher 3x3 harus 9 angka.',
          'error_hill_2x2_key': 'Kunci untuk Hill Cipher 2x2 harus 4 angka.',
          'error_text_too_long': 'Input terlalu panjang! Maksimum 8 karakter (64-bit) untuk algoritma ini.',
          'error_key_too_long': 'Kunci terlalu panjang! Maksimum 8 karakter (64-bit) untuk algoritma ini.',
          'key_max_reached': 'Kunci sudah mencapai maksimum (@count angka untuk @size).',
          'algo_not_recognized': 'Algoritma tidak dikenali.',
          
          // Profile Page
          'about_me': 'Tentang Saya',
          'job_title': 'Pengembang Perangkat Lunak | Penggemar Flutter',
          'bio': 'Bersemangat dalam membuat aplikasi mobile yang indah dan fungsional menggunakan Flutter.',
          'github_stats': 'Statistik GitHub',
          'loading_stats': 'Memuat statistik GitHub...',
          'error_loading_stats': 'Gagal memuat statistik',
          'retry': 'Coba Lagi',
          'stars': 'Bintang',
          'repositories': 'Repositori',
          'followers': 'Pengikut',
          'dark_mode': 'Mode Gelap',
          'buy_coffee': 'Belikan Saya Kopi',
        },
      };
}
