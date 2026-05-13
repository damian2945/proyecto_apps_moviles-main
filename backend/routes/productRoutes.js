const express = require('express');
const router = express.Router();
const ProductController = require('../controllers/productController');

// Rutas para productos
router.get('/productos', ProductController.getAllProducts);
router.get('/productos/buscar', ProductController.searchProducts);
router.get('/productos/:id', ProductController.getProductById);
router.post('/productos', ProductController.createProduct);
router.put('/productos/:id', ProductController.updateProduct);
router.delete('/productos/:id', ProductController.deleteProduct);

module.exports = router;