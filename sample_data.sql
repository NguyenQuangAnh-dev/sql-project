/* =====================================================================
   DU LIEU MAU - QuanLyBenhVien
   - Chay MOT LAN tren database con rong (sau khi da tao bang + 4 trigger).
   - Thu tu: danh muc -> lich kham -> ho so -> hoa don -> chi tiet.
   - Cac trigger se tu dong: tru ton kho thuoc va tinh TongTien hoa don.
   - Luu file o dinh dang UTF-8 (co BOM) de tieng Viet khong bi loi.
   ===================================================================== */
USE QuanLyBenhVien;
GO

-- 1. Khoa
INSERT INTO Khoa (MaKhoa, TenKhoa, DienThoai, Email) VALUES
('K01', N'Nội tổng hợp', '02431234501', 'noi@bv.vn'),
('K02', N'Ngoại',        '02431234502', 'ngoai@bv.vn'),
('K03', N'Nhi',          '02431234503', 'nhi@bv.vn');
GO

-- 2. Bac si
INSERT INTO BacSi (MaBS, HoTen, NgaySinh, GioiTinh, SDT, Email, MaKhoa) VALUES
('BS01', N'Nguyễn Văn An',  '1980-03-12', N'Nam', '0901000001', 'an@bv.vn',    'K01'),
('BS02', N'Trần Thị Bình',  '1985-07-25', N'Nữ',  '0901000002', 'binh@bv.vn',  'K02'),
('BS03', N'Lê Văn Cường',   '1978-11-02', N'Nam', '0901000003', 'cuong@bv.vn', 'K03'),
('BS04', N'Phạm Thị Dung',  '1990-01-18', N'Nữ',  '0901000004', 'dung@bv.vn',  'K01');
GO

-- 3. Benh nhan
INSERT INTO BenhNhan (MaBN, HoTen, NgaySinh, GioiTinh, SDT, DiaChi) VALUES
('BN01', N'Hoàng Minh Tuấn', '1995-05-20', N'Nam', '0912000001', N'Hà Nội'),
('BN02', N'Vũ Thu Hà',       '2000-09-09', N'Nữ',  '0912000002', N'Hà Nam'),
('BN03', N'Đỗ Gia Bảo',      '2015-02-14', N'Nam', '0912000003', N'Hà Nội'),
('BN04', N'Ngô Thanh Mai',   '1988-12-01', N'Nữ',  '0912000004', N'Bắc Ninh'),
('BN05', N'Bùi Quốc Huy',    '1972-06-30', N'Nam', '0912000005', N'Hải Phòng');
GO

-- 4. Lich kham
INSERT INTO LichKham (MaLK, MaBN, MaBS, ThoiGianKham, LyDo, TrangThai) VALUES
('LK01', 'BN01', 'BS01', '2026-10-12 08:30', N'Đau dạ dày',     N'Đã khám'),
('LK02', 'BN02', 'BS02', '2026-10-13 09:00', N'Đau bụng',       N'Đã khám'),
('LK03', 'BN03', 'BS03', '2026-10-14 10:15', N'Sốt, ho',        N'Đã khám'),
('LK04', 'BN04', 'BS01', '2026-10-20 14:00', N'Khám tổng quát', N'Chờ khám'),
('LK05', 'BN05', 'BS04', '2026-10-15 15:30', N'Đau đầu',        N'Đã hủy');
GO

-- 5. Ho so benh an (chi cac lich da kham)
INSERT INTO HoSoBenhAn (MaBA, MaLK, TrieuChung, ChanDoan, KetLuan) VALUES
('BA01', 'LK01', N'Đau thượng vị, ợ chua', N'Viêm dạ dày',       N'Điều trị ngoại trú'),
('BA02', 'LK02', N'Đau bụng vùng hố chậu', N'Rối loạn tiêu hóa', N'Theo dõi thêm'),
('BA03', 'LK03', N'Sốt 38.5 độ, ho',       N'Viêm họng cấp',      N'Điều trị ngoại trú');
GO

-- 6. Danh muc thuoc (T04 chi con 5 vien de test loi het hang)
INSERT INTO Thuoc (MaThuoc, TenThuoc, DonVi, DonGia, SoLuongTon) VALUES
('T01', N'Paracetamol 500mg', N'Viên', 1500, 100),
('T02', N'Amoxicillin 500mg', N'Viên', 3000,  50),
('T03', N'Vitamin C 500mg',   N'Viên', 1000, 200),
('T04', N'Omeprazole 20mg',   N'Viên', 2500,   5),
('T05', N'Ibuprofen 400mg',   N'Viên', 2000,  30);
GO

-- 7. Danh muc dich vu
INSERT INTO DichVu (MaDV, TenDV, DonGia, MoTa) VALUES
('DV01', N'Khám tổng quát', 150000, N'Khám lâm sàng ban đầu'),
('DV02', N'Xét nghiệm máu', 200000, N'Công thức máu cơ bản'),
('DV03', N'Siêu âm bụng',   250000, N'Siêu âm ổ bụng tổng quát'),
('DV04', N'Chụp X-quang',   180000, N'X-quang ngực thẳng');
GO

-- 8. Hoa don (TongTien = 0, trigger se tinh lai khi them chi tiet)
INSERT INTO HoaDon (MaHD, MaBA, TongTien, TrangThai) VALUES
('HD01', 'BA01', 0, N'Chưa thanh toán'),
('HD02', 'BA02', 0, N'Chưa thanh toán'),
('HD03', 'BA03', 0, N'Chưa thanh toán');
GO

-- 9. Chi tiet dich vu (trigger cap nhat TongTien)
INSERT INTO ChiTietDichVu (MaBA, MaDV, LanThucHien, SoLuong, DonGiaApDung) VALUES
('BA01', 'DV01', 1, 1, 150000),
('BA01', 'DV02', 1, 1, 200000),
('BA02', 'DV01', 1, 1, 150000),
('BA02', 'DV03', 1, 1, 250000),
('BA03', 'DV01', 1, 1, 150000);
GO

-- 10. Don thuoc
INSERT INTO DonThuoc (MaDT, MaBA, GhiChu) VALUES
('DT01', 'BA01', N'Uống sau ăn'),
('DT02', 'BA02', N'Uống 2 lần/ngày'),
('DT03', 'BA03', N'Uống khi sốt');
GO

-- 11. Chi tiet don thuoc (trigger tru ton kho + cap nhat TongTien)
INSERT INTO ChiTietDonThuoc (MaDT, MaThuoc, LieuDung, SoLuong, DonGiaKe) VALUES
('DT01', 'T01', N'2 viên/ngày', 10, 1500),
('DT01', 'T03', N'1 viên/ngày', 20, 1000),
('DT02', 'T02', N'2 viên/ngày', 14, 3000),
('DT03', 'T01', N'1 viên/lần',   6, 1500);
GO

/* ---------------------------------------------------------------------
   KIEM TRA SAU KHI CHEN (ket qua mong doi):
   Ton kho: T01=84, T02=36, T03=180, T04=5, T05=30
   TongTien: HD01=385000, HD02=442000, HD03=159000
   --------------------------------------------------------------------- */
SELECT MaThuoc, TenThuoc, SoLuongTon FROM Thuoc ORDER BY MaThuoc;
SELECT MaHD, MaBA, TongTien FROM HoaDon ORDER BY MaHD;
GO