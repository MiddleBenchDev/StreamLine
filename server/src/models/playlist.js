const { db } = require('../config/firebase');
const { collection, addDoc, getDocs, doc, updateDoc, deleteDoc, arrayUnion } = require('firebase/firestore');

class Playlist {
    static async create(userId, name) {
        const playlistRef = await addDoc(collection(db, 'playlists'), {
            userId,
            name,
            videos: [],
            createdAt: new Date().toISOString()
        });
        return playlistRef.id;
    }

    static async getUserPlaylists(userId) {
        const querySnapshot = await getDocs(collection(db, 'playlists'));
        const playlists = [];
        querySnapshot.forEach(doc => {
            if (doc.data().userId === userId) {
                playlists.push({ id: doc.id, ...doc.data() });
            }
        });
        return playlists;
    }

    static async addVideo(playlistId, videoUrl) {
        const playlistRef = doc(db, 'playlists', playlistId);
        await updateDoc(playlistRef, {
            videos: arrayUnion(videoUrl)
        });
    }

    static async deletePlaylist(playlistId) {
        await deleteDoc(doc(db, 'playlists', playlistId));
    }
}

module.exports = Playlist;