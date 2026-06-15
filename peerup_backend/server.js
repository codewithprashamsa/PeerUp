// peerup_backend/server.js
const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors()); // Allows your Flutter app to communicate with this server
app.use(express.json()); // Allows server to parse JSON bodies sent by Flutter

// PostgreSQL Connection configuration
const pool = new Pool({
    user: 'postgres',          // Your PostgreSQL username (usually postgres)
    host: 'localhost',
    database: 'PeerUp',      // The database name showing in your pgAdmin image (PeerUp or postgres)
    password: 'adhikari@023', 
    port: 5433,
});

// Test Endpoint: Fetching all system skills
// Updated Test Endpoint with precise error logging
app.get('/api/skills', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM skills ORDER BY skill_name ASC');
        res.json(result.rows); 
    } catch (err) {
        // This line prints the exact reason to your VS Code terminal window
        console.error("=== POSTGRESQL ERROR DETAILS ===");
        console.error(err);
        console.error("================================");
        
        res.status(500).json({ error: 'Database query failed', details: err.message });
    }
});

// Start backend server
app.listen(PORT, () => {
    console.log(`Backend bridge running smoothly on http://localhost:${PORT}`);
});