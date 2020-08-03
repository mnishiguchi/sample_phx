import Player from './player';

export default {
  init(socket, element) {
    if (!element) return;
    const playerId = element.getAttribute(`data-player-id`);
    const videoId = element.getAttribute(`data-id`);
    socket.connect();
    Player.init(element.id, playerId, () => {
      this.onPlayerLoaded(videoId, socket);
    });
  },

  onPlayerLoaded(videoId, socket) {
    const msgContainer = document.getElementById(`msg-container`);
    const msgInput = document.getElementById(`msg-input`);
    const postButton = document.getElementById(`msg-submit`);
    const videoChannel = socket.channel(`videos:${videoId}`);
    videoChannel
      .join()
      .receive(`ok`, (resp) => console.log(`joined the video channel`, resp))
      .receive(`error`, (reason) => console.log(`join failed`, reason));
  },
};
