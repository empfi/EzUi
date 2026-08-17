const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 3002;
const FILE_PATH = path.join(__dirname, 'library.lua');

const server = http.createServer((req, res) => {
    // CORS & No-Cache Headers for Roblox HttpGet
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
    res.setHeader('Pragma', 'no-cache');
    res.setHeader('Expires', '0');
    res.setHeader('Content-Type', 'text/plain; charset=utf-8');

    if (req.url === '/library.lua' || req.url === '/') {
        fs.readFile(FILE_PATH, 'utf8', (err, data) => {
            if (err) {
                res.statusCode = 500;
                res.end(`Error reading library.lua: ${err.message}`);
                return;
            }
            res.statusCode = 200;
            res.end(data);
            console.log(`[${new Date().toLocaleTimeString()}] Served library.lua (${data.length} bytes)`);
        });
    } else {
        res.statusCode = 404;
        res.end('Not Found');
    }
});

server.listen(PORT, '0.0.0.0', () => {
    console.log(`====================================================`);
    console.log(`  EZUI Local Dev Server Running!`);
    console.log(`  Serving: ${FILE_PATH}`);
    console.log(`  Local URL: http://127.0.0.1:${PORT}/library.lua`);
    console.log(`  Roblox Loadstring:`);
    console.log(`  loadstring(game:HttpGet("http://127.0.0.1:${PORT}/library.lua"))()`);
    console.log(`====================================================`);
});
