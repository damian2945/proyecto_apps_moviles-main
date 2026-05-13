const Product = require('../models/productModel');

class ProductController {
    // GET - Obtener todos los productos
    static async getAllProducts(req, res) {
        try {
            const products = await Product.getAll();
            res.status(200).json({
                success: true,
                data: products,
                count: products.length
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                message: 'Error al obtener productos',
                error: error.message
            });
        }
    }

    // GET - Obtener un producto por ID
    static async getProductById(req, res) {
        try {
            const { id } = req.params;
            const product = await Product.getById(id);
            
            if (!product) {
                return res.status(404).json({
                    success: false,
                    message: 'Producto no encontrado'
                });
            }

            res.status(200).json({
                success: true,
                data: product
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                message: 'Error al obtener el producto',
                error: error.message
            });
        }
    }

    // POST - Crear un nuevo producto
    static async createProduct(req, res) {
        try {
            const productData = req.body;
            
            // Validación básica
            if (!productData.nombre || !productData.precio) {
                return res.status(400).json({
                    success: false,
                    message: 'Nombre y precio son obligatorios'
                });
            }

            const result = await Product.create(productData);
            
            // Obtener el producto recién creado
            const newProduct = await Product.getById(result.insertId);
            
            res.status(201).json({
                success: true,
                message: 'Producto creado exitosamente',
                data: newProduct
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                message: 'Error al crear el producto',
                error: error.message
            });
        }
    }

    // PUT - Actualizar un producto
    static async updateProduct(req, res) {
        try {
            const { id } = req.params;
            const productData = req.body;

            // Verificar si el producto existe
            const existingProduct = await Product.getById(id);
            if (!existingProduct) {
                return res.status(404).json({
                    success: false,
                    message: 'Producto no encontrado'
                });
            }

            await Product.update(id, productData);
            
            // Obtener el producto actualizado
            const updatedProduct = await Product.getById(id);

            res.status(200).json({
                success: true,
                message: 'Producto actualizado exitosamente',
                data: updatedProduct
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                message: 'Error al actualizar el producto',
                error: error.message
            });
        }
    }

    // DELETE - Eliminar un producto
    static async deleteProduct(req, res) {
        try {
            const { id } = req.params;

            // Verificar si el producto existe
            const existingProduct = await Product.getById(id);
            if (!existingProduct) {
                return res.status(404).json({
                    success: false,
                    message: 'Producto no encontrado'
                });
            }

            await Product.delete(id);

            res.status(200).json({
                success: true,
                message: 'Producto eliminado exitosamente'
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                message: 'Error al eliminar el producto',
                error: error.message
            });
        }
    }

    // GET - Buscar productos por nombre
    static async searchProducts(req, res) {
        try {
            const { nombre } = req.query;
            
            if (!nombre) {
                return res.status(400).json({
                    success: false,
                    message: 'Parámetro de búsqueda "nombre" es requerido'
                });
            }

            const products = await Product.searchByName(nombre);

            res.status(200).json({
                success: true,
                data: products,
                count: products.length
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                message: 'Error al buscar productos',
                error: error.message
            });
        }
    }
}

module.exports = ProductController;