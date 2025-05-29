const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/authRoute');
const playlistRoutes = require('./routes/playlistRoute');
const videoRoutes = require('./routes/videoRoute');

const app = express();

app.use(cors());
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/playlists', playlistRoutes);
app.use('/api/videos', videoRoutes);

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

module.exports = app;