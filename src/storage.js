function checkStorage() {
    let good = "localStorage" in window;
    if (!good) {
        alert("Local storage is not supported currently.");
    }
    return good;
}

let storage = {
    getItem: function(str) {
        if (!checkStorage()) return;
        return window.localStorage.getItem(str);
    },
    
    getKeys: function(str) {
        if (!checkStorage()) return;
        return Object.keys(window.localStorage);
    },

    setItem: function(storageObj) {
        if (!checkStorage()) return;
        window.localStorage.setItem(storageObj.key, storageObj.value);
        return storageObj;
    },

    deleteItem: function(key) {
        if (!checkStorage()) return;
        window.localStorage.removeItem(key);
        return key;
    },
}

export { storage };
