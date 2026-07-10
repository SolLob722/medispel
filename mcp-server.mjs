import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const PORT = 8888;
const MIME = { '.html': 'text/html', '.js': 'text/javascript', '.mjs': 'text/javascript', '.css': 'text/css', '.png': 'image/png', '.jpg': 'image/jpeg', '.svg': 'image/svg+xml', '.json': 'application/json' };

process.env.DATABASE_URL = 'postgresql://netlifydb_owner:npg_cl3stJjUqv7O@ep-lingering-scene-ajbellc5.c-3.us-east-2.db.netlify.com/netlifydb?sslmode=require';

http.createServer(async (req, res) => {
  // MCP endpoint
  if (req.url === '/mcp' && req.method === 'POST') {
    try {
      const mcp = await import('../netlify/functions/mcp.mjs');
      const nodeReq = new Request(`http://localhost:${PORT}${req.url}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: await new Promise(r => { let d=[]; req.on('data', c=>d.push(c)); req.on('end', ()=>r(Buffer.concat(d).toString())); })
      });
      const nodeRes = await mcp.default(nodeReq);
      res.writeHead(nodeRes.status, Object.fromEntries(nodeRes.headers));
      res.end(await nodeRes.text());
    } catch (e) {
      res.writeHead(500, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: e.message }));
    }
    return;
  }

  // Serve static files
  let file = req.url === '/' ? '/admin-portal.html' : req.url;
  const fp = path.join(__dirname, file);
  if (!fs.existsSync(fp) || fs.statSync(fp).isDirectory()) {
    res.writeHead(404); res.end('Not found');
    return;
  }
  const ext = path.extname(file);
  res.writeHead(200, { 'Content-Type': MIME[ext] || 'text/plain', 'Access-Control-Allow-Origin': '*' });
  fs.createReadStream(fp).pipe(res);
}).listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
  console.log(`MCP endpoint at http://localhost:${PORT}/mcp`);
  console.log(`Admin portal at http://localhost:${PORT}`);
});
