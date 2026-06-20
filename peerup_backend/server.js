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
    user: 'postgres',          
    host: 'localhost',
    database: 'PeerUp',      
    password: 'adhikari@023', 
    port: 5433,
});

// ==========================================
// 1. DUAL EXTENSION ROUTE: HYBRID FIREBASE SIGNUP SYNC
// ==========================================
app.post('/api/auth/signup', async (req, res) => {
    const { uid, name, email } = req.body;
    
    console.log("=== RECEIVED SIGNUP SYNC REQUEST FROM FLUTTER ===");
    console.log(`UID: ${uid}, Name: ${name}, Email: ${email}`);
    
    try {
        // Inserts the authenticated user into your local PostgreSQL database
        const queryText = `
            INSERT INTO users (uid, name, email) 
            VALUES ($1, $2, $3) 
            ON CONFLICT (uid) DO UPDATE SET name = $2, email = $3
            RETURNING *;
        `;
        const values = [uid, name, email];
        const result = await pool.query(queryText, values);
        
        console.log("Successfully recorded user in PostgreSQL database.");
        console.log("================================================");
        
        // CRITICAL: Returns a 201 Created status back so Flutter stops buffering!
        return res.status(201).json({ 
            success: true, 
            message: "User account synchronized successfully with local database.",
            user: result.rows[0]
        });
    } catch (err) {
        console.error("=== POSTGRESQL SIGNUP ERROR DETAILS ===");
        console.error(err);
        console.error("=======================================");
        
        return res.status(500).json({ 
            error: 'Failed to sync user to PostgreSQL', 
            details: err.message 
        });
    }
});

// Optional: Fallback login check endpoint if your architecture wants database verification
app.post('/api/auth/login', async (req, res) => {
    const { email } = req.body;
    try {
        const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
        if (result.rows.length > 0) {
            return res.status(200).json({ success: true, message: "User exists in local records." });
        } else {
            return res.status(200).json({ success: true, message: "New user profile check completed." });
        }
    } catch (err) {
        return res.status(500).json({ error: 'Database login query handshake failed.' });
    }
});

// ==========================================
// 2. DATA LAYERS: FETCH ALL SYSTEM SKILLS
// ==========================================
app.get('/api/skills', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM skills ORDER BY skill_name ASC');
        res.json(result.rows); 
    } catch (err) {
        console.error("=== POSTGRESQL SKILLS ERROR DETAILS ===");
        console.error(err);
        console.error("=======================================");
        
        res.status(500).json({ error: 'Database query failed', details: err.message });
    }
});

// Start backend server listening on all network interfaces for emulators
app.listen(PORT, '0.0.0.0', () => {
    console.log(`\n====================================================`);
    console.log(`🚀 Backend bridge running smoothly on port: ${PORT}`);
    console.log(`🔗 Local server endpoint: http://localhost:${PORT}`);
    console.log(`📱 Android Emulator connection map link: http://10.0.2.2:${PORT}`);
    console.log(`====================================================\n`);
});