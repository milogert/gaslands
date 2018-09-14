function getUserMedia(options, successCallback, failureCallback) {
  var api = navigator.getUserMedia || navigator.webkitGetUserMedia ||
    navigator.mozGetUserMedia || navigator.msGetUserMedia;
  if (api) {
    return api.bind(navigator)(options, successCallback, failureCallback);
  }
}

var streamObj;

var photo = {
    getStream: function() {
        if (!navigator.mediaDevices) {
            alert('User Media API not supported.');
            return;
        }
          
        var constraints = {
            video: true
        };

        navigator.mediaDevices.getUserMedia(constraints)
            .then(function (stream) {
                var mediaControl = document.querySelector('video');
                if ('srcObject' in mediaControl) {
                    mediaControl.srcObject = stream;
                    mediaControl.src = (window.URL || window.webkitURL).createObjectURL(stream);
                } else if (navigator.mozGetUserMedia) {
                    mediaControl.mozSrcObject = stream;
                }
                streamObj = stream;
            })
            .catch(function (err) {
                alert('Error: ' + err);
            });
    },

    takePhoto: function() {
        if (!('ImageCapture' in window)) {
            alert('ImageCapture is not available');
            return;
        }

        if (!streamObj) {
            alert('Grab the video stream first!');
            return;
        }

        var theImageCapturer = new ImageCapture(streamObj.getVideoTracks()[0])
        var photo = theImageCapturer.takePhoto();
        console.log("taking photo", photo);
 
        return photo;
    },

    stopStream: function() {
        console.log("attempting to kill stream");
        if (!streamObj) return;
        console.log("killing stream");
        streamObj.getTracks()[0].stop();
    }
}

export { photo, stream };
