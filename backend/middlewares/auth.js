require('dotenv').config();
const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET;
if (!JWT_SECRET) {
  console.warn('JWT_SECRET is not set in env — authentication will fail without it.');
}

function authenticateToken(req, res, next) {
  const auth = req.headers['authorization'] || '';
  const parts = auth.split(' ');
  if (parts.length !== 2 || parts[0] !== 'Bearer') {
 
    req.user = null;
    return next(); 
  }
  const token = parts[1];
  try {
    const payload = jwt.verify(token, JWT_SECRET);
    req.user = payload;
  } catch (err) {
    console.warn('JWT verify failed:', err && err.message);
    req.user = null;
  }
  next();
}

function authorizeRoles(...allowedRoles) {
  return (req, res, next) => {
    if (!req.user) return res.status(401).json({ success: false, error: 'Not authenticated' });
    const role = req.user.role || 'user';
    if (allowedRoles.includes(role)) return next();
    return res.status(403).json({ success: false, error: 'Forbidden' });
  };
}

function globalGuard(req, res, next) {
  const url = req.path;
  const method = req.method.toUpperCase();

  if ((method === 'POST' && url === '/create') || (method === 'POST' && url === '/login')) {
    return next();
  }

  if (method === 'GET' && url === '/select') {
    if (req.user && req.user.role === 'admin') return next();
    return res.status(403).json({ success: false, error: 'Forbidden' });
  }

  if (method === 'DELETE' && /^\/deleted\/\d+$/.test(url)) {
    if (req.user && req.user.role === 'admin') return next();
    return res.status(403).json({ success: false, error: 'Forbidden' });
  }

  if (method === 'POST' && /^\/update\/\d+$/.test(url)) {
    if (!req.user) return res.status(401).json({ success: false, error: 'Not authenticated' });

    const requestedId = req.path.split('/').pop();
    if (req.user.role === 'admin' || String(req.user.id) === String(requestedId)) return next();
    return res.status(403).json({ success: false, error: 'Forbidden' });
  }

  if (method === 'GET' && /^\/id\/\d+$/.test(url)) {
    if (!req.user) return res.status(401).json({ success: false, error: 'Not authenticated' });

    const requestedId = req.path.split('/').pop();
    if (req.user.role === 'admin' || String(req.user.id) === String(requestedId)) return next();
    return res.status(403).json({ success: false, error: 'Forbidden' });
  }

  if (!req.user) return res.status(401).json({ success: false, error: 'Not authenticated' });

  next();
}

module.exports = {
  authenticateToken,
  authorizeRoles,
  globalGuard,
};
