var player;

function onYouTubeIframeAPIReady() {
  if (typeof YT == "undefined") {
    return;
  }

  player = new YT.Player('player', {
    height: '390',
    width: '640',
    videoId: videoId,
    events: {
      'onStateChange': onPlayerStateChange
    }
  });
}

function onPlayerStateChange(event) {
  if (event.data == YT.PlayerState.PLAYING && !done) {
    done = true;
  }
}

function stopVideo() {
  player.stopVideo();
}

$(function() {
  onYouTubeIframeAPIReady();
})
