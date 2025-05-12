![Downloads](https://img.shields.io/github/downloads/Moon-Store/moon-permakill/total?logo=github)
![Contributors](https://img.shields.io/github/contributors/Moon-Store/moon-permakill?color=blue)
![Release](https://img.shields.io/github/v/release/Moon-Store/moon-permakill?label=release)

# 🪦 QBCore Perma-Kill System

A lightweight and effective **Perma-Kill system** for QBCore-based servers that allows you to **permanently kill a character** without deleting their data. This system prevents dead characters from being selected on login, while offering server admins control via recovery commands.

---

## 🧠 Features

- 🔒 **Perma-Death Enforcement**  
  Characters marked as dead cannot be selected through `qb-multicharacter`.

- 📁 **Data Preservation**  
  Characters are not deleted—only flagged. Ideal for roleplay appeal workflows.

- 🔄 **Admin Commands**  
  - `/permakill [citizenid]`: Flag character as permanently dead.  
  - `/unpermakill [citizenid]`: Recover character.

- 🧩 **Seamless UI Feedback**  
  Gracefully blocks character selection and shows an in-game notification when character is dead.

---

## ⚙️ Installation

### 1. Update Your Database

Run this query:
```sql
ALTER TABLE players ADD COLUMN permakilled TINYINT(1) DEFAULT 0;
```

### 2. Modify Multicharacter Logic

#### `qb-multicharacter/html/index.html`
Replace `play_character()` function:
```js
play_character: function() {
    if (this.selectedCharacter && this.selectedCharacter !== -1) {
        var data = this.characters[this.selectedCharacter];

        if (data !== undefined) {
            axios.post('https://qb-multicharacter/selectCharacter', {
                cData: data
            }).then((response) => {
                if (response.data === "ok") {
                    setTimeout(function() {
                        viewmodel.show.characters = false;
                    }, 500);
                } else if (response.data === "cancel") {
                    console.log("Character selection cancelled due to permakill.");
                }
            });
        } else {
            this.registerData.firstname = undefined;
            this.registerData.lastname = undefined;
            this.registerData.nationality = undefined;
            this.registerData.gender = undefined;
            this.registerData.date = (new Date(Date.now() - (new Date()).getTimezoneOffset() * 60000)).toISOString().substr(0, 10);

            this.show.characters = false;
            this.show.register = true;
        }
    }
}
```

#### `qb-multicharacter/client/main.lua`
Replace `selectCharacter` callback:
```lua
RegisterNUICallback('selectCharacter', function(data, cb)
    local cData = data.cData

    QBCore.Functions.TriggerCallback('moon-permakill:checkPermakill', function(isDead)
        if isDead then
            TriggerEvent("QBCore:Notify", "This character is dead. Appeal on Discord.", "error")
            cb("cancel")
            return
        end

        DoScreenFadeOut(10)
        TriggerServerEvent('qb-multicharacter:server:loadUserData', cData)
        openCharMenu(false)
        SetEntityAsMissionEntity(charPed, true, true)
        DeleteEntity(charPed)
        cb("ok")
    end, cData.citizenid)
end)
```

---

## 📦 Commands

| Command | Description |
|--------|-------------|
| `/permakill [citizenid]` | Permanently flags a character as dead |
| `/unpermakill [citizenid]` | Recovers a character by unflagging |

---

## 🧪 Use Cases

- Hardcore RP servers with permadeath mechanics  
- Gang wars, police shootouts, or long-term injury consequences  
- Character bans without database deletion

---

## 🙌 Credits

Created by [Moon Scripts](https://moon-scriptsstore.tebex.io) for marketing and educational purposes.  
Join the [Support & Dev Discord](https://discord.gg/ukdw25av2V) or [Store Discord](https://discord.gg/khN9aqTnY6) if you need help or want custom scripts.

---

## ❤️ Support the Project

This resource is released **for free** to support the FiveM community and showcase our development quality.

If you find it useful:
- ⭐ Leave a GitHub star
- 📢 Share with other developers
- 💸 [Support us on Tebex](https://moon-scriptsstore.tebex.io)

Your support helps us invest more into free, high-quality releases.
