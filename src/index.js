import './main.css';
import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

const app = Elm.Main.init({
  node: document.getElementById('root')
});

console.log(app.ports);

registerServiceWorker();

app.ports.share.subscribe(function(str) {
    if (!("share" in navigator))
    {
        alert("Sharing is not supported currently.");
        return;
    }
    window.navigator.share({text: str});
});

app.ports.get.subscribe(function(str) {
    if (!("localStorage" in window))
    {
        alert("Local storage is not supported currently.");
        return;
    }
    app.ports.getSub.send(window.localStorage.getItem(str));
});

app.ports.getKeys.subscribe(function(str) {
    if (!("localStorage" in window))
    {
        alert("Local storage is not supported currently.");
        return;
    }
    app.ports.getKeysSub.send(Object.keys(window.localStorage));
});

app.ports.set.subscribe(function(storageObj) {
    if (!("localStorage" in window))
    {
        alert("Local storage is not supported currently.");
        return;
    }
    window.localStorage.setItem(
        storageObj.key, storageObj.value
    );
    app.ports.setSub.send(storageObj);
});

app.ports.delete.subscribe(function(key) {
    if (!("localStorage" in window))
    {
        alert("Local storage is not supported currently.");
        return;
    }
    window.localStorage.removeItem(key);
    app.ports.deleteSub.send(key);
});

// Photo capabilities.
import { photo } from './photo.js';
app.ports.getStream.subscribe(function(nothing) {
    photo.getStream();
});

app.ports.takePhoto.subscribe(function(nothing) {
    photo
        .takePhoto()
        .then(blob => {
            let reader = new FileReader();
            reader.onload = function() {
                console.log(reader.result);

                var url = URL.createObjectURL(blob);
                console.log("url", url);
                //app.ports.getPhotoUrl.send(reader.result);
                app.ports.getPhotoUrl.send(url);
                photo.stopStream();
            };
            reader.readAsDataURL(blob);
        })
        .catch(err => console.error('Error: ' + err));
});

app.ports.destroyStream.subscribe(nothing => photo.stopStream());
