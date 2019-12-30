const ns = "glom/teams/"
const checkStorage = () => {
    const good = "localStorage" in window
    if (!good) {
        alert("Local storage is not supported currently.")
    }
    return good
}

const getTeamStore = () => JSON.parse(window.localStorage.getItem(ns + "teams") || "{}")
const setTeamStore = obj => window.localStorage.setItem(ns + "teams", JSON.stringify(obj))

const getLastTeam = () => window.localStorage.getItem(ns + "latest") || "NoName"
const setLastTeam = str => window.localStorage.setItem(ns + "latest", str)

const jsonToStorageEntry = (key, json_) => {
  const parsed = JSON.parse(json_)
  return {
    key: key,
    name: parsed.name || "NoName (missing name from storage)",
    value: json_,
  }
}

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
    return Object.values(teams)
  },

  setItem: storageObj => {
    if (!checkStorage()) return;
    const teams = getTeamStore()
    setTeamStore({...teams, [storageObj.key]: storageObj});
    return storageObj;
  },

  deleteItem: key => {
    if (!checkStorage()) return;
    const teams = getTeamStore()
    delete teams[key]
    setTeamStore(teams);
    return key;
  },

  getLastTeam: str => {
    if (!checkStorage()) return
    const lastTeam = Object.values(getTeamStore()).sort().reverse()[0]
    if (!lastTeam) {
      return {
        key: "NoName",
        name: "",
        value: "{}",
      }
    }

    const ret = {
      key: lastTeam.key,
      name: lastTeam.name || "",
      value: lastTeam.value || '{}'
    }
    return ret
  },

  setLastTeam: team => {
    if (!checkStorage()) return
    console.log(`setting last team: >${team}<`)
    setLastTeam(team)
    return team
  }
}

export { storage };
