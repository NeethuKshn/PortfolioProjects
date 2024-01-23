-- This is auto-generated code
USE golddb
GO

CREATE OR ALTER PROC CreateSQLServerLessView_gold @ViewName NVARCHAR(100)
AS BEGIN
    DECLARE @statement NVARCHAR(MAX)

    SET @statement = N'CREATE OR ALTER VIEW ' + QUOTENAME(@ViewName) + ' AS 
        SELECT *
        FROM OPENROWSET(
            BULK ''https://sankmigrationproject.dfs.core.windows.net/gold/' + @ViewName + '.parquet'',
            FORMAT = ''PARQUET''
        ) AS [result]'

    -- Debugging: Print the generated SQL statement
    PRINT @statement

 
    EXEC sp_executesql @statement
END
GO
