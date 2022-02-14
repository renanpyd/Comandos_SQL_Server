CREATE PROCEDURE [dbo].[stpExtendedProperty_Database] (
    @Ds_Database sysname,
    @Ds_Texto VARCHAR(MAX)
)
AS BEGIN
 
 
    IF (LEN(LTRIM(RTRIM(@Ds_Texto))) = 0)
    BEGIN
        PRINT 'Texto não informado para a o database "' + @Ds_Database + '"'
        RETURN
    END
 
    
    DECLARE @query VARCHAR(MAX)
        
    SET @query = '
        
    IF ((SELECT COUNT(*) FROM [' + @Ds_Database + '].sys.extended_properties A WHERE A.class = 0 AND A.name = ''MS_Description'') = 0)
    BEGIN
        
        IF ((SELECT COUNT(*) FROM [' + @Ds_Database + '].sys.databases WHERE name = ''' + @Ds_Database + ''') > 0)
        BEGIN
        
            EXEC [' + @Ds_Database + '].sys.sp_addextendedproperty 
                @name = N''MS_Description'', 
                @value = ''' + @Ds_Texto + '''
                    
        END
        ELSE
            PRINT ''O database "' + @Ds_Database + '" não existe para adicionar ExtendedProperty.''
                
    END
    ELSE BEGIN
            
        EXEC [' + @Ds_Database + '].sys.sp_updateextendedproperty 
            @name = N''MS_Description'', 
            @value = ''' + @Ds_Texto + '''
        
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