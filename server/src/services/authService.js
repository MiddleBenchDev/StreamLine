const { auth } = require('../config/firebase');
const { signInWithPopup, GoogleAuthProvider } = require('firebase/auth');

const googleProvider = new GoogleAuthProvider();

const signInWithGoogle = async () => {
    try {
        const result = await signInWithPopup(auth, googleProvider);
        return result.user;
    } catch (error) {
        throw new Error(error.message);
    }
};

module.exports = { signInWithGoogle };