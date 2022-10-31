### PROD region start ###
$storagePath = './'
$location = 'LocationName'
$cameraIP = '<CAMERA_IP>'
$cameraPort = '<CAMERA_PORT>'
### PROD region end ###

$destinationPath = Join-Path -Path $storagePath -ChildPath $location

#camera authentication block
$user = '<camera_user>'
$pass = '<camera_pass>'

#$nonAuthTemplate = "http://<IP>:<PORT>/ISAPI/Streaming/channels/1/picture"
$snapshotURL = 'http://' + $cameraIP +':' + $cameraPort + '/ISAPI/Streaming/channels/1/picture'

$counter = 0;
#do {
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
        $pair = "$($user):$($pass)"
        $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))

        $basicAuthValue = "Basic $encodedCreds"

        $Headers = @{
            Authorization = $basicAuthValue
        }

		Invoke-WebRequest -Uri $snapshotURL -Headers $Headers -OutFile $destinationFile
		
		if(Test-Path ($destinationFile)) {
			Write-Host (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $location '<OK> Image downloaded'
		}
		else {
			 Write-Host (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $location '<ERROR> Image not downloaded'
		}
		#Start-Sleep -Seconds 299
	}
	catch {
		$message = $_
		Write-Host (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $location '<ERROR>' $message
		#Start-Sleep -Seconds 279
		
	}
#} while($true)