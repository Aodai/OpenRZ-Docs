---
title: MixResource Documentation
authors: iSmokeDrow
date: 2020.6.25
---

# Description
---

This document will explain use cases for the `dbo.MixResource` table and rdb.

## Mix Type
---

```cpp
MIX_ENHANCE																= 101,
MIX_ENHANCE_SKILL_CARD													= 102,
MIX_ENHANCE_WITHOUT_FAIL												= 103,
MIX_ENHANCE_CREATURE_CARD												= 104,
MIX_ENHANCE_CREATURE_CARD_WITH_JOKER									= 105,
MIX_SET_LEVEL															= 201,
MIX_SET_LEVEL_CREATE_ITEM												= 202,
MIX_SET_LEVEL_SET_FLAG													= 211,
MIX_SET_LEVEL_SET_FLAG_CREATE_ITEM										= 212,
MIX_SET_LEVEL_SET_FLAG_CREATE_ITEM_WITH_MAIN_MATERIAL_LEVEL				= 213,
MIX_SET_LEVEL_ON_SUB_MATERIAL_LEVEL_SET_FLAG							= 214,
MIX_SET_LEVEL_SET_FLAG_CREATE_ITEM_WITH_MAIN_MATERIAL_LEVEL_SET_ZERO	= 215,
MIX_ADD_LEVEL															= 301,
MIX_ADD_LEVEL_CREATE_ITEM												= 302,
MIX_ADD_LEVEL_SET_FLAG													= 311,
MIX_ADD_LEVEL_SET_FLAG_CREATE_ITEM										= 312,
MIX_RECYCLE																= 401,
MIX_RECYCLE_ENHANCE														= 402,
MIX_RESTORE_ENHANCE_SET_FLAG											= 501,
MIX_CREATE_ITEM															= 601,
MIX_REPLACE_WITH														= 602,
MIX_SET_ELEMENTAL_EFFECT												= 701,
MIX_SET_ELEMENTAL_EFFECT_PARAMETER										= 702,
MIX_SET_SOCKET															= 703,
MIX_SACRIFICE_ITEM_FOR_ETHEREAL_DURABILITY_WITH_MESSAGE					= 801,
MIX_TRANSMIT_ETHEREAL_DURABILITY										= 802,
MIX_RECOVER_EXHAUSTED_ETHEREAL_DURABILITY								= 803,
MIX_SACRIFICE_ITEM_FOR_ETHEREAL_DURABILITY								= 804,
MIX_SACRIFICE_ITEM_FOR_ETHEREAL_STONE_DURABILITY						= 805,
MIX_TRANSMIT_ETHEREAL_DURABILITY_FROM_ETHEREAL_STONE					= 806,

```

## Check Type
---

The check enumeration is typically used in the `sub0x_type_0x` depending on the `sub_material_count`
 
```cpp
CHECK_ITEM_GROUP = 1,
CHECK_ITEM_CLASS = 2,
CHECK_ITEM_ID = 3,
CHECK_ITEM_RANK = 4,
CHECK_ITEM_LEVEL = 5,
CHECK_FLAG_ON = 6,
CHECK_FLAG_OFF = 7,

CHECK_ENHANCE_MATCH = 8,
CHECK_ENHANCE_DISMATCH = 9,
CHECK_ITEM_COUNT = 10,
CHECK_ELEMENTAL_EFFECT_MATCH = 11,
CHECK_ELEMENTAL_EFFECT_MISMATCH = 12,
CHECK_ITEM_WEAR_POSITION_MATCH = 13,
CHECK_ITEM_WEAR_POSITION_MISMATCH = 14,
CHECK_ITEM_COUNT_GE = 15, // The number of items exceeds the specified quantity

CHECK_ITEM_ETHEREAL_DURABILITY_E = 16, // Ethereal durability is the same as the specified value
CHECK_ITEM_ETHEREAL_DURABILITY_NE = 17, // Ethereal durability is different from the specified value
CHECK_ITEM_GRADE = 18, // Item grade is same as specified value

CHECK_SAME_ITEM_ID = 19, // Item code identical to the item in the designated slot (auxiliary material cross-reference type)
CHECK_SAME_SUMMON_CODE = 20, // Minion code identical to the item in the designated slot (code material cross-reference type)
CHECK_ITEM_EXPIRED_TIME_GE = 21, // The remaining time of the fixed-term item is greater than or equal to the specified value
CHECK_ITEM_EXPIRED_TIME_LE = 22, // The remaining time of the fixed-term item is less than or equal to the specified value
CHECK_ITEM_FIRST_SOCKET_CODE_MATCH = 23, // The code of the first slot is the same as the specified value
CHECK_SAME_ITEM_ENHANCE = 24, // same enhancement as the item in the designated slot (auxiliary material cross-reference type)
CHECK_SAME_SKILL_ID = 25, // The same skill ID as the item in the specified slot (auxiliary material cross-reference type)
```

## Explination by Type
---

Below the various types of combinations will be broken down by their type *(e.g. their mix_type)*

### Create Item (601)
---

- `mix_value_01` - Result item id *(the item this combination will create)*
- `mix_value_02` - Result item lv *(the level of the resulting item)*
- `mix_value_03` - Percent (0-100) this combination will succeeed
- `mix_value_04` - Result item minimum count *(the minimum number of the resulting item for this combination)*
- `mix_value_05` - Result item maximum count *(the maximum number of the resulting item for this combination)*
- `sub_material_count` - The amount of items that must be combined to create the result item.
	- Amount of `sub0*_type0*` / `sub0*_value_0*`fields completed/used is determined by this value.
- `sub0*_type_0*` - Value enumerated by [Check Type Enum](#check-type)
- `sub0*_value_0*` - Depends on the matching `sub0*_type_0*` field before it.  *(See following example)*

**Example**

```
sub01_type_01: 3
sub01_value_01: 490003
sub01_type_02: 10
sub01_value_02: 1
```

In the above example if we refer to the [Check Type Enum](#check-type) we can see `3` resolves to: `CHECK_ITEM_ID` and `10` resolves to `CHECK_ITEM_COUNT`.

So in the above example, the first required item/ingredient for the combination is `490003` because a `sub01_type_01` of `3` means we're checking the `sub01_value_01` field for an item id. We are also checking to see if there is `1` of that item because the `sub01_type_02` of  `10` means were checking `sub01_value_02` for a count.

### Enhance Creature Card (104/105)
---

**Note:** *Type `104` is enhance without Joker / `105` is enhance with Joker*

- `mix_value_01` - `EnhanceResource` id used in success calculation for stage +1/5
- `mix_value_04` - If enhance is type `104 (without joker)` and the `main` creature card is `>=` `+3` then this field will contain a creature card item id (likely joker `540070`)
- `mix_value_06` - Maximum percentage chance that the item id in `mix_value_04` will be given on an enhance failure of type `104`
- `sub_material_count` - The amount of items that must be combined to create the result item.
	- Amount of `sub0*_type0*` / `sub0*_value_0*`fields completed/used is determined by this value.
- `main0*_type_0*` - Value enumated by [Check Type Enum](#check-type)
- `main0*_value_0*` - Depends on the matching `main0*_type_0*`
- `sub0*_type_0*` - Value enumerated by [Check Type Enum](#check-type)
- `sub0*_value_0*` - Depends on the matching `sub0*_type_0*` field before it.  *(See following example)*

**Example (type 104)**

```
type: 104
mix_value_01: 2000
mix_value_04: 540070
mix_value_06: 4
main_type_01: 1
main_value_01: 13
main_type_02: 6
main_value_02: 31
sub01_type_01: 1
sub01_value_01: 13
sub01_type_02: 6
sub01_value_02: 31
sub01_type_03: 20
sub02_type_01: 3
sub02_value_01: 710001
```

In the above example, we can tell we are enhancing a creature card without a joker because the type is `104`

We also notice that our chance for success (per stage 1/5) can be found in the `EnhanceResource` table with `enhance_id` `2000`

We also see that since we are type `104` that if our enhance fails at or above +3 (stage 3) that there is a 4% (`mix_value_06`) chance that a `Joker` (`540070`) will be the result.

By refering to [Check Type Enum](#check-type) we know that main_type_01 (1 - `CHECK_ITEM_GROUP`) means our main creature card (item) must have group `13` (`main_value_01`) and by checking main_type_02 (`6` - `CHECK_FLAG_ON`) we can tell that the main creature card (item) must bear flag `31` (`Tamed Pet`)

We can also see that `sub01_type_01/02` and `sub_01_value_01/02` are the same basically telling us our second creature card must be of group `13` and bearing the `31` (`Tamed Pet`) flag.

Looking at `sub01_type_03` (`20` -`CHECK_SAME_SUMMON_CODE`) we can see that both the main and combined creature must be the same summon.

And lastly; `sub02_type_01` (`3` - `CHECK_ITEM_ID`) means an item with id (`710001` - `Soul Catalyst` ) must also be present in the combination