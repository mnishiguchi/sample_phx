import Player from './player';

export default {
  init(socket, element) {
    if (!element) return;
    const playerId = element.getAttribute('data-player-id');
    const videoId = element.getAttribute('data-id');
    socket.connect();
    Player.init(element.id, playerId, () => {
      this.onPlayerLoaded(videoId, socket);
    });
  },

  onPlayerLoaded(videoId, socket) {
    const $msgContainer = document.getElementById('msg-container');
    const $msgInput = document.getElementById('msg-input');
    const $postButton = document.getElementById('msg-submit');

    const videoChannel = socket.channel(`videos:${videoId}`);

    $postButton.addEventListener('click', (e) => {
      const payload = { body: $msgInput.value, at: Player.getCurrentTime() };

      // Sent a new annotation to the server.
      videoChannel.push('new_annotation', payload).receive('error', (e) => {
        console.log(e);
      });

      // Clear the input.
      $msgInput.value = '';
    });

    // When we push an event to the server, we can opt to receive a response.
    videoChannel.on('new_annotation', (resp) => {
      this.renderAnnotation($msgContainer, resp);
    });

    videoChannel
      .join()
      .receive('ok', ({ annotations }) => {
        annotations.forEach((annotation) => this.renderAnnotation($msgContainer, annotation));
      })
      .receive('error', (reason) => {
        console.log('join failed', reason);
      });
  },

  // Escapes user input before injecting values into the page. This strategy
  // protects our users from XSS attacks.
  esc(str) {
    const div = document.createElement('div');
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
  },

  // Append an annotation to msgContainer. Scrolls the msgContainer at the
  // right point.
  renderAnnotation(msgContainer, { user, body, at }) {
    const template = document.createElement('div');

    template.innerHTML = `
    <a href="#" data-seek-"${this.esc(at)}">
      <b>${this.esc(user.username)}</b>: ${this.esc(body)}
    </a>
    `;
    msgContainer.appendChild(template);
    msgContainer.scrollTop = msgContainer.scrollHeight;
  },
};
