---
title: RemoveIT Script
authors: iSmokeDrow
date: 2015.7.6
---

## Description
---

Maintenance sql script to clear the `Telecaster` of deleted characters *(aswell as their assets and pets)*

## Script
---

```sql
USE Telecaster -- Change my name to your Telecaster name

DECLARE @CUR INT,
		@MAX INT,
		@SID INT,
		@NAME NVARCHAR(50),
		@PETCUR INT,
		@PETMAX INT,
		@PETSID INT

SET @CUR = 0
SET @PETCUR = 0
SET @MAX = (SELECT COUNT(*) FROM dbo.Character WHERE name LIKE '%@%')

PRINT CONCAT(N'There are a total of ', @MAX, N' deleted characters')

WHILE @CUR < @MAX 
BEGIN
	SET @SID = (SELECT TOP(1) sid FROM dbo.Character WHERE name LIKE '%@%')
	SET @NAME = (SELECT TOP(1) name FROM dbo.Character WHERE sid = @SID)

	PRINT CONCAT(N'Processing entry ', @CUR, N' of ', @MAX,  N' with SID: ', @SID, N' and NAME: ', @NAME)
	
	DELETE FROM dbo.Character WHERE sid = @SID
	DELETE FROM dbo.Auction WHERE seller_id = @SID
	DELETE FROM dbo.Denials WHERE owner_id = @NAME OR denial_id = @NAME
	DELETE FROM dbo.EventAreaEnterCount WHERE player_id = @SID
	DELETE FROM dbo.Farm WHERE owner_id = @SID
	DELETE FROM dbo.Favor WHERE owner_id = @SID
	DELETE FROM dbo.Friends WHERE owner_id = @NAME or friend_id = @NAME
	DELETE FROM dbo.GuildMember WHERE player_id = @SID
	DELETE FROM dbo.Item WHERE owner_id = @SID
	DELETE FROM dbo.ItemCoolTime WHERE owner_id = @SID
	DELETE FROM dbo.ItemKeeping WHERE owner_id = @SID
	DELETE FROM dbo.Party WHERE leader_id = @SID
	DELETE FROM dbo.Quest WHERE owner_id = @SID
	DELETE FROM dbo.QuestCoolTime WHERE owner_id = @SID
	DELETE FROM dbo.RankingScore WHERE owner_id = @SID
	DELETE FROM dbo.Skill WHERE owner_id = @SID
	DELETE FROM dbo.State WHERE owner_id = @SID
	DELETE FROM dbo.Title WHERE owner_id = @SID
	DELETE FROM dbo.TitleCondition WHERE owner_id = @SID

	SET @PETMAX = (SELECT COUNT(*) FROM dbo.Summon WHERE owner_id = @SID)

	PRINT CONCAT(@PETMAX, N' Pets detected for this character.')
	
	WHILE @PETCUR < @PETMAX 
	BEGIN
		SET @PETSID = (SELECT TOP(1) sid FROM dbo.Summon WHERE owner_id = @SID)
		DELETE FROM dbo.Summon WHERE sid = @PETSID
		DELETE FROM dbo.Item WHERE summon_id = @PETSID
		DELETE FROM dbo.Skill WHERE summon_id = @PETSID
		DELETE FROM dbo.State WHERE summon_id = @PETSID

		SET @PETCUR = @PETCUR + 1

		PRINT CONCAT(N' Pet bearing sid ', @PETSID, N' and all related information deleted.')
	END

	PRINT N'Delete Successful'

	SET @CUR = @CUR + 1
END
```

## Usage
---

1. Launch `SSMS`
2. Use `CTRL+N` key combo
3. Paste the [script](#script)
4. Edit `USE` statement as needed
5. Execute