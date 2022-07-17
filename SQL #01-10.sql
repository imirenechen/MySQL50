#1. 查詢 "01" 課程比 "02" 課程成績高的學生的資訊及課程分數
SELECT student.*,
	   cid01.score AS 01_Score,
       cid02.score AS 02_Score
	FROM student
    JOIN (SELECT score, SId FROM sc WHERE CId = '01') cid01
    ON student.SId = cid01.SId
    JOIN (SELECT score, SId FROM sc WHERE CId = '02') cid02
    ON cid01.SId = cid02.SId
    WHERE cid01.score > cid02.score;

    
#1.1 查詢同時存在 "01" 課程和 "02" 課程的情況
SELECT student.*,
       cid01.score AS 01_Score,
       cid02.score AS 02_Score
	FROM student
    JOIN (SELECT score, SId FROM sc WHERE CId = '01') cid01
    ON student.SId = cid01.SId
    JOIN (SELECT score, SId FROM sc WHERE CId = '02') cid02
    ON cid01.SId = cid02.SId;
    
    
#1.2 查詢存在 "01" 課程但可能不存在 "02" 課程的情況(不存在時顯示為 null)
SELECT student.*,
       cid01.score AS 01_Score,
       cid02.score AS 02_Score
	FROM student
    JOIN (SELECT score, SId FROM sc WHERE CId = '01') cid01
    ON student.SId = cid01.SId
    LEFT JOIN (SELECT score, SId FROM sc WHERE CId = '02') cid02
    ON cid01.SId = cid02.SId;
    
    
#1.3 查詢不存在 "01" 課程但存在 "02" 課程的情況
SELECT student.*,
       cid02.score AS 02_Score
	FROM student
    JOIN (SELECT score, SId FROM sc WHERE CId = '02') cid02
    ON student.SId = cid02.SId
    LEFT JOIN (SELECT score, SId FROM sc WHERE CId = '01') cid01
    ON cid02.SId = cid01.SId
    WHERE cid01.score IS NULL;


#2. 查詢平均成績大於等於 60 分的同學的學生編號和學生姓名和平均成績
SELECT student.SId,
	   student.Sname,
       ROUND(AVG(sc.score),2) AS Avg_Score
	FROM student
    JOIN sc
    ON student.SId = sc.SId
    GROUP BY SId
    HAVING Avg_Score >= 60;
    
    
#3. 查詢在 SC 表存在成績的學生資訊
SELECT DISTINCT student.*
	FROM student
    JOIN sc
    ON student.SId = sc.SId;
#Remark: DISTINCT 回傳相異值, 顯示一次即可


#4. 查詢所有同學的學生編號、學生姓名、選課總數、所有課程的總成績(沒成績的顯示為 null)
SELECT student.SId,
	   student.Sname,
       COUNT(sc.CId) AS '選課總數',
       SUM(sc.score) AS '總成績'
	FROM student
    LEFT JOIN sc
    ON student.SId = sc.SId
    GROUP BY SId;
    
    
#4.1 查有成績的學生資訊
SELECT student.SId,
	   student.Sname,
       COUNT(sc.CId) AS '選課總數',
       SUM(sc.score) AS '總成績'
	FROM student
    JOIN sc
    ON student.SId = sc.SId
    GROUP BY SId;


#5. 查詢「李」姓老師的數量
SELECT COUNT(*)
	FROM teacher
    WHERE Tname LIKE '%李%';


#6. 查詢學過「張三」老師授課的同學的資訊
SELECT student.*
	FROM student
    JOIN sc
    ON student.SId = sc.SId
    JOIN course
    ON sc.CId = course.CId
    JOIN teacher
    ON course.TId = teacher.TId
    WHERE Tname = '張三';
    

#7. 查詢沒有學全所有課程的同學的資訊
SELECT student.*
	FROM student
    LEFT JOIN sc
    ON student.SId = sc.SId
    GROUP BY SId
    HAVING COUNT(sc.CId) < (SELECT COUNT(CId) FROM course);
    

#8. 查詢至少有一門課與學號為 "01" 的同學所學相同的同學的資訊
SELECT DISTINCT student.*
	FROM student
    JOIN sc
    ON student.SId = sc.SId
    WHERE CId IN (SELECT CId FROM sc WHERE SId = '01') AND
		  sc.SId != '01';
          

#9. 查詢和 "01" 號的同學學習的課程完全相同的其他同學的資訊
SELECT *
	FROM student
    WHERE SId IN (SELECT SId FROM sc
					WHERE CId IN (SELECT CId FROM sc WHERE SId = '01')
                    GROUP BY SId
                    HAVING COUNT(CId) = (SELECT COUNT(CId) FROM sc WHERE SId = '01'))
		   AND SId != '01';
          
          
#10. 查詢沒學過「張三」老師講授的任一門課程的學生姓名
SELECT Sname
	FROM student
    WHERE SId NOT IN (
		SELECT SId
			FROM sc
            LEFT JOIN course
			ON sc.CId = course.CId
			LEFT JOIN teacher
			ON course.TId = teacher.TId
			WHERE Tname = '張三');
