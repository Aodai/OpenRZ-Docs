---
title: NFMapEdit Documentation
authors: iSmokeDrow
date: 2020.1.5
---

## Definitions
---

* **NFA** *(nFlavor Attribute)* - Contains polygons used for collision/bounding.
* **NFC** *(nFlavor Local/Region)* - Contains information regarding regions (such as area title, bgm, sky/fog/cloud colors as-well as region ambient, diffuse and specular lighting, weather and more)
* **NFE** *( nFlavor Event)* - Contains LUA script triggers, such as on_init, on_enter, on_leave which can be used to spawn monsters/props or otherwise further quests etc.
* **NFK** *( nFlavor Camera Work)* - Contains camera movement information. *(such as the opening scene after creating a new character. !!!The SFrame is coded to only recognize the three existing nfk!!!)
* **NFL** *( nFlavor Lighting)* - Contains lighting (directional, omni-directional) information that can be processed through [Light Map Generator](http://openrz.ddns.net/t/map-utility-light-map-generator/57) to create shadows on props/terrain.
* **NFM** *( nFlavor Map)* - Contains information regarding the terrain (such as height, terrain textures and static props)
* **NFP** *(nFlavor Path)* - Contains information regarding automated walking paths (for monster, npc etc)
* **NFS** *( nFlavor Script)* - Contains information regarding monster spawns (similar to NFE)
* **NFW** *(nFlavor Water)* - Contains information regarding water placed on the terrain
* **GCI/GC2** *( nFlavor Grass Colony)* - Contains information regarding grass on the terrain
* **QPF** *(Quest Prop File)* - Contains information regarding props that can be interacted with by the player. 


## First start
---

When starting for the first time, you will be requested to provide a 'Resource' folder. This is the folder where a structured/unstructured client dump is located.

However, with this version you can also provide a client directory (containing data.000-008)


## Panes
---

### Area Selection

This pane allows selecting areas of the terrain (by dragging a square onto the displayed terrain) is denoted by a black and white checkered area. 

*(Unless View > Always Show Selection is checked, the area select tool and selected area can only be used in this pane)*

This pane also allows the generation/testing/view/camera configuration for the given maps PVS. [More information on PVS can be found here.](https://en.wikipedia.org/wiki/Potentially_visible_set)

You can find a thorough explanation of the controls in this tab below:

*Select Area**
* Select - *Selected the entire loaded terrain*
* Deselect - *Deselects currently selected terrain*

**Local PVS**

* Build PVS - *Generates a .pvs of the currently loaded terrain (this is for the entire loaded terrain)*
* test PVS - *Toggles PVS rendering to simulate the effect this pvs will have ingame*
* Distance - *??? Needs testing*
* Count - *??? Needs testing*
* Length - *??? Needs testing*
* Camera Offset - *??? Needs testing*
  * Position - *??? Needs testing*
  * Target - *??? Needs testing*
* SAMPLE Point Visible - *??? Needs testing*
* Preview - *??? Needs testing*

**User Sample Point**

* Enable - *Toggles user based PVS points*
* User Build PVS - *Generates PVS based on user points instead of automatic selection*
* All Delete Sample Point - *Removes all user placed points*
* Force Render - *??? Needs testing*

**Find Hole**

* '#'- *??? Needs testing*

**Segment Modify**

* Selection Prop - *??? Needs testing*
* Selection Segment - *??? Needs testing*
* None - *??? Needs testing*
* Export TXT - *??? Needs testing*
* Import TXT - *??? Needs testing*
* View Caption Segment - *??? Needs testing*
* View Caption Prop - *??? Needs testing*

#### Height Editor

This pane allows the user to alter the height of the loaded maps terrain. This includes; Raising/Lowering/Planarizing (leveling out varying terrain heights to a more common height) and flattening (useful for creating plateaus.)

You can find a thorough explanation of the controls in this tab below:

* Raise (F1) - *Raises the terrain by the given size and pressure (intensity)*
* Lower (F2) - *Lowers the terrain by the given size and pressure (intensity)*
* Planarize (F3) - *Planarize (averages) the terrain by the given size and pressure (intensity)*
- Ignore Palanarize Pressure (F4) - *Causes the Planarization of the terrain to ignore the pressure (intensity) currently selected*
* Flatten - *Flattens the terrain (useful to create plateaus)*

#### Tile Editor

This pane allows the users to lay/alter/remove textures on the loaded terrain. This includes the ability to blend up to three unique textures in a variety of blend ratios.

You can find a thorough explanation of the controls in this tab below:

*coming soon..*

## Opening Maps
---

Maps can be opened in multiple ways:

1. Press *(and holding)* the left 'ALT' key, then pressing the 'F' key, then pressing the 'O' key.
2. Click the 'File' menu and then click 'Open Map (O)'
3. Using the 'CTRL' + 'O' key combination
4. Provide proper 'X' and 'Y' map coordinates in the 'Information' group box
4.1 *Example: m009(x)_004(y) or x:9 y:4 is Horizon*
4.2 *No layer is required*
4.3 **# of Additional Maps to Load can load adjacent maps but performance takes a giant hit, it is not recommended to load more than 1 additional map**

## Camera Movement
---

The camera position can be moved in a variety of ways:

#### Keyboard

* `???` / `Num. Pad 8` - Forward *(x plane)*
* `???` / `Num. Pad 4` - Left *(y plane)*
* `???` / `Num. Pad 3` - Backward *(x plane)*
* `???` /  `Num. Pad 6` - Right *(y plane)*
* `Shift` - Increases the movement speed of the camera movement through the directional keys

#### Mouse

* Moving across the `x / y` plane
  * Press and hold the `Center / Scroll mouse wheel`and drag  the mouse.
* Panning 
  * Press and hold the `L. Ctrl` key and the `Center / Scroll mouse wheel` and drag the mouse.

*(to increase the camera movement speed hold the `Shift` key)*
