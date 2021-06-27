---
title: Daedalus Documentation
authors: iSmokeDrow
date: 2020.6.25
---

# Daedalus Documentation

## Override List
---

Overrides are LUA variables that can be defined to change Daedalus behaviours during loading/saving operations.

Overrides:

- header <Defining a header will cause the engine to use this definition to process the file header instead of the normal .rdb header format>
- specialCase <Defining a special case will fundamentally change the behaviour of the engine! See example: [DBSKLTR]>
- sqlColumns <Defining this table of names will tell the Database engine in Daedalus to read/write ONLY these columns
instead of using the columns defined in 'fields'>
- selectStatement <Defining this will over-ride the Database engines select generation methods>

## Field Types 
---

- *The FIELDTYPE identifier must **ALWAYS** be **ALL CAPS** and any typos will result in program errors*
- *len is types length in bytes*
- *all fieldtypes can present a `default` value.*
- *all fieldtypes can set their own `show` (visibility) Can be 0 or 1*
- *all fieldtypes can present a `flag`, advanced use!*

|Type|Len|Args|Description|
|-|-|-|-|
|`BYTE`|1|`int` length|Reads `1` byte from the stream, otherwise reads `length` bytes from the stream. *(reading multiple bytes is generally used for padding*)|
|`BIT_VECTOR`|4|n/a|Reads `4` bytes from the stream into a `BitVector32` for per bit processing.|
|`BIT_FROM_VECTOR`|n/a|`int` bit_position, `string` dependency|This fieldtype is not read from the stream, the value is obtained by reading the `n` bit of the value stored by `dependency`. *(must be an `int`)*|
|`INT16/SHORT`|2|n/a|Reads `2`bytes from the stream as an `short`|
|`UINT16/USHORT`|2|n/a|Reads `2` bytes from the stream as an `ushort`|
|`INT32/INT`|4|n/a|Reads `4` bytes from the stream as an `int`|
|`UINT32/UINT`|4|n/a|Reads `4` bytes from the stream as an `uint`|
|`INT64/LONG`|4|n/a|Reads `8` bytes from the stream as an `long`|
|`UINT64/ULONG`|4|n/a|Reads `8` bytes from the stream as an `ulong`|
|`SINGLE`|4|n/a|Reads `4` bytes from the stream as an `single`|
|`FLOAT`|4|n/a|Reads `4` bytes from the stream as an `single`|
|`DOUBLE`|8|n/a|Reads `8` bytes from the stream as an `double`|
|`FLOAT64`|8|n/a|Reads `8` bytes from the stream as an `double`|
|`DECIMAL`|4|n/a|Reads `4` bytes from the stream as an `decimal`|
|`DATETIME`|4|n/a|Reads `4` bytes from the stream as an `int` *(seconds since epoch)* which is stored as an `DateTime`|
|`SID`|n/a|n/a|This `fieldtype` is not read from the stream, the value starts at `1` and is incremented for every row read from the rdb.|
|`STRING`|n/a|`int` length|Reads `length` bytes from the stream and encodes them into a string according to currently selected `Encoding`|
|`STRING_LEN`|4|n/a|This `fieldtype` reads a `4` byte `int` from the stream and is later used to provide the length for a `STRING_BY_LEN` cell.|
|`STRING_BY_LEN`|n/a|`string` dependency|This field type gets its length from a previously defined `STRING_LEN` cell by the name of `dependency` and is then read and encoded according to currently selected `Encoding`|
|`STRING_BY_REF`|n/a|`string` dependency|This field type gets its length from a header cell of type `int`|

**Dependency Note:**

- Usage: `{ "fieldName", STRING_BY_REF, dependency="headerFieldName" }`
- Description:
	- Fields marked with a dependency means they rely on another field

**Possible Flags:**

- `ROWCOUNT` *(used in header definition to denote engine loop count)*
- `LOOPCOUNTER` *(used in specialCase=DOUBLELOOP files)*


## Defining Field Lists 
---

There are two types of lists that can be defined in a structure.lua, those are:
- header *(All fields in this list will be used to process a files header)*
- fields *(All fields in this list will be used to process a files contents)*

### Defining Header
---
Normally the header of any given .rdb is as follows:

- Date `8 bytes`
- Blank `120 bytes`
- Row Count `4 bytes`

**In this case, you will simply NOT define a header!**

However in special cases (e.g. `.ref` files) the header is different, which will cause an issue with Deadalus reading this file, to fix this we can now simply script our header by defining a field list as we would below, but giving it the name `header`. See the example below:

The `header` list is a lua table containing tables of information

```lua
header =
{
	{ "rows", INT32, flag=ROWCOUNT }, -- flag=ROWCOUNT identifies that the engine will loop on the INT value stored in "rows"
	{ "strLen", INT32, default=52 } -- Holds the length of fields.string
}
```

Notice that in the case of `db_item.ref`, this file does not have the date/blank areas but instead contains two `INT32` fields, one of which would define the row count as a normal header. In order for the engine to work properly we must inform it that the "rows" field contains the row count by giving it the variable `flag` with the value `ROWCOUNT`


### Defining Basic Fields 
---
The `fields` list is a lua table containing tables of information

```lua
fields =
{
	{ "fieldName", FIELDTYPE },
	{ "fieldName", FIELDTYPE }
}
```

- `fieldName` is a string which will be used as an identifier when the rdb data is displayed in the calling tool
- `FIELDTYPE` is an identifier that determines how many bytes will be read on the particular field while processing the rdb.

## Defining Complex Fields 
---

While some rdb have easily definable fields some need extra information to process correctly, refer to the examples below.

### db_string 
---

`db_string` structure example:

```lua
fields =
{
	{ "name", STRING_LEN },
	{ "value", STRING_LEN },
	{ "name", STRING_BY_LEN },
	{ "value", STRING_BY_LEN },
	{ "code", INT32 },
	{ "group_id", INT32 },
	{ "unknown", BYTE, length=16, default=0, show=0 }
}
```

As you can see above we make use of the `STRING_LEN`/`STRING_BY_LEN` fieldtypes's but we also need to process 'useless' data in order to read the rdb properly. So we define the 'unknown' field.

Sometimes we need to process data that we don't want to show, in this case we will use the `show` variable and set it to `0`

In this particular case we need to read a specific amount of bytes to properly process the 'unknown' field, while this could be done as:

```lua
fields =
{
	{ "unknown1", INT32 },
	{ "unknown2", INT32 },
	{ "unknown3", INT32 },
	{ "unknown4", INT32 },
}
```

it is accomplished much easier by using the fieldtype `BYTE` and defining the `length` variable as `16` 

In this particular case we also define the `default` variable, this variable is used when saving an rdb. For instance, had we loaded this
rdb's information from an SQL table we have no proper way of knowing what to place in this area of useless data. Thusly, if we already know
there is no information here we can provide a default value of `0`. 

**NOTE: FIELDTYPE:`STRING` can also have a default string value!**

### db_item/db_monster 
---

There are however even more complex field definitions required by some rdb, in the next instance we will look at using the fieldtype `BIT_VECTOR`
and `BIT_FROM_VECTOR` as they are used in `db_item`/`db_monster`

In `db_item` there are `limit_*` fields such as `limit_deva`, `limit_gaia`, `limit_asura` which limit the ability of races or classes to use that specific item. See the example below:

```lua
fields =
{
	{"limit_bits", BIT_VECTOR, show=0 },
	{"limit_deva", BIT_FROM_VECTOR, dependency="limit_bits", bit_position=2},
	{"limit_asura", BIT_FROM_VECTOR, dependency="limit_bits", bit_position=3},
	{"limit_gaia", BIT_FROM_VECTOR, dependency="limit_bits", bit_position=4},
	{"limit_fighter", BIT_FROM_VECTOR, dependency="limit_bits", bit_position=10},
	{"limit_hunter", BIT_FROM_VECTOR, dependency="limit_bits", bit_position=11},
	{"limit_magician", BIT_FROM_VECTOR, dependency="limit_bits", bit_position=12},
	{"limit_summoner", BIT_FROM_VECTOR, dependency="limit_bits", bit_position=13}
}
```

In this particular instance we will be reading an `INT` from the physical rdb and converting it into individual values, in c++ this would be done by reading the individual bits of this section of the rdb. Unfortunately this can not be accomplished in that manner in c#, so we read the `INT` and convert it into a `BitVector32` which we can then read by position.

So in the above example we read the `INT` `{ "limit_bits" }` and convert it into a `BitVector32` by giving this cell the fieldtype `BIT_VECTOR`, the fields with the variable `dependency` of the same name `limit_bits` are not physically read from the rdb but are generated from the `limit_bits` field by reading the bit at the position given by the `bit_position` variable.

So in the above example `limit_magician` will generate it's value by reading the bit at position `12` in the `limit_bits` fields.

Another unique configuration of fields in `db_item` is repeated or duplicated fields such as `item_use_flag` which appears twice in a row in this rdb. 

See the example below:

**Example 1:**

```lua
fields =
{
	{"item_use_flag", INT32},
	{"item_use_flag", INT32, show=0} -- Use the same name so engine will copy shown value
}
```

If we were to load the physical rdb in this case we could define it like so:

**Example 2:**

```lua
fields =
{
	{"item_use_flag", INT32},
	{"item_use_flag2", INT32 }
}
```

and all would be good, unfortunately if we use the above structure and attempt to load the data from the ItemResource sql table we will be prompted by a `column does not exist` error. In this instance we can either simply use the engines duplicated field feature by defining the structure like in `Example 1`, which will automatically give the field with the variable `show` set to `0` the same value as the shown field.

Or we can go a little more complex by defining the value in a special LUA variable called `selectStatement`, in this case you would simply define the value as part of the sql statement like below:

```lua
selectStatement = "SELECT item_use_flag, item_use_flag as item_use_flag2 FROM dbo.ItemResource"
```

### db_skilltree 
---

In the case of `db_skilltree` we can not read this rdb as we would the others, this is because unlike other rdb who use a single read loop based on a variable called the row count *(which is part of the file header)* this particular rdb uses a double read loop, where its initial loop is based off the count in the header and then a secondary count based off a field in the rdb itself.

Consider the below structure example:

```lua
specialCase = DOUBLELOOP

fields =
{
	{ "job_id", INT32, flag=LOOPCOUNTER },
	{ "skill_id", INT32 },
	{ "min_skill_lv", INT32 },
	{ "max_skill_lv", INT32 },
	{ "lv", INT32 },
	{ "job_lv", INT32 },
	{ "jp_ratio", SINGLE },
	{ "need_skill_id_1", INT32 },
	{ "need_skill_lv_1", INT32 },
	{ "need_skill_id_2", INT32 },
	{ "need_skill_lv_2", INT32 },
	{ "need_skill_id_3", INT32 },
	{ "need_skill_lv_3", INT32 },
	{ "cenhance_min", INT32 },
	{ "cenhance_max", INT32 }
}
```

In this rdb structure first and foremost we need to alert the engine to the fact that this particular rdb is a special case, we will do this by defining the LUA variable `specialCase` In this instance our special case will be `DOUBLELOOP`. Once this has been defined the engine will attempt to do a secondary loop during its initial read loop, this however requires the engine know which field it will be using as the count for the secondary loop. This is where the `flag` variable will come into use. By defining the `flag` variable as `LOOPCOUNTER`. You are not only telling the engine to use this field during the read process but also to count the amount of rows in loaded data that have the same `job_id` or `flag=LOOPCOUNTER` so that it can write this count back down when you are saving this particular file.

**NOTE: at this time there is only one specialCase and it is DOUBLELOOP**

### Using LUA ProcessRow 
---

In the case of `db_monster` we finally have to do some row processing with our trusty `ProcessRow` function, in the case of this particular rdb the id field has had it's bits scrambled when it was written. This means if you just load the rdb as normal you will not get the proper id. In order to counteract this we will need to perform some bitwise operations on this field for each row as they are loaded. For such cases Daedalus already has a built in feature. Simply define the `ProcessRow` function.

Consider the below example:

```lua
local encodeMap = {}
local decodeMap = {}

function compute_bit_swapping()

	local j, oldValue

	for i = 0,31 do
		encodeMap[i] = i;
	end

	j = 3
	for i = 0,31 do
		oldValue = encodeMap[i]
		encodeMap[i] = encodeMap[j]
		encodeMap[j] = oldValue
		j = (j + i + 3) % 32
	end

	for i = 0,31 do
		decodeMap[encodeMap[i]] = i
	end
end

compute_bit_swapping()

ProcessRow = function (mode, row, rowNum)

	local value = row["id"]
	local result = 0

	if mode == READ then
		for i = 0,31 do
			if bit32.band(bit32.lshift(1, i), value) ~= 0 then
			result = bit32.bor(result, (bit32.lshift(1, decodeMap[i])))
		end
	end
	elseif mode == WRITE then
		for i = 0,31 do
			if bit32.band(bit32.lshift(1, i), value) ~= 0 then
			result = bit32.bor(result, (bit32.lshift(1, encodeMap[i])))
			end
		end
	end

	row["id"] = result
end
```

**Notes:**

- **The `ProcessRow` function must always present the following arguments `(mode, row, rowNum)`**
- **Any function call like `compute_bit_swapping()` will occur automatically and doesn't need to be called manually within `ProcessRow`**
- **If `ProcessRow` has been defined it will be called once per row `read`/`write` operation**

In this above example we provide the encode/decode maps by defining the tables and computing the values they will hold by calling `compute_bit_swapping()` so when `ProcessRow` is called by the engine it will already have access to these variables. Now you can alter the current row being processed by `Daedalus` because it was passed into the `ProcessRow` function as the `row` argument.

In this case we need to perform the bitwise operation on the field `id` so we define the local value as `row["id"]`, here you can use strongly typed names as the key or you can provide the oridinal value which in this case would be row[0]. Then at the end of this operation we set the `row["id"]` value to the newly decoded value and now we have the proper id when displayed.

# SQL
---

The last topic we will be covering is the proper usage of the LUA variables `sqlColumns` and `selectStatement`

These two variables should only ever be defined in the case that your provided structure (e.g. fields) can not result in a proper insert or select statement. For instance if you are selecting data which needs to be combined from two tables in the instance of `db_skill` or inserting data from a rdb whose epic or structure does not match the epic or structure of the target table.

Example sqlColumns for db_npcresource (for 7.3):

```lua
-- To send rdb data to a database table of different epic you will need to define
-- the sql table structure below, in this instance the data is going backwards to 7.2
-- table. If you are sending information between matching epics, do not define sqlColumns
sqlColumns =
{
	"id",
	"text_id",
	"name_text_id",
	"race_id",
	"sexsual_id",
	"x",
	"y",
	"z",
	"face",
	"local_flag",
	"is_periodic",
	"begin_of_period",
	"end_of_period",
	"face_x",
	"face_y",
	"face_z",
	"model_file",
	"hair_id",
	"face_id",
	"body_id",
	"weapon_item_id",
	"shield_item_id",
	"clothes_item_id",
	"helm_item_id",
	"gloves_item_id",
	"boots_item_id",
	"belt_item_id",
	"mantle_item_id",
	"necklace_item_id",
	"earring_item_id",
	"ring1_item_id",
	"ring2_item_id",
	"motion_id",
	"is_roam",
	"roaming_id",
	"standard_walk_speed",
	"standard_run_speed",
	"walk_speed",
	"run_speed",
	"attackable",
	"offensive_type",
	"spawn_type",
	"chase_range",
	"regen_time",
	"level",
	"stat_id",
	"attack_range",
	"attack_speed_type",
	"hp",
	"mp",
	"attack_point",
	"magic_point",
	"defence",
	"magic_defence",
	"attack_speed",
	"magic_speed",
	"accuracy",
	"avoid",
	"magic_accuracy",
	"magic_avoid",
	"ai_script",
	"contact_script",
	"texture_group",
	--"type" <this field does not exist in 7.2>
}
```

Example select for db_skill:

```lua
-- Use DISCTINT keyword to avoid duplicates left by gala
selectStatement = "SELECT DISTINCT [id],[text_id],[is_valid],[elemental],[is_passive],[is_physical_act],[is_harmful],[is_need_target],[is_corpse],[is_toggle],[toggle_group],[casting_type],[casting_level],[cast_range],[valid_range],[cost_hp],[cost_hp_per_skl],[cost_mp],[cost_mp_per_skl],[cost_mp_per_enhance],[cost_hp_per],[cost_hp_per_skl_per],[cost_mp_per],[cost_mp_per_skl_per],[cost_havoc],[cost_havoc_per_skl],[cost_energy],[cost_energy_per_skl],[cost_exp],[cost_exp_per_enhance],[cost_jp],[cost_jp_per_enhance],[cost_item],[cost_item_count],[cost_item_count_per_skl],[need_level],[need_hp],[need_mp],[need_havoc],[need_havoc_burst],[need_state_id],[need_state_level],[need_state_exhaust],[vf_one_hand_sword],[vf_two_hand_sword],[vf_double_sword],[vf_dagger],[vf_double_dagger],[vf_spear],[vf_axe],[vf_one_hand_axe],[vf_double_axe],[vf_one_hand_mace],[vf_two_hand_mace],[vf_lightbow],[vf_heavybow],[vf_crossbow],[vf_one_hand_staff],[vf_two_hand_staff],[vf_shield_only],[vf_is_not_need_weapon],[delay_cast],[delay_cast_per_skl],[delay_cast_mode_per_enhance],[delay_common],[delay_cooltime],[delay_cooltime_mode_per_enhance],[cool_time_group_id],[uf_self],[uf_party],[uf_guild],[uf_neutral],[uf_purple],[uf_enemy],[tf_avatar],[tf_summon],[tf_monster],[skill_lvup_limit],[target],[effect_type],[state_id],[state_level_base],[state_level_per_skl],[state_level_per_enhance],[state_second],[state_second_per_level],[state_second_per_enhance],[state_type],[probability_on_hit],[probability_inc_by_slv],[hit_bonus],[hit_bonus_per_enhance],[percentage],[hate_mod],[hate_basic],[hate_per_skl],[hate_per_enhance],[critical_bonus],[critical_bonus_per_skl],[var1],[var2],[var3],[var4],[var5],[var6],[var7],[var8],[var9],[var10],[var11],[var12],[var13],[var14],[var15],[var16],[var17],[var18],[var19],[var20],[jp_01],[jp_02],[jp_03],[jp_04],[jp_05],[jp_06],[jp_07],[jp_08],[jp_09],[jp_10],[jp_11],[jp_12],[jp_13],[jp_14],[jp_15],[jp_16],[jp_17],[jp_18],[jp_19],[jp_20],[jp_21],[jp_22],[jp_23],[jp_24],[jp_25],[jp_26],[jp_27],[jp_28],[jp_29],[jp_30],[jp_31],[jp_32],[jp_33],[jp_34],[jp_35],[jp_36],[jp_37],[jp_38],[jp_39],[jp_40],[jp_41],[jp_42],[jp_43],[jp_44],[jp_45],[jp_46],[jp_47],[jp_48],[jp_49],[jp_50],[desc_id],[tooltip_id],[icon_id],[icon_file_name],[is_projectile],[projectile_speed],[projectile_acceleration] FROM dbo.SkillResource s LEFT JOIN dbo.SkillJpResource sj ON sj.skill_id = s.id"
```