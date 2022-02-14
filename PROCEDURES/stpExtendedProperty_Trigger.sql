CREATE PROCEDURE [dbo].[stpExtendedProperty_Trigger] (
    @Ds_Database sysname,
    @Ds_Tabela sysname,
    @Ds_Schema sysname = 'dbo',
    @Ds_Trigger sysname,
    @Ds_Texto VARCHAR(MAX)
)
AS BEGIN
    
 
    IF (LEN(LTRIM(RTRIM(@Ds_Texto))) = 0)
    BEGIN
        PRINT 'Texto não informado para a trigger "' + @Ds_Trigger + '" da tabela "' + @Ds_Tabela + '" no database "' + @Ds_Database + '"'
        RETURN
    END
 
    DECLARE @query VARCHAR(MAX)
        
    SET @query = '
        
    IF ((SELECT COUNT(*) FROM [' + @Ds_Database + '].sys.extended_properties A JOIN [' + @Ds_Database + '].sys.triggers B ON A.major_id = B.object_id JOIN [' + @Ds_Database + '].sys.objects C ON B.parent_id = C.object_id WHERE A.class = 1 AND A.name = ''MS_Description'' AND C.name = ''' + @Ds_Tabela + ''' AND B.name = ''' + @Ds_Trigger + ''') = 0)
    BEGIN
        
        IF ((SELECT COUNT(*) FROM [' + @Ds_Database + '].sys.triggers A JOIN [' + @Ds_Database + '].sys.objects B ON A.parent_id = B.object_id WHERE B.name = ''' + @Ds_Tabela + ''' AND A.name = ''' + @Ds_Trigger + ''') > 0)
        BEGIN
        
            EXEC [' + @Ds_Database + '].sys.sp_addextendedproperty 
                @name = N''MS_Description'', 
                @value = ''' + @Ds_Texto + ''', 
                @level0type = N''SCHEMA'',
                @level0name = ''' + @Ds_Schema + ''', 
                @level1type = N''TABLE'',
                @level1name = ''' + @Ds_Tabela + ''',
                @level2type = N''TRIGGER'',
                @level2name = ''' + @Ds_Trigger + '''
                    
        END
        ELSE
            PRINT ''A trigger "' + @Ds_Database + '.' + @Ds_Schema + '.' + @Ds_Tabela + '.' + @Ds_Trigger + '" não existe para adicionar ExtendedProperty.''
                
    END
    ELSE BEGIN
            
        EXEC [' + @Ds_Database + '].sys.sp_updateextendedproperty 
            @name = N''MS_Description'', 
            @value = ''' + @Ds_Texto + ''', 
            @level0type = N''SCHEMA'',
            @level0name = ''' + @Ds_Schema + ''', 
            @level1type = N''TABLE'',
            @level1name = ''' + @Ds_Tabela + ''',
            @level2type = N''TRIGGER'',
            @level2name = ''' + @Ds_Trigger + '''
        
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