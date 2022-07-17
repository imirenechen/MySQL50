#31. 查詢課程編號為 "01" 且課程成績在 80 分以上的學生的學號和姓名
SELECT student.SId,
	   student.Sname
	FROM student
    JOIN sc
    ON student.SId = sc.SId
    WHERE sc.CId = '01' AND sc.score >= 80;
    
    
#32. 求每門課程的學生人數
SELECT CId,
	   COUNT(SId)
	FROM sc
    GROUP BY CId;
    
    
#33. 成績不重複，查詢選修「張三」老師所授課程的學生中，成績最高的學生資訊及其成績
SELECT student.*,
	   sc.score
	FROM student
    JOIN sc ON student.SId = sc.SId
    JOIN course ON sc.CId = course.CId
    JOIN teacher ON course.TId = teacher.TId
    WHERE teacher.Tname = '張三'
    ORDER BY sc.score DESC
    LIMIT 1;
    

#34. 成績有重複的情況下，查詢選修「張三」老師所授課程的學生中，成績最高的學生資訊及其成績
SELECT student.*,
	   sc.score
	FROM student
    JOIN sc ON student.SId = sc.SId
    JOIN course ON sc.CId = course.CId
    JOIN teacher ON course.TId = teacher.TId
    WHERE teacher.Tname = '張三'
    AND sc.score = (SELECT MAX(sc.score) FROM sc
						JOIN course ON sc.CId = course.CId
						JOIN teacher ON course.TId = teacher.TId
						WHERE teacher.Tname = '張三');


#35. 查詢不同課程成績相同的學生的學生編號、課程編號、學生成績
SELECT DISTINCT sc.*
	FROM sc
    JOIN sc AS temp
    ON sc.SId = temp.SId
    AND sc.score = temp.score
    AND sc.CId != temp.CId;


#36. 查詢每門課成績最好的前兩名
SELECT sc.*,
       COUNT(rank_table.score) +1 AS Ranking
	FROM sc
    LEFT JOIN sc AS rank_table
    ON sc.CId = rank_table.CId
    AND sc.score < rank_table.score
    GROUP BY sc.CId, sc.SId
    HAVING Ranking <= 2
    ORDER BY sc.CId, Ranking;


#37. 統計每門課程的學生選修人數（超過 5 人的課程才統計）
SELECT CId,
	   COUNT(SId)
	FROM sc
    GROUP BY CId
    HAVING COUNT(SId) >5;


#38. 檢索至少選修兩門課程的學生學號
SELECT SId
	FROM sc
    GROUP BY SId
    HAVING COUNT(CId) >= 2;
    
    
#39. 查詢選修了全部課程的學生資訊
SELECT student.*
	FROM student
    JOIN sc
    ON student.SId = sc.SId
    GROUP BY SId
    HAVING COUNT(CId) = (SELECT COUNT(DISTINCT CId) FROM course);


#40. 查詢各學生的年齡，只按年份來算
SELECT Sname,
	   YEAR(NOW()) - YEAR(Sage) AS Age
	FROM student;
/*YEAR()：用於返回指定日期的年份*/