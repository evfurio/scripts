# == Overview
# This module contains the domain specific language (DSL) methods for monitoring
# various products in the Game Stop Online System Stack
#
# The class named WebBrowser is the main class for this DSL.
#
# Author:: Dturner
# Copyright:: Copyright (c) 2014 GameStop, Inc.
# Not for external distribution.
#
# = Usage

module MonitoringDSL

  def start_mechanize(user_agent, ssl_version, verify_mode, follow = true)
    $tracer.trace("MonitoringDSL : #{__method__}, Line : #{__LINE__}")
    mech = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mechanize'
      agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
      agent.follow_meta_refresh = true
    }
    return mech
  end

  def verify_game_stop_dot_com_is_alive(params, dir, env)
    envs = [env]
    $tracer.trace("MonitoringDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.report("should #{__method__}")
    config = RestAgentConfig.new
    config.set_user_agent('Mechanize')
    config.set_option("accept", 'application/json')
    config.set_option("content-type", 'text/html')

    mech = RestAgent.new(config)
    domain = params['domain']
    envs.each {|xx|
      dir.each{|yy|
        xx = "www" if xx.downcase == "prod"
        urls = ["https://#{xx.downcase}.#{domain}.com#{yy}"]
        urls.each {|url|
          $tracer.trace(url)
          page = mech.get(url)
          check = page.code.to_i.should == 200
          $tracer.report("#{url} responsed? : #{check}")
        }
      }
    }
  end

end