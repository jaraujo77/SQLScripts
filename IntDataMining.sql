--Data Mining Script To Find All Related GUIDS
DECLARE @INT_TOFIND VARCHAR(255),
		@cmd nvarchar(max),
		@parameters nvarchar(max),
		@TABLE_NAME VARCHAR(255),
		@COLUMN_NAME VARCHAR(255),
		@cnt bigint

SELECT @INT_TOFIND = '25371701'

DECLARE colCursor CURSOR FOR 
SELECT	TABLE_NAME,
		COLUMN_NAME
FROM	INFORMATION_SCHEMA.COLUMNS
WHERE	DATA_TYPE = 'int'
AND		TABLE_SCHEMA = 'dbo'

OPEN colCursor

FETCH NEXT FROM colCursor INTO @TABLE_NAME, @COLUMN_NAME

WHILE @@FETCH_STATUS = 0
BEGIN
		set @parameters = '@cnt bigint output'
		SELECT @cmd = 'SELECT @cnt = count(*) FROM [' + @TABLE_NAME + '] WHERE [' + @COLUMN_NAME + '] = ' + CAST(@INT_TOFIND AS VARCHAR(255)) + ''

		EXEC sp_executesql @cmd, @parameters, @cnt = @cnt output
		if (@cnt > 0)
		BEGIN
			PRINT 'Match Found IN ' + @TABLE_NAME + '.' + @COLUMN_NAME
			SELECT @cmd = 'SELECT * FROM [' + @TABLE_NAME + '] WHERE [' + @COLUMN_NAME + '] = ' + CAST(@INT_TOFIND AS VARCHAR(255)) + ''
			EXEC sp_executesql @cmd
		END
		FETCH NEXT FROM colCursor INTO @TABLE_NAME, @COLUMN_NAME   
END

CLOSE colCursor
DEALLOCATE colCursor