DECLARE @Serial varchar(50)
SET @Serial = 'AD87B-64C97-AFA5B-9E017-95CE1-43FDE'

SELECT * FROM tb_SerialNum_GalCiv2Ultimate where ActivationSN = @Serial OR SN = @Serial OR SN=dbo.NormalizeSerial(@Serial)


/* dbo.NormalizeSerial */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[NormalizeSerial]
(
      @Serial varchar(255)
)
RETURNS varchar(255)
AS
BEGIN

      IF LEN(@Serial) <> 35 AND @Serial Not Like '%-%'
            Return @Serial

      --Remove first and last character
      SET @Serial = SUBSTRING(@Serial, 2,33)

      SET @Serial = REPLACE(@Serial,'-','')

      return @Serial

END
GO