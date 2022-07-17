#11. 查詢兩門及其以上不及格課程的同學的學號，姓名及其平均成績
SELECT student.SId,
	   student.Sname,
       ROUND(AVG(sc.score), 2) as Avg_Score
	FROM student
    JOIN sc
    ON student.SId = sc.SId
    WHERE score < 60
	GROUP BY SId
    HAVING COUNT(CId) >= 2;


#12. 檢索 "01" 課程分數小於 60，按分數降序排列的學生資訊
SELECT student.*,
	   sc.score
	FROM student
    JOIN sc
    ON student.SId = sc.SId
    WHERE CId = '01' AND score < 60
    ORDER BY score DESC;
    
    
#13. 按平均成績從高到低顯示所有學生的所有課程的成績以及平均成績
SELECT sc.*,
       Avg_Score
	FROM sc
    LEFT JOIN (SELECT SId, 
					  ROUND(AVG(score),2) AS Avg_Score
				FROM sc 
                GROUP BY SId) average
	ON sc.SId = average.SId
    ORDER BY Avg_Score DESC;
    

#14. 查詢各科成績最高分、最低分和平均分：
/*以如下形式顯示：課程 ID，課程 name，最高分，最低分，平均分，及格率，中等率，優良率，優秀率
及格為>=60，中等為：70-80，優良為：80-90，優秀為：>=90
要求輸出課程號和選修人數，查詢結果按人數降序排列，若人數相同，按課程號升序排列*/
SELECT course.CId AS '課程ID',
	   course.Cname AS '課程Name',
	   COUNT(sc.SId) AS '選修人數',
       MAX(sc.score) AS '最高分',
       MIN(sc.score) AS '最低分',
       ROUND(AVG(sc.score), 2) AS '平均分',
       ROUND(SUM(CASE WHEN score >= 60 THEN 1 ELSE 0 END) / COUNT(sc.SId) *100, 2) AS '及格率(%)',
       ROUND(SUM(CASE WHEN score >= 70 AND score < 80 THEN 1 ELSE 0 END) / COUNT(sc.SId) *100, 2) AS '中等率(%)',
       ROUND(SUM(CASE WHEN score >= 80 AND score < 90 THEN 1 ELSE 0 END) / COUNT(sc.SId) *100, 2) AS '優良率(%)',
       ROUND(SUM(CASE WHEN score >= 90 THEN 1 ELSE 0 END) / COUNT(sc.SId) *100, 2) AS '優秀率(%)'
	FROM course
    JOIN sc
    ON course.CId = sc.CId
    GROUP BY course.CId
    ORDER BY COUNT(sc.SId) DESC, sc.CId;
    

#15. 按各科成績進行排序，並顯示排名，Score 重複時保留名次空缺
SELECT sc.*,
       COUNT(rank_table.score) +1 AS Ranking
	FROM sc
    LEFT JOIN sc AS rank_table
    ON sc.CId = rank_table.CId
    AND sc.score < rank_table.score
    GROUP BY sc.CId, sc.SId
    ORDER BY sc.CId, Ranking;
/*同名次的話, 排名為1→1→3, 保留名次空缺*/


#15.1 按各科成績進行行排序，並顯示排名，Score 重複時合併名次
SELECT sc.*,
       COUNT(DISTINCT rank_table.score) +1 AS Ranking
	FROM sc
    LEFT JOIN sc AS rank_table
    ON sc.CId = rank_table.CId
    AND sc.score < rank_table.score
    GROUP BY sc.CId, sc.SId
    ORDER BY sc.CId, Ranking;
/*同名次的話, 排名為1→1→2, 合併名次*/


#16. 查詢學生的總成績，並進行排名，總分重複時保留名次空缺
SELECT a.SId,
       a.total_score,
       COUNT(b.total_score) +1 AS Ranking
	FROM (SELECT SId, SUM(score) AS total_score
          FROM sc GROUP BY SId) a
    LEFT JOIN (SELECT SId, SUM(score) AS total_score
			   FROM sc GROUP BY SId) b
    ON a.total_score < b.total_score
    GROUP BY a.SId
    ORDER BY Ranking;


#16.1 查詢學生的總成績，並進行排名，總分重複時不保留名次空缺
SELECT a.SId,
       a.total_score,
       COUNT(DISTINCT b.total_score) +1 AS Ranking
	FROM (SELECT SId, SUM(score) AS total_score
          FROM sc GROUP BY SId) a
    LEFT JOIN (SELECT SId, SUM(score) AS total_score
			   FROM sc GROUP BY SId) b
    ON a.total_score < b.total_score
    GROUP BY a.SId
    ORDER BY Ranking;


#17. 統計各科成績各分數段人數：課程編號，課程名稱，[100-85]，[85-70]，[70-60]，[60-0] 及所佔百分比
SELECT course.CId AS '課程編號',
	   course.Cname AS '課程名稱',
       ROUND(SUM(CASE WHEN score >= 85 THEN 1 ELSE 0 END) / COUNT(sc.SId) *100, 2) AS '[100-85](%)',
       ROUND(SUM(CASE WHEN score >= 70 AND score < 85 THEN 1 ELSE 0 END) / COUNT(sc.SId) *100, 2) AS '[85-70](%)',
       ROUND(SUM(CASE WHEN score >= 60 AND score < 70 THEN 1 ELSE 0 END) / COUNT(sc.SId) *100, 2) AS '[70-60](%)',
       ROUND(SUM(CASE WHEN score < 60 THEN 1 ELSE 0 END) / COUNT(sc.SId) *100, 2) AS '[60-0](%)'
	FROM course
    JOIN sc
    ON course.CId = sc.CId
    GROUP BY course.CId;


#18. 查詢各科成績前三名的記錄
SELECT sc.*,
       COUNT(rank_table.score) +1 AS Ranking
	FROM sc
    LEFT JOIN sc AS rank_table
    ON sc.CId = rank_table.CId
    AND sc.score < rank_table.score
    GROUP BY sc.CId, sc.SId
    HAVING Ranking <= 3
    ORDER BY sc.CId, Ranking;


#19. 查詢每門課程被選修的學生數
SELECT CId,
	   COUNT(SId)
	FROM sc
    GROUP BY CId;
    
#20. 查詢出只選修兩門課程的學生學號和姓名
SELECT student.SId,
	   student.Sname
	FROM student
    JOIN sc
    ON student.SId = sc.SId
    GROUP BY sc.SId
    HAVING COUNT(sc.CId) = 2;