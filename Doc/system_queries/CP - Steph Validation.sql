--AddressTypeID	AddressTypeDesc
---------------   ---------------
--0				Shipping	
--1				Billing	
--2				Mailing	


--ecom ship addr
SELECT ck.OpenIDClaimedIdentifier, p.ProfileID, p.EmailAddress, a.*
FROM Profile.keymap.CustomerKey ck
	JOIN profile.dbo.Profile p
		ON ck.ProfileID = p.ProfileID
	JOIN Profile.dbo.Address a
		ON p.ProfileID = a.ProfileID
WHERE a.AddressTypeID = 0 
  AND ck.OpenIDClaimedIdentifier IN (
'https://logincert.gamestop.comID/zF9Pd6iRq0ixcRXzs4x33A',
'https://logincert.gamestop.comID/T2e2hoLgZ0OqReGpcf5PoQ',
'https://logincert.gamestop.comID/qJOtFdH4OESONPzLtXPN_g',
'https://logincert.gamestop.comID/dLSDPeyK3kGO1QX3mlGByQ',
'https://logincert.gamestop.comID/NDs1js0rwk6o1Ep_33hyfQ',
'https://logincert.gamestop.comID/3Rv9iDSQK0KKf_lAtusA-Q',
'https://logincert.gamestop.comID/gy85PJabR0muiviNHDUZYA'
)
ORDER BY p.EmailAddress 

--default ship addr
SELECT ck.OpenIDClaimedIdentifier, p.ProfileID, p.EmailAddress, a.*
FROM Profile.keymap.CustomerKey ck
	JOIN profile.dbo.Profile p
		ON ck.ProfileID = p.ProfileID
	JOIN Profile.dbo.Address a
		ON p.ProfileID = a.ProfileID
WHERE a.AddressTypeID = 0 
  AND a.[Default] = 1
  AND ck.OpenIDClaimedIdentifier IN (
'https://logincert.gamestop.comID/zF9Pd6iRq0ixcRXzs4x33A',
'https://logincert.gamestop.comID/T2e2hoLgZ0OqReGpcf5PoQ',
'https://logincert.gamestop.comID/qJOtFdH4OESONPzLtXPN_g',
'https://logincert.gamestop.comID/dLSDPeyK3kGO1QX3mlGByQ',
'https://logincert.gamestop.comID/NDs1js0rwk6o1Ep_33hyfQ',
'https://logincert.gamestop.comID/3Rv9iDSQK0KKf_lAtusA-Q',
'https://logincert.gamestop.comID/gy85PJabR0muiviNHDUZYA'
)
ORDER BY p.EmailAddress 

--ecom billing addr
SELECT ck.OpenIDClaimedIdentifier, p.ProfileID, p.EmailAddress, a.*
FROM Profile.keymap.CustomerKey ck
	JOIN profile.dbo.Profile p
		ON ck.ProfileID = p.ProfileID
	JOIN Profile.dbo.Address a
		ON p.ProfileID = a.ProfileID
WHERE a.AddressTypeID = 1
  AND ck.OpenIDClaimedIdentifier IN (
'https://logincert.gamestop.comID/T9xW_obQNUGd5AUWGE0IGg',
'https://logincert.gamestop.comID/jrjCXDNYZUyeaJBL5LMYzA',
'https://logincert.gamestop.comID/wk3j0KQdTUi9L7t_bBm1Pg',
'https://logincert.gamestop.comID/pYfwcyICN0m6FACb5F2jUg',
'https://logincert.gamestop.comID/-zf31WkZCUS_5mGww4wV5A',
'https://logincert.gamestop.comID/_wXfawNBoE26Nvp6ul_U-g',
'https://logincert.gamestop.com/ID/pjBt_9UhZkWhJELdIy8YVA',
'https://logincert.gamestop.comID/B70_okTAs0OpORWLTvGQqw',
'https://logincert.gamestop.comID/srvdDCif2kq9iVWX-DxEug',
'https://logincert.gamestop.comID/934YfZ65PECTzpP6M5VK1g',
'https://logincert.gamestop.comID/MFKNH0Zn9UqtuHWNPlDkEw',
'https://logincert.gamestop.comID/d7YfcNo-MEGy2qMOXjyRmA',
'https://logincert.gamestop.comID/zwYu1YQaqUKHRUGQjzyUlA',
'https://logincert.gamestop.comID/lq637UNK_0izRWyk8WNTvw',
'https://logincert.gamestop.comID/Pp_Kj6Y54kqPGq9EXFH5iA',
'https://logincert.gamestop.comID/P_T_xmSw8E2T7McdXaTR0g',
'https://logincert.gamestop.comID/f3dEPMNBhkOWxLjwtK4bww',
'https://logincert.gamestop.comID/9-JC4X15LU2UcgFFCaoAQw',
'https://logincert.gamestop.comID/-KxvZ4xAMEC8MXYanHYGag',
'https://logincert.gamestop.comID/ZNcbzwj2I0aSLxXdxvrcSg',
'https://logincert.gamestop.comID/_CNRh-iH80uJtLn9Anu0sg',
'https://logincert.gamestop.comID/CcSY5Y7jmEKAmj9myeNulw',
'https://logincert.gamestop.comID/WtvGGq1M3USSvzODU-BWpg',
'https://logincert.gamestop.comID/48mz44gnKUa_jpy4zuRzrg',
'https://logincert.gamestop.comID/a2GCuVQiP062BXZ4GHjJPw',
'https://logincert.gamestop.comID/E21FLUxgUUmJumy9AAbq9A',
'https://logincert.gamestop.comID/xkr6dGIoWUibAIFO-4b2PQ',
'https://logincert.gamestop.comID/NzF1i16wSUGhJ8c4I4IMcA',
'https://logincert.gamestop.comID/GK1Nlz3iaEyGt0abxRiCAg',
'https://logincert.gamestop.comID/frXHKWKxEEmO41Ta1f0dxg',
'https://logincert.gamestop.comID/g1OFPJNafEOxnsz6n_RL_g',
'https://logincert.gamestop.comID/bU-ENeRuh0eQLt3UV3zpDg',
'https://logincert.gamestop.comID/r5bKw3-opECEK3X3AgMeCw',
'https://logincert.gamestop.comID/DMNi2F5QG0K3GYs2BJR7zA',
'https://logincert.gamestop.comID/lpVjEP4O70W9k-va9BRnTg',
'https://logincert.gamestop.comID/m1HK9miIGkOE_5Vuis8LYw',
'https://logincert.gamestop.comID/-0ViXnDwAEWeVxNmidmNIw',
'https://logincert.gamestop.comID/Sj5NXZBWm06ZrtwYVQl2HA',
'https://logincert.gamestop.comID/i7Bn-MdMM0KZ-zMDlI_9gA',
'https://logincert.gamestop.comID/G9hrhflITkmZI9G0EofYYw',
'https://logincert.gamestop.comID/sPS_Tu-IrkaR3Qhly2QvwA',
'https://logincert.gamestop.comID/JKhWaNfZQkaR0W98T4CLwA',
'https://logincert.gamestop.comID/SuJf6biNDEmcZYvKKzyNkw',
'https://logincert.gamestop.comID/6yLoFltRSkqRlS_6P_bk9w',
'https://logincert.gamestop.comID/417TIULFP06VwN5BzxZw1Q',
'https://logincert.gamestop.comID/9CnckfXpYEOntdp1QThQHA',
'https://logincert.gamestop.comID/m8Zn3tTbhEaRO_cawjSugQ',
'https://logincert.gamestop.comID/QtmG76rDUEmP0oTJVJCp6g',
'https://logincert.gamestop.comID/bENO0TkIWE_QSA-kRgMB-w',
'https://logincert.gamestop.comID/SZ3M8g04r0ys-FJY8eaO1g',
'https://logincert.gamestop.comID/-_nB33JxQE__ic3wLRDT_w',
'https://logincert.gamestop.comID/BIfQFkCBdkW--hKtw_1-sQ',
'https://logincert.gamestop.comID/qNoMM4JjEUWmwOuZx-Snsw',
'https://logincert.gamestop.comID/C-GRlGEVD0u4wQsY1eVwgw',
'https://logincert.gamestop.com/ID/ZOt9qur9x0K6T1Eplt5CdA',
'https://logincert.gamestop.comID/ZlWokfh9qUSIN2ojnO0oMw',
'https://logincert.gamestop.comID/bA4M3jg_pUaaeeHkqQTZ0g',
'https://logincert.gamestop.comID/eb25aCbK-UWvoxKG8lNbHA',
'https://logincert.gamestop.comID/Igyhi80JeEOy5qc58IUPsw',
'https://logincert.gamestop.comID/DTew4Du2XESUoJRPfg35hg',
'https://logincert.gamestop.comID/FOxDmbYKqkGJGtjAqHiK2A',
'https://logincert.gamestop.comID/2I_Q_gRX30OSNNa2DwCPuA',
'https://logincert.gamestop.comID/OlWwo_bmTkmeGPnV0KqzaQ',
'https://logincert.gamestop.comID/QN8nv_KktUizdCfHB8XGqQ',
'https://logincert.gamestop.com/ID/l5kBXCj58kSGHKrTcSlhfw',
'https://logincert.gamestop.comID/qKJE-V31iEe5uqeqNMhRuw',
'https://logincert.gamestop.comID/F25NDVjj7kCOexB8BBbNdw',
'https://logincert.gamestop.comID/IvHfWU1OMkGgwpaxrmj9Kg',
'https://logincert.gamestop.comID/UHC6RGU68kuP1IkK_Zc5DQ',
'https://logincert.gamestop.comID/zQY4NDboP0qn0oXbH-5J4w',
'https://logincert.gamestop.comID/OcqaATkYV0GagkqSHhKkvg',
'https://logincert.gamestop.comID/5AcZs4AILUy7ytbw2X7bKg',
'https://logincert.gamestop.comID/jhAxwFt0H06XYmVJXYcsUA',
'https://logincert.gamestop.comID/Pj1yb43jFUyM6GtX2KudvA',
'https://logincert.gamestop.comID/CVCXqWgh6EmQoe0RSJFMEg',
'https://logincert.gamestop.comID/k67KNp_6n0mnj4KBhNxZmQ',
'https://logincert.gamestop.comID/e8fGkZT8Pk6exEd8OMbklA',
'https://logincert.gamestop.comID/kVzhwwdhX0izv8rb0nwSGg',
'https://logincert.gamestop.comID/cEJ_aYx9pUi-GbOs4SeJAw',
'https://logincert.gamestop.comID/ZEA9q4ta60K0hOKrY71PXg',
'https://logincert.gamestop.comID/6o4srL86WE6mTx1zKnouUQ',
'https://logincert.gamestop.comID/5hHlZZKiNUqxRN0kslPHRQ',
'https://logincert.gamestop.comID/XHEVJAAzfkuzkubEL3lZzg',
'https://logincert.gamestop.comID/qO3NZ8TBkUyYuEVajUbwdA',
'https://logincert.gamestop.comID/m6m9nVloQUaR6HKlI4QL4w',
'https://logincert.gamestop.comID/cDMOAikURkaK7sDN1FfTAA',
'https://logincert.gamestop.comID/DjaiHeBCUk6itxxOfjNX_A',
'https://logincert.gamestop.comID/NaxBgS_nrUah3CIdmZo9PA',
'https://logincert.gamestop.comID/STd4ZTT-rk2oDXZkAXsu5g',
'https://logincert.gamestop.comID/l3CHDOzxaEyyzgi3LJS3vA',
'https://logincert.gamestop.comID/VAle7EU1I0iWIBZuuFqK2Q',
'https://logincert.gamestop.comID/iRdP3Lq25kCQ1_hstBZLvw',
'https://logincert.gamestop.comID/H1YQ82vgIUKBD9nkPCEhIg',
'https://logincert.gamestop.comID/h4IxNi9DJEKyWFRjml0nVQ',
'https://logincert.gamestop.comID/Oe5J--dfq028Z0r_5hxeRg',
'https://logincert.gamestop.comID/axM-QK64QUu7c1kUJ-Oe4w',
'https://logincert.gamestop.comID/9UvO6WrzF0GxiAcylrY8OA',
'https://logincert.gamestop.comID/bxbbGRPhwUGlGw_mIKMUXQ',
'https://logincert.gamestop.comID/RCIw_5ay6E6GaE_ygc5mRw',
'https://logincert.gamestop.comID/hSxVo4Ue8EGu2hrJIGbbeQ',
'https://logincert.gamestop.comID/ZTwLDowgJUONJnUhPkHEJw',
'https://logincert.gamestop.comID/x4Q8BzDcvE_3OSN3JL6Y2g',
'https://logincert.gamestop.comID/vAvvcm4F3U2ATb2Tzd2-Bw',
'https://logincert.gamestop.comID/WVQjlRK4BU_fQ9qeXZVNpA',
'https://logincert.gamestop.comID/USwbEzxtLUWly-x5CC7GBA',
'https://logincert.gamestop.comID/RNQ6b6mhZ0a3Xd86ZcBKuA',
'https://logincert.gamestop.comID/vZgg_Rdbf0SQ7LTU54ZKmg',
'https://logincert.gamestop.comID/2z_keApLgUCrlwgGjQ8bcQ',
'https://logincert.gamestop.comID/GsvbQg87WEGCb3FA6EIU6A',
'https://logincert.gamestop.comID/zEmAWcOJAE6bQ0-0BTTG7A',
'https://logincert.gamestop.comID/jixDbP2R3EedG05IUWEJMw',
'https://logincert.gamestop.comID/afaNZ52rFkaaF391Cl3Wmw',
'https://logincert.gamestop.comID/id6eyl8psUKDOU-cyFCXAQ',
'https://logincert.gamestop.comID/2sUwjPRpnUSuzLvvS76pkg',
'https://logincert.gamestop.comID/p2usFB67rEiNbXVdc5MsbA',
'https://logincert.gamestop.comID/e0wodkKMZEaP65LVOhXtmQ',
'https://logincert.gamestop.comID/7bdhhHRIBUacoPKvUtJuaQ',
'https://logincert.gamestop.comID/RSUguvWcMEeM5fG0ccRs6w',
'https://logincert.gamestop.comID/AmgWk7e2I0SDxJVNonN9NQ',
'https://logincert.gamestop.comID/9YhqwXvA-02dGKKangGreA',
'https://logincert.gamestop.comID/n6LW3LCPRUqb-ERU0M2jiw',
'https://logincert.gamestop.comID/40kMYadS7keupdpoUPeK5g',
'https://logincert.gamestop.comID/3zhflkcRk068qe3AqUp5mw',
'https://logincert.gamestop.comID/JkmD-0pS70a26lCwM_pgEQ',
'https://logincert.gamestop.comID/Z2e959CZhk2xaD03yB8giA',
'https://logincert.gamestop.com/ID/90B753Awwki_-4WTvHg28w',
'https://logincert.gamestop.comID/0xcPy-aGRkCpMyIsuMmDHA',
'https://logincert.gamestop.comID/VpoT4Zevk0uEWS0qM77nQA',
'https://logincert.gamestop.comID/3zLVJ8vJqUSH0flicXlZvQ',
'https://logincert.gamestop.comID/F1VFh7kvkU_VRf4JAJbORA',
'https://logincert.gamestop.comID/poLrGfb1yEiTxaqHk77_vA',
'https://logincert.gamestop.comID/Ymr5t2v0O0KZQvCP7fAkag',
'https://logincert.gamestop.comID/3V55cwK5vUmQtV3-v1Lipg',
'https://logincert.gamestop.comID/rKxgrGKtvEicn--lRN-FLg',
'https://logincert.gamestop.comID/wNMTI2w4FkWWZlo-gf9RtQ',
'https://logincert.gamestop.comID/uDqKprTzL0iL_2p6HR-oGA',
'https://logincert.gamestop.comID/EFhoH3fVzEWQeXM2bptSyA',
'https://logincert.gamestop.com/ID/kyWQjK98ZUa8d_gp7iHmLA',
'https://logincert.gamestop.comID/21ZV4CQpKkGxvhWAxEmE2w'
)
ORDER BY p.EmailAddress 

--ecom bill and ship max (validated the max was 4, and also validated some 3's)
--the 4 had only 3 rows in addr, the 3's only had 2
--this is correct, as 1 from each openID was a store addr, these arent brought over)
SELECT ck.OpenIDClaimedIdentifier, p.ProfileID, p.EmailAddress, a.*
FROM Profile.keymap.CustomerKey ck
	JOIN profile.dbo.Profile p
		ON ck.ProfileID = p.ProfileID
	JOIN Profile.dbo.Address a
		ON p.ProfileID = a.ProfileID
WHERE a.AddressTypeID = 1
  AND ck.OpenIDClaimedIdentifier IN (
'https://logincert.gamestop.comID/T9xW_obQNUGd5AUWGE0IGg',
'https://logincert.gamestop.comID/jrjCXDNYZUyeaJBL5LMYzA',
'https://logincert.gamestop.comID/wk3j0KQdTUi9L7t_bBm1Pg',
'https://logincert.gamestop.comID/pYfwcyICN0m6FACb5F2jUg',
'https://logincert.gamestop.comID/dLSDPeyK3kGO1QX3mlGByQ',
'https://logincert.gamestop.comID/-zf31WkZCUS_5mGww4wV5A',
'https://logincert.gamestop.comID/_wXfawNBoE26Nvp6ul_U-g',
'https://logincert.gamestop.com/ID/pjBt_9UhZkWhJELdIy8YVA',
'https://logincert.gamestop.comID/B70_okTAs0OpORWLTvGQqw',
'https://logincert.gamestop.comID/srvdDCif2kq9iVWX-DxEug',
'https://logincert.gamestop.comID/934YfZ65PECTzpP6M5VK1g',
'https://logincert.gamestop.comID/MFKNH0Zn9UqtuHWNPlDkEw',
'https://logincert.gamestop.comID/d7YfcNo-MEGy2qMOXjyRmA',
'https://logincert.gamestop.comID/3Rv9iDSQK0KKf_lAtusA-Q',
'https://logincert.gamestop.comID/zwYu1YQaqUKHRUGQjzyUlA',
'https://logincert.gamestop.comID/lq637UNK_0izRWyk8WNTvw',
'https://logincert.gamestop.comID/Pp_Kj6Y54kqPGq9EXFH5iA',
'https://logincert.gamestop.comID/P_T_xmSw8E2T7McdXaTR0g',
'https://logincert.gamestop.comID/f3dEPMNBhkOWxLjwtK4bww',
'https://logincert.gamestop.comID/9-JC4X15LU2UcgFFCaoAQw',
'https://logincert.gamestop.comID/-KxvZ4xAMEC8MXYanHYGag',
'https://logincert.gamestop.comID/ZNcbzwj2I0aSLxXdxvrcSg',
'https://logincert.gamestop.comID/_CNRh-iH80uJtLn9Anu0sg',
'https://logincert.gamestop.comID/CcSY5Y7jmEKAmj9myeNulw',
'https://logincert.gamestop.comID/WtvGGq1M3USSvzODU-BWpg',
'https://logincert.gamestop.comID/48mz44gnKUa_jpy4zuRzrg',
'https://logincert.gamestop.comID/a2GCuVQiP062BXZ4GHjJPw',
'https://logincert.gamestop.comID/E21FLUxgUUmJumy9AAbq9A',
'https://logincert.gamestop.comID/xkr6dGIoWUibAIFO-4b2PQ',
'https://logincert.gamestop.comID/NzF1i16wSUGhJ8c4I4IMcA',
'https://logincert.gamestop.comID/GK1Nlz3iaEyGt0abxRiCAg',
'https://logincert.gamestop.comID/frXHKWKxEEmO41Ta1f0dxg',
'https://logincert.gamestop.comID/g1OFPJNafEOxnsz6n_RL_g',
'https://logincert.gamestop.comID/bU-ENeRuh0eQLt3UV3zpDg',
'https://logincert.gamestop.comID/r5bKw3-opECEK3X3AgMeCw',
'https://logincert.gamestop.comID/DMNi2F5QG0K3GYs2BJR7zA',
'https://logincert.gamestop.comID/lpVjEP4O70W9k-va9BRnTg',
'https://logincert.gamestop.comID/m1HK9miIGkOE_5Vuis8LYw',
'https://logincert.gamestop.comID/-0ViXnDwAEWeVxNmidmNIw',
'https://logincert.gamestop.comID/Sj5NXZBWm06ZrtwYVQl2HA',
'https://logincert.gamestop.comID/i7Bn-MdMM0KZ-zMDlI_9gA',
'https://logincert.gamestop.comID/G9hrhflITkmZI9G0EofYYw',
'https://logincert.gamestop.comID/sPS_Tu-IrkaR3Qhly2QvwA',
'https://logincert.gamestop.comID/JKhWaNfZQkaR0W98T4CLwA',
'https://logincert.gamestop.comID/SuJf6biNDEmcZYvKKzyNkw',
'https://logincert.gamestop.comID/6yLoFltRSkqRlS_6P_bk9w',
'https://logincert.gamestop.comID/417TIULFP06VwN5BzxZw1Q',
'https://logincert.gamestop.comID/9CnckfXpYEOntdp1QThQHA',
'https://logincert.gamestop.comID/m8Zn3tTbhEaRO_cawjSugQ',
'https://logincert.gamestop.comID/QtmG76rDUEmP0oTJVJCp6g',
'https://logincert.gamestop.comID/bENO0TkIWE_QSA-kRgMB-w',
'https://logincert.gamestop.comID/SZ3M8g04r0ys-FJY8eaO1g',
'https://logincert.gamestop.comID/-_nB33JxQE__ic3wLRDT_w',
'https://logincert.gamestop.comID/BIfQFkCBdkW--hKtw_1-sQ',
'https://logincert.gamestop.comID/qNoMM4JjEUWmwOuZx-Snsw',
'https://logincert.gamestop.comID/C-GRlGEVD0u4wQsY1eVwgw',
'https://logincert.gamestop.com/ID/ZOt9qur9x0K6T1Eplt5CdA',
'https://logincert.gamestop.comID/ZlWokfh9qUSIN2ojnO0oMw',
'https://logincert.gamestop.comID/bA4M3jg_pUaaeeHkqQTZ0g',
'https://logincert.gamestop.comID/eb25aCbK-UWvoxKG8lNbHA',
'https://logincert.gamestop.comID/NDs1js0rwk6o1Ep_33hyfQ',
'https://logincert.gamestop.comID/Igyhi80JeEOy5qc58IUPsw',
'https://logincert.gamestop.comID/DTew4Du2XESUoJRPfg35hg',
'https://logincert.gamestop.comID/FOxDmbYKqkGJGtjAqHiK2A',
'https://logincert.gamestop.comID/2I_Q_gRX30OSNNa2DwCPuA',
'https://logincert.gamestop.comID/OlWwo_bmTkmeGPnV0KqzaQ',
'https://logincert.gamestop.comID/QN8nv_KktUizdCfHB8XGqQ',
'https://logincert.gamestop.com/ID/l5kBXCj58kSGHKrTcSlhfw',
'https://logincert.gamestop.comID/qKJE-V31iEe5uqeqNMhRuw',
'https://logincert.gamestop.comID/F25NDVjj7kCOexB8BBbNdw',
'https://logincert.gamestop.comID/IvHfWU1OMkGgwpaxrmj9Kg',
'https://logincert.gamestop.comID/UHC6RGU68kuP1IkK_Zc5DQ',
'https://logincert.gamestop.comID/zQY4NDboP0qn0oXbH-5J4w',
'https://logincert.gamestop.comID/OcqaATkYV0GagkqSHhKkvg',
'https://logincert.gamestop.comID/5AcZs4AILUy7ytbw2X7bKg',
'https://logincert.gamestop.comID/jhAxwFt0H06XYmVJXYcsUA',
'https://logincert.gamestop.comID/Pj1yb43jFUyM6GtX2KudvA',
'https://logincert.gamestop.comID/CVCXqWgh6EmQoe0RSJFMEg',
'https://logincert.gamestop.comID/k67KNp_6n0mnj4KBhNxZmQ',
'https://logincert.gamestop.comID/e8fGkZT8Pk6exEd8OMbklA',
'https://logincert.gamestop.comID/kVzhwwdhX0izv8rb0nwSGg',
'https://logincert.gamestop.comID/cEJ_aYx9pUi-GbOs4SeJAw',
'https://logincert.gamestop.comID/ZEA9q4ta60K0hOKrY71PXg',
'https://logincert.gamestop.comID/6o4srL86WE6mTx1zKnouUQ',
'https://logincert.gamestop.comID/5hHlZZKiNUqxRN0kslPHRQ',
'https://logincert.gamestop.comID/XHEVJAAzfkuzkubEL3lZzg',
'https://logincert.gamestop.comID/qO3NZ8TBkUyYuEVajUbwdA',
'https://logincert.gamestop.comID/m6m9nVloQUaR6HKlI4QL4w',
'https://logincert.gamestop.comID/cDMOAikURkaK7sDN1FfTAA',
'https://logincert.gamestop.comID/T2e2hoLgZ0OqReGpcf5PoQ',
'https://logincert.gamestop.comID/DjaiHeBCUk6itxxOfjNX_A',
'https://logincert.gamestop.comID/NaxBgS_nrUah3CIdmZo9PA',
'https://logincert.gamestop.comID/STd4ZTT-rk2oDXZkAXsu5g',
'https://logincert.gamestop.comID/l3CHDOzxaEyyzgi3LJS3vA',
'https://logincert.gamestop.comID/VAle7EU1I0iWIBZuuFqK2Q',
'https://logincert.gamestop.comID/iRdP3Lq25kCQ1_hstBZLvw',
'https://logincert.gamestop.comID/H1YQ82vgIUKBD9nkPCEhIg',
'https://logincert.gamestop.comID/h4IxNi9DJEKyWFRjml0nVQ',
'https://logincert.gamestop.comID/Oe5J--dfq028Z0r_5hxeRg',
'https://logincert.gamestop.comID/axM-QK64QUu7c1kUJ-Oe4w',
'https://logincert.gamestop.comID/9UvO6WrzF0GxiAcylrY8OA',
'https://logincert.gamestop.comID/bxbbGRPhwUGlGw_mIKMUXQ',
'https://logincert.gamestop.comID/RCIw_5ay6E6GaE_ygc5mRw',
'https://logincert.gamestop.comID/hSxVo4Ue8EGu2hrJIGbbeQ',
'https://logincert.gamestop.comID/gy85PJabR0muiviNHDUZYA',
'https://logincert.gamestop.comID/ZTwLDowgJUONJnUhPkHEJw',
'https://logincert.gamestop.comID/x4Q8BzDcvE_3OSN3JL6Y2g',
'https://logincert.gamestop.comID/vAvvcm4F3U2ATb2Tzd2-Bw',
'https://logincert.gamestop.comID/WVQjlRK4BU_fQ9qeXZVNpA',
'https://logincert.gamestop.comID/USwbEzxtLUWly-x5CC7GBA',
'https://logincert.gamestop.comID/zF9Pd6iRq0ixcRXzs4x33A',
'https://logincert.gamestop.comID/RNQ6b6mhZ0a3Xd86ZcBKuA',
'https://logincert.gamestop.comID/vZgg_Rdbf0SQ7LTU54ZKmg',
'https://logincert.gamestop.comID/2z_keApLgUCrlwgGjQ8bcQ',
'https://logincert.gamestop.comID/GsvbQg87WEGCb3FA6EIU6A',
'https://logincert.gamestop.comID/zEmAWcOJAE6bQ0-0BTTG7A',
'https://logincert.gamestop.comID/jixDbP2R3EedG05IUWEJMw',
'https://logincert.gamestop.comID/afaNZ52rFkaaF391Cl3Wmw',
'https://logincert.gamestop.comID/id6eyl8psUKDOU-cyFCXAQ',
'https://logincert.gamestop.comID/2sUwjPRpnUSuzLvvS76pkg',
'https://logincert.gamestop.comID/p2usFB67rEiNbXVdc5MsbA',
'https://logincert.gamestop.comID/e0wodkKMZEaP65LVOhXtmQ',
'https://logincert.gamestop.comID/7bdhhHRIBUacoPKvUtJuaQ',
'https://logincert.gamestop.comID/RSUguvWcMEeM5fG0ccRs6w',
'https://logincert.gamestop.comID/AmgWk7e2I0SDxJVNonN9NQ',
'https://logincert.gamestop.comID/9YhqwXvA-02dGKKangGreA',
'https://logincert.gamestop.comID/qJOtFdH4OESONPzLtXPN_g',
'https://logincert.gamestop.comID/n6LW3LCPRUqb-ERU0M2jiw',
'https://logincert.gamestop.comID/40kMYadS7keupdpoUPeK5g',
'https://logincert.gamestop.comID/3zhflkcRk068qe3AqUp5mw',
'https://logincert.gamestop.comID/JkmD-0pS70a26lCwM_pgEQ',
'https://logincert.gamestop.comID/Z2e959CZhk2xaD03yB8giA',
'https://logincert.gamestop.com/ID/90B753Awwki_-4WTvHg28w',
'https://logincert.gamestop.comID/0xcPy-aGRkCpMyIsuMmDHA',
'https://logincert.gamestop.comID/VpoT4Zevk0uEWS0qM77nQA',
'https://logincert.gamestop.comID/3zLVJ8vJqUSH0flicXlZvQ',
'https://logincert.gamestop.comID/F1VFh7kvkU_VRf4JAJbORA',
'https://logincert.gamestop.comID/poLrGfb1yEiTxaqHk77_vA',
'https://logincert.gamestop.comID/Ymr5t2v0O0KZQvCP7fAkag',
'https://logincert.gamestop.comID/3V55cwK5vUmQtV3-v1Lipg',
'https://logincert.gamestop.comID/rKxgrGKtvEicn--lRN-FLg',
'https://logincert.gamestop.comID/wNMTI2w4FkWWZlo-gf9RtQ',
'https://logincert.gamestop.comID/uDqKprTzL0iL_2p6HR-oGA',
'https://logincert.gamestop.comID/EFhoH3fVzEWQeXM2bptSyA',
'https://logincert.gamestop.com/ID/kyWQjK98ZUa8d_gp7iHmLA',
'https://logincert.gamestop.comID/21ZV4CQpKkGxvhWAxEmE2w'
)
ORDER BY p.EmailAddress 

--ecom birthday
SELECT ck.OpenIDClaimedIdentifier, p.EmailAddress, p.BirthMonth, p.BirthDay
FROM Profile.keymap.CustomerKey ck
	JOIN profile.dbo.Profile p
		ON ck.ProfileID = p.ProfileID
WHERE ck.OpenIDClaimedIdentifier IN (
'https://logincert.gamestop.comID/IJfypr4Cl02CVW-Uc-6E3w',
'https://logincert.gamestop.comID/D5AyC1suUUmeQ5cBf8FcoQ',
'https://logincert.gamestop.comID/5k_kW5yTjEqzpe3dk5Ko6w',
'https://logincert.gamestop.comID/DRDekTEqCkuPlx5h0AYPtQ',
'https://logincert.gamestop.comID/zF9Pd6iRq0ixcRXzs4x33A',
'https://logincert.gamestop.comID/GEcB9oLDf0q_1g5__EDAuA',
'https://logincert.gamestop.comID/QygdPGcJ2EirbqMD7cLUJA',
'https://logincert.gamestop.comID/yODFH2OrNE6VcbAhtca-gw',
'https://logincert.gamestop.comID/2z_keApLgUCrlwgGjQ8bcQ',
'https://logincert.gamestop.comID/JqRJE6lOvUG2ic71zY_jXA',
'https://logincert.gamestop.comID/jOpR9K8ZYUaMG54z4BqUEQ',
'https://logincert.gamestop.comID/qO3NZ8TBkUyYuEVajUbwdA',
'https://logincert.gamestop.comID/STd4ZTT-rk2oDXZkAXsu5g',
'https://logincert.gamestop.comID/rHVCGfDYfka9mhDmhQkw2g'
)
ORDER BY p.EmailAddress

--ecom first name
SELECT ck.OpenIDClaimedIdentifier, p.EmailAddress, p.FirstName
FROM Profile.keymap.CustomerKey ck
	JOIN profile.dbo.Profile p
		ON ck.ProfileID = p.ProfileID
WHERE ck.OpenIDClaimedIdentifier IN (
'https://logincert.gamestop.comID/IJfypr4Cl02CVW-Uc-6E3w',
'https://logincert.gamestop.comID/D5AyC1suUUmeQ5cBf8FcoQ',
'https://logincert.gamestop.comID/5k_kW5yTjEqzpe3dk5Ko6w',
'https://logincert.gamestop.comID/DRDekTEqCkuPlx5h0AYPtQ',
'https://logincert.gamestop.comID/zF9Pd6iRq0ixcRXzs4x33A',
'https://logincert.gamestop.comID/GEcB9oLDf0q_1g5__EDAuA',
'https://logincert.gamestop.comID/QygdPGcJ2EirbqMD7cLUJA',
'https://logincert.gamestop.comID/yODFH2OrNE6VcbAhtca-gw',
'https://logincert.gamestop.comID/2z_keApLgUCrlwgGjQ8bcQ',
'https://logincert.gamestop.comID/JqRJE6lOvUG2ic71zY_jXA',
'https://logincert.gamestop.comID/jOpR9K8ZYUaMG54z4BqUEQ',
'https://logincert.gamestop.comID/qO3NZ8TBkUyYuEVajUbwdA',
'https://logincert.gamestop.comID/STd4ZTT-rk2oDXZkAXsu5g',
'https://logincert.gamestop.comID/rHVCGfDYfka9mhDmhQkw2g'
)
ORDER BY p.EmailAddress

--ecom last name
SELECT ck.OpenIDClaimedIdentifier, p.EmailAddress, p.LastName
FROM Profile.keymap.CustomerKey ck
	JOIN profile.dbo.Profile p
		ON ck.ProfileID = p.ProfileID
WHERE ck.OpenIDClaimedIdentifier IN (
'https://logincert.gamestop.comID/IJfypr4Cl02CVW-Uc-6E3w',
'https://logincert.gamestop.comID/D5AyC1suUUmeQ5cBf8FcoQ',
'https://logincert.gamestop.comID/5k_kW5yTjEqzpe3dk5Ko6w',
'https://logincert.gamestop.comID/DRDekTEqCkuPlx5h0AYPtQ',
'https://logincert.gamestop.comID/zF9Pd6iRq0ixcRXzs4x33A',
'https://logincert.gamestop.comID/GEcB9oLDf0q_1g5__EDAuA',
'https://logincert.gamestop.comID/QygdPGcJ2EirbqMD7cLUJA',
'https://logincert.gamestop.comID/yODFH2OrNE6VcbAhtca-gw',
'https://logincert.gamestop.comID/2z_keApLgUCrlwgGjQ8bcQ',
'https://logincert.gamestop.comID/JqRJE6lOvUG2ic71zY_jXA',
'https://logincert.gamestop.comID/jOpR9K8ZYUaMG54z4BqUEQ',
'https://logincert.gamestop.comID/qO3NZ8TBkUyYuEVajUbwdA',
'https://logincert.gamestop.comID/STd4ZTT-rk2oDXZkAXsu5g',
'https://logincert.gamestop.comID/rHVCGfDYfka9mhDmhQkw2g'
)
ORDER BY p.EmailAddress

--ecom gender (validated type 0, 1, 2)
SELECT ck.OpenIDClaimedIdentifier, p.EmailAddress, p.GenderID
FROM Profile.keymap.CustomerKey ck
	JOIN profile.dbo.Profile p
		ON ck.ProfileID = p.ProfileID
WHERE ck.OpenIDClaimedIdentifier IN (
'https://logincert.gamestop.comID/iDFWIT_cAEO3MuV-EACl_Q',
'https://logincert.gamestop.comID/m-C24NbKt0C2ssUCm1mrwQ',
'https://logincert.gamestop.comID/_BP42PwI1UqPfH3SvrvacA',
'https://logincert.gamestop.comID/gNFKSGGnSUCT60u8yCtwgQ',
'https://logincert.gamestop.comID/p0gffuug4E2PFhKFP9IoXg',
'https://logincert.gamestop.comID/JqRJE6lOvUG2ic71zY_jXA', 
'https://logincert.gamestop.comID/STd4ZTT-rk2oDXZkAXsu5g'
)
ORDER BY p.EmailAddress

--ecom gender
SELECT ck.OpenIDClaimedIdentifier, p.EmailAddress, p.DisplayName
FROM Profile.keymap.CustomerKey ck
	JOIN profile.dbo.Profile p
		ON ck.ProfileID = p.ProfileID
WHERE ck.OpenIDClaimedIdentifier IN (
'https://logincert.gamestop.comID/IJfypr4Cl02CVW-Uc-6E3w',
'https://logincert.gamestop.comID/D5AyC1suUUmeQ5cBf8FcoQ',
'https://logincert.gamestop.comID/5k_kW5yTjEqzpe3dk5Ko6w',
'https://logincert.gamestop.comID/DRDekTEqCkuPlx5h0AYPtQ',
'https://logincert.gamestop.comID/zF9Pd6iRq0ixcRXzs4x33A',
'https://logincert.gamestop.comID/GEcB9oLDf0q_1g5__EDAuA',
'https://logincert.gamestop.comID/QygdPGcJ2EirbqMD7cLUJA',
'https://logincert.gamestop.comID/yODFH2OrNE6VcbAhtca-gw',
'https://logincert.gamestop.comID/2z_keApLgUCrlwgGjQ8bcQ',
'https://logincert.gamestop.comID/STd4ZTT-rk2oDXZkAXsu5g'
)
ORDER BY p.EmailAddress

