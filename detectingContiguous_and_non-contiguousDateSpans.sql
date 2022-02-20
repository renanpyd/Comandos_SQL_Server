WITH
D AS (
    SELECT
        MAX( Src_From_Dt ) OVER (
            PARTITION BY
                Category_A ,
                Category_B ,
                Category_C
            ORDER BY
                Src_Upto_Dt ,
                Src_From_Dt
            ROWS BETWEEN
                1 PRECEDING
                AND
                1 PRECEDING
            ) AS Prev_From_Dt ,  -- not used, here for inspections
        MAX( Src_Upto_Dt ) OVER (
            PARTITION BY
                Category_A ,
                Category_B ,
                Category_C
            ORDER BY
                Src_Upto_Dt ,
                Src_From_Dt
            ROWS BETWEEN
                1 PRECEDING
                AND
                1 PRECEDING
            ) AS Prev_Upto_Dt ,
    A.*
    FROM
        DbsNm.TblNm AS A -- AS SrcTbl
    ) ,
E AS (
    SELECT
        CASE
            WHEN
                Prev_Upto_Dt IS NULL
                OR
                ( Src_From_Dt - Prev_Upto_Dt ) IN ( 0, 1, 2, 3 ) THEN 'C' -- Continuous
            ELSE 'D'  -- Discontinuous
            END AS Continuity ,
        ( --
            ROW_NUMBER() OVER (
                PARTITION BY
                    Category_A ,
                    Category_B ,
                    Category_C
                ORDER BY                  
                    Src_From_Dt )
            -
            ROW_NUMBER() OVER (
                PARTITION BY
                    Category_A ,
                    Category_B ,
                    Category_C ,
                    Continuity
                ORDER BY
                    Src_From_Dt )
            ) AS GrpNum ,
        D.*
    FROM
        D
    ) ,
F AS (
    SELECT
        Category_A ,
        Category_B ,
        Category_C ,
        GrpNum ,
        MIN( Src_From_Dt  ) AS CntntyGrp_From_Dt ,
        MAX( Src_Upto_Dt  ) AS CntntyGrp_Upto_Dt , -- not used, here for inspections
        COUNT(*) AS Rw_Cnt
    FROM
        E
    GROUP BY
        Category_A ,
        Category_B ,
        Category_C ,
        GrpNum
    ) ,
G AS (
    SELECT
        Category_A ,
        Category_B ,
        Category_C ,
        COUNT( DISTINCT CntntyGrp_From_Dt ) AS CntntyGrp_From_Dt_Ctd  ,
        COUNT(*) AS Rw_Cnt
    FROM
        F
    GROUP BY
    Category_A ,
    Category_B ,
    Category_C
    ) 
SELECT
    CntntyGrp_From_Dt_Ctd  ,
    MIN( Rw_Cnt ) AS Min_RwsPerSince ,
    MAX( Rw_Cnt ) AS Max_RwsPerSince ,
    COUNT(*) AS CategoryCombo_Cnt ,
    MIN( Category_A ) AS Min_Category_A ,
    MAX( Category_A ) AS Max_Category_A
FROM
    G
GROUP BY
    CntntyGrp_From_Dt_Ctd
ORDER BY
    CategoryCombo_Cnt DESC ,
    Max_RwsPerSince DESC
;