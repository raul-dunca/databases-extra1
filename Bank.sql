--1)
CREATE TABLE Customers
( Cid int Primary key,
Cname Varchar(50),
CDob DATE,
)

CREATE TABLE BankAccount
(
Bid int Primary key,
Biban int,
Bbalance int,
Cid int References Customers(Cid)

)

CREATE TABLE Card
(
Caid int Primary key,
Canumber varchar(14),
CCV int,
Bid int References BankAccount(Bid)
)

CREATE TABLE ATM
(
Aid int Primary key,
Aaddress varchar(100)
)

CREATE TABLE Transactions
(
Tid int Primary key,
Aid int References ATM(Aid),
Tmoney int,
Caid int References Card(Caid),
time DATETIME,

)

--2)
ALTER PROCEDURE DeleteCardTransactions(@Caid int)
AS
	IF @Caid not in (SELECT Caid FROM Card )
		BEGIN
			RAISERROR('Card id not in Card Table',11,1)
		END
		ELSE
		BEGIN
			
			DELETE FROM Transactions 
			WHERE Caid=@Caid;
		END

GO

EXEC DeleteCardTransactions 1

--3)
ALTER VIEW AllAtms AS

SELECT Canumber
FROM Card
WHERE Caid IN
(
	SELECT Ca.Caid From Card CA  JOIn Transactions T on Ca.Caid=T.Caid
	GROUP BY Ca.Caid
	HAVING COUNT (DISTINCT T.Aid)=(SELECT COUNT(Aid) FROM ATM)
)


SELECT * FROM AllAtms

--4)

Create FUNCTION BigeerThan2000()
RETURNS TABLE
AS
 RETURN
 SELECT Canumber,CCV
 FROM Card
 WHERE Caid IN(
 SELECT C.Caid 
 FROM Card C JOIN Transactions T on T.Caid=C.Caid
 GROUP BY C.Caid
 HAVING SUM(T.Tmoney)>=2000
)
GO


SELECT *
FROM BigeerThan2000()


SELECT Ca.Caid From Card CA  INNER JOIN Transactions T on Ca.Caid=T.Caid
	GROUP BY Ca.Caid
	HAVING SUM(T.Aid)=2
SELECT * FROM ATM
SELECT * FROM Card
SELECT * FROM Transactions

INSERT  INTO ATM(Aid,Aaddress)
VALUES (2,'Sighet')

INSERT INTO Transactions(Tid,Aid,Caid,Tmoney,time)
VALUES(9,2,1,2100,'2016-06-18 01:34:09')