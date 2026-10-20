/*
    backup_restore.sql
    Du an: QuanLyBenhVien
    Moi truong: SQL Server 2022 Express - (local)\SQLEXPRESS

    Muc dich:
      1. Sao luu full database QuanLyBenhVien.
      2. Xem lich su backup va kiem tra file backup.
      3. Xem logical file trong ban backup.
      4. Phuc hoi vao QuanLyBenhVien_Test (khong ghi de database goc).
      5. Kiem tra bang, trigger va so sanh so dong.

    LUU Y:
      - Chay bang tai khoan co quyen backup/restore database.
      - SQL Server service account can quyen ghi vao thu muc Backup.
      - Duong dan va logical file duoi day theo cau hinh hien tai cua nhom.
      - Script se xoa database QuanLyBenhVien_Test neu database nay da ton tai,
        de co the restore lai. KHONG doi ten database thu nghiem thanh database goc.
      - Khong dua file .bak len GitHub.
*/

USE master;
GO

/* ================================================================
   BUOC 1. FULL BACKUP
   ================================================================ */
BACKUP DATABASE [QuanLyBenhVien]
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\QuanLyBenhVien.bak'
WITH INIT, CHECKSUM, NAME = N'QuanLyBenhVien-Full', STATS = 10;
GO

/* ================================================================
   BUOC 2. KIEM TRA LICH SU BACKUP
   ================================================================ */
SELECT TOP (10)
       bs.database_name,
       bs.backup_start_date,
       bs.backup_finish_date,
       CASE bs.type
           WHEN 'D' THEN N'Full'
           WHEN 'I' THEN N'Differential'
           WHEN 'L' THEN N'Log'
           ELSE bs.type
       END AS BackupType,
       bs.backup_size,
       bs.is_copy_only,
       bmf.physical_device_name AS BackupFile
FROM msdb.dbo.backupset AS bs
INNER JOIN msdb.dbo.backupmediafamily AS bmf
    ON bs.media_set_id = bmf.media_set_id
WHERE bs.database_name = N'QuanLyBenhVien'
ORDER BY bs.backup_finish_date DESC;
GO

/* ================================================================
   BUOC 3. KIEM TRA TINH DOC DUOC CUA FILE BACKUP
   VERIFYONLY khong thay the cho viec restore thu nghiem thuc te.
   ================================================================ */
RESTORE VERIFYONLY
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\QuanLyBenhVien.bak'
WITH CHECKSUM;
GO

/* ================================================================
   BUOC 4. XEM LOGICAL FILE NAME TRONG BAN BACKUP
   Kiem tra ket qua: Type D = data, Type L = log.
   MOVE o buoc 6 phai dung LogicalName thuc te.
   ================================================================ */
RESTORE FILELISTONLY
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\QuanLyBenhVien.bak';
GO

/* ================================================================
   BUOC 5. DON DEP DATABASE THU NGHIEM NEU DA TON TAI
   Chi xoa QuanLyBenhVien_Test, khong tac dong QuanLyBenhVien.
   Neu khong muon xoa DB thu nghiem cu, hay comment khoi lenh nay va
   tu xu ly truoc khi restore.
   ================================================================ */
IF DB_ID(N'QuanLyBenhVien_Test') IS NOT NULL
BEGIN
    ALTER DATABASE [QuanLyBenhVien_Test]
        SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [QuanLyBenhVien_Test];
END;
GO

/* ================================================================
   BUOC 6. RESTORE SANG DATABASE THU NGHIEM
   LogicalName ben duoi phai khop voi ket qua RESTORE FILELISTONLY.
   ================================================================ */
RESTORE DATABASE [QuanLyBenhVien_Test]
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\QuanLyBenhVien.bak'
WITH
    MOVE N'QuanLyBenhVien'
        TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\QuanLyBenhVien_Test.mdf',