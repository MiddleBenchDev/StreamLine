const Playlist = require('../models/playlist');

const createPlaylist = async (req, res) => {
    try {
        const { name } = req.body;
        const userId = req.user.uid;
        const playlistId = await Playlist.create(userId, name);
        res.json({ id: playlistId, name });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const getPlaylists = async (req, res) => {
    try {
        const userId = req.user.uid;
        const playlists = await Playlist.getUserPlaylists(userId);
        res.json(playlists);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const addVideoToPlaylist = async (req, res) => {
    try {
        const { playlistId, videoUrl } = req.body;
        await Playlist.addVideo(playlistId, videoUrl);
        res.json({ message: 'Video added to playlist' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const deletePlaylist = async (req, res) => {
    try {
        const { playlistId } = req.params;
        await Playlist.deletePlaylist(playlistId);
        res.json({ message: 'Playlist deleted' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

module.exports = { createPlaylist, getPlaylists, addVideoToPlaylist, deletePlaylist };