---
title: PetResoure Documentation
authors: iSmokeDrow
date: 2020.6.26
---

# PetResource Documentation
---

## cage_id

The `dbo.ItemResource` id of the item used to summon the `Pet`

**Notes**

- **The cage item must present `status_flag` `32`**
- **The cage item must present `opt_type_0` `90`**

## type

The `type` field is enumerated below:

```cpp
CREATURE_ETC			= 0;	
CREATURE_BEAST			= 1;	
CREATURE_SEMIHUMAN		= 2;	
CREATURE_ELEMENTAL		= 3;	
CREATURE_ANGEL			= 4;	
CREATURE_DEVIL			= 5;	
CREATURE_MECHA			= 6;	
CREATURE_DRAGON			= 7;	
CREATURE_UNDEAD			= 8;	
CREATURE_HUMAN			= 9;	
CREATURE_ALL			= 99;	
```

## rate/attribute_Flag

A `bit_flag` field used determine some behaviors of the pet.

**Note: in ep7.2 the field is named `rate` in of ep9+ the field is named `attribute_flag`**

```cpp
RATE_RARE = 			1 << 0, // Rare or not
RATE_SHOVELABLE = 		1 << 1, // Whether shoveling is possible
RATE_ITEM_COLLECTABLE = 1 << 2, // Whether it is possible to automatically pick up items
RATE_WEIGHT_1000 = 		1 << 3, // Increase possession (1000) (ep 9.x)
RATE_WEIGHT_2000 = 		1 << 4, // Increase possession (2000) (ep 9.x)
RATE_WEIGHT_4000 = 		1 << 5, // Increase possession (4000) (ep 9.x)
RATE_WEIGHT_8000 = 		1 << 6, // Increase possession (8000) (ep 9.x)
```

**Note: in ep7.2 the value is always `5` which enumerates to the following flags:**

```cpp
RATE_RARE = 			1 << 0, // Rare or not
RATE_ITEM_COLLECTABLE = 1 << 2, // Whether it is possible to automatically pick up items
```

**Note: newer pets such as Boss pets in ep9+ use `21` which enumerates to the following flags:**

```cpp
RATE_RARE = 			1 << 0, // Rare or not
RATE_ITEM_COLLECTABLE = 1 << 2, // Whether it is possible to automatically pick up items
RATE_WEIGHT_2000 = 		1 << 4, // Increase possession (2000) (ep 9.x)
```

## model
---

The filename of the model this pet will use to be rendered e.g.

`pet_arcadia`

## motion_file_id
---

This id links to the `MonsterMotionSet` table/rdb and must link to a vlid `id` or the pet will be invisible when summoned.

## Item Collection
---

In order for the `Collect Items` skill to be properly displayed for a summoned pet an entry needs to be created in the `SkillTreeResource` table/rdb with the pet's id as the `job_id` and the `skill_id` as `46018` *(All other fields may be `0`)*