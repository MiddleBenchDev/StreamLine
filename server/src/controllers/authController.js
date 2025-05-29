const { signInWithGoogle } = require('../services/authService');

const login = async (req, res) => {
    try {
        const user = await signInWithGoogle();
        const token = await user.getIdToken();
        res.json({ token, user: { uid: user.uid, displayName: user.displayName } });
    } catch (error) {
        res.status(401).json({ error: error.message });
    }
};

module.exports = { login };