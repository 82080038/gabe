# 📚 API Documentation - Koperasi Berjalan

**Version:** 1.0.0  
**Last Updated:** 2026-03-27  
**Base URL:** `http://localhost/api`  

---

## 🎯 **API Overview**

RESTful API untuk aplikasi Koperasi Berjalan dengan fitur:
- **Authentication** - JWT-based authentication
- **Authorization** - Role-based access control  
- **Validation** - Input validation and sanitization
- **Error Handling** - Standardized error responses
- **Logging** - Comprehensive activity logging
- **Rate Limiting** - Protection against abuse
- **Documentation** - Auto-generated API docs

---

## 🔐 **Authentication & Security**

### **Authentication Flow**
1. **Login** - Get JWT token
2. **Include Token** - Add to Authorization header
3. **Refresh Token** - Get new token before expiry
4. **Logout** - Invalidate token

### **Authorization Header**
```http
Authorization: Bearer <JWT_TOKEN>
```

### **Rate Limiting**
- **100 requests** per hour per IP
- **Automatic** ban after exceeding limit
- **Development mode** - More lenient limits

---

## 📊 **Response Format**

### **Success Response**
```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... },
  "timestamp": "2026-03-27 02:34:00",
  "status": 200,
  "meta": { ... },
  "debug": { ... } // Development only
}
```

### **Error Response**
```json
{
  "success": false,
  "error": "Error message",
  "status": 400,
  "timestamp": "2026-03-27 02:34:00",
  "errors": { ... }, // Validation errors
  "debug": { ... } // Development only
}
```

### **Pagination Meta**
```json
{
  "total": 150,
  "page": 1,
  "limit": 20,
  "total_pages": 8,
  "has_next": true,
  "has_prev": false
}
```

---

## 🔑 **Authentication Endpoints**

### **POST /api/auth/login**
Login user and return JWT token.

**Request Body:**
```json
{
  "username": "admin",
  "password": "password123"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "username": "admin",
      "name": "Administrator",
      "role": "admin",
      "permissions": ["users", "members", "products", "reports"]
    },
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "expires_in": 86400
  }
}
```

### **POST /api/auth/logout**
Logout current user.

**Headers:**
```http
Authorization: Bearer <JWT_TOKEN>
```

**Response:**
```json
{
  "success": true,
  "message": "Logout successful"
}
```

### **POST /api/auth/refresh**
Refresh JWT token.

**Headers:**
```http
Authorization: Bearer <JWT_TOKEN>
```

**Response:**
```json
{
  "success": true,
  "data": {
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "expires_in": 86400
  }
}
```

---

## 👥 **User Management Endpoints**

### **GET /api/users**
Get all users with pagination and filtering.

**Headers:**
```http
Authorization: Bearer <JWT_TOKEN>
```

**Query Parameters:**
- `page` (int) - Page number (default: 1)
- `limit` (int) - Items per page (default: 20, max: 100)
- `search` (string) - Search by username, name, or email
- `role` (string) - Filter by role
- `branch_id` (int) - Filter by branch
- `status` (string) - Filter by status

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "username": "admin",
      "role": "admin",
      "role_name": "Administrator",
      "status": "active",
      "person_name": "John Doe",
      "email": "john@example.com",
      "branch_name": "Kantor Pusat",
      "last_login": "2026-03-27 02:30:00"
    }
  ],
  "meta": {
    "total": 25,
    "page": 1,
    "limit": 20,
    "total_pages": 2
  }
}
```

### **POST /api/users**
Create new user.

**Headers:**
```http
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

**Request Body:**
```json
{
  "username": "newuser",
  "password": "Password123!",
  "person_id": 123,
  "role": "collector",
  "branch_id": 1,
  "email": "newuser@example.com"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 26,
    "username": "newuser",
    "role": "collector",
    "status": "active",
    "person_name": "Jane Smith",
    "branch_name": "Cabang Jakarta"
  },
  "status": 201
}
```

### **GET /api/users/{id}**
Get specific user details.

**Headers:**
```http
Authorization: Bearer <JWT_TOKEN>
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "username": "admin",
    "role": "admin",
    "permissions": ["users", "members", "products", "reports"],
    "person_info": {
      "name": "John Doe",
      "phone": "+628123456789",
      "email": "john@example.com",
      "nik": "1234567890123456"
    },
    "branch": {
      "id": 1,
      "name": "Kantor Pusat"
    }
  }
}
```

### **PUT /api/users/{id}**
Update user details.

**Headers:**
```http
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

**Request Body:**
```json
{
  "email": "updated@example.com",
  "status": "active"
}
```

**Response:**
```json
{
  "success": true,
  "data": { /* Updated user data */ }
}
```

### **DELETE /api/users/{id}**
Delete user (soft delete).

**Headers:**
```http
Authorization: Bearer <JWT_TOKEN>
```

**Response:**
```json
{
  "success": true,
  "message": "User deleted successfully"
}
```

### **GET /api/users/profile**
Get current user profile.

**Headers:**
```http
Authorization: Bearer <JWT_TOKEN>
```

**Response:**
```json
{
  "success": true,
  "data": { /* Current user data */ }
}
```

### **PUT /api/users/password**
Update current user password.

**Headers:**
```http
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

**Request Body:**
```json
{
  "current_password": "oldpassword123",
  "new_password": "NewPassword123!",
  "confirm_password": "NewPassword123!"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Password updated successfully"
}
```

---

## 📊 **Dashboard Endpoints**

### **GET /api/dashboard/stats**
Get dashboard statistics.

**Headers:**
```http
Authorization: Bearer <JWT_TOKEN>
```

**Response:**
```json
{
  "success": true,
  "data": {
    "members": {
      "total_members": 150,
      "active_members": 120,
      "new_members_today": 2,
      "new_members_week": 8
    },
    "loans": {
      "total_loans": 75,
      "active_loans": 45,
      "completed_loans": 25,
      "late_loans": 5,
      "total_outstanding": 250000000
    },
    "savings": {
      "total_savings_accounts": 120,
      "total_savings_balance": 500000000,
      "deposits_today": 15
    },
    "financial": {
      "total_debits": 750000000,
      "total_credits": 500000000,
      "net_flow": 250000000
    }
  }
}
```

### **GET /api/dashboard/recent-activity**
Get recent activity feed.

**Headers:**
```http
Authorization: Bearer <JWT_TOKEN>
```

**Query Parameters:**
- `limit` (int) - Number of activities (default: 10, max: 50)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "type": "loan",
      "action": "approved",
      "description": "Loan 5000000 for John Doe (Pinjaman Mikro)",
      "timestamp": "2026-03-27 02:30:00",
      "user": "admin",
      "data": { /* Activity details */ }
    }
  ]
}
```

### **GET /api/dashboard/performance**
Get performance metrics.

**Headers:**
```http
Authorization: Bearer <JWT_TOKEN>
```

**Query Parameters:**
- `period` (string) - Period: day, week, month, quarter, year (default: month)

**Response:**
```json
{
  "success": true,
  "data": {
    "collections": {
      "total_collections": 150,
      "successful_collections": 140,
      "success_rate": 93.33,
      "total_collected": 75000000
    },
    "loans": {
      "total_loans": 50,
      "approved_loans": 45,
      "approval_rate": 90.0,
      "disbursed_loans": 40
    },
    "savings": {
      "total_deposits": 200,
      "total_deposits": 50000000,
      "average_deposit": 250000
    }
  }
}
```

---

## 🔧 **Utility Endpoints**

### **GET /api/utils/health-check**
System health check.

**Response:**
```json
{
  "success": true,
  "data": {
    "status": "healthy",
    "timestamp": "2026-03-27 02:34:00",
    "version": "1.0.0",
    "environment": "development",
    "database": "connected",
    "memory_usage": "32.5 MB",
    "uptime": "2 days, 14 hours"
  }
}
```

### **POST /api/utils/upload**
Upload file.

**Headers:**
```http
Authorization: Bearer <JWT_TOKEN>
Content-Type: multipart/form-data
```

**Request Body:**
```
file: <binary_data>
```

**Response:**
```json
{
  "success": true,
  "data": {
    "name": "document.pdf",
    "path": "/uploads/abc123def456.pdf",
    "size": 1048576,
    "type": "pdf"
  }
}
```

---

## 📋 **Master Data Endpoints**

### **GET /api/master/religions**
Get all religions.

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "code": "ISL",
      "name": "Islam",
      "description": "Agama Islam",
      "is_active": true
    }
  ]
}
```

### **GET /api/master/occupations**
Get all occupations.

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "code": "PNS",
      "name": "Pegawai Negeri Sipil",
      "category": "Pemerintah",
      "income_level": "medium",
      "is_active": true
    }
  ]
}
```

---

## 🚨 **Error Codes**

| Code | Description | Example |
|------|-------------|---------|
| 400 | Bad Request | Invalid input data |
| 401 | Unauthorized | Invalid or missing token |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource not found |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | System error |

---

## 🔍 **Validation Rules**

### **Password Requirements:**
- Minimum 8 characters
- At least 1 uppercase letter
- At least 1 lowercase letter  
- At least 1 number
- At least 1 special character

### **Username Requirements:**
- Minimum 3 characters
- Maximum 50 characters
- Alphanumeric and underscore only

### **Email Requirements:**
- Valid email format
- Maximum 255 characters

---

## 📝 **Logging**

All API activities are logged with:
- **User ID** - Who performed the action
- **Action** - What was done
- **Timestamp** - When it happened
- **IP Address** - Where it came from
- **User Agent** - Client information
- **Details** - Additional context

---

## 🛡️ **Security Features**

### **Input Sanitization:**
- XSS prevention
- SQL injection prevention
- HTML tag removal
- Whitespace trimming

### **Rate Limiting:**
- IP-based limiting
- Endpoint-specific limits
- Automatic ban on abuse

### **Authentication Security:**
- JWT tokens with expiration
- Password hashing (bcrypt)
- Secure password requirements
- Session management

---

## 🧪 **Testing**

### **Development Tools:**
- **Debug Panel** - Available at localhost
- **Error Logging** - Detailed error information
- **Performance Metrics** - Execution time tracking
- **Query Logging** - Database query monitoring

### **Debug Panel Commands:**
```javascript
// Available in browser console (localhost only)
window.PWA_DEBUG.clearCache()     // Clear all caches
window.PWA_DEBUG.forceUpdate()     // Force service worker update
window.PWA_DEBUG.subscribePush()   // Subscribe to push notifications
```

---

## 📚 **Code Examples**

### **JavaScript/Axios Example:**
```javascript
// Login
const login = async (username, password) => {
  try {
    const response = await axios.post('/api/auth/login', {
      username,
      password
    });
    
    const { token, user } = response.data.data;
    localStorage.setItem('token', token);
    
    return response.data;
  } catch (error) {
    console.error('Login failed:', error.response.data);
    throw error;
  }
};

// Get users with authentication
const getUsers = async (page = 1, search = '') => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.get('/api/users', {
      headers: {
        'Authorization': `Bearer ${token}`
      },
      params: {
        page,
        search,
        limit: 20
      }
    });
    
    return response.data;
  } catch (error) {
    console.error('Failed to get users:', error.response.data);
    throw error;
  }
};
```

### **PHP/cURL Example:**
```php
// API Request with cURL
function apiRequest($endpoint, $method = 'GET', $data = null, $token = null) {
    $url = 'http://localhost/api' . $endpoint;
    
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Accept: application/json'
    ]);
    
    if ($token) {
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json',
            'Accept: application/json',
            'Authorization: Bearer ' . $token
        ]);
    }
    
    if ($method === 'POST' && $data) {
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
    }
    
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    
    return [
        'data' => json_decode($response, true),
        'status' => $httpCode
    ];
}
```

---

## 🔄 **Version History**

### **v1.0.0** (2026-03-27)
- Initial API release
- Authentication endpoints
- User management endpoints
- Dashboard endpoints
- Master data endpoints
- Utility endpoints

---

## 📞 **Support**

For API support and questions:
- **Documentation**: This file
- **Error Logs**: `/logs/api-*.log`
- **Debug Mode**: Available in development
- **Contact**: Development team

---

*This documentation is automatically updated with API changes.*
