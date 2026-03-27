/**
 * User-Friendly Form Validation
 * Provides clear, helpful feedback for form validation
 */

class FormValidator {
    constructor(formId) {
        this.form = document.getElementById(formId);
        this.errors = {};
        this.init();
    }
    
    init() {
        if (!this.form) return;
        
        // Add real-time validation
        this.form.addEventListener('input', (e) => this.validateField(e.target));
        this.form.addEventListener('blur', (e) => this.validateField(e.target), true);
        this.form.addEventListener('submit', (e) => this.handleSubmit(e));
        
        // Create feedback container
        this.createFeedbackContainer();
    }
    
    createFeedbackContainer() {
        const container = document.createElement('div');
        container.className = 'validation-feedback mb-3';
        container.style.display = 'none';
        this.form.parentNode.insertBefore(container, this.form);
        this.feedbackContainer = container;
    }
    
    validateField(field) {
        const fieldName = field.name;
        const value = field.value.trim();
        let error = '';
        
        // Remove previous error styling
        field.classList.remove('is-invalid', 'is-valid');
        this.removeFieldError(field);
        
        // Show loading state for complex validation
        if (fieldName === 'nik' && value.length >= 16) {
            this.showFieldLoading(field);
        }
        
        // Validation rules
        switch (fieldName) {
            case 'name':
                if (!value) {
                    error = 'Nama lengkap harus diisi';
                } else if (value.length < 3) {
                    error = 'Nama minimal 3 karakter';
                } else if (!/^[a-zA-Z\s]+$/.test(value)) {
                    error = 'Nama hanya boleh huruf dan spasi';
                } else {
                    this.showFieldSuccess(field, 'Nama valid');
                }
                break;
                
            case 'nik':
                if (!value) {
                    error = 'NIK harus diisi';
                } else if (value.length < 16) {
                    error = `NIK harus 16 digit (saat ini: ${value.length} digit)`;
                } else if (!/^\d{16}$/.test(value)) {
                    error = 'NIK harus 16 digit angka';
                } else {
                    this.showFieldSuccess(field, 'NIK valid');
                }
                break;
                
            case 'phone':
                if (!value) {
                    error = 'Nomor telepon harus diisi';
                } else if (!/^(\+62|62|0)[0-9]{9,13}$/.test(value.replace(/[-\s]/g, ''))) {
                    error = 'Format nomor telepon tidak valid. Gunakan 08xxxxxxxxxx atau 62xxxxxxxxxx';
                } else {
                    this.showFieldSuccess(field, 'Nomor telepon valid');
                }
                break;
                
            case 'email':
                if (value && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
                    error = 'Format email tidak valid. Contoh: nama@email.com';
                } else if (value) {
                    this.showFieldSuccess(field, 'Email valid');
                }
                break;
                
            case 'address':
                if (!value) {
                    error = 'Alamat harus diisi';
                } else if (value.length < 10) {
                    error = 'Alamat terlalu singkat. Minimal 10 karakter';
                } else if (value.length < 20) {
                    this.showFieldWarning(field, 'Alamat kurang detail. Tambahkan RT/RW jika perlu');
                } else {
                    this.showFieldSuccess(field, 'Alamat lengkap');
                }
                break;
                
            case 'amount':
                if (!value) {
                    error = 'Jumlah pinjaman harus diisi';
                } else {
                    const amount = parseFloat(value.replace(/[^\d.]/g, ''));
                    if (isNaN(amount) || amount <= 0) {
                        error = 'Jumlah pinjaman harus lebih dari 0';
                    } else if (amount < 1000000) {
                        error = 'Minimal pinjaman Rp 1.000.000';
                    } else if (amount > 50000000) {
                        error = 'Maksimal pinjaman Rp 50.000.000';
                    } else {
                        this.showFieldSuccess(field, `Jumlah valid: Rp ${new Intl.NumberFormat('id-ID').format(amount)}`);
                    }
                }
                break;
                
            case 'member_id':
                if (!value) {
                    error = 'Pilih anggota terlebih dahulu';
                } else {
                    this.showFieldSuccess(field, 'Anggota dipilih');
                }
                break;
                
            case 'branch':
                if (!value) {
                    error = 'Pilih cabang terlebih dahulu';
                } else {
                    this.showFieldSuccess(field, 'Cabang dipilih');
                }
                break;
        }
        
        // Show error or success
        if (error) {
            this.showFieldError(field, error);
            field.classList.add('is-invalid');
            this.errors[fieldName] = error;
        } else if (value) {
            field.classList.add('is-valid');
            delete this.errors[fieldName];
        }
        
        return !error;
    }
    
    showFieldError(field, message) {
        this.removeFieldError(field);
        
        const errorDiv = document.createElement('div');
        errorDiv.className = 'invalid-feedback animated fadeIn';
        errorDiv.style.display = 'block';
        errorDiv.style.fontSize = '0.875rem';
        errorDiv.style.color = '#dc3545';
        errorDiv.style.marginTop = '0.25rem';
        errorDiv.style.padding = '8px 12px';
        errorDiv.style.backgroundColor = 'rgba(220,53,69,0.1)';
        errorDiv.style.borderRadius = '6px';
        errorDiv.style.borderLeft = '3px solid #dc3545';
        errorDiv.innerHTML = `
            <div style="display: flex; align-items: center;">
                <i class="fas fa-exclamation-triangle me-2" style="color: #dc3545;"></i>
                <span>${message}</span>
            </div>
        `;
        
        field.parentNode.appendChild(errorDiv);
        
        // Add shake animation to field
        field.style.animation = 'shake 0.5s';
        field.style.borderColor = '#dc3545';
        
        setTimeout(() => {
            field.style.animation = '';
        }, 500);
    }
    
    removeFieldError(field) {
        const existingError = field.parentNode.querySelector('.invalid-feedback, .valid-feedback, .warning-feedback, .loading-feedback');
        if (existingError) {
            existingError.remove();
        }
        field.style.borderColor = '';
        field.classList.remove('is-invalid', 'is-valid');
    }
    
    showFieldSuccess(field, message) {
        this.removeFieldError(field);
        
        const successDiv = document.createElement('div');
        successDiv.className = 'valid-feedback animated fadeIn';
        successDiv.style.display = 'block';
        successDiv.style.fontSize = '0.875rem';
        successDiv.style.color = '#198754';
        successDiv.style.marginTop = '0.25rem';
        successDiv.style.padding = '6px 12px';
        successDiv.style.backgroundColor = 'rgba(25,135,84,0.1)';
        successDiv.style.borderRadius = '6px';
        successDiv.style.borderLeft = '3px solid #198754';
        successDiv.innerHTML = `
            <div style="display: flex; align-items: center;">
                <i class="fas fa-check-circle me-2" style="color: #198754;"></i>
                <span>${message}</span>
            </div>
        `;
        
        field.parentNode.appendChild(successDiv);
        field.style.borderColor = '#198754';
        field.classList.add('is-valid');
    }
    
    showFieldWarning(field, message) {
        this.removeFieldError(field);
        
        const warningDiv = document.createElement('div');
        warningDiv.className = 'warning-feedback animated fadeIn';
        warningDiv.style.display = 'block';
        warningDiv.style.fontSize = '0.875rem';
        warningDiv.style.color = '#fd7e14';
        warningDiv.style.marginTop = '0.25rem';
        warningDiv.style.padding = '6px 12px';
        warningDiv.style.backgroundColor = 'rgba(253,126,20,0.1)';
        warningDiv.style.borderRadius = '6px';
        warningDiv.style.borderLeft = '3px solid #fd7e14';
        warningDiv.innerHTML = `
            <div style="display: flex; align-items: center;">
                <i class="fas fa-exclamation-circle me-2" style="color: #fd7e14;"></i>
                <span>${message}</span>
            </div>
        `;
        
        field.parentNode.appendChild(warningDiv);
        field.style.borderColor = '#fd7e14';
    }
    
    showFieldLoading(field) {
        this.removeFieldError(field);
        
        const loadingDiv = document.createElement('div');
        loadingDiv.className = 'loading-feedback animated fadeIn';
        loadingDiv.style.display = 'block';
        loadingDiv.style.fontSize = '0.875rem';
        loadingDiv.style.color = '#6c757d';
        loadingDiv.style.marginTop = '0.25rem';
        loadingDiv.style.padding = '6px 12px';
        loadingDiv.style.backgroundColor = 'rgba(108,117,125,0.1)';
        loadingDiv.style.borderRadius = '6px';
        loadingDiv.style.borderLeft = '3px solid #6c757d';
        loadingDiv.innerHTML = `
            <div style="display: flex; align-items: center;">
                <i class="fas fa-spinner fa-spin me-2" style="color: #6c757d;"></i>
                <span>Memvalidasi...</span>
            </div>
        `;
        
        field.parentNode.appendChild(loadingDiv);
        field.style.borderColor = '#6c757d';
        
        // Auto-remove loading after 1 second
        setTimeout(() => {
            if (loadingDiv.parentNode) {
                loadingDiv.remove();
            }
        }, 1000);
    }
    
    validateForm() {
        const fields = this.form.querySelectorAll('input, select, textarea');
        let isValid = true;
        this.errors = {};
        
        fields.forEach(field => {
            if (!this.validateField(field)) {
                isValid = false;
            }
        });
        
        return isValid;
    }
    
    handleSubmit(e) {
        e.preventDefault();
        
        if (this.validateForm()) {
            this.showSuccess('Form valid! Mengirim data...');
            // Submit form normally
            this.form.submit();
        } else {
            this.showError('Mohon perbaiki error yang ditandai');
        }
    }
    
    showError(message) {
        this.showFeedback(message, 'danger');
    }
    
    showSuccess(message) {
        this.showFeedback(message, 'success');
    }
    
    showFeedback(message, type) {
        this.feedbackContainer.innerHTML = `
            <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-triangle'}"></i>
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        `;
        this.feedbackContainer.style.display = 'block';
        
        // Auto-hide success messages
        if (type === 'success') {
            setTimeout(() => {
                this.feedbackContainer.style.display = 'none';
            }, 3000);
        }
    }
}

// Auto-initialize forms
document.addEventListener('DOMContentLoaded', function() {
    // Find all forms with validation
    const forms = document.querySelectorAll('form[data-validate], #addMemberForm, #addLoanForm');
    
    forms.forEach(form => {
        const formId = form.id || `form-${Math.random().toString(36).substr(2, 9)}`;
        if (!form.id) {
            form.id = formId;
        }
        new FormValidator(formId);
    });
    
    // Add phone formatting
    const phoneInputs = document.querySelectorAll('input[name="phone"], input[type="tel"]');
    phoneInputs.forEach(input => {
        input.addEventListener('input', function(e) {
            let value = e.target.value.replace(/[^\d]/g, '');
            if (value.startsWith('0')) {
                value = '62' + value.substring(1);
            }
            e.target.value = value;
        });
    });
    
    // Add currency formatting
    const currencyInputs = document.querySelectorAll('input[name="amount"], input.currency');
    currencyInputs.forEach(input => {
        input.addEventListener('blur', function(e) {
            const value = parseFloat(e.target.value.replace(/[^\d.]/g, ''));
            if (!isNaN(value)) {
                e.target.value = new Intl.NumberFormat('id-ID').format(value);
            }
        });
    });
});
