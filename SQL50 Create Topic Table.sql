#1. 學生表：SId 學生編號, Sname 學生姓名, Sage 出生年月, Ssex 學生性別
create table Student (SId varchar(10), Sname varchar(10), Sage datetime, Ssex varchar(10));
insert into Student values('01' , '趙雷' , '1990-01-01' , '男');
insert into Student values('02' , '錢電' , '1990-12-21' , '男');
insert into Student values('03' , '孫風' , '1990-12-20' , '男');
insert into Student values('04' , '李雲' , '1990-12-06' , '男');
insert into Student values('05' , '周梅' , '1991-12-01' , '女');
insert into Student values('06' , '吳蘭' , '1992-01-01' , '女');
insert into Student values('07' , '鄭竹' , '1989-01-01' , '女');
insert into Student values('09' , '張三' , '2017-12-20' , '女');
insert into Student values('10' , '李四' , '2017-12-25' , '女');
insert into Student values('11' , '李四' , '2012-06-06' , '女');
insert into Student values('12' , '趙六' , '2013-06-13' , '女');
insert into Student values('13' , '孫七' , '2014-06-01' , '女');

#2. 課程表：CId 課程編號, Cname 課程名稱, TId 教師編號
create table Course(CId varchar(10),Cname nvarchar(10),TId varchar(10));
insert into Course values('01' , '語文' , '02');
insert into Course values('02' , '數學' , '01');
insert into Course values('03' , '英語' , '03');

#3. 教師表：TId 教師編號, Tname 教師姓名
create table Teacher(TId varchar(10),Tname varchar(10));
insert into Teacher values('01' , '張三');
insert into Teacher values('02' , '李四');
insert into Teacher values('03' , '王五');

#4. 成績表：SId 學生編號, CId 課程編號, score 分數
create table SC(SId varchar(10),CId varchar(10),score decimal(18,1));
insert into SC values('01' , '01' , 80);
insert into SC values('01' , '02' , 90);
insert into SC values('01' , '03' , 99);
insert into SC values('02' , '01' , 70);
insert into SC values('02' , '02' , 60);
insert into SC values('02' , '03' , 80);
insert into SC values('03' , '01' , 80);
insert into SC values('03' , '02' , 80);
insert into SC values('03' , '03' , 80);
insert into SC values('04' , '01' , 50);
insert into SC values('04' , '02' , 30);
insert into SC values('04' , '03' , 20);
insert into SC values('05' , '01' , 76);
insert into SC values('05' , '02' , 87);
insert into SC values('06' , '01' , 31);
insert into SC values('06' , '03' , 34);
insert into SC values('07' , '02' , 89);
insert into SC values('07' , '03' , 98);