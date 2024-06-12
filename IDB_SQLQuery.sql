

--Q1
select m.MemberName, count(case l.Stat when 'Unreturned' then 1 else null end) as 'Total Book Lending'
from MEMBER_DETAILS m inner join LENDING_RECORDS l on m.MemberID = l.MemberID
group by m.MemberName
having count(l.LendingID) > 2
order by m.MemberName asc;


--Q2
select c.Categories, count(b.BookID) as 'Total Number of Book'
from CATALOGUE b left join CATEGORIES c on c.CategoriesID = b.CategoriesID left join LENDING_RECORDS l on b.BookID = l.BookID 
where l.BookID is null or l.Stat = 'Returned' and l.BorrowDate = (select max(l2.BorrowDate) from LENDING_RECORDS l2 where l.BookID = l2.BookID)
group by c.Categories
order by count(b.BookID) desc;


--Q3
select BookTitle, BookAuthor, Publisher
from CATALOGUE
where BookAuthor in ('Thomas Connolly','Ramez Elmasri')


--QQ2
select d.DepartmentName, m.MemberName, m.EmailAddress, m.Roles, count(l.LendingID) as 'Total Book Lended'
from DEPARTMENTS d inner join MEMBER_DETAILS m on d.DepartmentID = m.DepartmentID inner join LENDING_RECORDS l on m.MemberID = l.MemberID
where l.BorrowDate between DATEADD(YYYY,-1,GETDATE()) and GETDATE()
group by d.DepartmentName, m.MemberName, m.EmailAddress, m.Roles
having count(l.LendingID) < 10
order by d.DepartmentName, m.MemberName asc;

--QQ2
select d.DepartmentName, count(case m.Roles when 'Student' then 1 else null end) as 'student', count(case m.Roles when 'Lecture' then 1 else null end) as 'staff'
from DEPARTMENTS d join MEMBER_DETAILS m on d.DepartmentID = m.DepartmentID join LENDING_RECORDS l on m.MemberID = l.MemberID
group by d.DepartmentName

--QQ1
select r.MemberID, m.MemberName, r.BookID, b.BookTitle, l.Stat
from RESERVATION r join MEMBER_DETAILS m on r.MemberID = m.MemberID join CATALOGUE b on r.BookID = b.BookID join LENDING_RECORDS l on r.BookID = l.BookID
where r.ReservationStatus = 'Reserving' and l.BorrowDate = (select max(l2.BorrowDate) from LENDING_RECORDS l2 where l.BookID = l2.BookID)
group by r.MemberID, m.MemberName, r.BookID, b.BookTitle, l.Stat

--QQ3
select l.MemberID, m.MemberName, l.BookID, b.BookTitle, c.FinePerDay*DATEDIFF(day, l.DueDate, l.ActualReturnDate) as 'Fines'
from LENDING_RECORDS l join MEMBER_DETAILS m on l.MemberID = m.MemberID join CATALOGUE b on l.BookID = b.BookID join CATEGORIES c on b.CategoriesID = c.CategoriesID
where l.ActualReturnDate > l.DueDate