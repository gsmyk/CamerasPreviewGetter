### PROD region start ###
$storagePath = './'
$location = 'location_name'
$cameraIP = '<camera_ip>'
$cameraPort = '<camera_port>'
### PROD region end ###

$destinationPath = Join-Path -Path $storagePath -ChildPath $location

#camera authentication block
$user = '<user_name>'
$pass = '<user_pass>'

#$nonAuthTemplate = "http://<IP>:<PORT>/ISAPI/Streaming/channels/1/picture"
$snapshotURL = 'http://' + $cameraIP +':' + $cameraPort + '/cgi-bin/snapshot.cgi?stream=1'

$counter = 0;
do {
    #daily path block
    $dateInfo  = Get-Date -Format 'yyyy-MM-dd'
    $dailyPath = Join-Path -Path $destinationPath -ChildPath $dateInfo

    if (! (Test-Path ($dailyPath))) {
        New-Item -Path $destinationPath -ItemType Directory -Name $dateInfo
    }
	

    #file Name block
    $fileName = Get-Date -Format 'yyyyMMddHHmmss'
    $destinationFile = Join-Path -Path $dailyPath -ChildPath ($fileName + '.jpg')

	Write-Host (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $location
	
	try {
        #basic authentication request
        #$pair = "$($user):$($pass)"
        #$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))

        #$basicAuthValue = "Basic $encodedCreds"

        #$Headers = @{
        #    Authorization = $basicAuthValue
        #}

		Invoke-WebRequest -Uri $snapshotURL -OutFile $destinationFile
		
		if(Test-Path ($destinationFile)) {
			Write-Host (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $location '<OK> Image downloaded'
		}
		else {
			 Write-Host (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $location '<ERROR> Image not downloaded'
		}
		Start-Sleep -Seconds 119
	}
	catch {
		$message = $_
		Write-Host (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $location '<ERROR>' $message
		#Start-Sleep -Seconds 279
		
	}
} while($true)