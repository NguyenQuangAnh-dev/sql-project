/* =====================================================================
   BACKUP / RESTORE - DATABASE QuanLyBenhVien
   Chay TUNG BUOC theo thu tu (boi den tung lenh roi bam Execute),
   khong chay ca file mot lan.
   ===================================================================== */

-- BUOC 1) Chuan bi:
--   Dung thu muc Backup mac dinh cua SQL Server (khong can cap quyen them).

-- BUOC 2) Backup (full backup)
USE master;
GO
BACKUP DATABASE QuanLyBenhVien
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\QuanLyBenhVien.bak'
WITH INIT, CHECKSUM, STATS = 10;
GO

-- BUOC 3) Kiem tra file backup co hop le (chua khoi phuc gi ca)
RESTORE VERIFYONLY
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\QuanLyBenhVien.bak'
WITH CHECKSUM;
GO

-- BUOC 4) Xem ten logical file ben trong ban backup
--   Ghi lai cot LogicalName cua file du lieu (Type = D) va file log (Type = L).
RESTORE FILELISTONLY
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\QuanLyBenhVien.bak';
GO

-- BUOC 5) Restore vao database thu nghiem (khong de len database goc)
--   LogicalName lay tu BUOC 4: 'QuanLyBenhVien' (data) va 'QuanLyBenhVien_log' (log).
--   Neu database da ton tai: DROP DATABASE QuanLyBenhVien_Test truoc (xem BUOC 8).
RESTORE DATABASE QuanLyBenhVien_Test
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\QuanLyBenhVien.bak'
WITH
    MOVE N'QuanLyBenhVien' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\QuanLyBenhVien_Test.mdf',
    MOVE N'QuanLyBenhVien_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\QuanLyBenhVien_Test_log.ldf',
    RECOVERY, CHECKSUM, STATS = 10;
GO

-- BUOC 6) Kiem tra ket qua restore
USE QuanLyBenhVien_Test;
GO
SELECT name FROM sys.tables ORDER BY name;
GO

-- BUOC 7) So sanh so dong TAT CA cac bang giua DB goc va DB restore
--   Hai ket qua phai giong het nhau (chay sau khi da co du lieu mau).
USE QuanLyBenhVien;
SELECT 'GOC' AS CoSo, t.name AS Bang, SUM(p.rows) AS SoDong
FROM sys.tables t JOIN sys.partitions p ON p.object_id = t.object_id AND p.index_id IN (0,1)
GROUP BY t.name ORDER BY t.name;
GO
USE QuanLyBenhVien_Test;
SELECT 'TEST' AS CoSo, t.name AS Bang, SUM(p.rows) AS SoDong
FROM sys.tables t JOIN sys.partitions p ON p.object_id = t.object_id AND p.index_id IN (0,1)
GROUP BY t.name ORDER BY t.name;
GO

-- BUOC 8) Don dep (chay truoc khi restore lai, hoac sau khi demo xong)
-- USE master;
-- GO
-- ALTER DATABASE QuanLyBenhVien_Test SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
-- DROP DATABASE QuanLyBenhVien_Test;
-- GO