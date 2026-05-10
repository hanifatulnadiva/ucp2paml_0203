const express = require('express');
const router = express.Router();
const katalogController = require('../controllers/katalog_controller');

router.post('/', katalogController.create_katalog);
router.put('/:id', katalogController.update_katalog);
router.delete('/:id', katalogController.delete_katalog);
router.get('/', katalogController.get_all_katalog);
router.get('/:id', katalogController.get_katalog_by_id);

module.exports = router;