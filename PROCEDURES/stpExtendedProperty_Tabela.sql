CREATE PROCEDURE [dbo].[stpExtendedProperty_Tabela] (
    @Ds_Database sysname,
    @Ds_Tabela sysname,
    @Ds_Schema sysname = 'dbo',
    @Ds_Texto VARCHAR(MAX)
)
AS BEGIN
    
 
    IF (LEN(LTRIM(RTRIM(@Ds_Texto))) = 0)
    BEGIN
        PRINT 'Texto não informado para a tabela "' + @Ds_Tabela + '" no database "' + @Ds_Database + '"'
        RETURN
    END
 
 
    
    DECLARE @query VARCHAR(MAX)
        
    SET @query = '
        
    IF ((SELECT COUNT(*) FROM [' + @Ds_Database + '].sys.extended_properties A JOIN [' + @Ds_Database + '].sys.objects B ON A.major_id = B.object_id WHERE A.class = 1 AND A.name = ''MS_Description'' AND B.name = ''' + @Ds_Tabela + ''') = 0)
    BEGIN
        
        IF ((SELECT COUNT(*) FROM [' + @Ds_Database + '].INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ''' + @Ds_Tabela + ''') > 0)
        BEGIN
        
            EXEC [' + @Ds_Database + '].sys.sp_addextendedproperty 
                @name = N''MS_Description'', 
                @value = ''' + @Ds_Texto + ''', 
                @level0type = N''SCHEMA'',
                @level0name = ''' + @Ds_Schema + ''', 
                @level1type = N''TABLE'',
                @level1name = ''' + @Ds_Tabela + '''
                    
        END
        ELSE
            PRINT ''A Tabela "' + @Ds_Database + '.' + @Ds_Schema + '.' + @Ds_Tabela + '" não existe para adicionar ExtendedProperty.''
                
    END
    ELSE BEGIN
            
        EXEC [' + @Ds_Database + '].sys.sp_updateextendedproperty 
            @name = N''MS_Description'', 
            @value = ''' + @Ds_Texto + ''', 
            @level0type = N''SCHEMA'',
            @level0name = ''' + @Ds_Schema + ''', 
            @level1type = N''TABLE'',
            @level1name = ''' + @Ds_Tabela + '''
        
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