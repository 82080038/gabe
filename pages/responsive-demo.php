<?php
/**
 * Responsive Design Demo - Complete Responsive System
 * Demonstrates all responsive features and breakpoints
 */

require_once __DIR__ . '/template_header.php';

// Set page specific variables
$pageTitle = 'Responsive Design Demo';
$breadcrumbs = [
    ['title' => 'Demo', 'url' => '../pages/demo.php'],
    ['title' => 'Responsive', 'url' => '../pages/demo/responsive.php']
];

// Add responsive meta tags
echo '<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">';
echo '<meta name="apple-mobile-web-app-capable" content="yes">';
echo '<meta name="theme-color" content="#007bff">';
?>

<div class="container-fluid responsive-container">
    <!-- Demo Header -->
    <div class="responsive-header">
        <div class="responsive-header-content">
            <div class="responsive-header-logo">
                <i class="fas fa-mobile-alt"></i> Responsive Demo
            </div>
            <nav class="responsive-header-nav">
                <a href="#grid" class="responsive-nav-item">Grid</a>
                <a href="#typography" class="responsive-nav-item">Typography</a>
                <a href="#cards" class="responsive-nav-item">Cards</a>
                <a href="#forms" class="responsive-nav-item">Forms</a>
                <a href="#navigation" class="responsive-nav-item">Navigation</a>
            </nav>
            <div class="responsive-header-actions">
                <button class="responsive-btn responsive-btn-sm" onclick="toggleTheme()">
                    <i class="fas fa-moon"></i>
                </button>
                <button class="responsive-header-toggle" onclick="toggleSidebar()">
                    <i class="fas fa-bars"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- Current State Display -->
    <div class="responsive-card mb-4">
        <div class="responsive-card-header">
            <h5>Current Responsive State</h5>
        </div>
        <div class="responsive-card-body">
            <div class="responsive-grid responsive-grid-4">
                <div class="state-item">
                    <small class="text-muted">Breakpoint</small>
                    <div class="state-value" id="current-breakpoint">-</div>
                </div>
                <div class="state-item">
                    <small class="text-muted">Device Type</small>
                    <div class="state-value" id="device-type">-</div>
                </div>
                <div class="state-item">
                    <small class="text-muted">Orientation</small>
                    <div class="state-value" id="orientation">-</div>
                </div>
                <div class="state-item">
                    <small class="text-muted">Screen Size</small>
                    <div class="state-value" id="screen-size">-</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Grid System Demo -->
    <section id="grid" class="mb-5">
        <h2 class="responsive-typography mb-4">Grid System</h2>
        
        <div class="responsive-card mb-4">
            <div class="responsive-card-header">
                <h5>Responsive Grid</h5>
            </div>
            <div class="responsive-card-body">
                <div class="responsive-grid responsive-grid-6">
                    <div class="grid-demo-item">1</div>
                    <div class="grid-demo-item">2</div>
                    <div class="grid-demo-item">3</div>
                    <div class="grid-demo-item">4</div>
                    <div class="grid-demo-item">5</div>
                    <div class="grid-demo-item">6</div>
                </div>
            </div>
        </div>

        <div class="responsive-card mb-4">
            <div class="responsive-card-header">
                <h5>Auto Grid</h5>
            </div>
            <div class="responsive-card-body">
                <div class="responsive-grid" style="grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));">
                    <div class="grid-demo-item">Auto 1</div>
                    <div class="grid-demo-item">Auto 2</div>
                    <div class="grid-demo-item">Auto 3</div>
                    <div class="grid-demo-item">Auto 4</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Typography Demo -->
    <section id="typography" class="mb-5">
        <h2 class="responsive-typography mb-4">Typography</h2>
        
        <div class="responsive-card mb-4">
            <div class="responsive-card-header">
                <h5>Responsive Typography</h5>
            </div>
            <div class="responsive-card-body">
                <h1>Heading 1 - Responsive</h1>
                <h2>Heading 2 - Responsive</h2>
                <h3>Heading 3 - Responsive</h3>
                <h4>Heading 4 - Responsive</h4>
                <h5>Heading 5 - Responsive</h5>
                <h6>Heading 6 - Responsive</h6>
                
                <p class="responsive-text-md">
                    This is a responsive paragraph that adapts to different screen sizes. 
                    The font size and line height will automatically adjust based on the current breakpoint.
                </p>
                
                <div class="responsive-grid responsive-grid-3">
                    <div class="text-demo">
                        <small class="responsive-text-xs">Extra Small Text</small>
                    </div>
                    <div class="text-demo">
                        <span class="responsive-text-sm">Small Text</span>
                    </div>
                    <div class="text-demo">
                        <span class="responsive-text-lg">Large Text</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Cards Demo -->
    <section id="cards" class="mb-5">
        <h2 class="responsive-typography mb-4">Cards</h2>
        
        <div class="responsive-grid responsive-grid-3">
            <div class="responsive-card">
                <div class="responsive-card-header">
                    <h5>Card 1</h5>
                </div>
                <div class="responsive-card-body">
                    <p>This is a responsive card that adapts to different screen sizes.</p>
                </div>
                <div class="responsive-card-footer">
                    <button class="responsive-btn responsive-btn-sm">Action 1</button>
                    <button class="responsive-btn responsive-btn-sm">Action 2</button>
                </div>
            </div>
            
            <div class="responsive-card">
                <div class="responsive-card-header">
                    <h5>Card 2</h5>
                </div>
                <div class="responsive-card-body">
                    <p>Cards automatically adjust their layout based on available space.</p>
                </div>
                <div class="responsive-card-footer">
                    <button class="responsive-btn responsive-btn-block">Block Button</button>
                </div>
            </div>
            
            <div class="responsive-card">
                <div class="responsive-card-header">
                    <h5>Card 3</h5>
                </div>
                <div class="responsive-card-body">
                    <p>Responsive design ensures optimal user experience on all devices.</p>
                </div>
                <div class="responsive-card-footer">
                    <button class="responsive-btn responsive-btn-sm">Learn More</button>
                </div>
            </div>
        </div>
    </section>

    <!-- Forms Demo -->
    <section id="forms" class="mb-5">
        <h2 class="responsive-typography mb-4">Forms</h2>
        
        <div class="responsive-card">
            <div class="responsive-card-header">
                <h5>Responsive Form</h5>
            </div>
            <div class="responsive-card-body">
                <form class="responsive-form">
                    <div class="responsive-form-row">
                        <div class="responsive-form-group">
                            <label class="form-label">First Name</label>
                            <input type="text" class="form-control" placeholder="Enter first name">
                        </div>
                        <div class="responsive-form-group">
                            <label class="form-label">Last Name</label>
                            <input type="text" class="form-control" placeholder="Enter last name">
                        </div>
                    </div>
                    
                    <div class="responsive-form-group">
                        <label class="form-label">Email Address</label>
                        <input type="email" class="form-control" placeholder="Enter email address">
                    </div>
                    
                    <div class="responsive-form-group">
                        <label class="form-label">Message</label>
                        <textarea class="form-control" rows="4" placeholder="Enter your message"></textarea>
                    </div>
                    
                    <div class="responsive-flex responsive-flex-between">
                        <button type="button" class="responsive-btn responsive-btn-outline">Cancel</button>
                        <button type="submit" class="responsive-btn">Submit</button>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <!-- Navigation Demo -->
    <section id="navigation" class="mb-5">
        <h2 class="responsive-typography mb-4">Navigation</h2>
        
        <div class="responsive-grid responsive-grid-2">
            <div class="responsive-card">
                <div class="responsive-card-header">
                    <h5>Horizontal Navigation</h5>
                </div>
                <div class="responsive-card-body">
                    <nav class="responsive-nav responsive-nav-horizontal">
                        <a href="#" class="responsive-nav-item active">Home</a>
                        <a href="#" class="responsive-nav-item">About</a>
                        <a href="#" class="responsive-nav-item">Services</a>
                        <a href="#" class="responsive-nav-item">Contact</a>
                    </nav>
                </div>
            </div>
            
            <div class="responsive-card">
                <div class="responsive-card-header">
                    <h5>Vertical Navigation</h5>
                </div>
                <div class="responsive-card-body">
                    <nav class="responsive-nav responsive-nav-vertical">
                        <a href="#" class="responsive-nav-item active">Dashboard</a>
                        <a href="#" class="responsive-nav-item">Profile</a>
                        <a href="#" class="responsive-nav-item">Settings</a>
                        <a href="#" class="responsive-nav-item">Logout</a>
                    </nav>
                </div>
            </div>
        </div>
    </section>

    <!-- Components Demo -->
    <section id="components" class="mb-5">
        <h2 class="responsive-typography mb-4">Components</h2>
        
        <!-- Buttons -->
        <div class="responsive-card mb-4">
            <div class="responsive-card-header">
                <h5>Buttons</h5>
            </div>
            <div class="responsive-card-body">
                <div class="responsive-flex responsive-flex-wrap">
                    <button class="responsive-btn">Default</button>
                    <button class="responsive-btn responsive-btn-sm">Small</button>
                    <button class="responsive-btn responsive-btn-lg">Large</button>
                    <button class="responsive-btn responsive-btn-block">Block</button>
                </div>
            </div>
        </div>

        <!-- Tables -->
        <div class="responsive-card mb-4">
            <div class="responsive-card-header">
                <h5>Responsive Table</h5>
            </div>
            <div class="responsive-card-body">
                <div class="responsive-table">
                    <table>
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>John Doe</td>
                                <td>john@example.com</td>
                                <td>Admin</td>
                                <td><span class="badge bg-success">Active</span></td>
                                <td>
                                    <button class="responsive-btn responsive-btn-sm">Edit</button>
                                </td>
                            </tr>
                            <tr>
                                <td>Jane Smith</td>
                                <td>jane@example.com</td>
                                <td>User</td>
                                <td><span class="badge bg-warning">Pending</span></td>
                                <td>
                                    <button class="responsive-btn responsive-btn-sm">Edit</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Tabs -->
        <div class="responsive-card mb-4">
            <div class="responsive-card-header">
                <h5>Tabs</h5>
            </div>
            <div class="responsive-card-body">
                <div class="responsive-tabs">
                    <div class="responsive-tab-list">
                        <button class="responsive-tab active" onclick="showTab('tab1')">Tab 1</button>
                        <button class="responsive-tab" onclick="showTab('tab2')">Tab 2</button>
                        <button class="responsive-tab" onclick="showTab('tab3')">Tab 3</button>
                        <button class="responsive-tab" onclick="showTab('tab4')">Tab 4</button>
                    </div>
                    <div class="responsive-tab-content active" id="tab1">
                        <h6>Tab 1 Content</h6>
                        <p>This is the content for tab 1. It adapts to different screen sizes.</p>
                    </div>
                    <div class="responsive-tab-content" id="tab2">
                        <h6>Tab 2 Content</h6>
                        <p>This is the content for tab 2. Responsive tabs work great on mobile.</p>
                    </div>
                    <div class="responsive-tab-content" id="tab3">
                        <h6>Tab 3 Content</h6>
                        <p>This is the content for tab 3. Tabs scroll horizontally on small screens.</p>
                    </div>
                    <div class="responsive-tab-content" id="tab4">
                        <h6>Tab 4 Content</h6>
                        <p>This is the content for tab 4. Each tab can contain different content.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Accordion -->
        <div class="responsive-card mb-4">
            <div class="responsive-card-header">
                <h5>Accordion</h5>
            </div>
            <div class="responsive-card-body">
                <div class="responsive-accordion">
                    <div class="responsive-accordion-item">
                        <div class="responsive-accordion-header" onclick="toggleAccordion(this)">
                            <span>Accordion Item 1</span>
                            <i class="fas fa-chevron-down responsive-accordion-icon"></i>
                        </div>
                        <div class="responsive-accordion-content">
                            <p>This is the content for accordion item 1. It can contain any HTML content.</p>
                        </div>
                    </div>
                    <div class="responsive-accordion-item">
                        <div class="responsive-accordion-header" onclick="toggleAccordion(this)">
                            <span>Accordion Item 2</span>
                            <i class="fas fa-chevron-down responsive-accordion-icon"></i>
                        </div>
                        <div class="responsive-accordion-content">
                            <p>This is the content for accordion item 2. Accordion items expand and collapse smoothly.</p>
                        </div>
                    </div>
                    <div class="responsive-accordion-item">
                        <div class="responsive-accordion-header" onclick="toggleAccordion(this)">
                            <span>Accordion Item 3</span>
                            <i class="fas fa-chevron-down responsive-accordion-icon"></i>
                        </div>
                        <div class="responsive-accordion-content">
                            <p>This is the content for accordion item 3. Only one item can be expanded at a time.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Carousel -->
        <div class="responsive-card mb-4">
            <div class="responsive-card-header">
                <h5>Carousel</h5>
            </div>
            <div class="responsive-card-body">
                <div class="responsive-carousel" id="demo-carousel">
                    <div class="responsive-carousel-inner" style="transform: translateX(0%);">
                        <div class="responsive-carousel-item">
                            <img src="https://picsum.photos/seed/slide1/800/400.jpg" alt="Slide 1" class="responsive-img-cover">
                        </div>
                        <div class="responsive-carousel-item">
                            <img src="https://picsum.photos/seed/slide2/800/400.jpg" alt="Slide 2" class="responsive-img-cover">
                        </div>
                        <div class="responsive-carousel-item">
                            <img src="https://picsum.photos/seed/slide3/800/400.jpg" alt="Slide 3" class="responsive-img-cover">
                        </div>
                    </div>
                    <button class="responsive-carousel-control prev" onclick="moveCarousel(-1)">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <button class="responsive-carousel-control next" onclick="moveCarousel(1)">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                    <div class="responsive-carousel-indicators">
                        <button class="responsive-carousel-indicator active" onclick="goToSlide(0)"></button>
                        <button class="responsive-carousel-indicator" onclick="goToSlide(1)"></button>
                        <button class="responsive-carousel-indicator" onclick="goToSlide(2)"></button>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Performance Metrics -->
    <section id="performance" class="mb-5">
        <h2 class="responsive-typography mb-4">Performance Metrics</h2>
        
        <div class="responsive-card">
            <div class="responsive-card-header">
                <h5>Real-time Performance</h5>
            </div>
            <div class="responsive-card-body">
                <div class="responsive-grid responsive-grid-4">
                    <div class="metric-item">
                        <small class="text-muted">FPS</small>
                        <div class="metric-value" id="fps-metric">-</div>
                    </div>
                    <div class="metric-item">
                        <small class="text-muted">Memory (MB)</small>
                        <div class="metric-value" id="memory-metric">-</div>
                    </div>
                    <div class="metric-item">
                        <small class="text-muted">Network</small>
                        <div class="metric-value" id="network-metric">-</div>
                    </div>
                    <div class="metric-item">
                        <small class="text-muted">Load Time</small>
                        <div class="metric-value" id="load-metric">-</div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<!-- Responsive Sidebar -->
<div class="responsive-sidebar" id="responsive-sidebar">
    <div class="responsive-sidebar-header">
        <h5>Menu</h5>
        <button class="responsive-btn responsive-btn-sm" onclick="toggleSidebar()">
            <i class="fas fa-times"></i>
        </button>
    </div>
    <div class="responsive-sidebar-content">
        <nav class="responsive-sidebar-nav">
            <a href="#grid" class="responsive-nav-item" onclick="toggleSidebar()">Grid System</a>
            <a href="#typography" class="responsive-nav-item" onclick="toggleSidebar()">Typography</a>
            <a href="#cards" class="responsive-nav-item" onclick="toggleSidebar()">Cards</a>
            <a href="#forms" class="responsive-nav-item" onclick="toggleSidebar()">Forms</a>
            <a href="#navigation" class="responsive-nav-item" onclick="toggleSidebar()">Navigation</a>
            <a href="#components" class="responsive-nav-item" onclick="toggleSidebar()">Components</a>
            <a href="#performance" class="responsive-nav-item" onclick="toggleSidebar()">Performance</a>
        </nav>
    </div>
</div>

<div class="responsive-sidebar-overlay" id="responsive-sidebar-overlay" onclick="toggleSidebar()"></div>

<!-- Responsive CSS -->
<link rel="stylesheet" href="../assets/css/responsive-complete.css">

<!-- Responsive JavaScript -->
<script src="../assets/js/responsive-enhanced.js"></script>

<style>
/* Demo-specific styles */
.grid-demo-item {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 2rem;
    text-align: center;
    border-radius: var(--radius-lg);
    font-weight: 600;
    min-height: 100px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.text-demo {
    padding: 1rem;
    background: #f8f9fa;
    border-radius: var(--radius-md);
    text-align: center;
}

.state-item {
    text-align: center;
    padding: 1rem;
    background: #f8f9fa;
    border-radius: var(--radius-md);
}

.state-value {
    font-size: var(--font-lg);
    font-weight: 700;
    color: #007bff;
}

.metric-item {
    text-align: center;
    padding: 1rem;
    background: #f8f9fa;
    border-radius: var(--radius-md);
}

.metric-value {
    font-size: var(--font-lg);
    font-weight: 700;
    color: #28a745;
}

/* Dark mode support */
@media (prefers-color-scheme: dark) {
    .grid-demo-item {
        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
    }
    
    .text-demo,
    .state-item,
    .metric-item {
        background: #2d3748;
        color: #e2e8f0;
    }
    
    .state-value,
    .metric-value {
        color: #63b3ed;
    }
}
</style>

<script>
// Demo JavaScript
let currentSlide = 0;

function toggleSidebar() {
    const sidebar = document.getElementById('responsive-sidebar');
    const overlay = document.getElementById('responsive-sidebar-overlay');
    
    sidebar.classList.toggle('active');
    overlay.classList.toggle('active');
}

function toggleTheme() {
    document.body.classList.toggle('dark-mode');
}

function showTab(tabId) {
    // Hide all tabs
    document.querySelectorAll('.responsive-tab-content').forEach(tab => {
        tab.classList.remove('active');
    });
    
    // Remove active class from all tab buttons
    document.querySelectorAll('.responsive-tab').forEach(btn => {
        btn.classList.remove('active');
    });
    
    // Show selected tab
    document.getElementById(tabId).classList.add('active');
    
    // Add active class to clicked button
    event.target.classList.add('active');
}

function toggleAccordion(header) {
    const item = header.parentElement;
    const isActive = item.classList.contains('active');
    
    // Close all accordion items
    document.querySelectorAll('.responsive-accordion-item').forEach(accordionItem => {
        accordionItem.classList.remove('active');
    });
    
    // Open clicked item if it wasn't active
    if (!isActive) {
        item.classList.add('active');
    }
}

function moveCarousel(direction) {
    const carousel = document.getElementById('demo-carousel');
    const inner = carousel.querySelector('.responsive-carousel-inner');
    const items = inner.querySelectorAll('.responsive-carousel-item');
    const totalSlides = items.length;
    
    currentSlide = (currentSlide + direction + totalSlides) % totalSlides;
    
    inner.style.transform = `translateX(-${currentSlide * 100}%)`;
    
    // Update indicators
    updateCarouselIndicators();
}

function goToSlide(slideIndex) {
    const carousel = document.getElementById('demo-carousel');
    const inner = carousel.querySelector('.responsive-carousel-inner');
    
    currentSlide = slideIndex;
    inner.style.transform = `translateX(-${currentSlide * 100}%)`;
    
    // Update indicators
    updateCarouselIndicators();
}

function updateCarouselIndicators() {
    const indicators = document.querySelectorAll('.responsive-carousel-indicator');
    indicators.forEach((indicator, index) => {
        indicator.classList.toggle('active', index === currentSlide);
    });
}

// Auto-rotate carousel
setInterval(() => {
    moveCarousel(1);
}, 5000);

// Update responsive state display
function updateResponsiveState() {
    const state = window.responsiveEnhanced.getCurrentState();
    
    document.getElementById('current-breakpoint').textContent = state.currentBreakpoint;
    document.getElementById('device-type').textContent = state.deviceType;
    document.getElementById('orientation').textContent = state.orientation;
    document.getElementById('screen-size').textContent = `${window.innerWidth}x${window.innerHeight}`;
}

// Update performance metrics
function updatePerformanceMetrics() {
    const metrics = window.responsiveEnhanced.getPerformanceMetrics();
    
    document.getElementById('fps-metric').textContent = metrics.fps;
    document.getElementById('memory-metric').textContent = Math.round(metrics.memoryUsage / 1024 / 1024);
    document.getElementById('network-metric').textContent = metrics.networkSpeed || '-';
    document.getElementById('load-metric').textContent = performance.timing ? 
        Math.round(performance.timing.loadEventEnd - performance.timing.navigationStart) + 'ms' : '-';
}

// Listen to responsive events
window.responsiveEnhanced.on('resize', updateResponsiveState);
window.responsiveEnhanced.on('orientationchange', updateResponsiveState);
window.responsiveEnhanced.on('fpsupdate', updatePerformanceMetrics);
window.responsiveEnhanced.on('memoryupdate', updatePerformanceMetrics);
window.responsiveEnhanced.on('networkupdate', updatePerformanceMetrics);

// Initialize displays
document.addEventListener('DOMContentLoaded', () => {
    updateResponsiveState();
    updatePerformanceMetrics();
    
    // Update metrics every 5 seconds
    setInterval(updatePerformanceMetrics, 5000);
});

// Handle smooth scrolling for navigation links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});
</script>

<?php require_once __DIR__ . '/template_footer.php'; ?>
