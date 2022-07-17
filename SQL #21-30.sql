#21. 查詢男生、女生人數
SELECT Ssex,
	   COUNT(Ssex)
	FROM student
    GROUP BY Ssex;
    
    
#22. 查詢名字中含有「風」字的學生資訊
SELECT *
	FROM student
    WHERE Sname LIKE '%風%';
    
    
#23. 查詢同名同性學生名單，並統計同名人數
SELECT Sname,
       COUNT(Sname)
	FROM student
    GROUP BY Sname
    HAVING COUNT(Sname) > 1;
    
    
#24. 查詢 1990 年出生的學生名單
SELECT *
	FROM student
    WHERE Sage LIKE '%1990%';
    
    
#25. 查詢每門課程的平均成績，結果按平均成績降序排列，平均成績相同時，按課程編號升序排列
SELECT CId,
       ROUND(AVG(score), 2) AS Avg_Score
	FROM sc
    GROUP BY CId
    ORDER BY Avg_Score DESC, CId;
    
    
#26. 查詢平均成績大於等於 85 的所有學生的學號、姓名和平均成績
SELECT student.SId,
	   student.Sname,
       ROUND(AVG(sc.score), 2) AS Avg_Score
	FROM student
    JOIN sc
    ON student.SId = sc.SId
    GROUP BY sc.SId
    HAVING Avg_Score >= 85;
    
    
#27. 查詢課程名稱為「數學」，且分數低於 60 的學生姓名和分數
SELECT student.Sname,
	   sc.score
	FROM student
    JOIN sc
    ON student.SId = sc.SId
    JOIN course
    ON sc.CId = course.CId
    WHERE course.Cname = '數學' AND sc.score < 60;
    
    
#28. 查詢所有學生的課程及分數情況（存在學生沒成績，沒選課的情況）
SELECT student.Sname,
       sc.CId,
	   sc.score
	FROM student
    LEFT JOIN sc
    ON student.SId = sc.SId;
    
    
#29. 查詢任何一門課程成績在 70 分以上的姓名、課程名稱和分數
SELECT student.Sname,
	   course.Cname,
       sc.score
	FROM student
    JOIN sc
    ON student.SId = sc.SId
    JOIN course
    ON sc.CId = course.CId
    WHERE sc.score > 70;

#30. 查詢不及格的課程
SELECT DISTINCT course.Cname
	FROM course
    JOIN sc
    ON course.CId = sc.CId
    WHERE sc.score < 60;