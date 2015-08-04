# == Overview
# This module contains the domain specific language (DSL) methods for monitoring
# various products in the Game Stop Online Continuous Integration Tools
#
# The class named WebBrowser is the main class for this DSL.
#
# Author:: Dturner
# Copyright:: Copyright (c) 2014 GameStop, Inc.
# Not for external distribution.
#
# = Usage
# See the documentation for WebBrowser for examples.
#

module ContinuousIntegrationDSL

  def get_octopus_release
    $tracer.trace("ContinuousIntegrationFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    ## put this in a config
    url = "http://cibuilds.gamestop.com"
    port = "8888"

    #Need to return the deployment id's
    deployment_id = "deployments-1177"

    #Need to map the environment id's based on what Octopus returns, not a local mapping
    environment_id = "Environments-2"
    purpose = "ecomm_automation"
    apikey = "API-3VGWSZGHVXKTUOKVMATMTHJK3RE"

    config = RestAgentConfig.new
    config.set_user_agent('Mechanize')
    config.set_option("accept", 'application/json')
    config.set_option("content-type", 'text/html')
    config.set_option("X-Octopus-ApiKey", "#{apikey}")

    client = RestAgent.new(config)

    deployments = client.get("#{url}:#{port}/api/deployments/#{deployment_id}?apikey=#{apikey}")
    release_id = deployments.http_body.find_tag("release_id").content
    env = client.get("#{url}:#{port}/api/environments/#{environment_id}?apikey=#{apikey}")
    name = env.http_body.find_tag("name").content

    return name, release_id
  end
end