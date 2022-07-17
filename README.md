## MySQL50
Practice SQL 50 questions
* 題目資料表請參考 SQL50 Create Topic Table.sql
* 題目請參考 SQL50 Topic.sql
* 資料來源：網路

## 語法練習
**1. 查詢 "01" 課程比 "02" 課程成績高的學生的資訊及課程分數**
```sql
SELECT student.*,
       cid01.score AS 01_Score,
       cid02.score AS 02_Score
  FROM student
  JOIN (SELECT score, SId FROM sc WHERE CId = '01') cid01
  ON student.SId = cid01.SId
  JOIN (SELECT score, SId FROM sc WHERE CId = '02') cid02
  ON cid01.SId = cid02.SId
  WHERE cid01.score > cid02.score;
```
**1.1 查詢同時存在 "01" 課程和 "02" 課程的情況**
```sql
SELECT student.*,
       cid01.score AS 01_Score,
       cid02.score AS 02_Score
  FROM student
  JOIN (SELECT score, SId FROM sc WHERE CId = '01') cid01
  ON student.SId = cid01.SId
  JOIN (SELECT score, SId FROM sc WHERE CId = '02') cid02
  ON cid01.SId = cid02.SId;
 ```
**1.2 查詢存在 "01" 課程但可能不存在 "02" 課程的情況(不存在時顯示為 null)**
```sql
SELECT student.*,
       cid01.score AS 01_Score,
       cid02.score AS 02_Score
  FROM student
  JOIN (SELECT score, SId FROM sc WHERE CId = '01') cid01
  ON student.SId = cid01.SId
  LEFT JOIN (SELECT score, SId FROM sc WHERE CId = '02') cid02
  ON cid01.SId = cid02.SId;
```
**1.3 查詢不存在 "01" 課程但存在 "02" 課程的情況**
```sql
SELECT student.*,
       cid02.score AS 02_Score
  FROM student
  JOIN (SELECT score, SId FROM sc WHERE CId = '02') cid02
  ON student.SId = cid02.SId
  LEFT JOIN (SELECT score, SId FROM sc WHERE CId = '01') cid01
  ON cid02.SId = cid01.SId
  WHERE cid01.score IS NULL;
```
**2. 查詢平均成績大於等於 60 分的同學的學生編號和學生姓名和平均成績**
```sql
SELECT student.SId,
       student.Sname,
       ROUND(AVG(sc.score),2) AS Avg_Score
  FROM student
  JOIN sc
  ON student.SId = sc.SId
  GROUP BY SId
  HAVING Avg_Score >= 60;
```
**3. 查詢在 SC 表存在成績的學生資訊**

Remark: DISTINCT 回傳相異值, 顯示一次即可
```sql
SELECT DISTINCT student.*
  FROM student
  JOIN sc
  ON student.SId = sc.SId;
```
**4. 查詢所有同學的學生編號、學生姓名、選課總數、所有課程的總成績(沒成績的顯示為 null)**
```sql
SELECT student.SId,
       student.Sname,
       COUNT(sc.CId) AS '選課總數',
       SUM(sc.score) AS '總成績'
  FROM student
  LEFT JOIN sc
  ON student.SId = sc.SId
  GROUP BY SId;
```
**4.1 查有成績的學生資訊**
```sql
SELECT student.SId,
       student.Sname,
       COUNT(sc.CId) AS '選課總數',
       SUM(sc.score) AS '總成績'
  FROM student
  JOIN sc
  ON student.SId = sc.SId
  GROUP BY SId;
```
**5. 查詢「李」姓老師的數量**
```sql
SELECT COUNT(*)
  FROM teacher
  WHERE Tname LIKE '%李%';
```
**6. 查詢學過「張三」老師授課的同學的資訊**
```sql
SELECT student.*
  FROM student
  JOIN sc
  ON student.SId = sc.SId
  JOIN course
  ON sc.CId = course.CId
  JOIN teacher
  ON course.TId = teacher.TId
  WHERE Tname = '張三';
```
**7. 查詢沒有學全所有課程的同學的資訊**
```sql
SELECT student.*
  FROM student
  LEFT JOIN sc
  ON student.SId = sc.SId
  GROUP BY SId
  HAVING COUNT(sc.CId) < (SELECT COUNT(CId) FROM course);
```
**8. 查詢至少有一門課與學號為 "01" 的同學所學相同的同學的資訊**
```sql
SELECT DISTINCT student.*
  FROM student
  JOIN sc
  ON student.SId = sc.SId
  WHERE CId IN (SELECT CId FROM sc WHERE SId = '01') AND
        sc.SId != '01';
```
**9. 查詢和 "01" 號的同學學習的課程完全相同的其他同學的資訊**
```sql
SELECT *
  FROM student
  WHERE SId IN (SELECT SId FROM sc
                  WHERE CId IN (SELECT CId FROM sc WHERE SId = '01')
                  GROUP BY SId
                  HAVING COUNT(CId) = (SELECT COUNT(CId) FROM sc WHERE SId = '01'))
        AND SId != '01';
```
**10. 查詢沒學過「張三」老師講授的任一門課程的學生姓名**
```sql
SELECT Sname
  FROM student
  WHERE SId NOT IN (SELECT SId
                      FROM sc
                      LEFT JOIN course
                      ON sc.CId = course.CId
                      LEFT JOIN teacher
                      ON course.TId = teacher.TId
                      WHERE Tname = '張三');
```
**11. 查詢兩門及其以上不及格課程的同學的學號，姓名及其平均成績**
```sql
SELECT student.SId,
       student.Sname,
       ROUND(AVG(sc.score), 2) as Avg_Score
  FROM student
  JOIN sc
  ON student.SId = sc.SId
  WHERE score < 60
  GROUP BY SId
  HAVING COUNT(CId) >= 2;
```
**12. 檢索 "01" 課程分數小於 60，按分數降序排列的學生資訊**
```sql
SELECT student.*,
       sc.score
  FROM student
  JOIN sc
  ON student.SId = sc.SId
  WHERE CId = '01' AND score < 60
  ORDER BY score DESC;
```
**13. 按平均成績從高到低顯示所有學生的所有課程的成績以及平均成績**
```sql
SELECT sc.*,
       Avg_Score
  FROM sc
  LEFT JOIN (SELECT SId, 
                    ROUND(AVG(score),2) AS Avg_Score
              FROM sc 
              GROUP BY SId) average
  ON sc.SId = average.SId
  ORDER BY Avg_Score DESC;
```
**14. 查詢各科成績最高分、最低分和平均分**

以如下形式顯示：課程 ID，課程 name，最高分，最低分，平均分，及格率，中等率，優良率，優秀率
及格為>=60，中等為：70-80，優良為：80-90，優秀為：>=90
要求輸出課程號和選修人數，查詢結果按人數降序排列，若人數相同，按課程號升序排列
```sql
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
```
**15. 按各科成績進行排序，並顯示排名，Score 重複時保留名次空缺**

Remark: 名次的話, 排名為1→1→3, 保留名次空缺
```sql
SELECT sc.*,
       COUNT(rank_table.score) +1 AS Ranking
  FROM sc
  LEFT JOIN sc AS rank_table
  ON sc.CId = rank_table.CId
  AND sc.score < rank_table.score
  GROUP BY sc.CId, sc.SId
  ORDER BY sc.CId, Ranking;
```
**15.1 按各科成績進行行排序，並顯示排名，Score 重複時合併名次**

Remark: 同名次的話, 排名為1→1→2, 合併名次
```sql
SELECT sc.*,
       COUNT(DISTINCT rank_table.score) +1 AS Ranking
  FROM sc
  LEFT JOIN sc AS rank_table
  ON sc.CId = rank_table.CId
  AND sc.score < rank_table.score
  GROUP BY sc.CId, sc.SId
  ORDER BY sc.CId, Ranking;
```
**16. 查詢學生的總成績，並進行排名，總分重複時保留名次空缺**
```sql
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
```
**16.1 查詢學生的總成績，並進行排名，總分重複時不保留名次空缺**
```sql
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
```
**17. 統計各科成績各分數段人數：課程編號，課程名稱，[100-85]，[85-70]，[70-60]，[60-0] 及所佔百分比**
```sql
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
```
**18. 查詢各科成績前三名的記錄**
```sql
SELECT sc.*,
       COUNT(rank_table.score) +1 AS Ranking
  FROM sc
  LEFT JOIN sc AS rank_table
  ON sc.CId = rank_table.CId
  AND sc.score < rank_table.score
  GROUP BY sc.CId, sc.SId
  HAVING Ranking <= 3
  ORDER BY sc.CId, Ranking;
```
**19. 查詢每門課程被選修的學生數**
```sql
SELECT CId,
       COUNT(SId)
  FROM sc
  GROUP BY CId;
```
**20. 查詢出只選修兩門課程的學生學號和姓名**
```sql
SELECT student.SId,
       student.Sname
  FROM student
  JOIN sc
  ON student.SId = sc.SId
  GROUP BY sc.SId
  HAVING COUNT(sc.CId) = 2;
```
**21. 查詢男生、女生人數**
```sql
SELECT Ssex,
       COUNT(Ssex)
  FROM student
  GROUP BY Ssex;
``` 
**22. 查詢名字中含有「風」字的學生資訊**
```sql
SELECT *
  FROM student
  WHERE Sname LIKE '%風%';
```
**23. 查詢同名同性學生名單，並統計同名人數**
```sql
SELECT Sname,
       COUNT(Sname)
  FROM student
  GROUP BY Sname
  HAVING COUNT(Sname) > 1;
```   
**24. 查詢 1990 年出生的學生名單**
```sql
SELECT *
  FROM student
  WHERE Sage LIKE '%1990%';
```
**25. 查詢每門課程的平均成績，結果按平均成績降序排列，平均成績相同時，按課程編號升序排列**
```sql
SELECT CId,
       ROUND(AVG(score), 2) AS Avg_Score
  FROM sc
  GROUP BY CId
  ORDER BY Avg_Score DESC, CId;
```     
**26. 查詢平均成績大於等於 85 的所有學生的學號、姓名和平均成績**
```sql
SELECT student.SId,
       student.Sname,
       ROUND(AVG(sc.score), 2) AS Avg_Score
  FROM student
  JOIN sc
  ON student.SId = sc.SId
  GROUP BY sc.SId
  HAVING Avg_Score >= 85;
```
**27. 查詢課程名稱為「數學」，且分數低於 60 的學生姓名和分數**
```sql
SELECT student.Sname,
       sc.score
  FROM student
  JOIN sc
  ON student.SId = sc.SId
  JOIN course
  ON sc.CId = course.CId
  WHERE course.Cname = '數學' AND sc.score < 60;
``` 
**28. 查詢所有學生的課程及分數情況（存在學生沒成績，沒選課的情況）**
```sql
SELECT student.Sname,
       sc.CId,
       sc.score
  FROM student
  LEFT JOIN sc
  ON student.SId = sc.SId;
```
**29. 查詢任何一門課程成績在 70 分以上的姓名、課程名稱和分數**
```sql
SELECT student.Sname,
       course.Cname,
       sc.score
  FROM student
  JOIN sc
  ON student.SId = sc.SId
  JOIN course
  ON sc.CId = course.CId
  WHERE sc.score > 70;
```
**30. 查詢不及格的課程**
```sql
SELECT DISTINCT course.Cname
  FROM course
  JOIN sc
  ON course.CId = sc.CId
  WHERE sc.score < 60;
```
**31. 查詢課程編號為 "01" 且課程成績在 80 分以上的學生的學號和姓名**
```sql
SELECT student.SId,
       student.Sname
  FROM student
  JOIN sc
  ON student.SId = sc.SId
  WHERE sc.CId = '01' AND sc.score >= 80;
``` 
**32. 求每門課程的學生人數**
```sql
SELECT CId,
       COUNT(SId)
  FROM sc
  GROUP BY CId;
```
**33. 成績不重複，查詢選修「張三」老師所授課程的學生中，成績最高的學生資訊及其成績**
```sql
SELECT student.*,
       sc.score
  FROM student
  JOIN sc ON student.SId = sc.SId
  JOIN course ON sc.CId = course.CId
  JOIN teacher ON course.TId = teacher.TId
  WHERE teacher.Tname = '張三'
  ORDER BY sc.score DESC
  LIMIT 1;
```
**34. 成績有重複的情況下，查詢選修「張三」老師所授課程的學生中，成績最高的學生資訊及其成績**
```sql
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
```
**35. 查詢不同課程成績相同的學生的學生編號、課程編號、學生成績**
```sql
SELECT DISTINCT sc.*
  FROM sc
  JOIN sc AS temp
  ON sc.SId = temp.SId
  AND sc.score = temp.score
  AND sc.CId != temp.CId;
```
**36. 查詢每門課成績最好的前兩名**
```sql
SELECT sc.*,
       COUNT(rank_table.score) +1 AS Ranking
  FROM sc
  LEFT JOIN sc AS rank_table
  ON sc.CId = rank_table.CId
  AND sc.score < rank_table.score
  GROUP BY sc.CId, sc.SId
  HAVING Ranking <= 2
  ORDER BY sc.CId, Ranking;
```
**37. 統計每門課程的學生選修人數（超過 5 人的課程才統計）**
```sql
SELECT CId,
       COUNT(SId)
  FROM sc
  GROUP BY CId
  HAVING COUNT(SId) > 5;
```
**38. 檢索至少選修兩門課程的學生學號**
```sql
SELECT SId
  FROM sc
  GROUP BY SId
  HAVING COUNT(CId) >= 2;
```
**39. 查詢選修了全部課程的學生資訊**
```sql
SELECT student.*
  FROM student
  JOIN sc
  ON student.SId = sc.SId
  GROUP BY SId
  HAVING COUNT(CId) = (SELECT COUNT(DISTINCT CId) FROM course);
```
**40. 查詢各學生的年齡，只按年份來算**

Remark: YEAR( ) 用於返回指定日期的年份
```sql
SELECT Sname,
       YEAR(NOW()) - YEAR(Sage) AS Age
  FROM student;
```
**41. 按照出生日期來算，當前月日 < 出生年月的月日則，年齡減一**

Remark: TIMESTAMPDIFF( ) 計算兩個日期時間的間隔, CURDATE( ) 取得當前日期
```sql
SELECT Sname,
       TIMESTAMPDIFF(YEAR, Sage, CURDATE()) AS Age
  FROM student;
```
**42. 查詢本週過生日的學生**

Remark: WEEKOFYEAR(date) 返回日期用數字表示的範圍是從1到53的日曆周
```sql
SELECT Sname
  FROM student
  WHERE WEEKOFYEAR(Sage) = WEEKOFYEAR(CURDATE());
```
**43. 查詢下週過生日的學生**
```sql
SELECT Sname
  FROM student
  WHERE WEEKOFYEAR(Sage) = WEEKOFYEAR(CURDATE())+1;
``` 
**44. 查詢本月過生日的學生**
```sql
SELECT Sname
  FROM student
  WHERE MONTH(Sage) = MONTH(CURDATE());
```
**45. 查詢下月過生日的學生**
```sql
SELECT Sname
  FROM student
  WHERE MONTH(Sage) = MONTH(CURDATE())+1;
```
