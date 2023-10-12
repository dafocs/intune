#Connect to Az Account with the Managed Identity
Connect-AzAccount -Identity

#Extract the access token from the AzAccount authentication context and use it to connect to Microsoft Graph
$token = (Get-AzAccessToken -ResourceTypeName MSGraph).token

$Headers = @{
    'Authorization' = $token
    "Content-Type"  = 'application/json'
}

#Variables:
$fromAddress = ""
$address = ""
$Body = "Dit is een test van de mail functionaliteit"

# The mail subject and it's message
$mailSubject = 'Untagged Autopilot Devices'
$Emailbody = @"

    There are untagged or wrongly tagged Autopilot devices:

    $($Body)

    Thanks,
    Nielskok.Tech Automation
"@

$params = @{
"URI"         = "https://graph.microsoft.com/v1.0/users/$fromAddress/sendMail"
"Method"      = "POST"
"Headers"     = $Headers
"ContentType" = 'application/json'
"Body" = (@{
    "message" = @{
        "subject" = $mailSubject
        "body"    = @{
            "contentType" = 'Text'
            "content"     = $Emailbody
        }
        "toRecipients" = @(
        @{
            "emailAddress" = @{
            "address" = $address
        }
        }
        )
    }}) | ConvertTo-JSON -Depth 10
}
Write-Output -Message 'Sending mail via Graph...'

Invoke-RestMethod @params -Verbose