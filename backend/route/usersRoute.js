const express = require('express');
const router = express.Router();
const path = require('path');
const multer = require('multer');
const usersController = require('../controllers/usersControllers');

const { authenticateToken } = require('../middlewares/auth');
const { requireAdmin } = require('../middlewares/checkRole');

function adminOrOwner(req, res, next) {
  if (!req.user) return res.status(401).json({ success: false, error: 'Not authenticated' });
  const requestedId = String(req.params.id);
  if (req.user.role === 'admin' || String(req.user.id) === requestedId) return next();
  return res.status(403).json({ success: false, error: 'Forbidden' });
}

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, path.join(__dirname, '..', '..', 'uploads')),
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    const name = `${Date.now()}-${Math.round(Math.random() * 1e9)}${ext}`;
    cb(null, name);
  },
});
const upload = multer({ storage });

router.post('/create', usersController.create);
router.post('/login', usersController.login);

router.get('/select', authenticateToken, requireAdmin, usersController.selectAll);
router.get('/id/:id', authenticateToken, adminOrOwner, usersController.getById);
router.post(
  '/update/:id',
  authenticateToken,
  adminOrOwner,
  upload.single('photo'),
  usersController.update,
);
router.delete('/delete/:id', authenticateToken, requireAdmin, usersController.removeById);

module.exports = router;
