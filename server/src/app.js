require('dotenv').config();
const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/authRoute');
const playlistRoutes = require('./routes/playlistRoute');
const videoRoutes = require('./routes/videoRoute');

const app = express();

app.use(cors({
    origin: process.env.FLUTTER_APP_URL || '*',
}));
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/playlists', playlistRoutes);
app.use('/api/videos', videoRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

module.exports = app;