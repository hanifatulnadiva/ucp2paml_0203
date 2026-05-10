const express = require('express');
const router = express.Router();
const kategoriController = require('../controllers/kategori_controller');

router.post('/', kategoriController.create_kategori);

router.put('/:id', kategoriController.update_kategori);

router.delete('/:id', kategoriController.delete_kategori);

router.get('/', kategoriController.get_all_kategori);

module.exports = router;