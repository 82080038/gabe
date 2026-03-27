<?php
/**
 * Script untuk memperbaiki path absolut menjadi relatif
 * untuk XAMPP subdirectory structure
 */

function fixPathsInFile($filePath) {
    if (!file_exists($filePath)) {
        echo "File tidak ada: $filePath\n";
        return false;
    }
    
    $content = file_get_contents($filePath);
    $originalContent = $content;
    
    // Fix asset paths
    $content = preg_replace('/href="\/assets\//', 'href="../assets/', $content);
    $content = preg_replace('/src="\/assets\//', 'src="../assets/', $content);
    $content = preg_replace('/action="\/pages\//', 'action="pages/', $content);
    $content = preg_replace('/href="\/pages\//', 'href="pages/', $content);
    
    // Fix common absolute paths
    $content = preg_replace('/href="\/dashboard"/', 'href="../pages/web/dashboard.php"', $content);
    $content = preg_replace('/href="\/login"/', 'href="../pages/login.php"', $content);
    $content = preg_replace('/href="\/logout"/', 'href="../logout.php"', $content);
    $content = preg_replace('/href="\/profile"/', 'href="../pages/profile.php"', $content);
    $content = preg_replace('/href="\/settings"/', 'href="../pages/settings.php"', $content);
    
    // Fix breadcrumb URLs
    $content = preg_replace('/\'url\' => \'\/([^\']+)\'/', "'url' => '../pages/$1.php'", $content);
    
    // Save if changed
    if ($content !== $originalContent) {
        file_put_contents($filePath, $content);
        echo "✅ Fixed: $filePath\n";
        return true;
    }
    
    return false;
}

// Find all PHP files
$iterator = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator(__DIR__ . '/pages')
);

$phpFiles = [];
foreach ($iterator as $file) {
    if ($file->isFile() && $file->getExtension() === 'php') {
        $phpFiles[] = $file->getPathname();
    }
}

echo "Memperbaiki path absolut dalam " . count($phpFiles) . " file PHP...\n\n";

$fixedCount = 0;
foreach ($phpFiles as $file) {
    if (fixPathsInFile($file)) {
        $fixedCount++;
    }
}

echo "\n✨ Selesai! $fixedCount file telah diperbaiki.\n";
?>
