CREATE PROCEDURE [dbo].[stpExtendedProperty_Usuario] (
    @Ds_Database sysname = NULL,
    @Ds_Usuario sysname,
    @Ds_Texto VARCHAR(MAX)
)
AS BEGIN
 
 
    IF (LEN(LTRIM(RTRIM(@Ds_Texto))) = 0)
    BEGIN
        PRINT 'Texto não informado para o usuário "' + @Ds_Usuario + '" no database "' + @Ds_Database + '"'
        RETURN
    END
 
 
 
    DECLARE @query VARCHAR(MAX)
        
        
    IF (NULLIF(LTRIM(RTRIM(@Ds_Database)), '') IS NOT NULL)
    BEGIN
        
        SET @query = '
            
        IF ((SELECT COUNT(*) FROM [' + @Ds_Database + '].sys.extended_properties A JOIN [' + @Ds_Database + '].sys.database_principals B ON A.major_id = B.principal_id AND A.class = 4 WHERE A.name = ''MS_Description'' AND B.name = ''' + @Ds_Usuario + ''') = 0)
        BEGIN
            
            IF ((SELECT COUNT(*) FROM [' + @Ds_Database + '].sys.database_principals WHERE name = ''' + @Ds_Usuario + ''') > 0)
            BEGIN
            
                EXEC [' + @Ds_Database + '].sys.sp_addextendedproperty 
                    @name = N''MS_Description'', 
                    @value = ''' + @Ds_Texto + ''',
                    @level0type = N''USER'', 
                    @level0name = N''' + @Ds_Usuario + '''
                        
            END
            ELSE
                PRINT ''O usuário "' + @Ds_Usuario + ' não existe no database "' + @Ds_Database + '" para adicionar ExtendedProperty.''
                    
        END
        ELSE BEGIN
                
            EXEC [' + @Ds_Database + '].sys.sp_updateextendedproperty 
                @name = N''MS_Description'', 
                @value = ''' + @Ds_Texto + ''',
                @level0type = N''USER'', 
                @level0name = N''' + @Ds_Usuario + ''';
            
        END
        '
            
    END
    ELSE BEGIN
        
        SET @query = '
            
        IF ((SELECT COUNT(*) FROM [?].sys.extended_properties A JOIN [?].sys.database_principals B ON A.major_id = B.principal_id AND A.class = 4 WHERE A.name = ''MS_Description'' AND B.name = ''' + @Ds_Usuario + ''') = 0)
        BEGIN
            
            IF ((SELECT COUNT(*) FROM [?].sys.database_principals WHERE name = ''' + @Ds_Usuario + ''') > 0)
            BEGIN
            
                EXEC [?].sys.sp_addextendedproperty 
                    @name = N''MS_Description'', 
                    @value = ''' + @Ds_Texto + ''',
                    @level0type = N''USER'', 
                    @level0name = N''' + @Ds_Usuario + '''
                        
            END
                    
        END
        ELSE BEGIN
            
            IF ((SELECT COUNT(*) FROM [?].sys.database_principals WHERE name = ''' + @Ds_Usuario + ''') > 0)
            BEGIN
                
                EXEC [?].sys.sp_updateextendedproperty 
                    @name = N''MS_Description'', 
                    @value = ''' + @Ds_Texto + ''',
                    @level0type = N''USER'', 
                    @level0name = N''' + @Ds_Usuario + ''';
                        
            END
            
        END
        '
        
    END
 
 
    BEGIN TRY
    
        IF (NULLIF(LTRIM(RTRIM(@Ds_Database)), '') IS NOT NULL)
            EXEC(@query)    
        ELSE
            EXEC master.sys.sp_MSforeachdb @query
            
    END TRY
    
    BEGIN CATCH
        
        PRINT @query
 
        DECLARE @MsgErro VARCHAR(MAX) = 'Erro ao adicionar a ExtendedProperty: ' + ISNULL(ERROR_MESSAGE(), '')
        RAISERROR(@MsgErro, 10, 1) WITH NOWAIT
        RETURN
 
    END CATCH
    
END
GO