const express = require('express');
const authMiddleware = require('../middleware/authMiddleware');
const { updateVideoStatus, getVideoProgress, createVideoProgress } = require('../controllers/videoController');
const router = express.Router();

router.use(authMiddleware);
router.post('/progress', createVideoProgress);
router.put('/progress', updateVideoStatus);
router.get('/progress/:playlistId', getVideoProgress);

module.exports = router;