const { db } = require('../config/firebase');
const { collection, addDoc, getDocs, doc, updateDoc } = require('firebase/firestore');

class VideoProgress {
    static async create(userId, playlistId, videoUrl) {
        const progressRef = await addDoc(collection(db, 'videoProgress'), {
            userId,
            playlistId,
            videoUrl,
            status: 'incomplete',
            lastUpdated: new Date()
        });
        return progressRef.id;
    }

    static async updateStatus(progressId, status) {
        const progressRef = doc(db, 'videoProgress', progressId);
        await updateDoc(progressRef, {
            status,
            lastUpdated: new Date()
        });
    }

    static async getUserProgress(userId, playlistId) {
        const querySnapshot = await getDocs(collection(db, 'videoProgress'));
        const progress = [];
        querySnapshot.forEach(doc => {
            const data = doc.data();
            if (data.userId === userId && data.playlistId === playlistId) {
                progress.push({ id: doc.id, ...data });
            }
        });
        return progress;
    }
}

module.exports = VideoProgress;