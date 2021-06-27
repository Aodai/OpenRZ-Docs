---
title: Grimoire v4.11.1
authors: iSmokeDrow
date: 2021.6.18
---


## Description
---

Grimoire is a powerful multi-purpose Rappelz asset management suite, written in c# by iSmokeDrow with nearly 5 years of active development.

Built on top of libraries like:

- [DataCore](https://github.com/iSmokeDrow/DataCore) *(Data.XXX Management)*
- [Daedalus](https://github.com/iSmokeDrow/Daedalus) *(RDB Management)* 

It can deliver an easy and fast user experience.

## Version
---

**4.11.1**

## Features
---

### General

- In-Depth settings menu
- Seemless and powerful tab style management
- Easy and fast new tab selection/creation
- Configurable Styles List (Advanced users ONLY!)
- Selectable Default Style
- Powerful Database configuration
- Quick and helpful keycombos
	- CTRL + O (Open File) [RDB/DATA]
	- CTRL + S (Save File) [RDB]
	- CTRL + F (Search) [RDB]
	- CTRL + N (New Tab, same type as currently loaded) [ALL]
	- SHIFT + N (New Tab, if Data is loaded) [DATA]
	- CTRL + R (Rebuild Client) [DATA]

### Data.XXX Management
---

- File Backups
- Load
	- File > Load
	- Drop file onto clean Data Tab
	- Definable Default Directory
- View client file index
	- View detailed information by clicking on a filename
	- View detailed information about a given extension by opening its node in the right-hand drop tree view
	- Filter viewed index by clicking a particular extension
- Export
	- All
	- By extension
	- By selected in grid (single/multiple)
- Insert
	- Single/Multiple
	- Drag-N-Drop file'(s) onto loaded Client file index
- Create New Client (from Export > All dump)
	- Option to clear Data tab on successful creation or load created client to grid
- Search
	- All
	- In Filtered Index (by extension)
- Compare (stored with external)
- Rebuild via Rebuild Wizard
	- View Current Size | File Count | Fragmentation % (per data.xxx or all)
	- View visual presentation of Size vs Fragmentation via Pie Chart
	- Statistics and Pie Chart update in real time during rebuild

### RDB Editing
---

- User defined structures [LUA via MoonSharp]
	- Easy to use FieldTypes
	- Easy to use flags per field definition
	- Definable header
	- Definable fileName/tableName
	- ProcessRow functionality for indepth load/save requirements
	- Definable selectStatement/sqlColumns for up/down patching across different epics
- Easy-to-use fast drop-down structures list (populated on tab creation)
	- Drop-Down select
	- Type with auto-completed (press enter to load)
- Load
	- From File
		- By File menu
		- By dropping file onto clean RDB Tab
	- From SQL
	- From Data (Data.XXX)
	- Definable Default Directory
- Save
	- To File
		- As encrypted or plain name
		- With or without (ascii)
	- To SQL Table
		- Ability to backup/script schema only/schema and data in scripts
	- To CSV file
	- To SQL file
- Ability to Sort visible colums (ascending/descending) by clicking the column header
- Ability to Search any loaded column

### File Hashing
---

- Hash name in realtime w/flip option
- Add files to grid
	- By right clicking grid
	- Dropping File/Folder onto hasher tab grid
	- Add/Remove (ascii) during add
- Auto-Conversion
- Auto-Clear tab after successful conversion

### Flag Utility
---

- Customizable flag lists
- Switch flag list easy
- Covers multiple bit flag fields like
	- stateresource buff opt_var
	- stateresource state_time_type
	- itemresource item_use_flag
- Auto convert
- Calculate AND Reverse calculations

## Documentation
---

- [Grimoire](/documentation/grimoire-doc/)
- [DataCore](/documentation/datacore-doc/)
- [Daedalus](/documentation/daedalus-doc/)

## Download
---

[v4.11.1](https://github.com/iSmokeDrow/Grimoire/releases/tag/v4.11.1)