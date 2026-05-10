const express = require('express');
const router = express.Router();
const kategoriController = require('../controllers/kategori_controller');

const {authenticateToken} = require('../middlewares/auth');
const {isAdmin} = require('../middlewares/permissionMiddlewares')

router.post('/', authenticateToken, isAdmin, kategoriController.create_kategori);

router.put('/:id', authenticateToken, isAdmin, kategoriController.update_kategori);

router.delete('/:id', authenticateToken, isAdmin, kategoriController.delete_kategori);

router.get('/', authenticateToken, isAdmin, kategoriController.get_all_kategori);

module.exports = router;