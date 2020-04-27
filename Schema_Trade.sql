CREATE DATABASE CHUNGKHOAN
USE CHUNGKHOAN
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE LENHDAT(
	ID INT IDENTITY(1,1) NOT NULL,
	MACP CHAR(7) NOT NULL,
	NGAYDAT DATETIME NOT NULL DEFAULT GETDATE(),
	LOAIGD NCHAR(1) NOT NULL,
	LOAILENH NCHAR(10) NOT NULL,
	SOLUONG INT NOT NULL,
	GIADAT FLOAT NOT NULL,
	TRANGTHAILENH NVARCHAR(30) NOT NULL,
 CONSTRAINT [PK_LENHDAT] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LENHKHOP]    Script Date: 3/30/2020 10:36:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE LENHKHOP(
	IDKHOP INT IDENTITY(1,1) NOT NULL,
	NGAYKHOP DATETIME NOT NULL,
	SOLUONGKHOP INT NOT NULL,
	GIAKHOP FLOAT NOT NULL,
	IDLENHDAT INT NOT NULL,
 CONSTRAINT [PK_LENHKHOP1] PRIMARY KEY CLUSTERED 
(
	[IDKHOP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE BANGGIATRUCTUYEN(
	ID INT PRIMARY KEY IDENTITY,
	MACP CHAR(7),

	GIAMUA1 FLOAT,
	KLM1 INT,
	GIAMUA2 FLOAT,
	KLM2 INT,

	GIAKHOP FLOAT,-- moi nhat
	KHOILUONGKHOP INT,-- moi nhat

	GIABAN1 FLOAT,
	KLB1 INT,
	GIABAN2 FLOAT,
	KLB2 INT

)
GO

--------------------------------------------< INSERT DATA >--------------------------------------------
SET IDENTITY_INSERT [dbo].[LENHDAT] ON 

INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (2, N'ACB       ', CAST(N'2019-02-02 01:00:00.000' AS DateTime), N'M', N'LO        ', 1000, 10000, N'CK')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (3, N'ACB       ', CAST(N'2019-02-02 01:01:00.000' AS DateTime), N'M', N'LO        ', 1000, 10500, N'CK')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (4, N'ACB       ', CAST(N'2019-02-02 01:01:20.000' AS DateTime), N'M', N'LO        ', 1000, 9500, N'CK')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (5, N'ACB       ', CAST(N'2019-02-02 02:01:00.000' AS DateTime), N'M', N'LO        ', 1000, 11000, N'CK')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (7, N'ACB       ', CAST(N'2019-02-02 00:01:00.000' AS DateTime), N'M', N'LO        ', 1000, 21000, N'CK')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (20, N'ACB       ', CAST(N'2019-03-03 01:00:00.000' AS DateTime), N'B', N'LO        ', 3000, 10000, N'CK')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (21, N'ACB       ', CAST(N'2019-03-03 03:00:00.000' AS DateTime), N'B', N'LO        ', 4000, 12500, N'CK')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (22, N'ACB       ', CAST(N'2019-03-03 02:00:00.000' AS DateTime), N'B', N'LO        ', 1500, 20000, N'CK')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (23, N'ACB       ', CAST(N'2019-02-02 00:00:00.000' AS DateTime), N'B', N'LO        ', 2500, 11000, N'CK')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (26, N'ACB       ', CAST(N'2019-03-03 00:00:00.000' AS DateTime), N'M', N'LO        ', 2000, 8000, N'CK')
SET IDENTITY_INSERT [dbo].[LENHDAT] OFF
ALTER TABLE [dbo].[LENHKHOP]  WITH CHECK ADD  CONSTRAINT [FK_LENHKHOP_LENHDAT] FOREIGN KEY([IDLENHDAT])
REFERENCES [dbo].[LENHDAT] ([ID])
GO
ALTER TABLE [dbo].[LENHKHOP] CHECK CONSTRAINT [FK_LENHKHOP_LENHDAT]
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




------------------------------------- < DEPENDENCY ZONE > -------------------------------------


CREATE PROCEDURE SP_FILL_NEW_DATA_INTO_BANGGIATRUCTUYEN
AS
BEGIN


	INSERT INTO dbo.BANGGIATRUCTUYEN(MACP,GIAMUA1,KLM1,GIAMUA2,KLM2,GIABAN1,KLB1,GIABAN2,KLB2)
	SELECT TEMP.MACP AS MACP,
	  GIAMUA1 = MAX(CASE WHEN TEMP.RN=1 AND TEMP.LOAIGD LIKE 'M' THEN TEMP.GIADAT ELSE NULL END),
      KLM1    = MAX(CASE WHEN TEMP.RN=1 AND TEMP.LOAIGD LIKE 'M' THEN TEMP.SOLUONG ELSE NULL END),
      GIAMUA2 = MAX(CASE WHEN TEMP.RN=2 AND TEMP.LOAIGD LIKE 'M' THEN TEMP.GIADAT ELSE NULL END),
      KLM2    = MAX(CASE WHEN TEMP.RN=2 AND TEMP.LOAIGD LIKE 'M' THEN TEMP.SOLUONG ELSE NULL END),
	  GIABAN1 = MAX(CASE WHEN TEMP.RN=1 AND TEMP.LOAIGD LIKE 'B' THEN TEMP.GIADAT ELSE NULL END),
      KLB1    = MAX(CASE WHEN TEMP.RN=1 AND TEMP.LOAIGD LIKE 'B' THEN TEMP.SOLUONG ELSE NULL END),
      GIABAN2 = MAX(CASE WHEN TEMP.RN=2 AND TEMP.LOAIGD LIKE 'B' THEN TEMP.GIADAT ELSE NULL END),
      KLB2    = MAX(CASE WHEN TEMP.RN=2 AND TEMP.LOAIGD LIKE 'B' THEN TEMP.SOLUONG ELSE NULL END)
	  FROM 
	   (
	  	  SELECT *
		   FROM (
				SELECT TOP 2 *, RN = ROW_NUMBER() OVER (PARTITION BY MACP, LOAIGD ORDER BY GIADAT DESC)
				FROM dbo.LENHDAT AS LD
				WHERE LD.LOAIGD LIKE 'M' AND LD.MACP LIKE 'PTIT'
				ORDER BY LD.GIADAT DESC
				UNION
				SELECT TOP 2 *, RN = ROW_NUMBER() OVER (PARTITION BY MACP, LOAIGD ORDER BY GIADAT ASC)
				FROM dbo.LENHDAT AS LD
				WHERE LD.LOAIGD LIKE 'B' AND LD.MACP LIKE 'PTIT'
				ORDER BY LD.GIADAT ASC
		    ) AS X
	   ) AS TEMP
	  GROUP BY TEMP.MACP

END;

EXEC SP_FILL_DATA_TO_BANGGIATRUCTUYEN


