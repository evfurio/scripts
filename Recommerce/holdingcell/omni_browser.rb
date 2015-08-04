Object.send(:remove_const, :OmniBrowser) if Object.const_defined?(:OmniBrowser)

# Author:: Zach Burke
# Copyright:: Copyright (c) 2011 GameStop, Inc.
# Not for external distribution.

# == Overview
# => This browser allows for selecting between Chrome, IE, Firefox or whatever
# => at command line.  This was built to keep from having to update the framework 
# => when a new project is created.
# == Usage
#
#  @browser = OmniBrowser.new.ie.open("qa.gamestop.com")
#  @browser.log_in_link.should_exist

class OmniBrowser < CommonBrowserBaseClass

  # Returns a new instance of ImpulseBrowser.
  # === Parameters:
  # _browser_type_: string of the browser type, e.g. chrome, ie-webspec, etc.
  def self.new(browser_type = WEBSPEC)
    # Determine which Class is to be used as the internal tech, configure
    # it with the appropropriate mix-ins, and return it to be created later.
    browser_class = BrowserCreator.configure_and_return_browser_class(browser_type, self)

    # include all modules specified by dsl scripts.
    # OmniBrowser.include_script_modules

    CommonBrowserUtilities.browser_instance = browser_class.new
    BrowserCreator.handle_new_syntax_if_webspec(browser_type, CommonBrowserUtilities.browser_instance)
    return CommonBrowserUtilities.browser_instance

  end

  # Includes a users specified module into webspec if the module exists.
  # === Parameters:
  # _module_name_:: user specified module symbol
  def self.include_module(module_name)
    if Object.const_defined?(module_name)
      BrowserCreator.include_in_default_classes(module_name)
    end
  end

  private

  # DON'T move this include into the MODULE_LIST array.
  # At least one of the methods in the module needs to be called prior
  # to iterating through the MODULE_LIST.
  include BrowserCreator

  # Mix modules into the specified browser_class.
  # === Parameters:
  # _browser_class_: JRuby Class to mix the modules into.
  def self.include_modules(browser_class)
    browser_class.module_eval do
      include Spec::Matchers
      include CommonBuildUtilities
      include CommonBrowserUtilities
      include CommonSnapshotUtilities
    end
  end

end
