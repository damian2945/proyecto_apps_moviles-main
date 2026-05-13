const express = require('express');
const conexion = require('./config/database');
const cors = require('cors');
const app = express();
const rutaProductos = require('./routes/productRoutes.js');

app.use(cors());    
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/', rutaProductos);

const PORT = process.env.PORT || 3000;

app.listen(PORT, '0.0.0.0', () => {
    console.log(`✅ Servidor corriendo en puerto ${PORT}`);
    console.log(`🌐 Web: http://localhost:${PORT}`);
    console.log(`📱 Dispositivo móvil: http://192.168.1.5:${PORT}`);
});