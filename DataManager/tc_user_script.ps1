# Sample Powershell Script to utilize QADataManager web service
# Execute:  ./test.ps1

param(
    [Parameter(ValueFromRemainingArguments = $true)]
    $allArgs
)

$indexEmailPrefix =    $allArgs.indexof("-EmailPrefix") + 1
$indexEmailDomain =    $allArgs.indexof("-EmailDomain") + 1
$indexPurEnroll =      $allArgs.indexof("-PurEnroll") + 1
$indexPurActivate =    $allArgs.indexof("-PurActivate") + 1
$indexAddBillAddr =    $allArgs.indexof("-AddBillAddr") + 1
$indexAddShipAddr =    $allArgs.indexof("-AddShipAddr") + 1
$indexQuantity =       $allArgs.indexof("-Quantity") + 1

$emailPrefix = if ($indexEmailPrefix -lt $allArgs.Count -and !$allArgs[$indexEmailPrefix].startsWith("-")) {$allArgs[$indexEmailPrefix]} else {$null}
$emailDomain  = if ($indexEmailDomain  -lt $allArgs.Count -and !$allArgs[$indexEmailDomain ].startsWith("-")) {$allArgs[$indexEmailDomain ]} else {$null}
$purEnroll = if ($indexPurEnroll -lt $allArgs.Count -and !$allArgs[$indexPurEnroll].startsWith("-")) {$allArgs[$indexPurEnroll]} else {$null}
$purActivate = if ($indexPurActivate -lt $allArgs.Count -and !$allArgs[$indexPurActivate].startsWith("-")) {$allArgs[$indexPurActivate]} else {$null}
$addBillAddr = if ($indexAddBillAddr -lt $allArgs.Count -and !$allArgs[$indexAddBillAddr].startsWith("-")) {$allArgs[$indexAddBillAddr]} else {$null}
$addShipAddr = if ($indexAddShipAddr -lt $allArgs.Count -and !$allArgs[$indexAddShipAddr].startsWith("-")) {$allArgs[$indexAddShipAddr]} else {$null}
$quantity = if ($indexQuantity -lt $allArgs.Count -and !$allArgs[$indexQuantity].startsWith("-")) {$allArgs[$indexQuantity]} else {"1"}

$req_xml = [xml] (get-content ".\template_req.xml")

#Insert Quantity
$req_xml.SelectSingleNode("//request/quantity").innerText = $quantity
# Get a clone of an attribute
$attr_node = $req_xml.SelectSingleNode("//request/attributes/attribute").Clone()
# Remove all attributes
$req_xml.SelectSingleNode("//request/attributes").RemoveAll()

$attr_names = "EMAIL_PREFIX", "EMAIL_DOMAIN", "PUR_ENROLL", "PUR_ACTIVATE", "ADD_BILL_ADDR", "ADD_SHIP_ADDR"
$index = 0

foreach ($attr in $emailPrefix, $emailDomain, $purEnroll, $purActivate, $addBillAddr, $addShipAddr) {
  $attr_node = $attr_node.Clone()
  $attr_node.SelectSingleNode("name").InnerText = $attr_names[$index++]
  $attr_node.SelectSingleNode("values/value").InnerText = $attr
  $req_xml.SelectSingleNode("//request/attributes").appendChild($attr_node)
}

$UrlRoute = "http://GV1HQPAP03.babgsetc.pvt/AutomationDataManager/api/add_dcon_task"

function Execute-HTTPPost()
{
    param(
        [string] $url = $null,
        [string] $data = $null,
        [string] $contentType = "application/json",
        [string] $codePage = "UTF-8"
    )

    if ($url -and $data)
    {
        [System.Net.WebRequest]$webRequest = [System.Net.WebRequest]::Create($url);
        $webRequest.ContentType = $contentType
        $webRequest.Method = "POST";

        $enc = [System.Text.Encoding]::GetEncoding($codePage);
        [byte[]]$bytes = $enc.GetBytes($data);
        $webRequest.ContentLength = $bytes.Length;

        [System.IO.Stream]$reqStream = $webRequest.GetRequestStream();
        $reqStream.Write($bytes, 0, $bytes.Length);
        $reqStream.Flush();

        $resp = $webRequest.GetResponse();
        $rs = $resp.GetResponseStream();
        [System.IO.StreamReader]$sr = New-Object System.IO.StreamReader -argumentList $rs;
        $sr.ReadToEnd();
    }
}

try
{
   $Json = @"
   {
      "Command": "d-Con.bat",
      "Parameters": "./create_user_spec.rb --browser chrome --or --no_rdb",
      "Interface": "$($req_xml.OuterXml)"
   }
"@

    write-host $Json
    $resp = Execute-HTTPPost -url $UrlRoute -data $Json

    [System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")
    $ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer
    $obj = $ser.DeserializeObject($resp)
    write-host $obj.Result.Output
}
catch
{
    write-host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
    write-host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red

    exit 1
}

exit $obj.Result.ExitCode
