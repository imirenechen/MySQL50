#41. 按照出生日期來算，當前月日 < 出生年月的月日則，年齡減一
SELECT Sname,
	   TIMESTAMPDIFF(YEAR, Sage, CURDATE()) AS Age
	FROM student;
/*TIMESTAMPDIFF()；計算兩個日期時間的間隔, CURDATE()：取得當前日期*/


#42. 查詢本週過生日的學生
SELECT Sname
	FROM student
    WHERE WEEKOFYEAR(Sage) = WEEKOFYEAR(CURDATE());
/*WEEKOFYEAR(date)：返回日期用數字表示的範圍是從1到53的日曆周*/


#43. 查詢下週過生日的學生
SELECT Sname
	FROM student
    WHERE WEEKOFYEAR(Sage) = WEEKOFYEAR(CURDATE())+1;
    
    
#44. 查詢本月過生日的學生
SELECT Sname
	FROM student
    WHERE MONTH(Sage) = MONTH(CURDATE());
 
 
#45. 查詢下月過生日的學生
SELECT Sname
	FROM student
    WHERE MONTH(Sage) = MONTH(CURDATE())+1;