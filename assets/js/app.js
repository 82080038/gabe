/**
 * Aplikasi Koperasi Berjalan - Main JavaScript Application
 * Global functions and utilities for the application
 */

// Global application object
window.KoperasiApp = {
    // Application configuration
    config: {
        baseUrl: '/gabe',
        apiVersion: 'v1',
        dateFormat: 'dd/mm/yyyy',
        currency: 'IDR',
        language: 'id'
    },
    
    // Utility functions
    utils: {
        // Format currency
        formatCurrency: function(amount) {
            return new Intl.NumberFormat('id-ID', {
                style: 'currency',
                currency: 'IDR',
                minimumFractionDigits: 0
            }).format(amount);
        },
        
        // Format date
        formatDate: function(date, format = 'dd/mm/yyyy') {
            const d = new Date(date);
            const day = String(d.getDate()).padStart(2, '0');
            const month = String(d.getMonth() + 1).padStart(2, '0');
            const year = d.getFullYear();
            
            return format
                .replace('dd', day)
                .replace('mm', month)
                .replace('yyyy', year);
        },
        
        // Show loading spinner
        showLoading: function(element) {
            if (element) {
                element.innerHTML = '<div class="spinner-border spinner-border-sm" role="status"><span class="visually-hidden">Loading...</span></div>';
            }
        },
        
        // Hide loading spinner
        hideLoading: function(element, originalContent) {
            if (element && originalContent) {
                element.innerHTML = originalContent;
            }
        },
        
        // Debounce function
        debounce: function(func, wait) {
            let timeout;
            return function executedFunction(...args) {
                const later = () => {
                    clearTimeout(timeout);
                    func(...args);
                };
                clearTimeout(timeout);
                timeout = setTimeout(later, wait);
            };
        },
        
        // Generate UUID
        generateUUID: function() {
            return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
                const r = Math.random() * 16 | 0;
                const v = c === 'x' ? r : (r & 0x3 | 0x8);
                return v.toString(16);
            });
        }
    },
    
    // AJAX wrapper
    ajax: {
        // Default AJAX settings
        defaults: {
            type: 'POST',
            dataType: 'json',
            timeout: 30000,
            beforeSend: function(xhr) {
                xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
            }
        },
        
        // Make AJAX request
        request: function(options) {
            const settings = Object.assign({}, this.defaults, options);
            
            return $.ajax(settings)
                .fail(function(xhr, status, error) {
                    console.error('AJAX Error:', error);
                    KoperasiApp.utils.showNotification('Terjadi kesalahan pada server', 'error');
                });
        },
        
        // GET request
        get: function(url, data = {}) {
            return this.request({
                type: 'GET',
                url: url,
                data: data
            });
        },
        
        // POST request
        post: function(url, data = {}) {
            return this.request({
                type: 'POST',
                url: url,
                data: data
            });
        },
        
        // PUT request
        put: function(url, data = {}) {
            return this.request({
                type: 'PUT',
                url: url,
                data: data
            });
        },
        
        // DELETE request
        delete: function(url, data = {}) {
            return this.request({
                type: 'DELETE',
                url: url,
                data: data
            });
        }
    },
    
    // Notification system
    notification: {
        // Show notification
        show: function(message, type = 'info', title = '') {
            if (typeof Swal !== 'undefined') {
                Swal.fire({
                    icon: type,
                    title: title,
                    text: message,
                    timer: 3000,
                    showConfirmButton: false,
                    position: 'top-end',
                    toast: true
                });
            } else {
                // Fallback to basic alert
                alert(`${title}: ${message}`);
            }
        },
        
        // Success notification
        success: function(message, title = 'Berhasil') {
            this.show(message, 'success', title);
        },
        
        // Error notification
        error: function(message, title = 'Error') {
            this.show(message, 'error', title);
        },
        
        // Warning notification
        warning: function(message, title = 'Peringatan') {
            this.show(message, 'warning', title);
        },
        
        // Info notification
        info: function(message, title = 'Informasi') {
            this.show(message, 'info', title);
        }
    },
    
    // Modal management
    modal: {
        // Show modal
        show: function(modalId) {
            const modal = document.getElementById(modalId);
            if (modal) {
                const bootstrapModal = new bootstrap.Modal(modal);
                bootstrapModal.show();
            }
        },
        
        // Hide modal
        hide: function(modalId) {
            const modal = document.getElementById(modalId);
            if (modal) {
                const bootstrapModal = bootstrap.Modal.getInstance(modal);
                if (bootstrapModal) {
                    bootstrapModal.hide();
                }
            }
        },
        
        // Reset form in modal
        resetForm: function(modalId) {
            const modal = document.getElementById(modalId);
            if (modal) {
                const form = modal.querySelector('form');
                if (form) {
                    form.reset();
                }
            }
        }
    },
    
    // Form validation
    validation: {
        // Validate form
        validate: function(form) {
            let isValid = true;
            const inputs = form.querySelectorAll('input[required], select[required], textarea[required]');
            
            inputs.forEach(function(input) {
                if (!input.value.trim()) {
                    input.classList.add('is-invalid');
                    isValid = false;
                } else {
                    input.classList.remove('is-invalid');
                }
            });
            
            return isValid;
        },
        
        // Show validation error
        showError: function(input, message) {
            input.classList.add('is-invalid');
            
            let feedback = input.nextElementSibling;
            if (!feedback || !feedback.classList.contains('invalid-feedback')) {
                feedback = document.createElement('div');
                feedback.className = 'invalid-feedback';
                input.parentNode.insertBefore(feedback, input.nextSibling);
            }
            
            feedback.textContent = message;
        },
        
        // Clear validation errors
        clearErrors: function(form) {
            const inputs = form.querySelectorAll('.is-invalid');
            inputs.forEach(function(input) {
                input.classList.remove('is-invalid');
            });
            
            const feedbacks = form.querySelectorAll('.invalid-feedback');
            feedbacks.forEach(function(feedback) {
                feedback.remove();
            });
        }
    },
    
    // Chart utilities
    chart: {
        // Default chart options
        defaultOptions: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        },
        
        // Create line chart
        createLineChart: function(ctx, data, options = {}) {
            if (typeof Chart === 'undefined') {
                console.warn('Chart.js not loaded');
                return null;
            }
            
            return new Chart(ctx, {
                type: 'line',
                data: data,
                options: Object.assign({}, this.defaultOptions, options)
            });
        },
        
        // Create bar chart
        createBarChart: function(ctx, data, options = {}) {
            if (typeof Chart === 'undefined') {
                console.warn('Chart.js not loaded');
                return null;
            }
            
            return new Chart(ctx, {
                type: 'bar',
                data: data,
                options: Object.assign({}, this.defaultOptions, options)
            });
        },
        
        // Create pie chart
        createPieChart: function(ctx, data, options = {}) {
            if (typeof Chart === 'undefined') {
                console.warn('Chart.js not loaded');
                return null;
            }
            
            return new Chart(ctx, {
                type: 'pie',
                data: data,
                options: Object.assign({}, this.defaultOptions, options)
            });
        }
    },
    
    // DataTable utilities
    dataTable: {
        // Initialize DataTable
        init: function(selector, options = {}) {
            if (typeof $.fn.DataTable === 'undefined') {
                console.warn('DataTables not loaded');
                return null;
            }
            
            const defaultOptions = {
                responsive: true,
                language: {
                    url: "//cdn.datatables.net/plug-ins/1.10.24/i18n/Indonesian.json"
                },
                pageLength: 10,
                lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "Semua"]]
            };
            
            return $(selector).DataTable(Object.assign({}, defaultOptions, options));
        }
    },
    
    // Session management
    session: {
        // Check if user is logged in
        isLoggedIn: function() {
            return document.body.classList.contains('user-logged-in');
        },
        
        // Get user role
        getUserRole: function() {
            return document.body.getAttribute('data-user-role') || 'guest';
        },
        
        // Check user permissions
        hasPermission: function(permission) {
            const userRole = this.getUserRole();
            const permissions = {
                'bos': ['unit', 'branch', 'member', 'loan', 'savings', 'collection', 'report', 'settings'],
                'unit_head': ['unit', 'branch', 'member', 'loan', 'savings', 'collection', 'report'],
                'branch_head': ['branch', 'member', 'loan', 'savings', 'collection', 'report'],
                'collector': ['route', 'payment'],
                'cashier': ['payment', 'report'],
                'guest': []
            };
            
            return permissions[userRole] && permissions[userRole].includes(permission);
        }
    },
    
    // Initialize application
    init: function() {
        console.log('Koperasi Berjalan Application initialized');
        
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);
        
        // Initialize tooltips
        this.initTooltips();
        
        // Initialize modals
        this.initModals();
        
        // Initialize forms
        this.initForms();
        
        // Initialize navigation
        this.initNavigation();
    },
    
    // Initialize tooltips
    initTooltips: function() {
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    },
    
    // Initialize modals
    initModals: function() {
        // Add event listeners for modal events
        document.querySelectorAll('.modal').forEach(function(modal) {
            modal.addEventListener('show.bs.modal', function(e) {
                // Clear form when modal is shown
                const form = modal.querySelector('form');
                if (form) {
                    KoperasiApp.validation.clearErrors(form);
                }
            });
        });
    },
    
    // Initialize forms
    initForms: function() {
        // Add event listeners for form validation
        document.querySelectorAll('form').forEach(function(form) {
            form.addEventListener('submit', function(e) {
                if (!KoperasiApp.validation.validate(form)) {
                    e.preventDefault();
                }
            });
        });
        
        // Auto-format currency inputs
        document.querySelectorAll('input[data-type="currency"]').forEach(function(input) {
            input.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '');
                if (value) {
                    e.target.value = parseInt(value).toLocaleString('id-ID');
                }
            });
        });
    },
    
    // Initialize navigation
    initNavigation: function() {
        // Handle mobile navigation
        const mobileNavToggle = document.querySelector('.navbar-toggler');
        if (mobileNavToggle) {
            mobileNavToggle.addEventListener('click', function() {
                document.querySelector('.navbar-collapse').classList.toggle('show');
            });
        }
        
        // Handle active menu highlighting
        const currentPath = window.location.pathname;
        document.querySelectorAll('.navbar-nav a').forEach(function(link) {
            if (link.getAttribute('href') === currentPath) {
                link.classList.add('active');
            }
        });
    }
};

// Initialize application when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    KoperasiApp.init();
});

// Make app available globally
window.KoperasiApp = KoperasiApp;

// Utility functions for backward compatibility
window.formatRupiah = KoperasiApp.utils.formatCurrency;
window.showNotification = KoperasiApp.notification.show;
