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

#Aquire propertie
$propertie = [Microsoft.VisualBasic.Interaction]::InputBox("Indica la propiedad a modificar","Indica Propiedad")
#Adquire value of the propertie
$valuep = [Microsoft.VisualBasic.Interaction]::InputBox("indica el valor de la propiedad","Indica Valor")
#Store the data from ADUsers.csv in the $ADUsers variable
$ADUsers = Import-csv $csvname

#Loop through each row containing user details in the CSV file 
foreach ($User in $ADUsers)
{
    #Read user data from each field in each row and assign the data to a variable as below
        
    $Username   = $User.SamAccountName

    #Check to see if the user already have homepage set
    if (Get-ADUser -Identity $username -Properties *| where-object { $_.$propertie -ne $null})
    {
         #If user do have homepage set a warning
         Write-Warning "the user $Username already have a homepage"
        $count = $count + 1
    }
    else
    {
        #User does not have a homepage
        
        #will set a home page
        Set-ADUser -Identity $username -$propertie $valuep
        $count = $count + 1
            
    }
}
Write-Host "Alta Terminada, procesados $count"