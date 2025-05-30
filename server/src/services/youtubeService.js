const axios = require('axios');

class YouTubeService {
    static async getVideoMetadata(videoUrl) {
        try {
            const videoId = videoUrl.split('v=')[1]?.split('&')[0];
            if (!videoId) throw new Error('Invalid YouTube URL');

            const response = await axios.get(
                `https://www.googleapis.com/youtube/v3/videos`,
                {
                    params: {
                        part: 'snippet,contentDetails',
                        id: videoId,
                        key: process.env.YOUTUBE_API_KEY,
                    },
                }
            );

            if (response.data.items.length === 0) throw new Error('Video not found');

            const video = response.data.items[0];
            const thumbnail = video.snippet.thumbnails.medium.url;
            const duration = this.parseDuration(video.contentDetails.duration);

            return {
                videoId,
                thumbnail,
                duration, // in seconds
                title: video.snippet.title,
            };
        } catch (error) {
            throw new Error(`Failed to fetch video metadata: ${error.message}`);
        }
    }

    static parseDuration(duration) {
        const regex = /PT(\d+H)?(\d+M)?(\d+S)?/;
        const match = duration.match(regex);
        let hours = parseInt(match[1] || '0');
        let minutes = parseInt(match[2] || '0');
        let seconds = parseInt(match[3] || '0');
        return hours * 3600 + minutes * 60 + seconds;
    }
}

module.exports = YouTubeService;