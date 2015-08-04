d-Con $env:QAAUTOMATION_SCRIPTS\Impulse\spec\cart_to_impulse_spec.rb --csv $env:QAAUTOMATION_SCRIPTS\Impulse\spec\impulseitems.csv --or
d-Con $env:QAAUTOMATION_SCRIPTS\Impulse\spec\impulse_checkout_spec.rb --or
d-Con $env:QAAUTOMATION_SCRIPTS\Impulse\spec\com_footer_links_spec.rb --or
d-Con $env:QAAUTOMATION_SCRIPTS\Impulse\spec\sanity_homepage_spec.rb --or
d-Con $env:QAAUTOMATION_SCRIPTS\Impulse\spec\omniture_pagename_click_suite_spec.rb --csv $env:QAAUTOMATION_SCRIPTS\Impulse\spec\omniture_pagename_variables.csv --or
d-Con.bat --range QA_Cart --csv $env:QAAUTOMATION_SCRIPTS\Impulse\spec\lock_accounts.csv $env:QAAUTOMATION_SCRIPTS\Impulse\spec\store_lock_account_spec.rb  --or
d-Con.bat --range QA_Community --csv $env:QAAUTOMATION_SCRIPTS\Impulse\spec\lock_accounts.csv $env:QAAUTOMATION_SCRIPTS\Impulse\spec\community_lock_account_spec.rb --or
d-Con.bat --range QA_Developer --csv $env:QAAUTOMATION_SCRIPTS\Impulse\spec\lock_accounts.csv $env:QAAUTOMATION_SCRIPTS\Impulse\spec\developer_lock_account_spec.rb --or
d-Con.bat --range QA_Forums --csv $env:QAAUTOMATION_SCRIPTS\Impulse\spec\lock_accounts.csv $env:QAAUTOMATION_SCRIPTS\Impulse\spec\forums_lock_account_spec.rb --or
d-Con $env:QAAUTOMATION_SCRIPTS\Impulse\spec\store_front_reports_spec.rb --or
