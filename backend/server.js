require('dotenv').config();
const express = require('express');
const jwt = require('jsonwebtoken');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const PORT = process.env.PORT || 3000;

// Use secret key from .env file
const SECRET_KEY = process.env.SECRET_KEY;
const STREAM_API_KEY = process.env.STREAM_API_KEY;
const STREAM_API_SECRET = process.env.STREAM_API_SECRET;

//app.use(cors());
app.use(cors({ origin: '*' }));
app.use(bodyParser.json());

// Generate token for a user using Stream Secret
app.post('/generate-token', (req, res) => {
    const { userId } = req.body;

    if (!userId) {
        return res.status(400).json({ error: 'User ID is required' });
    }

    // Create JWT token using the Stream API Secret
     const token = jwt.sign({ user_id: userId }, SECRET_KEY, { expiresIn: '1h' });

    res.json({ token, apiKey: STREAM_API_KEY });
});

// Verify token
app.post('/verify-token', (req, res) => {
    const { token } = req.body;

    try {
        const decoded = jwt.verify(token, SECRET_KEY);
        res.json({ valid: true, decoded });
    } catch (error) {
        res.status(401).json({ valid: false, error: 'Invalid token' });
    }
});

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
