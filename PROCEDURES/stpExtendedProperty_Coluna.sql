CREATE PROCEDURE [dbo].[stpExtendedProperty_Coluna] (
    @Ds_Database sysname,
    @Ds_Tabela sysname,
    @Ds_Schema sysname = 'dbo',
    @Ds_Coluna sysname,
    @Ds_Texto VARCHAR(MAX)
)
AS BEGIN
    
 
    IF (LEN(LTRIM(RTRIM(@Ds_Texto))) = 0)
    BEGIN
        PRINT 'Texto não informado para a coluna "' + @Ds_Coluna + '" da tabela "' + @Ds_Tabela + '" no database "' + @Ds_Database + '"'
        RETURN
    END
 
 
    DECLARE @query VARCHAR(MAX)
        
    SET @query = '
        
    IF ((SELECT COUNT(*) FROM [' + @Ds_Database + '].sys.extended_properties A JOIN [' + @Ds_Database + '].sys.objects B ON A.major_id = B.object_id JOIN [' + @Ds_Database + '].sys.columns C ON B.id = C.object_id AND A.minor_id = C.column_id WHERE A.class = 1 AND A.minor_id > 0 AND A.name = ''MS_Description'' AND B.name = ''' + @Ds_Tabela + ''' AND C.name = ''' + @Ds_Coluna + ''') = 0)
    BEGIN
        
        IF ((SELECT COUNT(*) FROM [' + @Ds_Database + '].INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''' + @Ds_Tabela + ''' AND COLUMN_NAME = ''' + @Ds_Coluna + ''') > 0)
        BEGIN
        
            EXEC [' + @Ds_Database + '].sys.sp_addextendedproperty 
                @name = N''MS_Description'', 
                @value = ''' + @Ds_Texto + ''', 
                @level0type = N''SCHEMA'',
                @level0name = ''' + @Ds_Schema + ''', 
                @level1type = N''TABLE'',
                @level1name = ''' + @Ds_Tabela + ''',
                @level2type = N''COLUMN'',
                @level2name = ''' + @Ds_Coluna + '''
                    
        END
        ELSE
            PRINT ''A coluna "' + @Ds_Database + '.' + @Ds_Schema + '.' + @Ds_Tabela + '.' + @Ds_Coluna + '" não existe para adicionar ExtendedProperty.''
                
    END
    ELSE BEGIN
            
        EXEC [' + @Ds_Database + '].sys.sp_updateextendedproperty 
            @name = N''MS_Description'', 
            @value = ''' + @Ds_Texto + ''', 
            @level0type = N''SCHEMA'',
            @level0name = ''' + @Ds_Schema + ''', 
            @level1type = N''TABLE'',
            @level1name = ''' + @Ds_Tabela + ''',
            @level2type = N''COLUMN'',
            @level2name = ''' + @Ds_Coluna + '''
        
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