<?php
/**
 * Konfigurasi Lokal Indonesia untuk Aplikasi Koperasi Berjalan
 * 
 * File ini memastikan semua tampilan dan format menggunakan bahasa Indonesia
 * serta zona waktu Indonesia
 */

// Zona Waktu Indonesia
date_default_timezone_set('Asia/Jakarta');

// Konfigurasi Lokal (Locale)
setlocale(LC_ALL, 'id_ID.UTF8', 'id_ID.UTF-8', 'id_ID');

// Konstanta untuk Format Indonesia
define('INDONESIA_DATE_FORMAT', 'd F Y');
define('INDONESIA_DATETIME_FORMAT', 'd F Y H:i:s');
define('INDONESIA_TIME_FORMAT', 'H:i:s');

// Konstanta Mata Uang
define('CURRENCY_CODE', 'IDR');
define('CURRENCY_SYMBOL', 'Rp');
define('CURRENCY_DECIMALS', 0);

// Konstanta Lokasi
define('COUNTRY_CODE', 'ID');
define('COUNTRY_NAME', 'Indonesia');
define('DEFAULT_LANGUAGE', 'id');

// Konstanta Telepon Indonesia
define('PHONE_COUNTRY_CODE', '+62');
define('PHONE_MAX_LENGTH', 13);
define('PHONE_MIN_LENGTH', 10);

// Konstanta NIK Indonesia
define('NIK_LENGTH', 16);

// Konfigurasi Database untuk Indonesia
class IndonesiaConfig {
    /**
     * Format mata uang Indonesia
     */
    public static function formatCurrency($amount) {
        return 'Rp ' . number_format($amount, 0, ',', '.');
    }
    
    /**
     * Format tanggal Indonesia
     */
    public static function formatDate($date) {
        if (is_string($date)) {
            $date = new DateTime($date);
        }
        $months = [
            1 => 'Januari', 2 => 'Februari', 3 => 'Maret', 4 => 'April',
            5 => 'Mei', 6 => 'Juni', 7 => 'Juli', 8 => 'Agustus',
            9 => 'September', 10 => 'Oktober', 11 => 'November', 12 => 'Desember'
        ];
        
        return $date->format('d') . ' ' . $months[(int)$date->format('m')] . ' ' . $date->format('Y');
    }
    
    /**
     * Format tanggal waktu Indonesia
     */
    public static function formatDateTime($datetime) {
        if (is_string($datetime)) {
            $datetime = new DateTime($datetime);
        }
        return self::formatDate($datetime) . ' ' . $datetime->format('H:i:s');
    }
    
    /**
     * Format nomor telepon Indonesia
     */
    public static function formatPhoneNumber($phone) {
        // Hapus karakter non-digit
        $phone = preg_replace('/[^0-9]/', '', $phone);
        
        // Konversi 0 ke +62
        if (substr($phone, 0, 1) === '0') {
            $phone = PHONE_COUNTRY_CODE . substr($phone, 1);
        }
        
        // Validasi panjang
        if (strlen($phone) < PHONE_MIN_LENGTH || strlen($phone) > PHONE_MAX_LENGTH) {
            return false;
        }
        
        return $phone;
    }
    
    /**
     * Validasi NIK Indonesia
     */
    public static function validateNIK($nik) {
        // Hapus karakter non-digit
        $nik = preg_replace('/[^0-9]/', '', $nik);
        
        // Validasi panjang
        if (strlen($nik) !== NIK_LENGTH) {
            return false;
        }
        
        return $nik;
    }
    
    /**
     * Format angka dengan pemisah Indonesia
     */
    public static function formatNumber($number, $decimals = 0) {
        return number_format($number, $decimals, ',', '.');
    }
    
    /**
     * Konversi angka ke terbilang Indonesia
     */
    public static function toWords($number) {
        $number = abs($number);
        $words = "";
        
        $units = [
            "", "satu", "dua", "tiga", "empat", "lima", "enam", "tujuh", "delapan", "sembilan", "sepuluh", "sebelas"
        ];
        
        if ($number < 12) {
            $words = $units[$number];
        } elseif ($number < 20) {
            $words = $units[$number - 10] . " belas";
        } elseif ($number < 100) {
            $words = self::toWords($number / 10) . " puluh" . ($number % 10 != 0 ? " " . self::toWords($number % 10) : "");
        } elseif ($number < 200) {
            $words = "seratus" . ($number != 100 ? " " . self::toWords($number - 100) : "");
        } elseif ($number < 1000) {
            $words = self::toWords($number / 100) . " ratus" . ($number % 100 != 0 ? " " . self::toWords($number % 100) : "");
        } elseif ($number < 2000) {
            $words = "seribu" . ($number != 1000 ? " " . self::toWords($number - 1000) : "");
        } elseif ($number < 1000000) {
            $words = self::toWords($number / 1000) . " ribu" . ($number % 1000 != 0 ? " " . self::toWords($number % 1000) : "");
        } elseif ($number < 1000000000) {
            $words = self::toWords($number / 1000000) . " juta" . ($number % 1000000 != 0 ? " " . self::toWords($number % 1000000) : "");
        } elseif ($number < 1000000000000) {
            $words = self::toWords($number / 1000000000) . " miliar" . ($number % 1000000000 != 0 ? " " . self::toWords($number % 1000000000) : "");
        } else {
            $words = "angka terlalu besar";
        }
        
        return $words;
    }
    
    /**
     * Format terbilang mata uang
     */
    public static function toWordsCurrency($amount) {
        $words = self::toWords($amount);
        return ucwords($words) . " Rupiah";
    }
    
    /**
     * Generate meta tags untuk HTML Indonesia
     */
    public static function generateMetaTags() {
        return [
            '<meta charset="UTF-8">',
            '<meta http-equiv="Content-Language" content="id">',
            '<meta name="language" content="Indonesian">',
            '<meta name="geo.country" content="ID">',
            '<meta name="geo.region" content="ID">',
            '<meta name="geo.placename" content="Indonesia">',
            '<meta name="ICBM" content="-6.2088,106.8456">', // Koordinat Indonesia
            '<meta property="og:locale" content="id_ID">',
            '<html lang="id">'
        ];
    }
    
    /**
     * Konfigurasi JavaScript untuk Indonesia
     */
    public static function getJSConfig() {
        return [
            'locale' => 'id-ID',
            'currency' => 'IDR',
            'timezone' => 'Asia/Jakarta',
            'dateFormat' => 'DD/MM/YYYY',
            'timeFormat' => 'HH:mm:ss',
            'currencyFormat' => 'Rp #.###',
            'decimalSeparator' => ',',
            'thousandSeparator' => '.'
        ];
    }
}

// Auto-load konfigurasi
if (!function_exists('formatRupiah')) {
    function formatRupiah($amount) {
        return IndonesiaConfig::formatCurrency($amount);
    }
}

if (!function_exists('formatTanggal')) {
    function formatTanggal($date) {
        return IndonesiaConfig::formatDate($date);
    }
}

if (!function_exists('formatNomorTelepon')) {
    function formatNomorTelepon($phone) {
        return IndonesiaConfig::formatPhoneNumber($phone);
    }
}

if (!function_exists('formatWaktu')) {
    function formatWaktu($datetime) {
        return IndonesiaConfig::formatDateTime($datetime);
    }
}

if (!function_exists('terbilang')) {
    function terbilang($number) {
        return IndonesiaConfig::toWords($number);
    }
}

if (!function_exists('terbilangRupiah')) {
    function terbilangRupiah($amount) {
        return IndonesiaConfig::toWordsCurrency($amount);
    }
}

?>
