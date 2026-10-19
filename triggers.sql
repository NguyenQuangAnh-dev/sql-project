USE QuanLyBenhVien;
GO

/* 1. Ton kho thuoc: ho tro INSERT, UPDATE, DELETE nhieu dong. */
CREATE OR ALTER TRIGGER dbo.trg_ChiTietDonThuoc_TonKho
ON dbo.ChiTietDonThuoc
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE SoLuong IS NULL OR SoLuong <= 0)
        THROW 51002, N'So luong thuoc phai lon hon 0.', 1;

    DECLARE @BienDong TABLE (
        MaThuoc VARCHAR(10) PRIMARY KEY,
        ChenhLech INT NOT NULL
    );

    INSERT INTO @BienDong (MaThuoc, ChenhLech)
    SELECT MaThuoc, SUM(ChenhLech)
    FROM (
        SELECT MaThuoc, SUM(SoLuong) AS ChenhLech
        FROM inserted
        GROUP BY MaThuoc
        UNION ALL
        SELECT MaThuoc, -SUM(SoLuong) AS ChenhLech
        FROM deleted
        GROUP BY MaThuoc
    ) AS X
    GROUP BY MaThuoc
    HAVING SUM(ChenhLech) <> 0;

    -- Them/sua don thuoc lam giam ton kho; neu khong du thi huy thao tac.
    IF EXISTS (
        SELECT 1
        FROM @BienDong B
        JOIN dbo.Thuoc T ON T.MaThuoc = B.MaThuoc
        WHERE T.SoLuongTon - B.ChenhLech < 0
    )
    BEGIN
        ;THROW 51001, N'Khong du so luong thuoc ton kho de ke don.', 1;
    END;

    UPDATE T
       SET T.SoLuongTon = T.SoLuongTon - B.ChenhLech
    FROM dbo.Thuoc T
    JOIN @BienDong B ON B.MaThuoc = T.MaThuoc;
END;
GO

/* 2. Khi them/sua/xoa dich vu, tinh lai hoa don cua cac benh an lien quan. */
CREATE OR ALTER TRIGGER dbo.trg_ChiTietDichVu_CapNhatTongTien
ON dbo.ChiTietDichVu
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE SoLuong IS NULL OR SoLuong <= 0)
        THROW 51003, N'So luong dich vu phai lon hon 0.', 1;

    DECLARE @BA TABLE (MaBA VARCHAR(10) PRIMARY KEY);
    INSERT INTO @BA (MaBA)
    SELECT MaBA FROM inserted
    UNION
    SELECT MaBA FROM deleted;

    UPDATE HD
       SET TongTien =
           COALESCE((
               SELECT SUM(CONVERT(DECIMAL(18,2), CDV.SoLuong) * CDV.DonGiaApDung)
               FROM dbo.ChiTietDichVu CDV
               WHERE CDV.MaBA = HD.MaBA
           ), 0)
           + COALESCE((
               SELECT SUM(CONVERT(DECIMAL(18,2), CTDT.SoLuong) * CTDT.DonGiaKe)
               FROM dbo.DonThuoc DT
               JOIN dbo.ChiTietDonThuoc CTDT ON CTDT.MaDT = DT.MaDT
               WHERE DT.MaBA = HD.MaBA
           ), 0)
    FROM dbo.HoaDon HD
    JOIN @BA A ON A.MaBA = HD.MaBA;
END;
GO

/* 3. Khi them/sua/xoa chi tiet thuoc, tinh lai hoa don lien quan. */
CREATE OR ALTER TRIGGER dbo.trg_ChiTietDonThuoc_CapNhatTongTien
ON dbo.ChiTietDonThuoc
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @BA TABLE (MaBA VARCHAR(10) PRIMARY KEY);

    INSERT INTO @BA (MaBA)
    SELECT DISTINCT DT.MaBA
    FROM dbo.DonThuoc DT
    JOIN (
        SELECT MaDT FROM inserted
        UNION
        SELECT MaDT FROM deleted
    ) AS D ON D.MaDT = DT.MaDT
    WHERE DT.MaBA IS NOT NULL;

    UPDATE HD
       SET TongTien =
           COALESCE((
               SELECT SUM(CONVERT(DECIMAL(18,2), CDV.SoLuong) * CDV.DonGiaApDung)
               FROM dbo.ChiTietDichVu CDV
               WHERE CDV.MaBA = HD.MaBA
           ), 0)
           + COALESCE((
               SELECT SUM(CONVERT(DECIMAL(18,2), CTDT.SoLuong) * CTDT.DonGiaKe)
               FROM dbo.DonThuoc DT
               JOIN dbo.ChiTietDonThuoc CTDT ON CTDT.MaDT = DT.MaDT
               WHERE DT.MaBA = HD.MaBA
           ), 0)
    FROM dbo.HoaDon HD
    JOIN @BA A ON A.MaBA = HD.MaBA;
END;
GO

/* 4. Tao hoa don moi hoac doi MaBA thi tinh tong tien ban dau. */
CREATE OR ALTER TRIGGER dbo.trg_HoaDon_KhoiTaoTongTien
ON dbo.HoaDon
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT UPDATE(MaBA)
        RETURN;

    UPDATE HD
       SET TongTien =
           COALESCE((
               SELECT SUM(CONVERT(DECIMAL(18,2), CDV.SoLuong) * CDV.DonGiaApDung)
               FROM dbo.ChiTietDichVu CDV
               WHERE CDV.MaBA = HD.MaBA
           ), 0)
           + COALESCE((
               SELECT SUM(CONVERT(DECIMAL(18,2), CTDT.SoLuong) * CTDT.DonGiaKe)
               FROM dbo.DonThuoc DT
               JOIN dbo.ChiTietDonThuoc CTDT ON CTDT.MaDT = DT.MaDT
               WHERE DT.MaBA = HD.MaBA
           ), 0)
    FROM dbo.HoaDon HD
    JOIN inserted I ON I.MaHD = HD.MaHD;
END;
GO

/* Kiem tra cac trigger da duoc tao. */
SELECT name AS TenTrigger, OBJECT_NAME(parent_id) AS BangTacDong, is_disabled AS BiVoHieuHoa
FROM sys.triggers
WHERE name IN (
    'trg_ChiTietDonThuoc_TonKho',
    'trg_ChiTietDichVu_CapNhatTongTien',
    'trg_ChiTietDonThuoc_CapNhatTongTien',
    'trg_HoaDon_KhoiTaoTongTien'
)
ORDER BY name;
GO
