import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

var app = Main.embed(document.getElementById('root'));

registerServiceWorker();

// receive something from Elm
app.ports.exportModel.subscribe(function (str) {
  var myWindow = window.open("", "_blank");
  myWindow.document.write(str);
});

app.ports.share.subscribe(function(str) {
    if (!("share" in navigator))
    {
        alert("Sharing is not supported currently.");
        return;
    }
    window.navigator.share({text: str});
});
