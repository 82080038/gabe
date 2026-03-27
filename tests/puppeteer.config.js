module.exports = {
    launchOptions: {
        headless: false,
        slowMo: 100,
        defaultViewport: {
            width: 1366,
            height: 768
        },
        args: [
            '--no-sandbox',
            '--disable-setuid-sandbox',
            '--disable-dev-shm-usage',
            '--disable-accelerated-2d-canvas',
            '--no-first-run',
            '--no-zygote',
            '--single-process',
            '--disable-gpu'
        ]
    },
    browserContext: 'default',
    exitOnPageError: false,
    timeout: 30000,
    waitForNavigation: [
        'load',
        'domcontentloaded',
        'networkidle0',
        'networkidle2'
    ]
};
