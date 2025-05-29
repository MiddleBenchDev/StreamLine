const VideoProgress = require('../models/videoProgress');

const updateVideoStatus = async (req, res) => {
    try {
        const { progressId, status } = req.body;
        if (!['completed', 'incomplete'].includes(status)) {
            return res.status(400).json({ error: 'Invalid status' });
        }
        await VideoProgress.updateStatus(progressId, status);
        res.json({ message: 'Video status updated' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const getVideoProgress = async (req, res) => {
    try {
        const { playlistId } = req.params;
        const userId = req.user.uid;
        const progress = await VideoProgress.getUserProgress(userId, playlistId);
        res.json(progress);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const createVideoProgress = async (req, res) => {
    try {
        const { playlistId, videoUrl } = req.body;
        const userId = req.user.uid;
        const progressId = await VideoProgress.create(userId, playlistId, videoUrl);
        res.json({ id: progressId });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

module.exports = { updateVideoStatus, getVideoProgress, createVideoProgress };