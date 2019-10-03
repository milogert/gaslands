//import './main.css';
import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

const app = Elm.Main.init({
  node: document.getElementById('root')
});

registerServiceWorker();

app.ports.share.subscribe(function(str) {
    if (!("share" in navigator))
    {
        alert("Sharing is not supported currently.");
        return;
    }
    window.navigator.share({text: str});
});

// Storage.
import { storage } from './storage.js';
app.ports.get.subscribe(function(str) {
    app.ports.getSub.send(storage.getItem(str));
});

app.ports.getKeys.subscribe(function(str) {
    app.ports.getKeysSub.send(storage.getKeys(str));
});

app.ports.set.subscribe(function(storageObj) {
    app.ports.setSub.send(storage.setItem(storageObj));
});

app.ports.delete.subscribe(function(key) {
    app.ports.deleteSub.send(storage.deleteItem(key));
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

/*
app.ports.open.subscribe(_ => {
    document.querySelector('body').classList.add('modal-open');
});

app.ports.close.subscribe(_ => {
    document.querySelector('body').classList.remove('modal-open');
});
*/
