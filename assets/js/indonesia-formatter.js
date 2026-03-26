/**
 * JavaScript Formatter untuk Lokal Indonesia
 * Aplikasi Koperasi Berjalan
 */

class IndonesiaFormatter {
    constructor() {
        this.locale = 'id-ID';
        this.currency = 'IDR';
        this.timezone = 'Asia/Jakarta';
        
        // Konfigurasi format Indonesia
        this.config = {
            locale: 'id-ID',
            currency: 'IDR',
            timezone: 'Asia/Jakarta',
            dateFormat: 'DD/MM/YYYY',
            timeFormat: 'HH:mm:ss',
            currencyFormat: 'Rp #.###',
            decimalSeparator: ',',
            thousandSeparator: '.'
        };
    }
    
    /**
     * Format mata uang Indonesia
     * @param {number} amount - Jumlah uang
     * @returns {string} Format mata uang Indonesia
     */
    formatCurrency(amount) {
        return new Intl.NumberFormat(this.locale, {
            style: 'currency',
            currency: this.currency,
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
        }).format(amount);
    }
    
    /**
     * Format angka dengan pemisah Indonesia
     * @param {number} number - Angka yang akan diformat
     * @param {number} decimals - Jumlah desimal
     * @returns {string} Format angka Indonesia
     */
    formatNumber(number, decimals = 0) {
        return new Intl.NumberFormat(this.locale, {
            minimumFractionDigits: decimals,
            maximumFractionDigits: decimals
        }).format(number);
    }
    
    /**
     * Format tanggal Indonesia
     * @param {Date|string} date - Tanggal yang akan diformat
     * @returns {string} Format tanggal Indonesia
     */
    formatDate(date) {
        const dateObj = new Date(date);
        return new Intl.DateTimeFormat(this.locale, {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        }).format(dateObj);
    }
    
    /**
     * Format tanggal singkat Indonesia
     * @param {Date|string} date - Tanggal yang akan diformat
     * @returns {string} Format tanggal singkat
     */
    formatShortDate(date) {
        const dateObj = new Date(date);
        return new Intl.DateTimeFormat(this.locale, {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric'
        }).format(dateObj);
    }
    
    /**
     * Format tanggal waktu Indonesia
     * @param {Date|string} datetime - Tanggal waktu yang akan diformat
     * @returns {string} Format tanggal waktu Indonesia
     */
    formatDateTime(datetime) {
        const dateObj = new Date(datetime);
        return new Intl.DateTimeFormat(this.locale, {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit',
            hour12: false
        }).format(dateObj);
    }
    
    /**
     * Format waktu Indonesia
     * @param {Date|string} time - Waktu yang akan diformat
     * @returns {string} Format waktu Indonesia
     */
    formatTime(time) {
        const dateObj = new Date(time);
        return new Intl.DateTimeFormat(this.locale, {
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit',
            hour12: false
        }).format(dateObj);
    }
    
    /**
     * Format nomor telepon Indonesia
     * @param {string} phone - Nomor telepon
     * @returns {string} Format nomor telepon Indonesia
     */
    formatPhoneNumber(phone) {
        // Hapus karakter non-digit
        let cleaned = phone.replace(/[^0-9]/g, '');
        
        // Konversi 0 ke +62
        if (cleaned.startsWith('0')) {
            cleaned = '+62' + cleaned.substring(1);
        }
        
        // Format dengan pemisah
        if (cleaned.startsWith('+62')) {
            const areaCode = cleaned.substring(3, 5);
            const number = cleaned.substring(5);
            
            if (number.length <= 7) {
                return `+62 ${areaCode} ${number.substring(0, 3)} ${number.substring(3)}`;
            } else {
                return `+62 ${areaCode} ${number.substring(0, 4)} ${number.substring(4)}`;
            }
        }
        
        return cleaned;
    }
    
    /**
     * Validasi nomor telepon Indonesia
     * @param {string} phone - Nomor telepon
     * @returns {boolean} Valid atau tidak
     */
    validatePhoneNumber(phone) {
        const cleaned = phone.replace(/[^0-9]/g, '');
        
        // Cek panjang (10-13 digit untuk Indonesia)
        if (cleaned.length < 10 || cleaned.length > 13) {
            return false;
        }
        
        // Cek prefix operator Indonesia
        const validPrefixes = ['08', '+62'];
        return validPrefixes.some(prefix => cleaned.startsWith(prefix));
    }
    
    /**
     * Terbilang angka Indonesia (sederhana)
     * @param {number} number - Angka yang akan diubah
     * @returns {string} Terbilang Indonesia
     */
    toWords(number) {
        const units = ['', 'satu', 'dua', 'tiga', 'empat', 'lima', 'enam', 'tujuh', 'delapan', 'sembilan', 'sepuluh', 'sebelas'];
        const largeUnits = ['', 'ribu', 'juta', 'miliar', 'triliun'];
        
        if (number === 0) return 'nol';
        
        let words = '';
        let unitIndex = 0;
        
        while (number > 0) {
            const remainder = number % 1000;
            
            if (remainder > 0) {
                const unitWords = this.convertThreeDigits(remainder);
                const largeUnit = largeUnits[unitIndex];
                
                if (unitIndex === 1 && remainder === 1) {
                    words = 'seribu' + (words ? ' ' + words : '');
                } else if (unitIndex === 0 && remainder === 1 && words) {
                    words = 'seribu ' + words;
                } else {
                    words = unitWords + (largeUnit ? ' ' + largeUnit : '') + (words ? ' ' + words : '');
                }
            }
            
            number = Math.floor(number / 1000);
            unitIndex++;
        }
        
        return words;
    }
    
    /**
     * Konversi 3 digit ke terbilang
     * @param {number} number - Angka 3 digit
     * @returns {string} Terbilang
     */
    convertThreeDigits(number) {
        const units = ['', 'satu', 'dua', 'tiga', 'empat', 'lima', 'enam', 'tujuh', 'delapan', 'sembilan'];
        const teens = ['sepuluh', 'sebelas', 'dua belas', 'tiga belas', 'empat belas', 'lima belas', 'enam belas', 'tujuh belas', 'delapan belas', 'sembilan belas'];
        
        let words = '';
        
        if (number >= 100) {
            const hundreds = Math.floor(number / 100);
            words += (hundreds === 1 ? 'seratus' : units[hundreds] + ' ratus');
            number %= 100;
            
            if (number > 0) words += ' ';
        }
        
        if (number >= 20) {
            const tens = Math.floor(number / 10);
            words += units[tens] + ' puluh';
            number %= 10;
            
            if (number > 0) words += ' ' + units[number];
        } else if (number >= 10) {
            words += teens[number - 10];
        } else if (number > 0) {
            words += units[number];
        }
        
        return words;
    }
    
    /**
     * Terbilang mata uang Indonesia
     * @param {number} amount - Jumlah uang
     * @returns {string} Terbilang mata uang
     */
    toWordsCurrency(amount) {
        const words = this.toWords(amount);
        return words.charAt(0).toUpperCase() + words.slice(1) + ' Rupiah';
    }
    
    /**
     * Parse input dengan format Indonesia
     * @param {string} value - Nilai input
     * @param {string} type - Tipe input ('currency', 'number', 'date')
     * @returns {number|Date} Parsed value
     */
    parse(value, type = 'number') {
        switch (type) {
            case 'currency':
                // Hapus format mata uang
                let cleanValue = value.replace(/[^\d,-]/g, '');
                // Ganti koma dengan titik untuk desimal
                cleanValue = cleanValue.replace(/\./g, '').replace(/,/g, '.');
                return parseFloat(cleanValue) || 0;
                
            case 'number':
                cleanValue = value.replace(/[^\d,-]/g, '');
                cleanValue = cleanValue.replace(/\./g, '').replace(/,/g, '.');
                return parseFloat(cleanValue) || 0;
                
            case 'date':
                // Parse format DD/MM/YYYY
                const parts = value.split('/');
                if (parts.length === 3) {
                    return new Date(parts[2], parts[1] - 1, parts[0]);
                }
                return new Date(value);
                
            default:
                return value;
        }
    }
    
    /**
     * Setup input formatting otomatis
     * @param {HTMLElement} element - Input element
     * @param {string} type - Tipe formatting
     */
    setupInputFormatting(element, type) {
        element.addEventListener('input', (e) => {
            let value = e.target.value;
            
            switch (type) {
                case 'currency':
                    // Hanya allow digit dan koma
                    value = value.replace(/[^\d,]/g, '');
                    // Format currency
                    if (value) {
                        const number = this.parse(value, 'number');
                        e.target.value = this.formatCurrency(number);
                    }
                    break;
                    
                case 'number':
                    value = value.replace(/[^\d,]/g, '');
                    if (value) {
                        const number = this.parse(value, 'number');
                        e.target.value = this.formatNumber(number, 2);
                    }
                    break;
                    
                case 'phone':
                    value = value.replace(/[^\d+]/g, '');
                    if (value.length > 0) {
                        e.target.value = this.formatPhoneNumber(value);
                    }
                    break;
            }
        });
        
        // Format on load
        if (element.value) {
            element.dispatchEvent(new Event('input'));
        }
    }
    
    /**
     * Generate meta tags untuk HTML
     * @returns {string} Meta tags HTML
     */
    generateMetaTags() {
        return `
            <meta charset="UTF-8">
            <meta http-equiv="Content-Language" content="id">
            <meta name="language" content="Indonesian">
            <meta name="geo.country" content="ID">
            <meta name="geo.region" content="ID">
            <meta name="geo.placename" content="Indonesia">
            <meta property="og:locale" content="id_ID">
        `;
    }
}

// Global instance
const indonesiaFormatter = new IndonesiaFormatter();

// Helper functions global
window.formatRupiah = (amount) => indonesiaFormatter.formatCurrency(amount);
window.formatAngka = (number, decimals) => indonesiaFormatter.formatNumber(number, decimals);
window.formatTanggal = (date) => indonesiaFormatter.formatDate(date);
window.formatTanggalSingkat = (date) => indonesiaFormatter.formatShortDate(date);
window.formatWaktu = (time) => indonesiaFormatter.formatTime(time);
window.formatNomorTelepon = (phone) => indonesiaFormatter.formatPhoneNumber(phone);
window.terbilang = (number) => indonesiaFormatter.toWords(number);
window.terbilangRupiah = (amount) => indonesiaFormatter.toWordsCurrency(amount);

// Auto-setup untuk input dengan class khusus
document.addEventListener('DOMContentLoaded', () => {
    // Setup currency inputs
    document.querySelectorAll('input.currency, input[data-type="currency"]').forEach(input => {
        indonesiaFormatter.setupInputFormatting(input, 'currency');
    });
    
    // Setup number inputs
    document.querySelectorAll('input.number, input[data-type="number"]').forEach(input => {
        indonesiaFormatter.setupInputFormatting(input, 'number');
    });
    
    // Setup phone inputs
    document.querySelectorAll('input.phone, input[data-type="phone"]').forEach(input => {
        indonesiaFormatter.setupInputFormatting(input, 'phone');
    });
    
    // Setup date inputs
    document.querySelectorAll('input.date, input[data-type="date"]').forEach(input => {
        input.placeholder = 'DD/MM/YYYY';
    });
});

// Export untuk module
if (typeof module !== 'undefined' && module.exports) {
    module.exports = IndonesiaFormatter;
}
