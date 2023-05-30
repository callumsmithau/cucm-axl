if ($cred -eq $null) {$cred = Get-Credential}

function SOAP {
param ([Parameter (Mandatory)][String]$LineGroup)
[System.Net.ServicePointManager]::ServerCertificateValidationCallback ={$TRUE}

$axl =@"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/12.5">
   <soapenv:Header/>
   <soapenv:Body>
      <ns:getLineGroup sequence="?">
         <!--You have a CHOICE of the next 2 items at this level-->
         <name>$LineGroup</name>
         <!--Optional:-->
         <returnedTags uuid="?">
            <!--Optional:-->
            <distributionAlgorithm>?</distributionAlgorithm>
            <!--Optional:-->
            <rnaReversionTimeOut>?</rnaReversionTimeOut>
            <!--Optional:-->
            <huntAlgorithmNoAnswer>?</huntAlgorithmNoAnswer>
            <!--Optional:-->
            <huntAlgorithmBusy>?</huntAlgorithmBusy>
            <!--Optional:-->
            <huntAlgorithmNotAvailable>?</huntAlgorithmNotAvailable>
            <!--Optional:-->
            <members>
               <!--Zero or more repetitions:-->
               <member uuid="?">
                  <!--Optional:-->
                  <lineSelectionOrder>?</lineSelectionOrder>
                  <!--Optional:-->
                  <directoryNumber uuid="?">
                     <!--Optional:-->
                     <pattern>?</pattern>
                     <!--Optional:-->
                     <routePartitionName uuid="?">?</routePartitionName>
                  </directoryNumber>
               </member>
            </members>
            <!--Optional:-->
            <name>?</name>
            <!--Optional:-->
            <autoLogOffHunt>?</autoLogOffHunt>
         </returnedTags>
      </ns:getLineGroup>
   </soapenv:Body>
</soapenv:Envelope>
"@

$ResultLG = Invoke-WebRequest -ContentType "text/xml;charset=UTF-8" -Headers @{SOAPAction="CUCM:DBver=12.5"; Accept="Accept: text/"} -Body $axl -Uri https://192.168.1.70:8443/axl/ -Method Post -Credential $cred
$xmlContentLG = [xml]$ResultLG.Content
return $xmlContentLG. Envelope.Body.GetLineGroupResponse.return.linegroup.members.member.directorynumber.pattern


}


SOAP -LineGroup "LG IT Helpdesk"
