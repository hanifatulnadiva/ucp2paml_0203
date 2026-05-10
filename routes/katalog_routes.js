const express = require('express');
const router = express.Router();
const katalogController = require('../controllers/katalog_controllers');
const {authenticateToken} = require('../middlewares/auth');

const {isAdmin} = require('../middlewares/permissionMiddlewares')

router.post('/', authenticateToken, isAdmin,katalogController.create_katalog);
router.put('/:id', authenticateToken, isAdmin, katalogController.update_katalog);
router.delete('/:id', authenticateToken, isAdmin,katalogController.delete_katalog);
router.get('/', katalogController.get_all_katalog);
router.get('/:id', katalogController.get_katalog_by_id);

module.exports = router;