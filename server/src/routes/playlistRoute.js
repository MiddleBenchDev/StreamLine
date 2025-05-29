const express = require('express');
const authMiddleware = require('../middleware/authMiddleware');
const { createPlaylist, getPlaylists, addVideoToPlaylist, deletePlaylist } = require('../controllers/playlistController');
const router = express.Router();

router.use(authMiddleware);
router.post('/', createPlaylist);
router.get('/', getPlaylists);
router.post('/add-video', addVideoToPlaylist);
router.delete('/:playlistId', deletePlaylist);

module.exports = router;