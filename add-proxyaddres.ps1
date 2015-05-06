########################################################### 
# AUTHOR  : Rodrigo Fernandes - https://br.linkedin.com/in/rsgfernandes
# DATE    : 06-05-2015
########################################################### 

Import-Module activedirectory
$userou = 'OU=Organizational_Unit,DC=domain,DC=com,DC=br'
$newproxydomain = "@youroldoralternatedomain.com.br"
$defaultemailaddress = @yourdefaultdomain.com.br
$users = Get-ADUser -Filter * -SearchBase $userou -Properties SamAccountName, EmailAddress, ProxyAddresses
Foreach ($user in $users) {
	If (!$user.EmailAddress) {
		echo "$user nao possui endereco de email cadastrado no AD" > adiciona_proxyaddress.log
	}
	Else {
		Get-ADUser -Filter "SamAccountName -eq '$($user.samaccountname)'" -Properties * | Set-ADUser -Add @ {
			Proxyaddresses="SMTP:"+$user.EmailAddress.split('@')[0]+""+$newproxydomain
		}
	}
}