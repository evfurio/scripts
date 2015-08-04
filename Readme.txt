QAAUTOMATION SCRIPTS v3.7.0

Issues, Questions, Requests?  Email [CORP -IS-Automation@gamestop.com]

## QUICK REFERENCE TO SCRIPT EXECUTION ##
Additional command lines can be found in the Docs or data sets


UI Checkout Authenticated
# do_auth_checkout 		
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48627 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_GS --browser chrome --or

# do_linkshare A:		
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS65460 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --affiliate_url QA_LINK1 --browser chrome --or

# do_linkshare B:		
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range LINK02 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --affiliate_url QA_LINK2 --browser chrome --or

# do_ef:				
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range EF01 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --affiliate_url QA_EF --browser chrome --or

# do_optimizely:		
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range OPT01 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_GS --browser chrome --or

# do_adroll:			
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range ADROLL01 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_GS --browser chrome --or

# do_ci:				
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range CI01 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_GS --browser chrome --or

# do_google_analytics:	
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range GOOGLE01 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_GS --browser chrome --or


UI Checkout Guests

# do_guest_checkout		
d-Con  %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48600 --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --browser chrome --or 

# do_linkshare A:  		
d-Con  %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range LINK03 --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --browser chrome --or 

# do_linkshare B:  		
d-Con  %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range LINK04 --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --browser chrome --or 

# do_ef:           		
d-Con  %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range EF02 --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --browser chrome --or 

# do_optimizely:   		
d-Con  %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range OPT02 --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --browser chrome --or 

# do_adroll:       		
d-Con  %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range ADROLL02 --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --browser chrome --or 

# do_ci:           		
d-Con  %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range CI02 --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --browser chrome --or 

# do_google_analytics:	
d-Con  %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range GOOGLE02 --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --browser chrome --or 

UI HOPS

# do_hops_with_pur		
d-Con --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv  --url QA_GS --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\hops_dataset.csv --range HOPS01 --login tstr3@gs.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_hops_product.sql --svc %QAAUTOMATION_SCRIPTS%\Common\config\endpoints.csv --svc_env QA_V1 --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\hops_request_authenticated_user_spec.rb --browser chrome -e 'RequestHops as AuthenticatedUser when ShowHopsPURandCC is TRUE' --or
# do_hops_wo_pur		
d-Con --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv  --url QA_GS --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\hops_dataset.csv --range HOPS03 --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_hops_product.sql --svc %QAAUTOMATION_SCRIPTS%\Common\config\endpoints.csv --svc_env QA_V1 --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\hops_request_guest_spec.rb --browser chrome -e 'RequestHops as Guest when ShowHopsPURandCC is TRUE' --or

UI Single Sign On

# do_single_sign_on		
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\single_sign_on_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48627 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_products_with_titles.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog"  --browser chrome --prop QA_GS -e "Verify Authenticated Cookies for SSO states on GameStop.com" --or


PAYPAL SCRIPTS

# do paypal guest checkout	
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS57661 --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_GS --browser chrome --or

# do paypal guest checkout	
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS57680 --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_GS --browser chrome --or

# do paypal guest checkout	
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS57682 --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_GS --browser chrome --or

# do paypal guest checkout	
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS57662 --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_GS --browser chrome --or

# do paypal authenticated 	
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS57663 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_GS --browser chrome --or

# do paypal authenticated 	
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS57677 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_GS --browser chrome --or

# do paypal authenticated 	
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS57664 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_GS --svc %QAAUTOMATION_SCRIPTS%\Common\config\endpoints.csv --svc_env QA_V1 --browser chrome --or

# do paypal authenticated 	
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS57681 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_GS --browser chrome --or


ISPU SCRIPTS
# do ISPU authenticated 	
d-Con  %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_ISPU_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48617 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_GS --svc %QAAUTOMATION_SCRIPTS%\Common\config\endpoints.csv --svc_env QA_V1 --browser chrome --or


SEARCH SCRIPTS

# do a bulk search and verify 	
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\Search\search_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48600 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --browser chrome -e "should search for bulk results and validate" --or

# do a targeted keyword search and verify	
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\Search\search_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48600 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --browser chrome -e "should search by targeted keywords" --or

# do search for product available for 24 hr shipping
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\Search\search_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48600 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --browser chrome -e "should search for product available for 24 hr shipping" --or

# do search for accessories by filter
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\Search\search_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48600 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --browser chrome -e "should search for accessories" --or

# do search for preowned product by filter
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\Search\search_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48600 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --browser chrome -e "should search for preowned product" --or

# do search for pick up at store product by filter
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\Search\search_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48600 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --browser chrome -e "should search for pick up at store product" --or

# do search for downloadable product by filter
d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\Search\search_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48600 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --browser chrome -e "should search for downloadable product" --or

#########################################
ALL CHECKOUT UI SCRIPTS##################
#########################################
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48627 --login gsui_20140606_140620_430@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48592 --login gsui_20140606_140624_403@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48554 --login gsui_20140606_140626_656@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48593 --login gsui_20140606_140629_230@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48576 --login gsui_20140606_140631_282@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48594 --login gsui_20140606_140633_715@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48595 --login gsui_20140606_140635_873@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_DLC_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48596 --login gsui_20140606_140638_286@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_DLC_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48597 --login gsui_20140606_140640_647@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_DLC_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48598 --login gsui_20140606_140642_909@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_DLC_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48599 --login gsui_20140606_140645_518@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48600 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48601 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48602 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_DLC_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48603 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\new_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48604 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\new_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48605 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\new_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48606 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\new_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48607 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\new_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48608 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\new_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48609 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_ISPU_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48610 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_ISPU_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48611 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_ISPU_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48612 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48613 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48614 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_MIXED_PRODUCTS_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48615 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_MIXED_PRODUCTS_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48616 --login gsui_20140606_140647_712@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_ISPU_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48617 --login gsui_20140606_140650_264@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_ISPU_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48618 --login gsui_20140606_140652_385@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48765 --login gsui_20140606_140654_564@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48767 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48780 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48782 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48783 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48784 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48786 --login gsui_20140606_140656_873@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48787 --login gsui_20140606_140659_113@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48790 --login gsui_20140606_140701_394@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48795 --login gsui_20140606_140703_641@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48796 --login gsui_20140606_140706_407@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48797 --login gsui_20140606_140708_713@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48798 --login gsui_20140606_140710_878@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48799 --login gsui_20140606_140713_148@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48800 --login gsui_20140606_140715_297@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48802 --login gsui_20140606_140717_560@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48996 --login gsui_20140606_140719_845@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS49004 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_DLC_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS49005 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS49007 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS49008 --login gsui_20140606_140722_136@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_DLC_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS49016 --login gsui_20140606_140724_737@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS49017 --login gsui_20140606_140726_853@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\new_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS49141 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS57661 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS57680 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS57682 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS57662 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS57663 --login gsui_20140606_140728_998@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS57677 --login gsui_20140606_140731_291@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS57664 --login gsui_20140606_140733_431@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS57681 --login gsui_20140606_140735_621@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS65460 --login gsui_20140606_140738_108@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS69187 --login gsui_20140606_140740_398@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS69186 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS69188 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range EF01 --login gsui_20140606_140742_694@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range EF02 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range OPT01 --login gsui_20140606_140745_640@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range OPT02 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range ADROLL01 --login gsui_20140606_140747_423@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range ADROLL02 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range CI01 --login gsui_20140606_140849_613@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range CI02 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range GOOGLE01 --login gsui_20140606_140749_626@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range GOOGLE02 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec_RENEWAL.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range REWENAL --login gsui_20140606_140752_170@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS62917 --login gsui_20140606_140754_484@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\new_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS62918 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\new_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS62919 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\new_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS62920 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\new_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS62921 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_DLC_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS62922 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS62923 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS62924 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS62925 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_DLC_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS62926 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_DLC_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS62928 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_DLC_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS62929 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_DLC_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS62930 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS62931 --login gsui_20140606_140756_758@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS62932 --login gsui_20140606_140758_805@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS62933 --login gsui_20140606_140801_140@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS62934 --login gsui_20140606_140803_153@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS57939 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS57941 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS57942 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS57944 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS58265 --login gsui_20140606_140805_448@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS58266 --login gsui_20140606_140807_265@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS58267 --login gsui_20140606_140809_244@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS58289 --login gsui_20140606_140811_131@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS58290 --login gsui_20140606_140813_158@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS58292 --login gsui_20140606_140815_360@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS58293 --login gsui_20140606_140816_949@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS58294 --login gsui_20140606_140818_811@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS58295 --login gsui_20140606_140820_672@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS58296 --login gsui_20140606_140822_588@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS58297 --login gsui_20140606_140824_457@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS58300 --login gsui_20140606_140826_485@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS57860 --login gsui_20140606_140828_409@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS57859 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS58059 --login gsui_20140606_140830_184@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS58067 --login gsui_20140606_140832_340@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS57986 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS57988 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS23466 --login gsui_20140606_140834_214@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS64588 --login gsui_20140606_140836_187@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS20006 --login expire001@qagsecomprod.oib.com --password T3sting --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS60339 --login expire002@qagsecomprod.oib.com --password T3sting --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_DLC_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS65584 --login gsui_20140606_140838_360@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS65583 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\subscribe_unsubscribe_to_mailing_list_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range Unsubscribe --login gsui_20140606_140839_845@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\subscribe_unsubscribe_to_mailing_list_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range Subscribe --login gsui_20140606_140841_936@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\account_locked_five_attempts_spec.rb --browser chrome -e 'Locked Account after five attempts' --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS68121 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\account_locked_five_attempts_spec.rb --browser chrome -e 'Attempt to login less than 30 minutes' --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS68133 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\account_locked_five_attempts_spec.rb --browser chrome -e 'Attempt to login after 30 minutes' --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS68134 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\account_locked_five_attempts_spec.rb --browser chrome -e 'Locked Account after five attempts' --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS68141 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\account_locked_five_attempts_spec.rb --browser chrome -e 'Attempt to login less than 30 minutes' --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS68142 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\account_locked_five_attempts_spec.rb --browser chrome -e 'Attempt to login less than 30 minutes' --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS68143 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS65313 --login qa_ui_testing1@4test.com --password T3sting --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS65316 --login bf_gsdc85@qagsecomprod.oib.com --password T3sting --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS65318 --login gsui_20140606_140843_878@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range Upsell01 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_ISPU_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS67327 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22853 --login gsui_20140606_140845_717@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22834 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22833 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22828 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22827 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22826 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22813 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22812 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22811 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22810 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22808 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22804 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22802 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22801 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22797 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22796 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22795 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22794 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22793 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22792 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22791 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22790 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22789 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22788 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22787 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22786 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22785 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22784 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22783 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22782 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22781 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22780 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22736 --login gsui_20140606_140847_705@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22725 --login gsui_20140606_140849_613@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22724 --login gsui_20140606_140851_560@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22723 --login gsui_20140606_140853_427@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22722 --login gsui_20140606_140855_294@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22721 --login gsui_20140606_140857_283@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22720 --login gsui_20140606_140859_249@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22719 --login gsui_20140606_140901_260@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22718 --login gsui_20140606_140903_147@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22717 --login gsui_20140606_140904_985@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22714 --login gsui_20140606_140906_856@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22713 --login gsui_20140606_140908_915@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22712 --login gsui_20140606_140910_738@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22711 --login gsui_20140606_140912_599@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\new_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22708 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\new_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22706 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22697 --login gsui_20140606_140851_560@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22684 --login gsui_20140606_140853_427@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22682 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22681 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22680 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22675 --login gsui_20140606_140855_294@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22672 --login gsui_20140606_140857_283@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22665 --login gsui_20140606_140859_249@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22663 --login gsui_20140606_140901_260@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22660 --login gsui_20140606_140903_147@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22656 --login gsui_20140606_140904_985@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22652 --login gsui_20140606_140906_856@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22651 --login gsui_20140606_140908_915@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22649 --login gsui_20140606_140910_738@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22643 --login gsui_20140606_140912_599@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22642 --login gsui_20140606_140914_624@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22637 --login gsui_20140606_140916_556@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22633 --login gsui_20140606_140918_407@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22632 --login gsui_20140606_140920_280@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22631 --login gsui_20140606_140922_299@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22630 --login gsui_20140606_140924_149@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS63434 --login gsui_20140606_140926_170@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS63456 --login gsui_20140606_140927_916@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS63653 --login gsui_20140606_140929_731@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_ISPU_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS63731 --login gsui_20140606_140931_746@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_ISPU_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS63733 --login gsui_20140606_140933_525@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS64435 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS64237 --login gsui_20140606_140935_593@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS64216 --login gsui_20140606_140937_513@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS65310 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS16522 --login gsui_20140606_140939_349@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS16521 --login gsui_20140606_140941_254@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_ISPU_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS63749 --login gsui_20140606_140943_142@qagsecomprod.oib.com --password T3sting1 --or
d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_ISPU_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS63602 --login gsui_20140606_140945_220@qagsecomprod.oib.com --password T3sting1 --or






