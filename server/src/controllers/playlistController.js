const Playlist = require('../models/playlist');
const YouTubeService = require('../services/youtubeService');

const createPlaylist = async (req, res) => {
    try {
        const { name } = req.body;
        const userId = req.user.uid;
        const playlistId = await Playlist.create(userId, name);
        res.status(201).json({ id: playlistId, name });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const getPlaylists = async (req, res) => {
    try {
        const userId = req.user.uid;
        const playlists = await Playlist.getUserPlaylists(userId);
        const enrichedPlaylists = await Promise.all(
            playlists.map(async (playlist) => {
                if (playlist.videos.length > 0) {
                    const metadata = await YouTubeService.getVideoMetadata(playlist.videos[0]);
                    return {
                        ...playlist,
                        thumbnail: metadata.thumbnail,
                        totalDuration: metadata.duration,
                    };
                }
                return { ...playlist, thumbnail: null, totalDuration: 0 };
            })
        );
        res.status(200).json(enrichedPlaylists);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const addVideoToPlaylist = async (req, res) => {
    try {
        const { playlistId, videoUrl } = req.body;
        await Playlist.addVideo(playlistId, videoUrl);
        const metadata = await YouTubeService.getVideoMetadata(videoUrl);
        res.status(200).json({ message: 'Video added to playlist', metadata });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const deletePlaylist = async (req, res) => {
    try {
        const { playlistId } = req.params;
        await Playlist.deletePlaylist(playlistId);
        res.status(200).json({ message: 'Playlist deleted' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

module.exports = { createPlaylist, getPlaylists, addVideoToPlaylist, deletePlaylist };