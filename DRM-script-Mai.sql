-- Phim goi
SELECT COUNT(CustomerID) AS Total_key, Date_1, CASE WHEN Date_1 IS NOT NULL THEN 'PHIMGOI' END AS Service_name
INTO #PHIMGOI
FROM
(SELECT DISTINCT CustomerID, MIN(CAST(Date AS DATE)) OVER(PARTITION BY CustomerID, ServiceID , Date) AS Date_1
FROM SalesLT.CustomerService cs 
WHERE ServiceID IN (60, 148)) AS tmp
GROUP BY Date_1
ORDER BY Date_1 ASC;

-- Log_BHD DRM
SELECT COUNT(CustomerID) AS Total_Key, Date_1, CASE WHEN Date_1 IS NOT NULL THEN 'BHD' END AS Service_name
INTO #BHD_drm
FROM
(
SELECT DISTINCT CustomerID, MIN(CAST(Date AS DATE)) OVER(PARTITION BY CustomerID, MovieID, Date) AS Date_1
FROM SalesLT.Log_BHD_MovieID lbmi
INNER JOIN SalesLT.MV_PropertiesShowVN mpsv
ON mpsv.id = lbmi.movieid
WHERE mpsv.isDRM  = 1
) AS BHD
GROUP BY Date_1
ORDER BY Date_1 ASC;

-- Log_Fimplus DRM 
SELECT COUNT(CustomerID) AS Total_Key, Date_1, CASE WHEN Date_1 IS NOT NULL THEN 'FIM+' END AS Service_name
INTO #FIM_drm
FROM
(
SELECT DISTINCT CustomerID, MIN(CAST(Date AS DATE)) OVER(PARTITION BY CustomerID, MovieID, Date) AS Date_1
FROM SalesLT.Log_Fimplus_MovieID lfmi
INNER JOIN SalesLT.MV_PropertiesShowVN mpsv
ON mpsv.id = lfmi.movieid
WHERE mpsv.isDRM  = 1
) AS FIM
GROUP BY Date_1
ORDER BY Date_1 ASC;

-- 3 services
SELECT * FROM #FIM_drm
UNION
SELECT * FROM #BHD_drm
UNION
SELECT * FROM #PHIMGOI
ORDER BY Date_1 ASC


