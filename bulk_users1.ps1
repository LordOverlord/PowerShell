# Import active directory module for running AD cmdlets
Import-Module activedirectory

#Call by LoadWithPartialName to generate a input box.
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

#Get date and time of the running of the script
$timestamp = Get-Date -Format "dd-MM-yyyy.HH:mm"

#count of elements procesed
$count = 0
#Adquire csv name
$csvname = [Microsoft.VisualBasic.Interaction]::InputBox("Nombre del CSV","Ingresa CSV") 

#Adquire Domain name
$domain = [Microsoft.VisualBasic.Interaction]::InputBox("Indica el dominio, ex: contoso.com","Ingresa Dominio")

#Store the data from ADUsers.csv in the $ADUsers variable
$ADUsers = Import-csv $csvname

#Loop through each row containing user details in the CSV file 
foreach ($User in $ADUsers)
{
    #Read user data from each field in each row and assign the data to a variable as below
        
    $Username   = $User.username
    $Password   = $User.password
    $Firstname  = $User.firstname
    $surname    = $User.surname
    $OU         = $User.ou #This field refers to the OU the user account is to be created in
    $email      = $User.email
    $streetaddress = $User.streetaddress
    $city       = $User.city
    $zipcode    = $User.zipcode
    $state      = $User.state
    $country    = $User.country
    $telephone  = $User.telephone
    $jobtitle   = $User.jobtitle
    $company    = $User.company
    $department = $User.department
    $Password = $User.Password
    $office = $User.office
    $Description = $User.Description


    #Check to see if the user already exists in AD
    if (Get-ADUser -F {SamAccountName -eq $Username})
    {
         #If user does exist, give a warning
         Write-Warning "A user account with username $Username already exist in Active Directory."
         Write-Output "The account $username exists" | Out-File -FilePath .\log.txt -Append
        $count = $count + 1
    }
    else
    {
        #User does not exist then proceed to create the new user account
        
        #Account will be created in the OU provided by the $OU variable read from the CSV file
        New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@$domain" `
            -Name "$Firstname $surname" `
            -GivenName $Firstname `
            -Surname $surname `
            -Enabled $True `
            -DisplayName "$Firstname $surname" `
            -Path $OU `
            -City $city `
            -Company $company `
            -State $state `
            -StreetAddress $streetaddress `
            -OfficePhone $telephone `
            -EmailAddress $email `
            -Title $jobtitle `
            -Department $department `
            -Office $office `
            -Description $Description `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force) -ChangePasswordAtLogon $True 
            Write-Output "The $username was created" | Out-File -FilePath .\log.txt -Append
            $count = $count + 1
            
    }
}
Write-Host "Alta Terminada, procesados $count"