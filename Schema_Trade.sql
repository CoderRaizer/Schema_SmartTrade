CREATE DATABASE CHUNGKHOAN

USE CHUNGKHOAN
GO



--------------------------------------------< CURSOR >--------------------------------------------
CREATE PROCEDURE [dbo].[CursorLoaiGD]
  @OutCrsr CURSOR VARYING OUTPUT, 
  @macp NVARCHAR( 10), @Ngay NVARCHAR( 50),  @LoaiGD CHAR 
AS
SET DATEFORMAT DMY 
IF (@LoaiGD='M') 
  SET @OutCrsr=CURSOR KEYSET FOR 
  SELECT NGAYDAT, SOLUONG, GIADAT,ID FROM LENHDAT 
  WHERE MACP=@macp 
    AND DAY(NGAYDAT)=DAY(@Ngay)AND MONTH(NGAYDAT)= MONTH(@Ngay) AND YEAR(NGAYDAT)=YEAR(@Ngay)  
    AND LOAIGD=@LoaiGD AND SOLUONG >0  
    ORDER BY GIADAT DESC, NGAYDAT 
ELSE
  SET @OutCrsr=CURSOR KEYSET FOR 
  SELECT NGAYDAT, SOLUONG, GIADAT,ID FROM LENHDAT 
  WHERE MACP=@macp 
    AND DAY(NGAYDAT)=DAY(@Ngay)AND MONTH(NGAYDAT)= MONTH(@Ngay) AND YEAR(NGAYDAT)=YEAR(@Ngay)  
    AND LOAIGD=@LoaiGD AND SOLUONG >0  
    ORDER BY GIADAT, NGAYDAT 
OPEN @OutCrsr


GO
/****** Object:  StoredProcedure [dbo].[SP_KHOPLENH_LO]    Script Date: 3/30/2020 10:36:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROC [dbo].[SP_KHOPLENH_LO]
 @macp NVARCHAR( 10), @Ngay NVARCHAR( 50),  @LoaiGD CHAR, 
 @soluongMB INT, @giadatMB FLOAT 
AS
SET DATEFORMAT DMY
DECLARE @CrsrVar CURSOR , @ngaydat NVARCHAR( 50), @soluong INT, @giadat FLOAT,  @soluongkhop INT, @giakhop FLOAT,@idlenhdat int
 IF (@LoaiGD='B')
   EXEC CursorLoaiGD  @CrsrVar OUTPUT, @macp,@Ngay, 'M'
 ELSE 
  EXEC CursorLoaiGD  @CrsrVar OUTPUT, @macp,@Ngay, 'B'
  
FETCH NEXT FROM @CrsrVar  INTO  @ngaydat , @soluong , @giadat ,@idlenhdat
WHILE (@@FETCH_STATUS <> -1 AND @soluongMB >0)
BEGIN
 IF  (@LoaiGD='B' )
 BEGIN
   IF  (@giadatMB <= @giadat)
   BEGIN
     IF (@soluongMB >= @soluong)
     BEGIN
       SET @soluongkhop = @soluong
       SET @giakhop = @giadat
       SET @soluongMB = @soluongMB - @soluong
       UPDATE dbo.LENHDAT  
         SET SOLUONG = 0,TRANGTHAILENH = N'khớp hết'
         WHERE CURRENT OF @CrsrVar
     END
     ELSE
     BEGIN
       SET @soluongkhop = @soluongMB
       SET @giakhop = @giadat
       
       UPDATE dbo.LENHDAT  
         SET SOLUONG = SOLUONG - @soluongMB, TRANGTHAILENH = N'khớp lệnh 1 phần'
         WHERE CURRENT OF @CrsrVar
		SET @soluongMB = 0
     END
     SELECT  @soluongkhop, @giakhop,@giadat, @idlenhdat
     -- Cập nhật table LENHKHOP
	 INSERT INTO dbo.LENHKHOP
	         ( NGAYKHOP ,
	           SOLUONGKHOP ,
	           GIAKHOP ,
	           IDLENHDAT
	         )
	 VALUES  ( @Ngay, -- NGAYKHOP - datetime
	           @soluongkhop , -- SOLUONGKHOP - int
	           @giakhop , -- GIAKHOP - float
	           @idlenhdat -- IDLENHDAT - int
	         )
	END
     ELSE
	 BEGIN
	  INSERT INTO dbo.LENHDAT
	         ( MACP ,
	           NGAYDAT ,
	           LOAIGD ,
	           LOAILENH,
			   SOLUONG,
			   GIADAT,
			   TRANGTHAILENH
	         )
	 VALUES  (	@macp,
			   @Ngay, -- NGAYKHOP - datetime
			   @LoaiGD,
			   'LO',
	            @soluongMB , -- SOLUONGKHOP - int
	           @giadatMB , -- GIAKHOP - float
	           'CK' -- IDLENHDAT - int
	         )
			 SET @soluongMB=0
	END
END

ELSE
 BEGIN
  IF  (@giadatMB >= @giadat)
   BEGIN
     IF @soluongMB >= @soluong
     BEGIN
       SET @soluongkhop = @soluong
       SET @giakhop = @giadat
       SET @soluongMB = @soluongMB - @soluong
       UPDATE dbo.LENHDAT  
         SET SOLUONG = 0,TRANGTHAILENH = N'khớp hết'
         WHERE CURRENT OF @CrsrVar
     END
     ELSE
     BEGIN
       SET @soluongkhop = @soluongMB
       SET @giakhop = @giadat
       
       UPDATE dbo.LENHDAT  
         SET SOLUONG = SOLUONG - @soluongMB, TRANGTHAILENH = N'khớp lệnh 1 phần'
         WHERE CURRENT OF @CrsrVar
       SET @soluongMB = 0
     END
    SELECT  @soluongkhop, @giakhop, @giadat, @idlenhdat
	 
	 INSERT INTO dbo.LENHKHOP
	         ( NGAYKHOP ,
	           SOLUONGKHOP ,
	           GIAKHOP ,
	           IDLENHDAT
	         )
	 VALUES  ( @Ngay, -- NGAYKHOP - datetime
	           @soluongkhop , -- SOLUONGKHOP - int
	           @giakhop , -- GIAKHOP - float
	           @idlenhdat -- IDLENHDAT - int
	         )
    END
 ELSE --IF  (@giadatMB >= @giadat)
   BEGIN
	 INSERT INTO dbo.LENHDAT
	         ( MACP ,
	           NGAYDAT ,
	           LOAIGD ,
	           LOAILENH,
			   SOLUONG,
			   GIADAT,
			   TRANGTHAILENH
	         )
	 VALUES  ( @macp,
			   @Ngay, -- NGAYKHOP - datetime
			   @LoaiGD,
			   'LO',
	           @soluongMB , -- SOLUONGKHOP - int
	           @giadatMB , -- GIAKHOP - float
	           N'CK' 
	         )
	SET @soluongMB=0
    --GOTO THOAT
	END

	END
FETCH NEXT FROM @CrsrVar  INTO  @ngaydat , @soluong , @giadat ,@idlenhdat
END
THOAT:
    CLOSE @CrsrVar
    DEALLOCATE @CrsrVar






GO
