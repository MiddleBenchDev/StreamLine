const VideoProgress = require('../models/videoProgress');
const YouTubeService = require('../services/youtubeService');

const updateVideoStatus = async (req, res) => {
    try {
        const { progressId, status } = req.body;
        if (!['completed', 'incomplete'].includes(status)) {
            return res.status(400).json({ error: 'Invalid status' });
        }
        await VideoProgress.updateStatus(progressId, status);
        res.status(200).json({ message: 'Video status updated' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const getVideoProgress = async (req, res) => {
    try {
        const { playlistId } = req.params;
        const userId = req.user.uid;
        const progress = await VideoProgress.getUserProgress(userId, playlistId);
        const enrichedProgress = await Promise.all(
            progress.map(async (item) => {
                const metadata = await YouTubeService.getVideoMetadata(item.videoUrl);
                return {
                    ...item,
                    thumbnail: metadata.thumbnail,
                    duration: metadata.duration,
                };
            })
        );
        res.status(200).json(enrichedProgress);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const createVideoProgress = async (req, res) => {
    try {
        const { playlistId, videoUrl } = req.body;
        const userId = req.user.uid;
        const progressId = await VideoProgress.create(userId, playlistId, videoUrl);
        const metadata = await YouTubeService.getVideoMetadata(videoUrl);
        res.status(201).json({ id: progressId, metadata });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

module.exports = { updateVideoStatus, getVideoProgress, createVideoProgress };