const ns = "glom/teams/"
const checkStorage = () => {
    const good = "localStorage" in window
    if (!good) {
        alert("Local storage is not supported currently.")
    }
    return good
}

const getTeamStore = () => JSON.parse(window.localStorage.getItem(ns) || "{}")
const setTeamStore = obj => window.localStorage.setItem(ns, JSON.stringify(obj))

const storage = {
  getItem: str => {
    if (!checkStorage()) return;
    return getTeamStore()[str]
  },
    
  getKeys: str => {
    if (!checkStorage()) return;
    return Object.keys(getTeamStore());
  },

  getStorage: str => {
    if (!checkStorage()) return
    const teams = getTeamStore()
    return Object.keys(teams).map(k => [k, teams[k]])
  },

  setItem: storageObj => {
    if (!checkStorage()) return;
    const teams = getTeamStore()
    setTeamStore({...teams, [storageObj.key]: storageObj.value});
    return storageObj;
  },

  deleteItem: key => {
    if (!checkStorage()) return;
    const teams = getTeamStore()
    delete teams[key]
    setTeamStore(teams);
    return key;
  },
}

export { storage };
