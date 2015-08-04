SELECT a.i_pcdef_id AS ID, a.u_pc_code AS CODE, d.mny_disc_offer_value, d.u_disc_special_offer_type
FROM [Gamestop_marketing].[dbo].[mktg_promocode] a WITH (NOLOCK)
  INNER JOIN 
  [Gamestop_marketing].[dbo].[mktg_promocode_defn] b on a.i_pcdef_id = b.i_pcdef_id
  INNER JOIN
  [Gamestop_marketing].[dbo].[mktg_order_discount] d on b.i_pcdef_id = d.i_pcdef_id
  INNER JOIN
  [GameStop_marketing].[dbo].[mktg_campaign_item] x on d.i_campitem_id like x.i_campitem_id
  INNER JOIN
  
(SELECT DISTINCT i_pcdef_id, count(*) 'unique codes'
	FROM [Gamestop_marketing].[dbo].[mktg_promocode] (NOLOCK)
	GROUP BY i_pcdef_id
	HAVING COUNT(*) = 1
) as Z
ON Z.i_pcdef_id = a.i_pcdef_id
WHERE x.b_campitem_active = 1 AND d.u_disc_special_offer_type is not NULL AND u_disc_special_offer_type = 'OrderLevelDiscount'