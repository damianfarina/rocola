Rocola.namespace("playlists");
Rocola.playlists.action_show = function() {
  var volume = 50;

  var init = function() {
    preparePlaySong();
    praparePlayerActions();
  }

  var praparePlayerActions = function() {
    $('#player_play').click(play);
    $('#player_pause').click(pause);
    $('#player_stop').click(stop);
    $('#player_volume_up').click(volume_up);
    $('#player_volume_down').click(volume_down);
  }

  var play = function() {
    window.player.resumeStream();
    return false;
  }
  var pause = function() {
    window.player.pauseStream();
    return false;
  }
  var stop = function() {
    window.player.stopStream();
    return false;
  }
  var volume_up = function() {
    if (volume < 100) {
      volume = volume + 5;
      set_volume();
    }
    return false;
  }
  var volume_down = function() {
    if (volume > 0) {
      volume = volume - 5;
      set_volume();
    }
    return false;
  }
  var set_volume = function() {
    window.player.setVolume(volume);
  }

  var preparePlaySong = function() {
    setCallbacks();
    $(document).on("click", "a[data-songid]", function(e) {
      debugger;
      e.preventDefault();
      playSong($(this).data("songid"));
    });
  }

  var setCallbacks = function() {
    if (window.player && window.player.setStatusCallback) {
      window.player.setSongCompleteCallback('onSongComplete');
      window.player.setErrorCallback('onErrorHappen');
      window.player.setStatusCallback('onStatusChange');
      window.player.setPositionCallback('onPositionChange');
    } else {
      setTimeout(setCallbacks, 1000);
    }
  }

  var playSong = function(song_id) {
    $.ajax({
      url: '/songs/' + song_id + '.json',
      type: 'GET',
      dataType: 'json',
      success: function(response) {
        responseData = response.result;
        window.player.playStreamKey(responseData.StreamKey, (responseData.url.split('?')[0]).replace("http://", "").replace("/stream.php", ""), responseData.StreamServerID);
      }
    });
  }

  return {
    init: init
  }
}();


var onErrorHappen = function(message) {
  console.log(message);
}

var onStatusChange = function(status) {
  console.log(status);
}

var onPositionChange = function(data) {
  if (data.position && (data.duration > 0)) {
    $('#position_bar').css('width', (100 * data.position / data.duration) + '%');
    var total_seconds = parseInt((data.duration - data.position) / 1000);
    var hours = Math.floor(total_seconds / 3600);
    total_seconds = total_seconds - hours * 3600;
    var minutes = Math.floor(total_seconds / 60);
    total_seconds = total_seconds - minutes * 60;
    var seconds = total_seconds;
    $('#duration').text("-" + hours + ":" + minutes + ":" + seconds );
  }
}

var onSongComplete = function() {
  console.log("Terminado el tema")
}