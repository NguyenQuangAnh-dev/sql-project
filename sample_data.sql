USE QuanLyBenhVien;
GO

IF EXISTS (SELECT 1 FROM dbo.Khoa WHERE MaKhoa = 'K01')
BEGIN
    PRINT N'Database da co du lieu (K01). Bo qua toan bo file.';
    SET NOEXEC ON;
END;
GO

/* ===================== PHAN 1: DU LIEU CO BAN ===================== */
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

/* ===================== PHAN 2: DU LIEU BO SUNG ===================== */
-- BO SUNG 1. Khoa (them 4 khoa)
INSERT INTO Khoa (MaKhoa, TenKhoa, DienThoai, Email) VALUES
(N'K04', N'Tim mạch', N'02431234504', N'timmach@bv.vn'),
(N'K05', N'Da liễu', N'02431234505', N'dalieu@bv.vn'),
(N'K06', N'Tai mũi họng', N'02431234506', N'tmh@bv.vn'),
(N'K07', N'Sản phụ khoa', N'02431234507', N'san@bv.vn');
GO

-- BO SUNG 2. Bac si (them 10 bac si)
INSERT INTO BacSi (MaBS, HoTen, NgaySinh, GioiTinh, SDT, Email, MaKhoa) VALUES
(N'BS05', N'Đặng Quốc Việt', N'1975-04-09', N'Nam', N'0901000005', N'bs05@bv.vn', N'K04'),
(N'BS06', N'Hồ Thị Lan Anh', N'1983-08-21', N'Nữ', N'0901000006', N'bs06@bv.vn', N'K04'),
(N'BS07', N'Bùi Thu Hương', N'1987-02-14', N'Nữ', N'0901000007', N'bs07@bv.vn', N'K05'),
(N'BS08', N'Vũ Đức Thành', N'1979-10-30', N'Nam', N'0901000008', N'bs08@bv.vn', N'K06'),
(N'BS09', N'Ngô Thị Mai', N'1991-06-05', N'Nữ', N'0901000009', N'bs09@bv.vn', N'K06'),
(N'BS10', N'Dương Thị Hồng', N'1982-12-12', N'Nữ', N'0901000010', N'bs10@bv.vn', N'K07'),
(N'BS11', N'Lý Thanh Hà', N'1989-03-27', N'Nữ', N'0901000011', N'bs11@bv.vn', N'K07'),
(N'BS12', N'Phan Văn Khoa', N'1976-09-16', N'Nam', N'0901000012', N'bs12@bv.vn', N'K01'),
(N'BS13', N'Đinh Công Sơn', N'1984-01-08', N'Nam', N'0901000013', N'bs13@bv.vn', N'K02'),
(N'BS14', N'Trịnh Thị Bích', N'1986-05-23', N'Nữ', N'0901000014', N'bs14@bv.vn', N'K03');
GO

-- BO SUNG 3. Benh nhan (them 30 benh nhan, co 5 tre em)
INSERT INTO BenhNhan (MaBN, HoTen, NgaySinh, GioiTinh, SDT, DiaChi) VALUES
(N'BN06', N'Vũ Trung Hiếu', N'1991-02-08', N'Nam', N'0912000006', N'Ninh Bình'),
(N'BN07', N'Lý Mai Oanh', N'1996-08-25', N'Nữ', N'0912000007', N'Ninh Bình'),
(N'BN08', N'Phạm Thị Nhung', N'1955-02-10', N'Nữ', N'0912000008', N'Hà Nam'),
(N'BN09', N'Nguyễn Diệu Hà', N'2017-04-13', N'Nữ', N'0912000009', N'Hải Dương'),
(N'BN10', N'Đinh Bích Chi', N'1974-12-17', N'Nữ', N'0912000010', N'Thanh Hóa'),
(N'BN11', N'Dương Hữu Dũng', N'1985-09-10', N'Nam', N'0912000011', N'Hải Dương'),
(N'BN12', N'Lê Phương Lan', N'2004-12-12', N'Nữ', N'0912000012', N'Nam Định'),
(N'BN13', N'Đặng Thu Anh', N'1987-09-16', N'Nữ', N'0912000013', N'Hà Nam'),
(N'BN14', N'Đỗ Diệu Anh', N'2020-05-28', N'Nữ', N'0912000014', N'Thái Bình'),
(N'BN15', N'Đỗ Mai Chi', N'1951-10-08', N'Nữ', N'0912000015', N'Bắc Ninh'),
(N'BN16', N'Dương Trung Kiên', N'1992-02-23', N'Nam', N'0912000016', N'Ninh Bình'),
(N'BN17', N'Bùi Ngọc Thảo', N'1964-02-21', N'Nữ', N'0912000017', N'Nghệ An'),
(N'BN18', N'Ngô Diệu Yến', N'1984-05-18', N'Nữ', N'0912000018', N'Thái Bình'),
(N'BN19', N'Đỗ Mai Yến', N'2019-07-14', N'Nữ', N'0912000019', N'Hải Phòng'),
(N'BN20', N'Phan Phương Lan', N'1952-03-21', N'Nữ', N'0912000020', N'Ninh Bình'),
(N'BN21', N'Lý Mai Quyên', N'1981-06-07', N'Nữ', N'0912000021', N'Hải Dương'),
(N'BN22', N'Bùi Mai Chi', N'2002-08-26', N'Nữ', N'0912000022', N'Thái Bình'),
(N'BN23', N'Phan Đức Phúc', N'1979-02-15', N'Nam', N'0912000023', N'Nghệ An'),
(N'BN24', N'Bùi Ngọc Anh', N'2019-02-21', N'Nữ', N'0912000024', N'Hải Dương'),
(N'BN25', N'Vũ Thu Trang', N'1997-07-05', N'Nữ', N'0912000025', N'Vĩnh Phúc'),
(N'BN26', N'Trần Văn Tùng', N'1987-09-27', N'Nam', N'0912000026', N'Hà Nam'),
(N'BN27', N'Phạm Minh Việt', N'1952-09-09', N'Nam', N'0912000027', N'Thanh Hóa'),
(N'BN28', N'Lê Thị Ngân', N'1992-10-19', N'Nữ', N'0912000028', N'Vĩnh Phúc'),
(N'BN29', N'Đỗ Gia Tùng', N'1987-03-20', N'Nam', N'0912000029', N'Nghệ An'),
(N'BN30', N'Trần Hồng Hà', N'1960-03-26', N'Nữ', N'0912000030', N'Ninh Bình'),
(N'BN31', N'Đỗ Hồng Anh', N'2014-09-26', N'Nữ', N'0912000031', N'Hải Phòng'),
(N'BN32', N'Nguyễn Thu Anh', N'1954-01-27', N'Nữ', N'0912000032', N'Nam Định'),
(N'BN33', N'Đinh Thị Lan', N'1982-08-11', N'Nữ', N'0912000033', N'Thanh Hóa'),
(N'BN34', N'Bùi Bích Quyên', N'1957-08-15', N'Nữ', N'0912000034', N'Ninh Bình'),
(N'BN35', N'Lê Trung Khoa', N'1977-10-11', N'Nam', N'0912000035', N'Vĩnh Phúc');
GO

-- BO SUNG 4. Dich vu (them 6 dich vu)
INSERT INTO DichVu (MaDV, TenDV, DonGia, MoTa) VALUES
(N'DV05', N'Điện tâm đồ', 120000, N'Đo điện tim 12 chuyển đạo'),
(N'DV06', N'Nội soi dạ dày', 650000, N'Nội soi dạ dày - tá tràng'),
(N'DV07', N'Chụp CT', 1500000, N'Chụp cắt lớp vi tính'),
(N'DV08', N'Xét nghiệm nước tiểu', 90000, N'Tổng phân tích nước tiểu'),
(N'DV09', N'Siêu âm tim', 350000, N'Siêu âm tim Doppler'),
(N'DV10', N'Khám chuyên khoa', 200000, N'Khám theo chuyên khoa');
GO

-- BO SUNG 5. Thuoc T06-T20 (ton ban dau = ton cuoi mong muon + so luong se ke; T19 sap het, T20 het hang)
INSERT INTO Thuoc (MaThuoc, TenThuoc, DonVi, DonGia, SoLuongTon) VALUES
(N'T06', N'Cefuroxim 500mg', N'Viên', 5500, 443),
(N'T07', N'Metformin 850mg', N'Viên', 1200, 196),
(N'T08', N'Amlodipin 5mg', N'Viên', 900, 444),
(N'T09', N'Loratadin 10mg', N'Viên', 800, 176),
(N'T10', N'Siro ho Prospan', N'Chai', 65000, 353),
(N'T11', N'Oresol', N'Gói', 3500, 244),
(N'T12', N'Betadine 10%', N'Chai', 28000, 117),
(N'T13', N'Diclofenac 50mg', N'Viên', 1100, 241),
(N'T14', N'Atorvastatin 20mg', N'Viên', 3200, 458),
(N'T15', N'Cetirizin 10mg', N'Viên', 600, 214),
(N'T16', N'Acid folic 5mg', N'Viên', 400, 143),
(N'T17', N'Sắt Fumarat', N'Viên', 1800, 456),
(N'T18', N'Kem Hydrocortison', N'Tuýp', 18000, 335),
(N'T19', N'Nước muối sinh lý 0.9%', N'Chai', 9000, 181),
(N'T20', N'Vitamin B1-B6-B12', N'Viên', 1300, 0);
GO

-- BO SUNG 6. Lich kham (30 da kham, 5 cho kham, 2 dang kham, 3 da huy)
INSERT INTO LichKham (MaLK, MaBN, MaBS, ThoiGianKham, LyDo, TrangThai) VALUES
(N'LK07', N'BN24', N'BS14', '2026-09-15 12:00', N'Tiêu chảy', N'Đã khám'),
(N'LK08', N'BN23', N'BS12', '2026-09-17 09:15', N'Khám sức khỏe tổng quát', N'Đã khám'),
(N'LK09', N'BN02', N'BS06', '2026-09-18 08:45', N'Hồi hộp, đánh trống ngực', N'Đã khám'),
(N'LK10', N'BN08', N'BS06', '2026-09-18 12:30', N'Hồi hộp, đánh trống ngực', N'Đã khám'),
(N'LK11', N'BN02', N'BS09', '2026-09-21 12:15', N'Viêm họng', N'Đã khám'),
(N'LK12', N'BN04', N'BS10', '2026-09-21 16:30', N'Khám thai định kỳ', N'Đã khám'),
(N'LK13', N'BN08', N'BS01', '2026-09-22 16:15', N'Tăng huyết áp', N'Đã khám'),
(N'LK14', N'BN34', N'BS06', '2026-09-24 09:00', N'Đau thắt ngực', N'Đã khám'),
(N'LK15', N'BN28', N'BS08', '2026-09-24 12:30', N'Viêm xoang', N'Đã khám'),
(N'LK16', N'BN27', N'BS07', '2026-09-24 13:15', N'Mụn trứng cá', N'Đã khám'),
(N'LK17', N'BN27', N'BS10', '2026-09-25 08:30', N'Khám thai định kỳ', N'Đã khám'),
(N'LK18', N'BN12', N'BS08', '2026-09-25 12:45', N'Ù tai', N'Đã khám'),
(N'LK19', N'BN35', N'BS11', '2026-09-25 14:30', N'Rối loạn kinh nguyệt', N'Đã khám'),
(N'LK20', N'BN10', N'BS02', '2026-09-26 15:00', N'Đau khớp gối', N'Đã khám'),
(N'LK21', N'BN18', N'BS09', '2026-09-28 08:00', N'Viêm xoang', N'Đã khám'),
(N'LK22', N'BN17', N'BS05', '2026-09-30 09:45', N'Tái khám huyết áp', N'Đã khám'),
(N'LK23', N'BN06', N'BS02', '2026-09-30 14:00', N'Đau lưng', N'Đã khám'),
(N'LK24', N'BN22', N'BS11', '2026-10-02 12:15', N'Khám thai định kỳ', N'Đã khám'),
(N'LK25', N'BN01', N'BS10', '2026-10-03 10:30', N'Rối loạn kinh nguyệt', N'Đã khám'),
(N'LK26', N'BN04', N'BS02', '2026-10-06 10:00', N'U mỡ dưới da', N'Đã khám'),
(N'LK27', N'BN24', N'BS14', '2026-10-10 09:45', N'Tiêu chảy', N'Đã khám'),
(N'LK28', N'BN13', N'BS06', '2026-10-13 08:45', N'Hồi hộp, đánh trống ngực', N'Đã khám'),
(N'LK29', N'BN30', N'BS09', '2026-10-13 10:30', N'Ù tai', N'Đã khám'),
(N'LK30', N'BN20', N'BS02', '2026-10-13 13:45', N'U mỡ dưới da', N'Đã khám'),
(N'LK31', N'BN10', N'BS07', '2026-10-13 14:00', N'Viêm da cơ địa', N'Đã khám'),
(N'LK32', N'BN34', N'BS11', '2026-10-15 14:30', N'Khám thai định kỳ', N'Đã khám'),
(N'LK33', N'BN12', N'BS04', '2026-10-16 13:30', N'Tái khám đái tháo đường', N'Đã khám'),
(N'LK34', N'BN35', N'BS11', '2026-10-17 10:15', N'Khám thai định kỳ', N'Đã khám'),
(N'LK35', N'BN07', N'BS12', '2026-10-17 15:45', N'Tăng huyết áp', N'Đã khám'),
(N'LK36', N'BN20', N'BS08', '2026-10-19 13:30', N'Viêm xoang', N'Đã khám'),
(N'LK37', N'BN25', N'BS08', '2026-10-21 09:00', N'Ù tai', N'Chờ khám'),
(N'LK38', N'BN07', N'BS01', '2026-10-22 14:30', N'Khám sức khỏe tổng quát', N'Chờ khám'),
(N'LK39', N'BN22', N'BS09', '2026-10-23 10:15', N'Viêm xoang', N'Chờ khám'),
(N'LK40', N'BN03', N'BS03', '2026-10-27 08:45', N'Tiêu chảy', N'Chờ khám'),
(N'LK41', N'BN19', N'BS14', '2026-10-28 15:00', N'Ho, sổ mũi', N'Chờ khám'),
(N'LK42', N'BN25', N'BS02', '2026-10-20 08:30', N'U mỡ dưới da', N'Đang khám'),
(N'LK43', N'BN28', N'BS05', '2026-10-20 09:15', N'Tái khám huyết áp', N'Đang khám'),
(N'LK44', N'BN34', N'BS01', '2026-09-25 11:00', N'Tái khám đái tháo đường', N'Đã hủy'),
(N'LK45', N'BN35', N'BS02', '2026-10-05 13:30', N'Đau khớp gối', N'Đã hủy'),
(N'LK46', N'BN08', N'BS08', '2026-10-16 09:30', N'Viêm xoang', N'Đã hủy');
GO

-- BO SUNG 7. Ho so benh an (30 ho so cho cac lich da kham)
INSERT INTO HoSoBenhAn (MaBA, MaLK, NgayLap, TrieuChung, ChanDoan, KetLuan) VALUES
(N'BA05', N'LK07', '2026-09-15 12:30', N'Sốt 39 độ, quấy khóc', N'Sốt siêu vi', N'Theo dõi tại nhà'),
(N'BA06', N'LK08', '2026-09-17 09:45', N'Khát nhiều, mệt', N'Đái tháo đường type 2', N'Tái khám sau 1 tháng'),
(N'BA07', N'LK09', '2026-09-18 09:15', N'Tim đập nhanh', N'Rối loạn nhịp nhẹ', N'Điều trị nội trú ngắn ngày'),
(N'BA08', N'LK10', '2026-09-18 13:00', N'Tim đập nhanh', N'Rối loạn nhịp nhẹ', N'Điều trị nội trú ngắn ngày'),
(N'BA09', N'LK11', '2026-09-21 12:45', N'Ù tai, nghe kém', N'Viêm tai giữa', N'Tái khám sau 1 tuần'),
(N'BA10', N'LK12', '2026-09-21 17:00', N'Chu kỳ kinh không đều', N'Rối loạn kinh nguyệt', N'Theo dõi nội tiết'),
(N'BA11', N'LK13', '2026-09-22 16:45', N'Đau đầu, chóng mặt', N'Tăng huyết áp', N'Theo dõi huyết áp tại nhà'),
(N'BA12', N'LK14', '2026-09-24 09:30', N'Tim đập nhanh', N'Rối loạn nhịp nhẹ', N'Điều trị nội trú ngắn ngày'),
(N'BA13', N'LK15', '2026-09-24 13:00', N'Đau họng, nuốt vướng', N'Viêm họng cấp', N'Điều trị ngoại trú'),
(N'BA14', N'LK16', '2026-09-24 13:45', N'Ngứa vùng da kẽ', N'Nấm da', N'Điều trị 2 tuần'),
(N'BA15', N'LK17', '2026-09-25 09:00', N'Thai 20 tuần, khám định kỳ', N'Thai kỳ bình thường', N'Tái khám theo lịch'),
(N'BA16', N'LK18', '2026-09-25 13:15', N'Nghẹt mũi, đau vùng trán', N'Viêm xoang', N'Điều trị 10 ngày'),
(N'BA17', N'LK19', '2026-09-25 15:00', N'Chu kỳ kinh không đều', N'Rối loạn kinh nguyệt', N'Theo dõi nội tiết'),
(N'BA18', N'LK20', '2026-09-26 15:30', N'Đau khớp khi đi lại', N'Thoái hóa khớp', N'Vật lý trị liệu'),
(N'BA19', N'LK21', '2026-09-28 08:30', N'Ù tai, nghe kém', N'Viêm tai giữa', N'Tái khám sau 1 tuần'),
(N'BA20', N'LK22', '2026-09-30 10:15', N'Huyết áp cao', N'Tăng huyết áp độ 1', N'Điều chỉnh thuốc'),
(N'BA21', N'LK23', '2026-09-30 14:30', N'Sưng đau cổ chân', N'Bong gân độ II', N'Bất động 2 tuần'),
(N'BA22', N'LK24', '2026-10-02 12:45', N'Cần tư vấn', N'Khám sức khỏe sinh sản', N'Không có bất thường'),
(N'BA23', N'LK25', '2026-10-03 11:00', N'Chu kỳ kinh không đều', N'Rối loạn kinh nguyệt', N'Theo dõi nội tiết'),
(N'BA24', N'LK26', '2026-10-06 10:30', N'Đau khớp khi đi lại', N'Thoái hóa khớp', N'Vật lý trị liệu'),
(N'BA25', N'LK27', '2026-10-10 10:15', N'Đi ngoài phân lỏng', N'Rối loạn tiêu hóa', N'Bù nước, theo dõi'),
(N'BA26', N'LK28', '2026-10-13 09:15', N'Huyết áp cao', N'Tăng huyết áp độ 1', N'Điều chỉnh thuốc'),
(N'BA27', N'LK29', '2026-10-13 11:00', N'Ù tai, nghe kém', N'Viêm tai giữa', N'Tái khám sau 1 tuần'),
(N'BA28', N'LK30', '2026-10-13 14:15', N'Sưng đau cổ chân', N'Bong gân độ II', N'Bất động 2 tuần'),
(N'BA29', N'LK31', '2026-10-13 14:30', N'Nổi mụn viêm vùng mặt', N'Mụn trứng cá', N'Điều trị ngoại trú'),
(N'BA30', N'LK32', '2026-10-15 15:00', N'Cần tư vấn', N'Khám sức khỏe sinh sản', N'Không có bất thường'),
(N'BA31', N'LK33', '2026-10-16 14:00', N'Khát nhiều, mệt', N'Đái tháo đường type 2', N'Tái khám sau 1 tháng'),
(N'BA32', N'LK34', '2026-10-17 10:45', N'Cần tư vấn', N'Khám sức khỏe sinh sản', N'Không có bất thường'),
(N'BA33', N'LK35', '2026-10-17 16:15', N'Đau đầu, chóng mặt', N'Tăng huyết áp', N'Theo dõi huyết áp tại nhà'),
(N'BA34', N'LK36', '2026-10-19 14:00', N'Ù tai, nghe kém', N'Viêm tai giữa', N'Tái khám sau 1 tuần');
GO

-- BO SUNG 8. Hoa don (TongTien = 0, trigger tinh lai khi them chi tiet; 2 ho so cuoi chua co hoa don)
INSERT INTO HoaDon (MaHD, MaBA, NgayLap, TongTien, TrangThai) VALUES
(N'HD05', N'BA05', '2026-09-15 13:00', 0, N'Đã thanh toán'),
(N'HD06', N'BA06', '2026-09-17 10:15', 0, N'Chưa thanh toán'),
(N'HD07', N'BA07', '2026-09-18 09:45', 0, N'Đã thanh toán'),
(N'HD08', N'BA08', '2026-09-18 13:30', 0, N'Chưa thanh toán'),
(N'HD09', N'BA09', '2026-09-21 13:15', 0, N'Đã thanh toán'),
(N'HD10', N'BA10', '2026-09-21 17:30', 0, N'Đã thanh toán'),
(N'HD11', N'BA11', '2026-09-22 17:15', 0, N'Đã thanh toán'),
(N'HD12', N'BA12', '2026-09-24 10:00', 0, N'Chưa thanh toán'),
(N'HD13', N'BA13', '2026-09-24 13:30', 0, N'Đã thanh toán'),
(N'HD14', N'BA14', '2026-09-24 14:15', 0, N'Đã hủy'),
(N'HD15', N'BA15', '2026-09-25 09:30', 0, N'Đã thanh toán'),
(N'HD16', N'BA16', '2026-09-25 13:45', 0, N'Chưa thanh toán'),
(N'HD17', N'BA17', '2026-09-25 15:30', 0, N'Chưa thanh toán'),
(N'HD18', N'BA18', '2026-09-26 16:00', 0, N'Đã hủy'),
(N'HD19', N'BA19', '2026-09-28 09:00', 0, N'Đã thanh toán'),
(N'HD20', N'BA20', '2026-09-30 10:45', 0, N'Chưa thanh toán'),
(N'HD21', N'BA21', '2026-09-30 15:00', 0, N'Đã thanh toán'),
(N'HD22', N'BA22', '2026-10-02 13:15', 0, N'Đã thanh toán'),
(N'HD23', N'BA23', '2026-10-03 11:30', 0, N'Đã thanh toán'),
(N'HD24', N'BA24', '2026-10-06 11:00', 0, N'Đã thanh toán'),
(N'HD25', N'BA25', '2026-10-10 10:45', 0, N'Đã thanh toán'),
(N'HD26', N'BA26', '2026-10-13 09:45', 0, N'Đã thanh toán'),
(N'HD27', N'BA27', '2026-10-13 11:30', 0, N'Chưa thanh toán'),
(N'HD28', N'BA28', '2026-10-13 14:45', 0, N'Đã thanh toán'),
(N'HD29', N'BA29', '2026-10-13 15:00', 0, N'Đã thanh toán'),
(N'HD30', N'BA30', '2026-10-15 15:30', 0, N'Đã thanh toán'),
(N'HD31', N'BA31', '2026-10-16 14:30', 0, N'Đã thanh toán'),
(N'HD32', N'BA32', '2026-10-17 11:15', 0, N'Đã thanh toán');
GO

-- BO SUNG 9. Chi tiet dich vu (trigger cap nhat TongTien; mot so dich vu thuc hien lan 2; DV01 o cac ho so dau dung gia cu 140000)
INSERT INTO ChiTietDichVu (MaBA, MaDV, LanThucHien, SoLuong, DonGiaApDung, NgayThucHien) VALUES
(N'BA05', N'DV02', 1, 1, 200000, '2026-09-15 12:15'),
(N'BA05', N'DV01', 1, 1, 140000, '2026-09-15 12:15'),
(N'BA06', N'DV08', 1, 2, 90000, '2026-09-17 09:30'),
(N'BA07', N'DV02', 1, 1, 200000, '2026-09-18 09:00'),
(N'BA07', N'DV05', 1, 1, 120000, '2026-09-18 09:00'),
(N'BA08', N'DV02', 1, 1, 200000, '2026-09-18 12:45'),
(N'BA09', N'DV10', 1, 1, 200000, '2026-09-21 12:30'),
(N'BA09', N'DV04', 1, 1, 180000, '2026-09-21 12:30'),
(N'BA09', N'DV01', 1, 1, 140000, '2026-09-21 12:30'),
(N'BA10', N'DV02', 1, 1, 200000, '2026-09-21 16:45'),
(N'BA10', N'DV08', 1, 1, 90000, '2026-09-21 16:45'),
(N'BA10', N'DV03', 1, 1, 250000, '2026-09-21 16:45'),
(N'BA11', N'DV02', 1, 1, 200000, '2026-09-22 16:30'),
(N'BA11', N'DV01', 1, 1, 140000, '2026-09-22 16:30'),
(N'BA11', N'DV05', 1, 1, 120000, '2026-09-22 16:30'),
(N'BA11', N'DV02', 2, 1, 200000, '2026-09-25 16:15'),
(N'BA12', N'DV05', 1, 1, 120000, '2026-09-24 09:15'),
(N'BA12', N'DV02', 1, 2, 200000, '2026-09-24 09:15'),
(N'BA13', N'DV04', 1, 1, 180000, '2026-09-24 12:45'),
(N'BA14', N'DV01', 1, 1, 150000, '2026-09-24 13:30'),
(N'BA14', N'DV10', 2, 1, 200000, '2026-09-27 13:15'),
(N'BA15', N'DV08', 1, 1, 90000, '2026-09-25 08:45'),
(N'BA16', N'DV04', 1, 1, 180000, '2026-09-25 13:00'),
(N'BA16', N'DV01', 1, 1, 150000, '2026-09-25 13:00'),
(N'BA17', N'DV03', 1, 1, 250000, '2026-09-25 14:45'),
(N'BA17', N'DV02', 1, 1, 200000, '2026-09-25 14:45'),
(N'BA18', N'DV07', 1, 1, 1500000, '2026-09-26 15:15'),
(N'BA18', N'DV10', 1, 1, 200000, '2026-09-26 15:15'),
(N'BA18', N'DV04', 1, 1, 180000, '2026-09-26 15:15'),
(N'BA19', N'DV04', 1, 1, 180000, '2026-09-28 08:15'),
(N'BA19', N'DV01', 1, 1, 150000, '2026-09-28 08:15'),
(N'BA20', N'DV05', 1, 1, 120000, '2026-09-30 10:00'),
(N'BA21', N'DV07', 1, 1, 1500000, '2026-09-30 14:15'),
(N'BA22', N'DV08', 1, 1, 90000, '2026-10-02 12:30'),
(N'BA22', N'DV03', 1, 1, 250000, '2026-10-02 12:30'),
(N'BA23', N'DV03', 1, 1, 250000, '2026-10-03 10:45'),
(N'BA24', N'DV07', 1, 1, 1500000, '2026-10-06 10:15'),
(N'BA25', N'DV01', 1, 1, 150000, '2026-10-10 10:00'),
(N'BA25', N'DV02', 1, 1, 200000, '2026-10-10 10:00'),
(N'BA26', N'DV09', 1, 1, 350000, '2026-10-13 09:00'),
(N'BA26', N'DV02', 1, 1, 200000, '2026-10-13 09:00'),
(N'BA26', N'DV05', 1, 1, 120000, '2026-10-13 09:00'),
(N'BA27', N'DV10', 1, 1, 200000, '2026-10-13 10:45'),
(N'BA27', N'DV01', 1, 1, 150000, '2026-10-13 10:45'),
(N'BA28', N'DV07', 1, 1, 1500000, '2026-10-13 14:00'),
(N'BA28', N'DV04', 1, 1, 180000, '2026-10-13 14:00'),
(N'BA29', N'DV10', 1, 1, 200000, '2026-10-13 14:15'),
(N'BA29', N'DV01', 1, 1, 150000, '2026-10-13 14:15'),
(N'BA30', N'DV02', 1, 2, 200000, '2026-10-15 14:45'),
(N'BA30', N'DV08', 1, 1, 90000, '2026-10-15 14:45'),
(N'BA30', N'DV02', 2, 1, 200000, '2026-10-18 14:30'),
(N'BA31', N'DV08', 1, 2, 90000, '2026-10-16 13:45'),
(N'BA31', N'DV02', 1, 2, 200000, '2026-10-16 13:45'),
(N'BA31', N'DV01', 1, 1, 150000, '2026-10-16 13:45'),
(N'BA32', N'DV02', 1, 1, 200000, '2026-10-17 10:30'),
(N'BA32', N'DV02', 2, 1, 200000, '2026-10-20 10:15'),
(N'BA33', N'DV05', 1, 1, 120000, '2026-10-17 16:00'),
(N'BA33', N'DV08', 1, 1, 90000, '2026-10-17 16:00'),
(N'BA33', N'DV01', 1, 1, 150000, '2026-10-17 16:00'),
(N'BA34', N'DV10', 1, 1, 200000, '2026-10-19 13:45'),
(N'BA34', N'DV04', 1, 1, 180000, '2026-10-19 13:45'),
(N'BA34', N'DV01', 1, 1, 150000, '2026-10-19 13:45');
GO

-- BO SUNG 10. Don thuoc
INSERT INTO DonThuoc (MaDT, MaBA, NgayKe, GhiChu) VALUES
(N'DT05', N'BA05', '2026-09-15 12:20', N'Uống sau ăn'),
(N'DT06', N'BA06', '2026-09-17 09:35', N'Uống đúng liều, tái khám nếu không đỡ'),
(N'DT07', N'BA07', '2026-09-18 09:05', N'Tránh rượu bia'),
(N'DT08', N'BA08', '2026-09-18 12:50', N'Uống nhiều nước'),
(N'DT09', N'BA09', '2026-09-21 12:35', N'Tránh rượu bia'),
(N'DT10', N'BA10', '2026-09-21 16:50', N'Uống nhiều nước'),
(N'DT11', N'BA11', '2026-09-22 16:35', N'Uống nhiều nước'),
(N'DT12', N'BA12', '2026-09-24 09:20', N'Tránh rượu bia'),
(N'DT14', N'BA14', '2026-09-24 13:35', N'Uống đúng liều, tái khám nếu không đỡ'),
(N'DT16', N'BA16', '2026-09-25 13:05', N'Tránh rượu bia'),
(N'DT17', N'BA17', '2026-09-25 14:50', N'Tránh rượu bia'),
(N'DT19', N'BA19', '2026-09-28 08:20', N'Uống sau ăn'),
(N'DT20', N'BA20', '2026-09-30 10:05', N'Uống đúng liều, tái khám nếu không đỡ'),
(N'DT22', N'BA22', '2026-10-02 12:35', N'Uống đúng liều, tái khám nếu không đỡ'),
(N'DT23', N'BA23', '2026-10-03 10:50', N'Tránh rượu bia'),
(N'DT24', N'BA24', '2026-10-06 10:20', N'Uống nhiều nước'),
(N'DT25', N'BA25', '2026-10-10 10:05', N'Uống sau ăn'),
(N'DT27', N'BA27', '2026-10-13 10:50', N'Uống nhiều nước'),
(N'DT28', N'BA28', '2026-10-13 14:05', N'Uống nhiều nước'),
(N'DT29', N'BA29', '2026-10-13 14:20', N'Uống đúng liều, tái khám nếu không đỡ'),
(N'DT30', N'BA30', '2026-10-15 14:50', N'Uống đúng liều, tái khám nếu không đỡ'),
(N'DT32', N'BA32', '2026-10-17 10:35', N'Uống sau ăn'),
(N'DT33', N'BA33', '2026-10-17 16:05', N'Uống sau ăn'),
(N'DT34', N'BA34', '2026-10-19 13:50', N'Tránh rượu bia');
GO

-- BO SUNG 11. Chi tiet don thuoc (trigger tru ton kho + cap nhat TongTien)
INSERT INTO ChiTietDonThuoc (MaDT, MaThuoc, LieuDung, SoLuong, DonGiaKe) VALUES
(N'DT05', N'T15', N'1 viên/ngày', 7, 600),
(N'DT05', N'T10', N'5ml x 3 lần/ngày', 17, 65000),
(N'DT05', N'T09', N'1 viên/ngày', 13, 800),
(N'DT06', N'T14', N'1 viên buổi tối', 7, 3200),
(N'DT06', N'T13', N'1 viên x 2 lần/ngày sau ăn', 29, 1100),
(N'DT06', N'T07', N'1 viên x 2 lần/ngày', 7, 1200),
(N'DT07', N'T14', N'1 viên buổi tối', 15, 3200),
(N'DT07', N'T08', N'1 viên buổi sáng', 10, 900),
(N'DT08', N'T08', N'1 viên buổi sáng', 19, 900),
(N'DT09', N'T19', N'Nhỏ mũi 3 lần/ngày', 15, 9000),
(N'DT09', N'T06', N'1 viên x 2 lần/ngày', 9, 5500),
(N'DT09', N'T09', N'1 viên/ngày', 22, 800),
(N'DT09', N'T15', N'1 viên/ngày', 29, 600),
(N'DT10', N'T19', N'Nhỏ mũi 3 lần/ngày', 16, 9000),
(N'DT10', N'T16', N'1 viên/ngày', 25, 400),
(N'DT10', N'T17', N'1 viên x 2 lần/ngày', 15, 1800),
(N'DT11', N'T14', N'1 viên buổi tối', 29, 3200),
(N'DT11', N'T13', N'1 viên x 2 lần/ngày sau ăn', 12, 1100),
(N'DT11', N'T07', N'1 viên x 2 lần/ngày', 25, 1200),
(N'DT11', N'T06', N'1 viên x 2 lần/ngày', 8, 5500),
(N'DT12', N'T08', N'1 viên buổi sáng', 22, 900),
(N'DT14', N'T15', N'1 viên/ngày', 13, 600),
(N'DT16', N'T06', N'1 viên x 2 lần/ngày', 9, 5500),
(N'DT16', N'T19', N'Nhỏ mũi 3 lần/ngày', 5, 9000),
(N'DT16', N'T09', N'1 viên/ngày', 20, 800),
(N'DT17', N'T19', N'Nhỏ mũi 3 lần/ngày', 6, 9000),
(N'DT19', N'T19', N'Nhỏ mũi 3 lần/ngày', 21, 9000),
(N'DT19', N'T15', N'1 viên/ngày', 17, 600),
(N'DT20', N'T14', N'1 viên buổi tối', 29, 3200),
(N'DT22', N'T16', N'1 viên/ngày', 30, 400),
(N'DT22', N'T19', N'Nhỏ mũi 3 lần/ngày', 26, 9000),
(N'DT22', N'T17', N'1 viên x 2 lần/ngày', 6, 1800),
(N'DT23', N'T17', N'1 viên x 2 lần/ngày', 10, 1800),
(N'DT24', N'T13', N'1 viên x 2 lần/ngày sau ăn', 21, 1100),
(N'DT24', N'T12', N'Bôi ngoài da 2 lần/ngày', 16, 28000),
(N'DT24', N'T06', N'1 viên x 2 lần/ngày', 22, 5500),
(N'DT25', N'T10', N'5ml x 3 lần/ngày', 16, 65000),
(N'DT27', N'T19', N'Nhỏ mũi 3 lần/ngày', 22, 9000),
(N'DT27', N'T06', N'1 viên x 2 lần/ngày', 18, 5500),
(N'DT28', N'T06', N'1 viên x 2 lần/ngày', 11, 5500),
(N'DT28', N'T12', N'Bôi ngoài da 2 lần/ngày', 28, 28000),
(N'DT28', N'T13', N'1 viên x 2 lần/ngày sau ăn', 11, 1100),
(N'DT29', N'T15', N'1 viên/ngày', 14, 600),
(N'DT29', N'T09', N'1 viên/ngày', 28, 800),
(N'DT29', N'T12', N'Bôi ngoài da 2 lần/ngày', 16, 28000),
(N'DT29', N'T18', N'Thoa mỏng ngày 2 lần', 17, 18000),
(N'DT30', N'T17', N'1 viên x 2 lần/ngày', 24, 1800),
(N'DT30', N'T19', N'Nhỏ mũi 3 lần/ngày', 25, 9000),
(N'DT32', N'T17', N'1 viên x 2 lần/ngày', 30, 1800),
(N'DT32', N'T16', N'1 viên/ngày', 25, 400),
(N'DT32', N'T19', N'Nhỏ mũi 3 lần/ngày', 30, 9000),
(N'DT33', N'T07', N'1 viên x 2 lần/ngày', 5, 1200),
(N'DT33', N'T08', N'1 viên buổi sáng', 6, 900),
(N'DT33', N'T13', N'1 viên x 2 lần/ngày sau ăn', 28, 1100),
(N'DT33', N'T14', N'1 viên buổi tối', 7, 3200),
(N'DT34', N'T09', N'1 viên/ngày', 18, 800),
(N'DT34', N'T15', N'1 viên/ngày', 6, 600),
(N'DT34', N'T06', N'1 viên x 2 lần/ngày', 20, 5500),
(N'DT34', N'T19', N'Nhỏ mũi 3 lần/ngày', 12, 9000);
GO

SET NOEXEC OFF;
GO

/* ---------------------------------------------------------------------
   KIEM TRA SAU KHI CHEN
   --------------------------------------------------------------------- */
-- (a) So dong tung bang
SELECT t.name AS Bang, SUM(p.rows) AS SoDong
FROM sys.tables t
JOIN sys.partitions p ON p.object_id = t.object_id AND p.index_id IN (0,1)
GROUP BY t.name ORDER BY t.name;

-- (b) Hoa don co TongTien khac tong tinh lai tu chi tiet: mong doi 0 dong
SELECT HD.MaHD, HD.TongTien, X.TongTinh
FROM dbo.HoaDon HD
CROSS APPLY (
    SELECT COALESCE((SELECT SUM(CONVERT(DECIMAL(18,2), CDV.SoLuong) * CDV.DonGiaApDung)
                     FROM dbo.ChiTietDichVu CDV WHERE CDV.MaBA = HD.MaBA), 0)
         + COALESCE((SELECT SUM(CONVERT(DECIMAL(18,2), CT.SoLuong) * CT.DonGiaKe)
                     FROM dbo.DonThuoc DT JOIN dbo.ChiTietDonThuoc CT ON CT.MaDT = DT.MaDT
                     WHERE DT.MaBA = HD.MaBA), 0)
) AS X(TongTinh)
WHERE HD.TongTien <> X.TongTinh;

-- (c) Ton kho sau khi tru: T04=5 (cu), T19=3 (sap het), T20=0 (het hang)
SELECT MaThuoc, TenThuoc, SoLuongTon FROM dbo.Thuoc ORDER BY MaThuoc;

-- (d) Du lieu co ban khong doi: T01=84, T02=36, T03=180, T04=5, T05=30 ; HD01=385000, HD02=442000, HD03=159000
SELECT MaHD, TongTien FROM dbo.HoaDon WHERE MaHD IN ('HD01','HD02','HD03') ORDER BY MaHD;
GO