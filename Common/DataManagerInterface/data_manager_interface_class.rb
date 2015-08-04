# == Overview
# Support class for DmReqInterface class below
# If new elements are added to Data Manager request, add a corresponding method here
# To get content of an element within an Attribute, call relevant method e.g.) att.action, att.values
class Attribute
  # Initialize using attribute
  # === Parameters:
  # _attribute_:: an attribute in the request
  def initialize(attribute)
    @attribute = attribute
  end

  # Returns content of action element for this attribute
  def action
    @attribute.action.content
  end

  # Returns content of value elements as an array
  def values
    @attribute.values.collect {|val| val.content}
  end
end

# This class is used to simplify Data Manager access to an incoming request
class DataManagerReqInterface

  attr_reader :task_guid

  # Initialize using the json request to Data Manager
  # === Parameters:
  # _json_req: json request coming into Data Manager
  def initialize(json_req)
    message = JsonMessage.new(json_req,HttpBody::REQUEST)
    @task_guid = message.task_guid.content

    @json_obj = JsonMessage.new(message.interface.content,HttpBody::REQUEST)
    $tracer.trace("Request JSON : #{@json_obj.formatted_json}")
    @attributes = @json_obj.attributes
  end

  # The method_missing method is used to get an attribute via a dot mechanism e.g.) dm_req.HAS_CC to get the HAS_CC attribute
  # An exception is raised if attribute is not found
  # === Parameters:
  # _method_: attribute name
  # _arguments_: not used
  # _block_: not used.
  def method_missing(method_sym, *arguments, &block)
    attribute_name = method_sym.to_s
    att = @attributes.each {|a|
      break a if a.name.content == attribute_name
    }
    raise Exception.new("#{attribute_name} not found") unless att.class.to_s == 'HashToDotObjectConvertor'
    return Attribute.new(att)
  end

  # Returns content of quantity element
  def quantity
    @json_obj.quantity.content
  end

  def name
    @json_obj.name.content
  end
end

class DataManagerMail

  TABLE_STYLE_STR = <<-EOS
  <head>
  <style>
  h2{
      font-family:"Trebuchet MS",sans-serif;
      font-size:34px;
      font-style:normal;
      background-color:#f0f0f0;
      margin:40px 0px 30px -40px;
      padding:0px 40px;
      clear:both;
      float:left;
      width:100%;
      color:#aaa;
      text-shadow:1px 1px 1px #fff;
  }



  table.table1 {
      font-family: "Trebuchet MS", sans-serif;
      font-size: 16px;
      font-weight: bold;
      line-height: 1.4em;
      font-style: normal;
      border-collapse: separate;
  }
  .table1 thead th {
      padding: 15px;
      color: #fff;
      text-shadow: 1px 1px 1px #568F23;
      border: 1px solid #93CE37;
      border-bottom: 3px solid #9ED929;
      background-color: #9DD929;
      background: -webkit-gradient( linear, left bottom, left top, color-stop(0.02, rgb(123, 192, 67)), color-stop(0.51, rgb(139, 198, 66)), color-stop(0.87, rgb(158, 217, 41)));
      background: -moz-linear-gradient( center bottom, rgb(123, 192, 67) 2%, rgb(139, 198, 66) 51%, rgb(158, 217, 41) 87%);
      -webkit-border-top-left-radius: 5px;
      -webkit-border-top-right-radius: 5px;
      -moz-border-radius: 5px 5px 0px 0px;
      border-top-left-radius: 5px;
      border-top-right-radius: 5px;
  }
  .table1 thead th:empty {
      background: transparent;
      border: none;
  }
  .table1 tbody th {
      color: #fff;
      text-shadow: 1px 1px 1px #568F23;
      background-color: #9DD929;
      border: 1px solid #93CE37;
      border-right: 3px solid #9ED929;
      padding: 0px 10px;
      background: -webkit-gradient( linear, left bottom, right top, color-stop(0.02, rgb(158, 217, 41)), color-stop(0.51, rgb(139, 198, 66)), color-stop(0.87, rgb(123, 192, 67)));
      background: -moz-linear-gradient( left bottom, rgb(158, 217, 41) 2%, rgb(139, 198, 66) 51%, rgb(123, 192, 67) 87%);
      -moz-border-radius: 5px 0px 0px 5px;
      -webkit-border-top-left-radius: 5px;
      -webkit-border-bottom-left-radius: 5px;
      border-top-left-radius: 5px;
      border-bottom-left-radius: 5px;
  }
  .table1 tfoot td {
      color: #9CD009;
      font-size: 32px;
      text-align: center;
      padding: 10px 0px;
      text-shadow: 1px 1px 1px #444;
  }
  .table1 tfoot th {
      color: #666;
  }
  .table1 tbody td {
      padding: 10px;
      text-align: center;
      background-color: #DEF3CA;
      border: 2px solid #E7EFE0;
      -moz-border-radius: 2px;
      -webkit-border-radius: 2px;
      border-radius: 2px;
      color: #666;
      text-shadow: 1px 1px 1px #fff;
  }
  </style>
  </head>
  EOS

  def DataManagerMail.email_results_message(guid, title, array_of_hash_results = [])

    from_address = "QAAlerter@gsmail.babgsetc.pvt"

    address_list = $options.email_notify.to_s + ';'
    to_addresses = (email_parameter?) ? email_parameter : address_list

    body_array = []

    # NOTE: extra space and non-indenting is important
    message_header = <<-EOS
MIME-Version: 1.0
Content-Type: text/html
Subject: Data Manager results #{guid}, #{array_of_hash_results.length} items added

    EOS

    body_array << "<h2>#{title}</h2>"

    key_list = []
    array_of_hash_results.each do |h|
        h.each do |k,v|
          key_list << k
        end
    end

    body_array << "<table class='table1'>"
    # table header
    body_array << "<thead><tr><th scope='col'></th>"
    key_list.sort.uniq.each do |k|
      body_array << "<th scope='col'>#{k}</th>"
    end
    body_array << "</tr></thead>"

    # table body
    body_array << "<tbody>"
    array_of_hash_results.each_with_index do |h, count|
      body_array << "<tr><th scope='row'>#{count}</th>"
      key_list.sort.uniq.each { |k|
        body_array << "<td>#{h[k]}</td>"
      }
      body_array << "</tr>"
    end
    body_array << "</tbody>"
    body_array << "</table>"

    message = message_header + "\n" + TABLE_STYLE_STR + body_array.join + "\n"

    # email results  gsmail.babgsetc.pvt
    Net::SMTP.start($options.smtp_server) do |smtp|
      smtp.send_message message, from_address , to_addresses
    end

  end
end
