// assets/js/hooks/video_call.js
export default {
  mounted() {
    const roomName = this.el.dataset.roomName;
    const identity = this.el.dataset.identity;
    let localVideoTrack, localAudioTrack;
    
     console.log(this.el.dataset)

    Twilio.Video.connect(this.el.dataset.roomName, {
      name: roomName,
      video: true,
      audio: true,
      logLevel: 'debug',
      identity: identity
    }).then(room => {
      console.log('Successfully connected to Room: ' + room.name);

      room.localParticipant.tracks.forEach(publication => {
        if (publication.track.kind === 'video') {
          localVideoTrack = publication.track;
          document.getElementById('local-video').appendChild(localVideoTrack.attach());
        }
        if (publication.track.kind === 'audio') {
          localAudioTrack = publication.track;
        }
      });

      room.on('participantConnected', participant => {
        console.log('A remote Participant connected: ' + participant.identity);
      });

      room.on('participantDisconnected', participant => {
        console.log('A remote Participant disconnected: ' + participant.identity);
      });

      document.getElementById('mute-audio').addEventListener('click', () => {
        if (localAudioTrack.isEnabled) {
          localAudioTrack.disable();
          document.getElementById('mute-audio').innerText = 'Unmute Audio';
        } else {
          localAudioTrack.enable();
          document.getElementById('mute-audio').innerText = 'Mute Audio';
        }
      });

      document.getElementById('mute-video').addEventListener('click', () => {
        if (localVideoTrack.isEnabled) {
          localVideoTrack.disable();
          document.getElementById('mute-video').innerText = 'Unmute Video';
        } else {
          localVideoTrack.enable();
          document.getElementById('mute-video').innerText = 'Mute Video';
        }
      });

    }).catch(error => {
      console.error('Error connecting to Room: ' + error.message);
    });
 
}
};
 
