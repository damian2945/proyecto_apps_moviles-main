const mysql = require('mysql2');

// Crear pool de conexiones con soporte para promesas
const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'tienda'
});

// Probar la conexión
pool.getConnection((error, connection) => {
    if (error) {
        console.error('❌ Error conectando a MySQL:', error.message);
        return;
    }
    console.log('✅ Conectado a la base de datos MySQL!');
    connection.release();
});

// Exportar con promesas para usar async/await
module.exports = pool.promise();