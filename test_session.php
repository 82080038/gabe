<?php
session_start();

// Test session cookie persistence
echo "Testing session cookie persistence...\n";

// Check if session ID exists
if (isset($_COOKIE['PHPSESSID'])) {
    echo "✓ Session cookie exists: " . $_COOKIE['PHPSESSID'] . "\n";
} else {
    echo "✗ No session cookie found\n";
}

// Check if session data exists
if (isset($_SESSION['user'])) {
    echo "✓ Session data exists:\n";
    echo "  - User ID: " . $_SESSION['user']['id'] . "\n";
    echo "  - Username: " . $_SESSION['user']['username'] . "\n";
    echo "  - Role: " . $_SESSION['user']['role'] . "\n";
} else {
    echo "✗ No session data found\n";
    
    // Try to start session and check
    echo "Trying to initialize session...\n";
    session_regenerate_id(true);
    echo "✓ New session ID: " . session_id() . "\n";
}

// Test session file existence
$session_save_path = session_save_path();
echo "Session save path: " . $session_save_path . "\n";

$session_file = $session_save_path . '/sess_' . session_id();
if (file_exists($session_file)) {
    echo "✓ Session file exists: " . $session_file . "\n";
    echo "  File size: " . filesize($session_file) . " bytes\n";
} else {
    echo "✗ Session file not found: " . $session_file . "\n";
}

echo "\nSession persistence test completed.\n";
?>
