/**
 * ================================================================
 * MEMBER PORTAL JAVASCRIPT - KOPERASI BERJALAN
 * Self-service interface with comprehensive features and PWA integration
 * ================================================================ */

class MemberPortal {
    constructor() {
        this.init();
        this.setupEventListeners();
        this.setupPWAFeatures();
        this.loadMemberData();
        this.startRealTimeUpdates();
    }
    
    init() {
        // Initialize portal state
        this.state = {
            member: null,
            loans: [],
            savings: [],
            transactions: [],
            notifications: [],
            isOnline: navigator.onLine,
            pendingActions: []
        };
        
        // Check if we're in mobile view
        this.isMobile = window.innerWidth <= 768;
        
        // Setup mobile-specific optimizations
        if (this.isMobile) {
            this.setupMobileOptimizations();
        }
    }
    
    setupEventListeners() {
        // Touch events for mobile
        if ('ontouchstart' in window) {
            this.setupTouchEvents();
        }
        
        // Network status monitoring
        window.addEventListener('online', () => this.handleOnlineStatus(true));
        window.addEventListener('offline', () => this.handleOnlineStatus(false));
        
        // Page visibility
        document.addEventListener('visibilitychange', () => this.handleVisibilityChange());
        
        // Pull to refresh
        this.setupPullToRefresh();
        
        // Back button handling
        window.addEventListener('popstate', (event) => {
            this.handleBackButton(event);
        });
    }
    
    setupPWAFeatures() {
        // Check if PWA is installed
        if (window.matchMedia('(display-mode: standalone)').matches) {
            document.body.classList.add('pwa-installed');
        }
        
        // Setup service worker communication
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker.addEventListener('message', (event) => {
                this.handleServiceWorkerMessage(event);
            });
        }
        
        // Setup background sync for offline actions
        this.setupBackgroundSync();
    }
    
    async loadMemberData() {
        try {
            // Show loading state
            this.showLoadingState();
            
            // Load member data from API
            const [member, loans, savings, transactions, notifications] = await Promise.all([
                this.apiCall('/api/member/profile'),
                this.apiCall('/api/member/loans'),
                this.apiCall('/api/member/savings'),
                this.apiCall('/api/member/transactions'),
                this.apiCall('/api/notifications')
            ]);
            
            // Update state
            this.state.member = member.data;
            this.state.loans = loans.data || [];
            this.state.savings = savings.data || [];
            this.state.transactions = transactions.data || [];
            this.state.notifications = notifications.data || [];
            
            // Update UI
            this.updateMemberHeader();
            this.updateQuickStats();
            this.updateLoansSection();
            this.updateSavingsSection();
            this.updateTransactionsSection();
            this.updateNotificationsSection();
            
            // Hide loading state
            this.hideLoadingState();
            
        } catch (error) {
            console.error('Failed to load member data:', error);
            this.showErrorState('Gagal memuat data anggota');
        }
    }
    
    updateMemberHeader() {
        if (!this.state.member) return;
        
        // Update member header information
        const memberName = document.querySelector('.member-header h4');
        const memberNumber = document.querySelector('.member-header small');
        
        if (memberName) memberName.textContent = this.state.member.name;
        if (memberNumber) memberNumber.textContent = this.state.member.member_number;
    }
    
    updateQuickStats() {
        if (!this.state.member) return;
        
        // Update quick stats with animations
        this.animateNumber('#savings-balance', this.state.member.savings_balance);
        this.animateNumber('#loan-balance', this.state.member.loan_balance);
        this.animateNumber('#credit-score', this.state.member.credit_score);
    }
    
    updateLoansSection() {
        const loansContainer = document.querySelector('.card-body');
        if (!loansContainer) return;
        
        const loansSection = loansContainer.querySelector('.loan-item')?.parentElement;
        if (!loansSection) return;
        
        loansSection.innerHTML = '';
        
        if (this.state.loans.length === 0) {
            loansSection.innerHTML = `
                <div class="empty-state p-4">
                    <i class="fas fa-hand-holding-usd fa-2x text-muted mb-2"></i>
                    <p class="text-muted">Belum ada pinjaman</p>
                    <button class="btn btn-primary btn-sm mt-2" onclick="memberPortal.applyLoan()">
                        <i class="fas fa-plus"></i> Ajukan Pinjaman
                    </button>
                </div>
            `;
            return;
        }
        
        this.state.loans.forEach(loan => {
            const loanItem = this.createLoanItem(loan);
            loansSection.appendChild(loanItem);
        });
    }
    
    createLoanItem(loan) {
        const div = document.createElement('div');
        div.className = 'loan-item p-3 border-bottom';
        
        const progressPercentage = ((loan.amount - loan.balance) / loan.amount) * 100;
        
        div.innerHTML = `
            <div class="d-flex justify-content-between align-items-start">
                <div class="flex-grow-1">
                    <h6 class="mb-1">${loan.product_name}</h6>
                    <small class="text-muted">Total: ${this.formatCurrency(loan.amount)}</small>
                    <div class="mt-2">
                        <div class="d-flex justify-content-between mb-1">
                            <small>Sisa Pinjaman</small>
                            <small class="text-warning">${this.formatCurrency(loan.balance)}</small>
                        </div>
                        <div class="progress" style="height: 4px;">
                            <div class="progress-bar bg-warning" style="width: ${progressPercentage}%"></div>
                        </div>
                    </div>
                </div>
                <div class="text-end">
                    <span class="badge bg-${loan.status === 'active' ? 'success' : 'secondary'}">
                        ${loan.status.charAt(0).toUpperCase() + loan.status.slice(1)}
                    </span>
                    <small class="d-block text-muted mt-1">
                        <i class="fas fa-calendar"></i> ${this.formatDate(loan.next_payment)}
                    </small>
                </div>
            </div>
            <div class="mt-2">
                <button class="btn btn-sm btn-outline-primary" onclick="memberPortal.viewLoanDetails(${loan.id})">
                    <i class="fas fa-info-circle"></i> Detail
                </button>
                <button class="btn btn-sm btn-outline-success" onclick="memberPortal.makeLoanPayment(${loan.id})">
                    <i class="fas fa-money-bill"></i> Bayar
                </button>
            </div>
        `;
        
        return div;
    }
    
    updateSavingsSection() {
        const savingsContainer = document.querySelector('.card-body');
        if (!savingsContainer) return;
        
        const savingsSection = savingsContainer.querySelector('.savings-item')?.parentElement;
        if (!savingsSection) return;
        
        savingsSection.innerHTML = '';
        
        if (this.state.savings.length === 0) {
            savingsSection.innerHTML = `
                <div class="empty-state p-4">
                    <i class="fas fa-piggy-bank fa-2x text-muted mb-2"></i>
                    <p class="text-muted">Belum ada simpanan</p>
                    <button class="btn btn-success btn-sm mt-2" onclick="memberPortal.depositSavings()">
                        <i class="fas fa-plus"></i> Setor Simpanan
                    </button>
                </div>
            `;
            return;
        }
        
        this.state.savings.forEach(saving => {
            const savingItem = this.createSavingsItem(saving);
            savingsSection.appendChild(savingItem);
        });
    }
    
    createSavingsItem(saving) {
        const div = document.createElement('div');
        div.className = 'savings-item p-3 border-bottom';
        
        div.innerHTML = `
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h6 class="mb-1">${saving.product_name}</h6>
                    <small class="text-muted">${saving.type.charAt(0).toUpperCase() + saving.type.slice(1)}</small>
                </div>
                <div class="text-end">
                    <div class="savings-balance text-success fw-bold">${this.formatCurrency(saving.balance)}</div>
                    <small class="text-muted">Saldo</small>
                </div>
            </div>
        `;
        
        return div;
    }
    
    updateTransactionsSection() {
        const transactionsContainer = document.querySelector('.transaction-item')?.parentElement;
        if (!transactionsContainer) return;
        
        transactionsContainer.innerHTML = '';
        
        if (this.state.transactions.length === 0) {
            transactionsContainer.innerHTML = `
                <div class="empty-state p-4">
                    <i class="fas fa-history fa-2x text-muted mb-2"></i>
                    <p class="text-muted">Belum ada transaksi</p>
                </div>
            `;
            return;
        }
        
        this.state.transactions.slice(0, 5).forEach(transaction => {
            const transactionItem = this.createTransactionItem(transaction);
            transactionsContainer.appendChild(transactionItem);
        });
    }
    
    createTransactionItem(transaction) {
        const div = document.createElement('div');
        div.className = 'transaction-item p-3 border-bottom';
        
        const transactionType = this.getTransactionType(transaction.type);
        
        div.innerHTML = `
            <div class="d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center">
                    <div class="transaction-icon bg-${transactionType.color} text-white rounded-circle p-2 me-3">
                        <i class="fas fa-${transactionType.icon}"></i>
                    </div>
                    <div>
                        <div class="transaction-title">${transactionType.title}</div>
                        <small class="text-muted">${this.formatDate(transaction.date)}</small>
                    </div>
                </div>
                <div class="text-end">
                    <div class="transaction-amount ${transactionType.amountClass}">
                        ${transactionType.prefix}${this.formatCurrency(transaction.amount)}
                    </div>
                    <small class="text-muted">
                        <i class="fas fa-check-circle text-success"></i> Selesai
                    </small>
                </div>
            </div>
        `;
        
        return div;
    }
    
    updateNotificationsSection() {
        const notificationsContainer = document.querySelector('.notification-item')?.parentElement;
        if (!notificationsContainer) return;
        
        notificationsContainer.innerHTML = '';
        
        if (this.state.notifications.length === 0) {
            notificationsContainer.innerHTML = `
                <div class="empty-state p-4">
                    <i class="fas fa-bell fa-2x text-muted mb-2"></i>
                    <p class="text-muted">Belum ada notifikasi</p>
                </div>
            `;
            return;
        }
        
        this.state.notifications.slice(0, 3).forEach(notification => {
            const notificationItem = this.createNotificationItem(notification);
            notificationsContainer.appendChild(notificationItem);
        });
    }
    
    createNotificationItem(notification) {
        const div = document.createElement('div');
        div.className = 'notification-item p-3 border-bottom';
        
        const notificationType = this.getNotificationType(notification.type);
        
        div.innerHTML = `
            <div class="d-flex align-items-start">
                <div class="notification-icon bg-${notificationType.color} text-white rounded-circle p-2 me-3">
                    <i class="fas fa-${notificationType.icon}"></i>
                </div>
                <div class="flex-grow-1">
                    <div class="notification-title">${notification.title}</div>
                    <small class="text-muted">${notification.message}</small>
                    <div class="mt-1">
                        <small class="text-muted">${this.formatRelativeTime(notification.created_at)}</small>
                    </div>
                </div>
            </div>
        `;
        
        return div;
    }
    
    // Action Methods
    showProfile() {
        const modal = document.getElementById('profile-modal');
        const modalInstance = new bootstrap.Modal(modal);
        modalInstance.show();
    }
    
    async applyLoan() {
        try {
            // Load loan products
            const response = await this.apiCall('/api/loan-products');
            
            if (response.success) {
                this.showLoanApplicationModal(response.data);
            } else {
                this.showError('Gagal memuat produk pinjaman');
            }
        } catch (error) {
            this.showError('Gagal memuat produk pinjaman');
        }
    }
    
    showLoanApplicationModal(products) {
        const modal = document.createElement('div');
        modal.className = 'modal fade';
        modal.innerHTML = `
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Ajukan Pinjaman</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="loan-application-form">
                            <div class="mb-3">
                                <label class="form-label">Produk Pinjaman</label>
                                <select class="form-select" name="product_id" required>
                                    <option value="">Pilih produk</option>
                                    ${products.map(product => `
                                        <option value="${product.id}">${product.name} - Max ${this.formatCurrency(product.max_amount)}</option>
                                    `).join('')}
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Jumlah Pinjaman</label>
                                <div class="input-group">
                                    <span class="input-group-text">Rp</span>
                                    <input type="number" class="form-control" name="amount" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Tujuan Pinjaman</label>
                                <textarea class="form-control" name="purpose" rows="3" required></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Jangka Waktu (bulan)</label>
                                <input type="number" class="form-control" name="tenure" min="1" max="60" required>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                        <button type="button" class="btn btn-primary" onclick="memberPortal.submitLoanApplication()">
                            <i class="fas fa-paper-plane"></i> Ajukan
                        </button>
                    </div>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        const modalInstance = new bootstrap.Modal(modal);
        modalInstance.show();
        
        modal.addEventListener('hidden.bs.modal', () => {
            modal.remove();
        });
    }
    
    async submitLoanApplication() {
        const form = document.getElementById('loan-application-form');
        const formData = new FormData(form);
        
        try {
            const response = await this.apiCall('/api/loans', {
                method: 'POST',
                body: JSON.stringify(Object.fromEntries(formData))
            });
            
            if (response.success) {
                this.showNotification('Pengajuan pinjaman berhasil dikirim', 'success');
                
                const modal = form.closest('.modal');
                bootstrap.Modal.getInstance(modal).hide();
                
                // Refresh data
                this.loadMemberData();
            } else {
                this.showError(response.error || 'Pengajuan pinjaman gagal');
            }
        } catch (error) {
            this.showError('Gagal mengajukan pinjaman');
        }
    }
    
    async depositSavings() {
        try {
            // Load savings products
            const response = await this.apiCall('/api/savings-products');
            
            if (response.success) {
                this.showSavingsDepositModal(response.data);
            } else {
                this.showError('Gagal memuat produk simpanan');
            }
        } catch (error) {
            this.showError('Gagal memuat produk simpanan');
        }
    }
    
    showSavingsDepositModal(products) {
        const modal = document.createElement('div');
        modal.className = 'modal fade';
        modal.innerHTML = `
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Setor Simpanan</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="savings-deposit-form">
                            <div class="mb-3">
                                <label class="form-label">Jenis Simpanan</label>
                                <select class="form-select" name="product_id" required>
                                    <option value="">Pilih jenis simpanan</option>
                                    ${products.map(product => `
                                        <option value="${product.id}">${product.name}</option>
                                    `).join('')}
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Jumlah Setoran</label>
                                <div class="input-group">
                                    <span class="input-group-text">Rp</span>
                                    <input type="number" class="form-control" name="amount" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Metode Pembayaran</label>
                                <select class="form-select" name="payment_method" required>
                                    <option value="">Pilih metode</option>
                                    <option value="cash">Tunai</option>
                                    <option value="transfer">Transfer</option>
                                    <option value="digital">Dompet Digital</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Catatan</label>
                                <textarea class="form-control" name="notes" rows="2"></textarea>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                        <button type="button" class="btn btn-success" onclick="memberPortal.submitSavingsDeposit()">
                            <i class="fas fa-save"></i> Setor
                        </button>
                    </div>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        const modalInstance = new bootstrap.Modal(modal);
        modalInstance.show();
        
        modal.addEventListener('hidden.bs.modal', () => {
            modal.remove();
        });
    }
    
    async submitSavingsDeposit() {
        const form = document.getElementById('savings-deposit-form');
        const formData = new FormData(form);
        
        try {
            const response = await this.apiCall('/api/savings/deposit', {
                method: 'POST',
                body: JSON.stringify(Object.fromEntries(formData))
            });
            
            if (response.success) {
                this.showNotification('Setoran simpanan berhasil', 'success');
                
                const modal = form.closest('.modal');
                bootstrap.Modal.getInstance(modal).hide();
                
                // Refresh data
                this.loadMemberData();
            } else {
                this.showError(response.error || 'Setoran simpanan gagal');
            }
        } catch (error) {
            this.showError('Gagal melakukan setoran');
        }
    }
    
    viewTransactions() {
        window.location.href = '/member/transactions';
    }
    
    makePayment() {
        // Show payment options modal
        this.showPaymentOptionsModal();
    }
    
    showPaymentOptionsModal() {
        const modal = document.createElement('div');
        modal.className = 'modal fade';
        modal.innerHTML = `
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Pembayaran</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="payment-options">
                            <div class="payment-option p-3 border rounded mb-2" onclick="memberPortal.makeLoanPayment()">
                                <div class="d-flex align-items-center">
                                    <div class="payment-icon bg-warning text-white rounded-circle p-2 me-3">
                                        <i class="fas fa-money-bill"></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-1">Bayar Pinjaman</h6>
                                        <small class="text-muted">Bayar angsuran pinjaman aktif</small>
                                    </div>
                                </div>
                            </div>
                            <div class="payment-option p-3 border rounded" onclick="memberPortal.depositSavings()">
                                <div class="d-flex align-items-center">
                                    <div class="payment-icon bg-success text-white rounded-circle p-2 me-3">
                                        <i class="fas fa-piggy-bank"></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-1">Setor Simpanan</h6>
                                        <small class="text-muted">Tambah saldo simpanan</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    </div>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        const modalInstance = new bootstrap.Modal(modal);
        modalInstance.show();
        
        modal.addEventListener('hidden.bs.modal', () => {
            modal.remove();
        });
    }
    
    async makeLoanPayment(loanId) {
        if (!loanId) {
            // Show loan selection modal
            this.showLoanSelectionModal();
            return;
        }
        
        const loan = this.state.loans.find(l => l.id === loanId);
        if (!loan) return;
        
        const modal = document.createElement('div');
        modal.className = 'modal fade';
        modal.innerHTML = `
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Bayar Pinjaman</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="loan-info mb-3">
                            <h6>${loan.product_name}</h6>
                            <p class="text-muted">Sisa: ${this.formatCurrency(loan.balance)}</p>
                        </div>
                        
                        <form id="loan-payment-form">
                            <input type="hidden" name="loan_id" value="${loanId}">
                            
                            <div class="mb-3">
                                <label class="form-label">Jumlah Pembayaran</label>
                                <div class="input-group">
                                    <span class="input-group-text">Rp</span>
                                    <input type="number" class="form-control" name="amount" max="${loan.balance}" required>
                                </div>
                                <small class="text-muted">Maksimal: ${this.formatCurrency(loan.balance)}</small>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Metode Pembayaran</label>
                                <select class="form-select" name="payment_method" required>
                                    <option value="">Pilih metode</option>
                                    <option value="cash">Tunai</option>
                                    <option value="transfer">Transfer</option>
                                    <option value="digital">Dompet Digital</option>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Catatan</label>
                                <textarea class="form-control" name="notes" rows="2"></textarea>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                        <button type="button" class="btn btn-success" onclick="memberPortal.submitLoanPayment()">
                            <i class="fas fa-save"></i> Bayar
                        </button>
                    </div>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        const modalInstance = new bootstrap.Modal(modal);
        modalInstance.show();
        
        modal.addEventListener('hidden.bs.modal', () => {
            modal.remove();
        });
    }
    
    showLoanSelectionModal() {
        const modal = document.createElement('div');
        modal.className = 'modal fade';
        modal.innerHTML = `
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Pilih Pinjaman</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="loan-selection">
                            ${this.state.loans.map(loan => `
                                <div class="loan-option p-3 border rounded mb-2" onclick="memberPortal.makeLoanPayment(${loan.id})">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="mb-1">${loan.product_name}</h6>
                                            <small class="text-muted">Sisa: ${this.formatCurrency(loan.balance)}</small>
                                        </div>
                                        <button class="btn btn-sm btn-outline-success">
                                            <i class="fas fa-money-bill"></i> Bayar
                                        </button>
                                    </div>
                                </div>
                            `).join('')}
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    </div>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        const modalInstance = new bootstrap.Modal(modal);
        modalInstance.show();
        
        modal.addEventListener('hidden.bs.modal', () => {
            modal.remove();
        });
    }
    
    async submitLoanPayment() {
        const form = document.getElementById('loan-payment-form');
        const formData = new FormData(form);
        
        try {
            const response = await this.apiCall('/api/loans/payment', {
                method: 'POST',
                body: JSON.stringify(Object.fromEntries(formData))
            });
            
            if (response.success) {
                this.showNotification('Pembayaran pinjaman berhasil', 'success');
                
                const modal = form.closest('.modal');
                bootstrap.Modal.getInstance(modal).hide();
                
                // Refresh data
                this.loadMemberData();
            } else {
                this.showError(response.error || 'Pembayaran pinjaman gagal');
            }
        } catch (error) {
            this.showError('Gagal memproses pembayaran');
        }
    }
    
    viewLoanDetails(loanId) {
        const loan = this.state.loans.find(l => l.id === loanId);
        if (!loan) return;
        
        const modal = document.createElement('div');
        modal.className = 'modal fade';
        modal.innerHTML = `
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Detail Pinjaman</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="loan-details">
                            <div class="row mb-3">
                                <div class="col-6">
                                    <small class="text-muted">Produk</small>
                                    <p>${loan.product_name}</p>
                                </div>
                                <div class="col-6">
                                    <small class="text-muted">Status</small>
                                    <p><span class="badge bg-success">${loan.status}</span></p>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-6">
                                    <small class="text-muted">Total Pinjaman</small>
                                    <p>${this.formatCurrency(loan.amount)}</p>
                                </div>
                                <div class="col-6">
                                    <small class="text-muted">Sisa Pinjaman</small>
                                    <p class="text-warning">${this.formatCurrency(loan.balance)}</p>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-6">
                                    <small class="text-muted">Jatuh Tempo Berikutnya</small>
                                    <p>${this.formatDate(loan.next_payment)}</p>
                                </div>
                                <div class="col-6">
                                    <small class="text-muted">Tanggal Disburse</small>
                                    <p>${this.formatDate(loan.disbursement_date)}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
                        <button type="button" class="btn btn-success" onclick="memberPortal.makeLoanPayment(${loan.id})">
                            <i class="fas fa-money-bill"></i> Bayar
                        </button>
                    </div>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        const modalInstance = new bootstrap.Modal(modal);
        modalInstance.show();
        
        modal.addEventListener('hidden.bs.modal', () => {
            modal.remove();
        });
    }
    
    viewDocuments() {
        window.location.href = '/member/documents';
    }
    
    viewReports() {
        window.location.href = '/member/reports';
    }
    
    contactSupport() {
        this.showSupportModal();
    }
    
    showSupportModal() {
        const modal = document.createElement('div');
        modal.className = 'modal fade';
        modal.innerHTML = `
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Bantuan</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="support-options">
                            <div class="support-option p-3 border rounded mb-2">
                                <div class="d-flex align-items-center">
                                    <div class="support-icon bg-primary text-white rounded-circle p-2 me-3">
                                        <i class="fas fa-phone"></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-1">Telepon</h6>
                                        <small class="text-muted">+62 21 1234 5678</small>
                                    </div>
                                </div>
                            </div>
                            <div class="support-option p-3 border rounded mb-2">
                                <div class="d-flex align-items-center">
                                    <div class="support-icon bg-success text-white rounded-circle p-2 me-3">
                                        <i class="fas fa-envelope"></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-1">Email</h6>
                                        <small class="text-muted">support@koperasi-berjalan.com</small>
                                    </div>
                                </div>
                            </div>
                            <div class="support-option p-3 border rounded mb-2">
                                <div class="d-flex align-items-center">
                                    <div class="support-icon bg-info text-white rounded-circle p-2 me-3">
                                        <i class="fas fa-comments"></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-1">Live Chat</h6>
                                        <small class="text-muted">Senin - Jumat, 08:00 - 17:00</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
                    </div>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        const modalInstance = new bootstrap.Modal(modal);
        modalInstance.show();
        
        modal.addEventListener('hidden.bs.modal', () => {
            modal.remove();
        });
    }
    
    showSettings() {
        this.showSettingsModal();
    }
    
    showSettingsModal() {
        const modal = document.createElement('div');
        modal.className = 'modal fade';
        modal.innerHTML = `
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Pengaturan</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="settings-options">
                            <div class="setting-item p-3 border-bottom">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="mb-1">Notifikasi Push</h6>
                                        <small class="text-muted">Terima notifikasi pembayaran dan pengingat</small>
                                    </div>
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" id="push-notifications" checked>
                                    </div>
                                </div>
                            </div>
                            <div class="setting-item p-3 border-bottom">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="mb-1">Email Newsletter</h6>
                                        <small class="text-muted">Terima informasi promo dan berita</small>
                                    </div>
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" id="email-newsletter">
                                    </div>
                                </div>
                            </div>
                            <div class="setting-item p-3 border-bottom">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="mb-1">Mode Gelap</h6>
                                        <small class="text-muted">Tampilan gelap untuk kenyamanan mata</small>
                                    </div>
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" id="dark-mode">
                                    </div>
                                </div>
                            </div>
                            <div class="setting-item p-3">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="mb-1">Bahasa</h6>
                                        <small class="text-muted">Pilih bahasa tampilan</small>
                                    </div>
                                    <select class="form-select form-select-sm">
                                        <option value="id" selected>Bahasa Indonesia</option>
                                        <option value="en">English</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                        <button type="button" class="btn btn-primary" onclick="memberPortal.saveSettings()">
                            <i class="fas fa-save"></i> Simpan
                        </button>
                    </div>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        const modalInstance = new bootstrap.Modal(modal);
        modalInstance.show();
        
        modal.addEventListener('hidden.bs.modal', () => {
            modal.remove();
        });
    }
    
    saveSettings() {
        // Save settings to localStorage or API
        const settings = {
            pushNotifications: document.getElementById('push-notifications').checked,
            emailNewsletter: document.getElementById('email-newsletter').checked,
            darkMode: document.getElementById('dark-mode').checked
        };
        
        localStorage.setItem('member-settings', JSON.stringify(settings));
        
        this.showNotification('Pengaturan berhasil disimpan', 'success');
        
        const modal = document.querySelector('.modal.show');
        if (modal) {
            bootstrap.Modal.getInstance(modal).hide();
        }
    }
    
    editProfile() {
        this.showEditProfileModal();
    }
    
    showEditProfileModal() {
        const modal = document.createElement('div');
        modal.className = 'modal fade';
        modal.innerHTML = `
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Edit Profil</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="edit-profile-form">
                            <div class="mb-3">
                                <label class="form-label">Nama Lengkap</label>
                                <input type="text" class="form-control" name="name" value="${this.state.member.name}" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="email" value="${this.state.member.email}" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Telepon</label>
                                <input type="tel" class="form-control" name="phone" value="${this.state.member.phone}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Alamat</label>
                                <textarea class="form-control" name="address" rows="3">${this.state.member.address || ''}</textarea>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                        <button type="button" class="btn btn-primary" onclick="memberPortal.submitProfileUpdate()">
                            <i class="fas fa-save"></i> Simpan
                        </button>
                    </div>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        const modalInstance = new bootstrap.Modal(modal);
        modalInstance.show();
        
        modal.addEventListener('hidden.bs.modal', () => {
            modal.remove();
        });
    }
    
    async submitProfileUpdate() {
        const form = document.getElementById('edit-profile-form');
        const formData = new FormData(form);
        
        try {
            const response = await this.apiCall('/api/member/profile', {
                method: 'PUT',
                body: JSON.stringify(Object.fromEntries(formData))
            });
            
            if (response.success) {
                this.showNotification('Profil berhasil diperbarui', 'success');
                
                const modal = form.closest('.modal');
                bootstrap.Modal.getInstance(modal).hide();
                
                // Refresh data
                this.loadMemberData();
            } else {
                this.showError(response.error || 'Gagal memperbarui profil');
            }
        } catch (error) {
            this.showError('Gagal memperbarui profil');
        }
    }
    
    // Touch events and mobile optimizations
    setupTouchEvents() {
        let touchStartX = 0;
        let touchStartY = 0;
        
        document.addEventListener('touchstart', (e) => {
            touchStartX = e.touches[0].clientX;
            touchStartY = e.touches[0].clientY;
        });
        
        document.addEventListener('touchend', (e) => {
            const touchEndX = e.changedTouches[0].clientX;
            const touchEndY = e.changedTouches[0].clientY;
            
            const deltaX = touchEndX - touchStartX;
            const deltaY = touchEndY - touchStartY;
            
            // Check if it's a horizontal swipe
            if (Math.abs(deltaX) > Math.abs(deltaY) && Math.abs(deltaX) > 50) {
                this.handleSwipeGesture(deltaX > 0 ? 'right' : 'left');
            }
        });
    }
    
    handleSwipeGesture(direction) {
        // Handle swipe gestures for navigation
        if (direction === 'left') {
            // Navigate to next section
            this.navigateToNextSection();
        } else if (direction === 'right') {
            // Navigate to previous section
            this.navigateToPreviousSection();
        }
    }
    
    navigateToNextSection() {
        // Implement navigation logic
        console.log('Navigate to next section');
    }
    
    navigateToPreviousSection() {
        // Implement navigation logic
        console.log('Navigate to previous section');
    }
    
    setupPullToRefresh() {
        let startY = 0;
        let isPulling = false;
        
        const container = document.querySelector('.member-portal');
        
        container.addEventListener('touchstart', (e) => {
            if (window.scrollY === 0) {
                startY = e.touches[0].pageY;
                isPulling = true;
            }
        });
        
        container.addEventListener('touchmove', (e) => {
            if (!isPulling) return;
            
            const currentY = e.touches[0].pageY;
            const pullDistance = currentY - startY;
            
            if (pullDistance > 0) {
                e.preventDefault();
                this.showPullIndicator(pullDistance);
            }
        });
        
        container.addEventListener('touchend', (e) => {
            if (!isPulling) return;
            
            isPulling = false;
            const pullDistance = e.changedTouches[0].pageY - startY;
            
            if (pullDistance > 100) {
                this.refreshMemberData();
            } else {
                this.hidePullIndicator();
            }
        });
    }
    
    showPullIndicator(distance) {
        const indicator = document.getElementById('pull-indicator');
        if (!indicator) {
            const div = document.createElement('div');
            div.id = 'pull-indicator';
            div.className = 'pull-indicator';
            div.innerHTML = '<i class="fas fa-sync-alt"></i>';
            document.body.appendChild(div);
        }
        
        const height = Math.min(distance * 0.5, 60);
        indicator.style.height = `${height}px`;
        indicator.style.opacity = Math.min(distance / 100, 1);
    }
    
    hidePullIndicator() {
        const indicator = document.getElementById('pull-indicator');
        if (indicator) {
            indicator.style.height = '0';
            indicator.style.opacity = '0';
            setTimeout(() => indicator.remove(), 300);
        }
    }
    
    async refreshMemberData() {
        this.showPullIndicator(100);
        
        try {
            await this.loadMemberData();
            this.showNotification('Data diperbarui', 'success');
        } catch (error) {
            this.showError('Gagal memperbarui data');
        } finally {
            this.hidePullIndicator();
        }
    }
    
    // PWA and offline support
    setupBackgroundSync() {
        if ('serviceWorker' in navigator && 'sync' in window.ServiceWorkerRegistration.prototype) {
            navigator.serviceWorker.ready.then((registration) => {
                this.registerBackgroundSync(registration);
            });
        }
    }
    
    registerBackgroundSync(registration) {
        const pendingActions = this.getPendingActions();
        
        if (pendingActions.length > 0) {
            registration.sync.register('background-sync');
        }
    }
    
    getPendingActions() {
        return JSON.parse(localStorage.getItem('pendingActions') || '[]');
    }
    
    savePendingAction(action) {
        const pendingActions = this.getPendingActions();
        pendingActions.push({
            ...action,
            timestamp: Date.now(),
            id: this.generateId()
        });
        
        localStorage.setItem('pendingActions', JSON.stringify(pendingActions));
        
        if ('serviceWorker' in navigator && 'sync' in window.ServiceWorkerRegistration.prototype) {
            navigator.serviceWorker.ready.then((registration) => {
                registration.sync.register('background-sync');
            });
        }
    }
    
    generateId() {
        return Date.now().toString(36) + Math.random().toString(36).substr(2);
    }
    
    // API Methods
    async apiCall(endpoint, options = {}) {
        const token = localStorage.getItem('authToken');
        
        const config = {
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`
            },
            ...options
        };
        
        try {
            const response = await fetch(`/api${endpoint}`, config);
            
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }
            
            return await response.json();
        } catch (error) {
            if (!navigator.onLine) {
                this.savePendingAction({
                    endpoint,
                    options: config,
                    type: 'api_call'
                });
                
                throw new Error('Offline - Action saved for sync');
            }
            
            throw error;
        }
    }
    
    // Utility Methods
    animateNumber(selector, targetValue) {
        const element = document.querySelector(selector);
        if (!element) return;
        
        const duration = 1000;
        const startValue = 0;
        const startTime = performance.now();
        
        const animate = (currentTime) => {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / duration, 1);
            
            const currentValue = Math.floor(startValue + (targetValue - startValue) * progress);
            element.textContent = this.formatNumber(currentValue);
            
            if (progress < 1) {
                requestAnimationFrame(animate);
            }
        };
        
        requestAnimationFrame(animate);
    }
    
    formatNumber(num) {
        return new Intl.NumberFormat('id-ID').format(num);
    }
    
    formatCurrency(amount) {
        return new Intl.NumberFormat('id-ID', {
            style: 'currency',
            currency: 'IDR',
            minimumFractionDigits: 0
        }).format(amount);
    }
    
    formatDate(date) {
        return new Intl.DateTimeFormat('id-ID', {
            day: 'numeric',
            month: 'short',
            year: 'numeric'
        }).format(new Date(date));
    }
    
    formatRelativeTime(date) {
        const now = new Date();
        const targetDate = new Date(date);
        const diffMs = now - targetDate;
        const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));
        
        if (diffDays === 0) {
            return 'Hari ini';
        } else if (diffDays === 1) {
            return 'Kemarin';
        } else if (diffDays < 7) {
            return `${diffDays} hari yang lalu`;
        } else if (diffDays < 30) {
            return `${Math.floor(diffDays / 7)} minggu yang lalu`;
        } else {
            return `${Math.floor(diffDays / 30)} bulan yang lalu`;
        }
    }
    
    getTransactionType(type) {
        const types = {
            loan_payment: {
                title: 'Pembayaran Pinjaman',
                icon: 'money-bill',
                color: 'success',
                amountClass: 'text-success',
                prefix: '-'
            },
            savings_deposit: {
                title: 'Setoran Simpanan',
                icon: 'piggy-bank',
                color: 'primary',
                amountClass: 'text-primary',
                prefix: '+'
            },
            loan_disbursement: {
                title: 'Pencairan Pinjaman',
                icon: 'hand-holding-usd',
                color: 'warning',
                amountClass: 'text-warning',
                prefix: '+'
            }
        };
        
        return types[type] || {
            title: 'Transaksi',
            icon: 'exchange-alt',
            color: 'secondary',
            amountClass: 'text-secondary',
            prefix: ''
        };
    }
    
    getNotificationType(type) {
        const types = {
            payment_reminder: {
                icon: 'bell',
                color: 'warning'
            },
            payment_success: {
                icon: 'check',
                color: 'success'
            },
            loan_approved: {
                icon: 'check-circle',
                color: 'success'
            },
            promotion: {
                icon: 'tag',
                color: 'info'
            }
        };
        
        return types[type] || {
            icon: 'info-circle',
            color: 'info'
        };
    }
    
    showNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `member-notification notification-${type}`;
        notification.innerHTML = `
            <div class="notification-content">
                <i class="fas fa-${this.getNotificationIcon(type)}"></i>
                <span>${message}</span>
            </div>
        `;
        
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.classList.add('notification-hide');
            setTimeout(() => notification.remove(), 300);
        }, 3000);
    }
    
    getNotificationIcon(type) {
        const icons = {
            success: 'check-circle',
            error: 'exclamation-circle',
            warning: 'exclamation-triangle',
            info: 'info-circle'
        };
        return icons[type] || 'info-circle';
    }
    
    showError(message) {
        this.showNotification(message, 'error');
    }
    
    showLoadingState() {
        const loader = document.createElement('div');
        loader.id = 'member-loader';
        loader.className = 'loading-spinner';
        loader.innerHTML = `
            <div class="spinner-border text-success" role="status">
                <span class="sr-only">Loading...</span>
            </div>
            <p class="mt-2">Memuat data...</p>
        `;
        
        document.body.appendChild(loader);
    }
    
    hideLoadingState() {
        const loader = document.getElementById('member-loader');
        if (loader) {
            loader.remove();
        }
    }
    
    showErrorState(message) {
        const errorContainer = document.getElementById('error-container');
        if (errorContainer) {
            errorContainer.innerHTML = `
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle"></i>
                    ${message}
                    <button class="btn btn-sm btn-outline-danger ml-2" onclick="memberPortal.refreshMemberData()">
                        <i class="fas fa-sync-alt"></i> Coba Lagi
                    </button>
                </div>
            `;
        }
    }
    
    handleOnlineStatus(isOnline) {
        this.state.isOnline = isOnline;
        
        const statusIndicator = document.getElementById('online-status');
        if (statusIndicator) {
            statusIndicator.className = `online-status ${isOnline ? 'online' : 'offline'}`;
            statusIndicator.innerHTML = isOnline ? 
                '<i class="fas fa-wifi"></i> Online' : 
                '<i class="fas fa-wifi-slash"></i> Offline';
        }
        
        if (isOnline) {
            this.showNotification('Koneksi tersambung kembali', 'success');
            this.syncPendingActions();
        } else {
            this.showNotification('Koneksi terputus', 'warning');
        }
    }
    
    async syncPendingActions() {
        const pendingActions = this.getPendingActions();
        
        for (const action of pendingActions) {
            try {
                await this.apiCall(action.endpoint, action.options);
                this.removePendingAction(action.id);
            } catch (error) {
                console.error('Failed to sync action:', error);
            }
        }
    }
    
    removePendingAction(actionId) {
        const pendingActions = this.getPendingActions();
        const filteredActions = pendingActions.filter(action => action.id !== actionId);
        localStorage.setItem('pendingActions', JSON.stringify(filteredActions));
    }
    
    handleVisibilityChange() {
        if (document.visibilityState === 'visible') {
            this.loadMemberData();
        }
    }
    
    handleBackButton(event) {
        // Handle custom back button logic
        if (this.state.isNavigating) {
            event.preventDefault();
            this.stopNavigation();
        }
    }
    
    handleServiceWorkerMessage(event) {
        if (event.data?.type === 'SYNC_COMPLETED') {
            this.showNotification('Data berhasil disinkronisasi', 'success');
            this.loadMemberData();
        }
    }
    
    startRealTimeUpdates() {
        // Update every 30 seconds
        setInterval(() => {
            if (document.visibilityState === 'visible') {
                this.loadMemberData();
            }
        }, 30000);
    }
    
    setupMobileOptimizations() {
        // Prevent zoom on double tap
        let lastTouchEnd = 0;
        document.addEventListener('touchend', (event) => {
            const now = Date.now();
            if (now - lastTouchEnd <= 300) {
                event.preventDefault();
            }
            lastTouchEnd = now;
        });
        
        document.body.style.touchAction = 'pan-y';
    }
}

// Initialize member portal when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    window.memberPortal = new MemberPortal();
});

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = MemberPortal;
}
