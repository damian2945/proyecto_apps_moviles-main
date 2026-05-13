const db = require('../config/database');

class Product {
    // Obtener todos los productos
    static async getAll() {
        try {
            const [rows] = await db.query('SELECT * FROM productos ORDER BY id DESC');
            return rows;
        } catch (error) {
            throw error;
        }
    }

    // Obtener un producto por ID
    static async getById(id) {
        try {
            const [rows] = await db.query('SELECT * FROM productos WHERE id = ?', [id]);
            return rows[0];
        } catch (error) {
            throw error;
        }
    }

    // Crear un nuevo producto
    static async create(productData) {
        try {
            const { nombre, precio, imagen } = productData;
            const [result] = await db.query(
                'INSERT INTO productos (nombre, precio, imagen, creado_en) VALUES (?, ?, ?, NOW())',
                [nombre, precio, imagen]
            );
            return result;
        } catch (error) {
            throw error;
        }
    }

    // Actualizar un producto
    static async update(id, productData) {
        try {
            const { nombre, precio, imagen } = productData;
            const [result] = await db.query(
                'UPDATE productos SET nombre = ?, precio = ?, imagen = ? WHERE id = ?',
                [nombre, precio, imagen, id]
            );
            return result;
        } catch (error) {
            throw error;
        }
    }

    // Eliminar un producto
    static async delete(id) {
        try {
            const [result] = await db.query('DELETE FROM productos WHERE id = ?', [id]);
            return result;
        } catch (error) {
            throw error;
        }
    }

    // Buscar productos por nombre
    static async searchByName(nombre) {
        try {
            const [rows] = await db.query(
                'SELECT * FROM productos WHERE nombre LIKE ?',
                [`%${nombre}%`]
            );
            return rows;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = Product;