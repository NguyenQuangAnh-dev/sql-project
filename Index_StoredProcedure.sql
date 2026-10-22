
USE QuanLyBenhVien;
GO

-- PHAN 4: INDEX VA STORED PROCEDURE

-- 1. INDEX TIM KIEM LICH KHAM THEO THOI GIAN
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_LichKham_ThoiGianKham'
      AND object_id = OBJECT_ID('dbo.LichKham')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_LichKham_ThoiGianKham
    ON dbo.LichKham (ThoiGianKham)
    INCLUDE (MaBN, MaBS, TrangThai);
END;
GO

-- 2. INDEX TIM KIEM LICH KHAM THEO BENH NHAN VA THOI GIAN
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_LichKham_MaBN_ThoiGianKham'
      AND object_id = OBJECT_ID('dbo.LichKham')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_LichKham_MaBN_ThoiGianKham
    ON dbo.LichKham (MaBN, ThoiGianKham DESC)
    INCLUDE (MaLK, MaBS, TrangThai);
END;
GO

-- 3. STORED PROCEDURE TRA CUU LICH KHAM
CREATE OR ALTER PROCEDURE dbo.sp_TraCuuLichKham
    @MaBN VARCHAR(10) = NULL,
    @TuNgay DATE = NULL,
    @DenNgay DATE = NULL,
    @TrangThai NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @TuNgay IS NOT NULL
       AND @DenNgay IS NOT NULL
       AND @TuNgay > @DenNgay
    BEGIN
        ;THROW 50001, N'Tu ngay khong duoc lon hon den ngay.', 1;
    END;

    SELECT
        lk.MaLK,
        bn.MaBN,
        bn.HoTen AS TenBenhNhan,
        bs.MaBS,
        bs.HoTen AS TenBacSi,
        k.TenKhoa,
        lk.ThoiGianKham,
        lk.LyDo,
        lk.TrangThai
    FROM dbo.LichKham AS lk
    INNER JOIN dbo.BenhNhan AS bn
        ON lk.MaBN = bn.MaBN
    INNER JOIN dbo.BacSi AS bs
        ON lk.MaBS = bs.MaBS
    LEFT JOIN dbo.Khoa AS k
        ON bs.MaKhoa = k.MaKhoa
    WHERE (@MaBN IS NULL OR lk.MaBN = @MaBN)
      AND (@TuNgay IS NULL OR lk.ThoiGianKham >= @TuNgay)
      AND (
          @DenNgay IS NULL
          OR lk.ThoiGianKham < DATEADD(DAY, 1, @DenNgay)
      )
      AND (@TrangThai IS NULL OR lk.TrangThai = @TrangThai)
    ORDER BY lk.ThoiGianKham DESC;
END;
GO

-- 4. STORED PROCEDURE THONG KE LUOT KHAM THEO KHOA
CREATE OR ALTER PROCEDURE dbo.sp_ThongKeLuotKhamTheoKhoa
    @TuNgay DATE,
    @DenNgay DATE
AS
BEGIN
    SET NOCOUNT ON;

    IF @TuNgay IS NULL OR @DenNgay IS NULL
    BEGIN
        ;THROW 50002, N'Vui long nhap ngay bat dau va ngay ket thuc.', 1;
    END;

    IF @TuNgay > @DenNgay
    BEGIN
        ;THROW 50003, N'Tu ngay khong duoc lon hon den ngay.', 1;
    END;

    SELECT
        k.MaKhoa,
        k.TenKhoa,
        COUNT(lk.MaLK) AS TongLuotKham,
        SUM(
            CASE
                WHEN lk.TrangThai = N'Đã khám' THEN 1
                ELSE 0
            END
        ) AS SoLuotDaKham
    FROM dbo.Khoa AS k
    LEFT JOIN dbo.BacSi AS bs
        ON k.MaKhoa = bs.MaKhoa
    LEFT JOIN dbo.LichKham AS lk
        ON bs.MaBS = lk.MaBS
        AND lk.ThoiGianKham >= @TuNgay
        AND lk.ThoiGianKham < DATEADD(DAY, 1, @DenNgay)
        AND lk.TrangThai <> N'Đã hủy'
    GROUP BY k.MaKhoa, k.TenKhoa
    ORDER BY TongLuotKham DESC, k.TenKhoa;
END;
GO
