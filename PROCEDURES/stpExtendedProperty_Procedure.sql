CREATE PROCEDURE [dbo].[stpExtendedProperty_Procedure] (
    @Ds_Database sysname,
    @Ds_Procedure sysname,
    @Ds_Schema sysname = 'dbo',
    @Ds_Texto VARCHAR(MAX)
)
AS BEGIN
    
 
    IF (LEN(LTRIM(RTRIM(@Ds_Texto))) = 0)
    BEGIN
        PRINT 'Texto não informado para a Stored Procedure "' + @Ds_Procedure + '" no database "' + @Ds_Database + '"'
        RETURN
    END
        
        
    DECLARE @query VARCHAR(MAX)
        
    SET @query = '
        
    IF ((SELECT COUNT(*) FROM [' + @Ds_Database + '].sys.extended_properties A JOIN [' + @Ds_Database + '].sys.objects B ON A.major_id = B.object_id WHERE A.class = 1 AND A.name = ''MS_Description'' AND B.name = ''' + @Ds_Procedure + ''') = 0)
    BEGIN
        
        IF ((SELECT COUNT(*) FROM [' + @Ds_Database + '].INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = ''' + @Ds_Procedure + ''') > 0)
        BEGIN
        
            EXEC [' + @Ds_Database + '].sys.sp_addextendedproperty 
                @name = N''MS_Description'', 
                @value = ''' + @Ds_Texto + ''', 
                @level0type = N''SCHEMA'',
                @level0name = ''' + @Ds_Schema + ''', 
                @level1type = N''PROCEDURE'',
                @level1name = ''' + @Ds_Procedure + '''
                    
        END
        ELSE
            PRINT ''A Stored Procedure "' + @Ds_Database + '.' + @Ds_Schema + '.' + @Ds_Procedure + '" não existe para adicionar ExtendedProperty.''
                
    END
    ELSE BEGIN
            
        EXEC [' + @Ds_Database + '].sys.sp_updateextendedproperty 
            @name = N''MS_Description'', 
            @value = ''' + @Ds_Texto + ''', 
            @level0type = N''SCHEMA'',
            @level0name = ''' + @Ds_Schema + ''', 
            @level1type = N''PROCEDURE'',
            @level1name = ''' + @Ds_Procedure + '''
        
    END
    '
 
    BEGIN TRY
    
        EXEC(@query)
        
    END TRY
    
    BEGIN CATCH
        
        PRINT @query
 
        DECLARE @MsgErro VARCHAR(MAX) = 'Erro ao adicionar a ExtendedProperty: ' + ISNULL(ERROR_MESSAGE(), '')
        RAISERROR(@MsgErro, 10, 1) WITH NOWAIT
        RETURN
 
    END CATCH
    
END
GO