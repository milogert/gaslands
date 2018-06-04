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
