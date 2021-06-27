---
title: Mix Category Guide
authors: iSmokeDrow
date: 2021.6.27
---

# Editing MixCategoryResource

## In-Game Structure
---

![](https://i.imgur.com/GTdD78P.png)

- Column 1 - `high_category_id`
- Column 2 - `middle_category_id`
- Column 3 - `low_category_id`

Each column is a list of `strings` and the `***_category_id` is the associated index *(position)* of this entry.

Consider the following example:

![](https://i.imgur.com/8P6FDaO.png)

Which consists of the following indexes:

- `high_category_id` = `0`
- `middle_category_id` = `0`
- `low_category_id` = `-1`

While the following example:

![](https://i.imgur.com/xVYMF7D.png)

consist of the following indexes:

- `high_category_id` = `0`
- `middle_category_id` = `0`
- `low_category_id` = `0`

In the above example, all the ids are `0` because each category selected is at the beginning of its list)

However in the following example:

![](https://i.imgur.com/SzjaHzB.png)

the selected `***_category_id` would be:

- `high_category_id` = `1`
- `middle_category_id` = `0`
- `low_category_id` = `0`

## Database Structure
---

![](https://i.imgur.com/fsLnlSf.png)

**Notes:**

- **`MixCategoryResource` services both the `Combine` and `Enhance` formula windows. See `mix_id`**
- **`-1` in _category_id means there is nothing to be displayed.**

### Columns

- `id` = A unique identifier 
- `mix_id` = `1` Formula / `0` Enhance
- `local_flag` = Determines which regions this formula can be displayed to.
- `category_text_id` = `dbo.StringResource.[code]` of string to be displayed as category text
- `formal_text_id` = `dbo.StringResource.[code]` of string to be displayed as `ingredients`
- `result_text_id` = `dbo.StringResource.[code]` of string to be displayed as the `result`