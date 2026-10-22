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
    MOVE N'QuanLyBenhVien_log'
        TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\QuanLyBenhVien_Test_log.ldf',
    RECOVERY,
    STATS = 10;
GO

/* ================================================================
   BUOC 7. KIEM TRA DATABASE SAU KHI RESTORE
   Mong doi: 11 bang va 4 trigger.
   ================================================================ */
USE QuanLyBenhVien_Test;
GO

SELECT COUNT(*) AS SoBang
FROM sys.tables;
GO

SELECT name AS TenTrigger,
       OBJECT_NAME(parent_id) AS BangTacDong,
       is_disabled AS BiVoHieuHoa
FROM sys.triggers
ORDER BY name;
GO

/* ================================================================
   BUOC 8. DOI CHIEU SO DONG GIUA DATABASE GOC VA DATABASE RESTORE
   Hai cot SoDongGoc va SoDongTest cua moi bang phai bang nhau.
   Luu y: neu nap du lieu mau SAU khi backup thi so dong se khac nhau;
   khi do hay backup lai roi restore lai truoc khi doi chieu.
   ================================================================ */
SELECT N'Khoa' AS Bang,
       (SELECT COUNT(*) FROM QuanLyBenhVien.dbo.Khoa) AS SoDongGoc,
       (SELECT COUNT(*) FROM QuanLyBenhVien_Test.dbo.Khoa) AS SoDongTest
UNION ALL SELECT N'BacSi',
       (SELECT COUNT(*) FROM QuanLyBenhVien.dbo.BacSi),
       (SELECT COUNT(*) FROM QuanLyBenhVien_Test.dbo.BacSi)
UNION ALL SELECT N'BenhNhan',
       (SELECT COUNT(*) FROM QuanLyBenhVien.dbo.BenhNhan),
       (SELECT COUNT(*) FROM QuanLyBenhVien_Test.dbo.BenhNhan)
UNION ALL SELECT N'LichKham',
       (SELECT COUNT(*) FROM QuanLyBenhVien.dbo.LichKham),
       (SELECT COUNT(*) FROM QuanLyBenhVien_Test.dbo.LichKham)
UNION ALL SELECT N'HoSoBenhAn',
       (SELECT COUNT(*) FROM QuanLyBenhVien.dbo.HoSoBenhAn),
       (SELECT COUNT(*) FROM QuanLyBenhVien_Test.dbo.HoSoBenhAn)
UNION ALL SELECT N'DonThuoc',
       (SELECT COUNT(*) FROM QuanLyBenhVien.dbo.DonThuoc),
       (SELECT COUNT(*) FROM QuanLyBenhVien_Test.dbo.DonThuoc)
UNION ALL SELECT N'Thuoc',
       (SELECT COUNT(*) FROM QuanLyBenhVien.dbo.Thuoc),
       (SELECT COUNT(*) FROM QuanLyBenhVien_Test.dbo.Thuoc)
UNION ALL SELECT N'ChiTietDonThuoc',
       (SELECT COUNT(*) FROM QuanLyBenhVien.dbo.ChiTietDonThuoc),
       (SELECT COUNT(*) FROM QuanLyBenhVien_Test.dbo.ChiTietDonThuoc)
UNION ALL SELECT N'DichVu',
       (SELECT COUNT(*) FROM QuanLyBenhVien.dbo.DichVu),
       (SELECT COUNT(*) FROM QuanLyBenhVien_Test.dbo.DichVu)
UNION ALL SELECT N'ChiTietDichVu',
       (SELECT COUNT(*) FROM QuanLyBenhVien.dbo.ChiTietDichVu),
       (SELECT COUNT(*) FROM QuanLyBenhVien_Test.dbo.ChiTietDichVu)
UNION ALL SELECT N'HoaDon',
       (SELECT COUNT(*) FROM QuanLyBenhVien.dbo.HoaDon),
       (SELECT COUNT(*) FROM QuanLyBenhVien_Test.dbo.HoaDon);
GO

USE master;
GO