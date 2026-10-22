USE QuanLyBenhVien;
GO

/* ---------------------------------------------------------------------
   T1: Ke thuoc du ton kho
   Them DT03 - T03 x10 (don gia 1000)
   Mong doi: T03 180 -> 170 ; HD03 159000 -> 169000
   --------------------------------------------------------------------- */
PRINT N'===== T1: Ke thuoc du ton kho =====';
SELECT N'TRUOC' AS ThoiDiem, T.MaThuoc, T.SoLuongTon, H.MaHD, H.TongTien
FROM Thuoc T, HoaDon H WHERE T.MaThuoc = 'T03' AND H.MaHD = 'HD03';

BEGIN TRAN;
    INSERT INTO ChiTietDonThuoc (MaDT, MaThuoc, LieuDung, SoLuong, DonGiaKe)
    VALUES ('DT03', 'T03', N'1 vien/ngay', 10, 1000);

    SELECT N'SAU' AS ThoiDiem, T.MaThuoc, T.SoLuongTon, H.MaHD, H.TongTien
    FROM Thuoc T, HoaDon H WHERE T.MaThuoc = 'T03' AND H.MaHD = 'HD03';
ROLLBACK;
GO

/* ---------------------------------------------------------------------
   T2: Ke thuoc VUOT ton kho
   T04 chi con 5, ke 10 -> trigger bao loi 51001, du lieu khong doi
   --------------------------------------------------------------------- */
PRINT N'===== T2: Ke thuoc vuot ton kho =====';
SELECT N'TRUOC' AS ThoiDiem, MaThuoc, SoLuongTon FROM Thuoc WHERE MaThuoc = 'T04';

BEGIN TRAN;
BEGIN TRY
    INSERT INTO ChiTietDonThuoc (MaDT, MaThuoc, LieuDung, SoLuong, DonGiaKe)
    VALUES ('DT03', 'T04', N'1 vien/ngay', 10, 2500);
    PRINT N'!!! KHONG MONG DOI: lenh chay thanh cong';
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS MaLoi, ERROR_MESSAGE() AS ThongBao;  -- mong doi 51001
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;

SELECT N'SAU' AS ThoiDiem, MaThuoc, SoLuongTon FROM Thuoc WHERE MaThuoc = 'T04';  -- van = 5
GO

/* ---------------------------------------------------------------------
   T3a: So luong = 0
   Bi chan boi rang buoc CHECK (SoLuong > 0) cua bang -> loi 547
   (rang buoc CHECK chay truoc trigger)
   --------------------------------------------------------------------- */
PRINT N'===== T3a: So luong = 0 =====';
BEGIN TRAN;
BEGIN TRY
    INSERT INTO ChiTietDonThuoc (MaDT, MaThuoc, LieuDung, SoLuong, DonGiaKe)
    VALUES ('DT03', 'T05', N'1 vien/ngay', 0, 2000);
    PRINT N'!!! KHONG MONG DOI: lenh chay thanh cong';
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS MaLoi, ERROR_MESSAGE() AS ThongBao;  -- mong doi 547
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
GO

/* ---------------------------------------------------------------------
   T3b: So luong = NULL
   CHECK cho phep NULL, nen trigger se chan -> loi 51002
   --------------------------------------------------------------------- */
PRINT N'===== T3b: So luong = NULL =====';
BEGIN TRAN;
BEGIN TRY
    INSERT INTO ChiTietDonThuoc (MaDT, MaThuoc, LieuDung, SoLuong, DonGiaKe)
    VALUES ('DT03', 'T05', N'1 vien/ngay', NULL, 2000);
    PRINT N'!!! KHONG MONG DOI: lenh chay thanh cong';
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS MaLoi, ERROR_MESSAGE() AS ThongBao;  -- mong doi 51002
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
GO

/* ---------------------------------------------------------------------
   T4a: UPDATE tang so luong thuoc da ke
   DT01 - T01: 10 -> 15 (tang 5)
   Mong doi: T01 84 -> 79 ; HD01 385000 -> 392500
   --------------------------------------------------------------------- */
PRINT N'===== T4a: UPDATE tang so luong =====';
SELECT N'TRUOC' AS ThoiDiem, T.MaThuoc, T.SoLuongTon, H.MaHD, H.TongTien
FROM Thuoc T, HoaDon H WHERE T.MaThuoc = 'T01' AND H.MaHD = 'HD01';

BEGIN TRAN;
    UPDATE ChiTietDonThuoc SET SoLuong = 15
    WHERE MaDT = 'DT01' AND MaThuoc = 'T01';

    SELECT N'SAU' AS ThoiDiem, T.MaThuoc, T.SoLuongTon, H.MaHD, H.TongTien
    FROM Thuoc T, HoaDon H WHERE T.MaThuoc = 'T01' AND H.MaHD = 'HD01';
ROLLBACK;
GO

/* ---------------------------------------------------------------------
   T4b: UPDATE giam so luong -> ton kho duoc hoan lai
   DT01 - T01: 10 -> 4 (giam 6)
   Mong doi: T01 84 -> 90 ; HD01 385000 -> 376000
   --------------------------------------------------------------------- */
PRINT N'===== T4b: UPDATE giam so luong =====';
BEGIN TRAN;
    UPDATE ChiTietDonThuoc SET SoLuong = 4
    WHERE MaDT = 'DT01' AND MaThuoc = 'T01';

    SELECT N'SAU' AS ThoiDiem, T.MaThuoc, T.SoLuongTon, H.MaHD, H.TongTien
    FROM Thuoc T, HoaDon H WHERE T.MaThuoc = 'T01' AND H.MaHD = 'HD01';
ROLLBACK;
GO

/* ---------------------------------------------------------------------
   T4c: UPDATE tang vuot ton kho -> loi 51001
   DT01 - T01: 10 -> 500 (can them 490, ton chi 84)
   --------------------------------------------------------------------- */
PRINT N'===== T4c: UPDATE vuot ton kho =====';
BEGIN TRAN;
BEGIN TRY
    UPDATE ChiTietDonThuoc SET SoLuong = 500
    WHERE MaDT = 'DT01' AND MaThuoc = 'T01';
    PRINT N'!!! KHONG MONG DOI: lenh chay thanh cong';
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS MaLoi, ERROR_MESSAGE() AS ThongBao;  -- mong doi 51001
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;

SELECT N'SAU' AS ThoiDiem, MaThuoc, SoLuongTon FROM Thuoc WHERE MaThuoc = 'T01';  -- van = 84
GO

/* ---------------------------------------------------------------------
   T5: DELETE chi tiet don thuoc -> hoan ton kho, giam TongTien
   Xoa DT01 - T03 (20 vien x 1000)
   Mong doi: T03 180 -> 200 ; HD01 385000 -> 365000
   --------------------------------------------------------------------- */
PRINT N'===== T5: DELETE chi tiet don thuoc =====';
SELECT N'TRUOC' AS ThoiDiem, T.MaThuoc, T.SoLuongTon, H.MaHD, H.TongTien
FROM Thuoc T, HoaDon H WHERE T.MaThuoc = 'T03' AND H.MaHD = 'HD01';

BEGIN TRAN;
    DELETE FROM ChiTietDonThuoc WHERE MaDT = 'DT01' AND MaThuoc = 'T03';

    SELECT N'SAU' AS ThoiDiem, T.MaThuoc, T.SoLuongTon, H.MaHD, H.TongTien
    FROM Thuoc T, HoaDon H WHERE T.MaThuoc = 'T03' AND H.MaHD = 'HD01';
ROLLBACK;
GO

/* ---------------------------------------------------------------------
   T6: Them / sua / xoa dich vu -> TongTien tinh lai
   HD03 ban dau = 159000
   Them DV04 (180000)      -> 339000
   Sua so luong len 2      -> 519000
   Xoa dich vu do          -> 159000
   --------------------------------------------------------------------- */
PRINT N'===== T6: Them/sua/xoa dich vu =====';
SELECT N'0. Ban dau' AS Buoc, MaHD, TongTien FROM HoaDon WHERE MaHD = 'HD03';

BEGIN TRAN;
    INSERT INTO ChiTietDichVu (MaBA, MaDV, LanThucHien, SoLuong, DonGiaApDung)
    VALUES ('BA03', 'DV04', 1, 1, 180000);
    SELECT N'1. Sau INSERT' AS Buoc, MaHD, TongTien FROM HoaDon WHERE MaHD = 'HD03';

    UPDATE ChiTietDichVu SET SoLuong = 2
    WHERE MaBA = 'BA03' AND MaDV = 'DV04' AND LanThucHien = 1;
    SELECT N'2. Sau UPDATE' AS Buoc, MaHD, TongTien FROM HoaDon WHERE MaHD = 'HD03';

    DELETE FROM ChiTietDichVu
    WHERE MaBA = 'BA03' AND MaDV = 'DV04' AND LanThucHien = 1;
    SELECT N'3. Sau DELETE' AS Buoc, MaHD, TongTien FROM HoaDon WHERE MaHD = 'HD03';
ROLLBACK;
GO

/* ---------------------------------------------------------------------
   T7: Tao hoa don moi -> TongTien khoi tao dung
   Tao lich kham, benh an, 2 dich vu (2 x 150000), 1 don thuoc (T05 x3 @2000)
   roi moi tao hoa don. Mong doi TongTien HD04 = 300000 + 6000 = 306000
   --------------------------------------------------------------------- */
PRINT N'===== T7: Tao hoa don moi =====';
BEGIN TRAN;
    INSERT INTO LichKham (MaLK, MaBN, MaBS, ThoiGianKham, LyDo, TrangThai)
    VALUES ('LK06', 'BN04', 'BS01', '2026-10-18 09:00', N'Kham thu', N'Đã khám');

    INSERT INTO HoSoBenhAn (MaBA, MaLK, TrieuChung, ChanDoan, KetLuan)
    VALUES ('BA04', 'LK06', N'Dau dau', N'Roi loan tien dinh', N'Theo doi');

    INSERT INTO ChiTietDichVu (MaBA, MaDV, LanThucHien, SoLuong, DonGiaApDung)
    VALUES ('BA04', 'DV01', 1, 2, 150000);

    INSERT INTO DonThuoc (MaDT, MaBA, GhiChu) VALUES ('DT04', 'BA04', N'Uong khi dau');
    INSERT INTO ChiTietDonThuoc (MaDT, MaThuoc, LieuDung, SoLuong, DonGiaKe)
    VALUES ('DT04', 'T05', N'1 vien/lan', 3, 2000);

    INSERT INTO HoaDon (MaHD, MaBA, TongTien, TrangThai)
    VALUES ('HD04', 'BA04', 0, N'Chưa thanh toán');

    SELECT MaHD, MaBA, TongTien FROM HoaDon WHERE MaHD = 'HD04';  -- mong doi 306000
ROLLBACK;
GO

/* ---------------------------------------------------------------------
   KIEM TRA CUOI: du lieu goc khong bi thay doi sau tat ca cac test
   Mong doi: T01=84, T02=36, T03=180, T04=5, T05=30
             HD01=385000, HD02=442000, HD03=159000, khong co HD04
   --------------------------------------------------------------------- */
PRINT N'===== KIEM TRA CUOI =====';
SELECT MaThuoc, SoLuongTon FROM Thuoc ORDER BY MaThuoc;
SELECT MaHD, TongTien FROM HoaDon ORDER BY MaHD;
GO