#Serves as a functional wrapper of the proxy_manager class.

module ProxyFunctions

  #sets up proxy server
  def start_proxy_server(port)
    #Set proxy for the web driver
    $options.http_proxy = "localhost"
    $options.http_proxy_port = port
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    proxy = ProxyServerManager.new(port)
    proxy.start
    proxy.started?.should be_true
    return proxy
  end

  #stop and ensure the proxy is no longer started
  def stop_proxy_server(proxy)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    proxy.stop
    proxy.started?.should be_false
  end

  def start_capture(proxy)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    proxy.started?.should be_true
    proxy.start_capture
  end

  def stop_capture(proxy)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    proxy.started?.should be_true
    proxy.stop_capture
  end

  def get_capture(proxy)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    proxy.started?.should be_true
    json_dot_object = proxy.get_capture
    $tracer.trace(json_dot_object.formatted_json)
    return json_dot_object
  end

  def set_capture_content(proxy, boolean)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    proxy.started?.should be_true
    proxy.set_capture_content(boolean)
  end

  def set_capture_headers(proxy, boolean)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    proxy.started?.should be_true
    proxy.set_capture_headers(boolean)
  end

  def set_user_agent_header(proxy, user_agent)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    proxy.started?.should be_true
    proxy.set_request_header("User-Agent", user_agent)
    #verify the user agent is set
  end

  # Adds a list of HTTP headers to requests.
  # === Parameters:
  # _http_header_string_array_:: an array of http header strings in the form of "<header_name>:<header_value>"
  def set_request_headers(proxy, header_array = [])
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    proxy.started?.should be_true
    header_array.length > 1
    proxy.set_request_headers(header_array)
  end

  # Remaps a DNS source hostname to target ip
  # === Parameters:
  # _source_: source hostname string
  # _target_: target ip string
  def set_dns_remap(proxy, source, target)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    proxy.started?.should be_true
    $proxy.set_dns_remap(source, target)
  end

  # Remaps an array of DNS source hostname to target ips
  # === Parameters:
  # _source_: source hostname string
  # _target_: target ip string
  # Array of _source_:_target_
  def set_dns_remaps(proxy, source_target_array)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    proxy.started?.should be_true
    proxy.set_dns_remaps(source_target_array)
  end

#Not yet supported as a stand alone function.  The clear dns cache function is currently only called in the set_dns_remaps.
  # def clear_dns(proxy)
  #   $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
  #   $tracer.report("Should #{__method__}.")
  #   proxy.started?.should be_true
  #   proxy.clear_dns_cache
  # end


end