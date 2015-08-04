SELECT        a.i_pcdef_id AS ID, a.u_pc_code AS CODE, d.mny_disc_offer_value, d.u_disc_special_offer_type
FROM            mktg_promocode AS a WITH (NOLOCK) INNER JOIN
                         mktg_promocode_defn AS b ON a.i_pcdef_id = b.i_pcdef_id INNER JOIN
                         mktg_order_discount AS d ON b.i_pcdef_id = d.i_pcdef_id INNER JOIN
                         mktg_campaign_item AS x ON d.i_campitem_id LIKE x.i_campitem_id INNER JOIN
                             (SELECT DISTINCT i_pcdef_id, COUNT(*) AS 'unique codes'
                               FROM            mktg_promocode WITH (NOLOCK)
                               GROUP BY i_pcdef_id
                               HAVING         (COUNT(*) = 1)) AS Z ON Z.i_pcdef_id = a.i_pcdef_id
WHERE        (x.b_campitem_active = 1) AND (d.u_disc_special_offer_type = 'Shipping_Discount')