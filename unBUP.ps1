#Requirements:
#7zip
#xor.exe
#PowerShell Community Extensions (PSCX) - http://pscx.codeplex.com/
#
#You will need BUPs folder; store your BUPs there...
#
#Reference:
#http://blog.opensecurityresearch.com/2012/07/unbup-mcafee-bup-extractor-for-linux.html
#
param(
   [string] $bupname = ""
   )
   
if ($bupname -ne "") {
  	Get-ChildItem $bupname | % {$_.BaseName} -OutVariable +uniqname
	7z e $bupname -o"$uniqname"
	xor .\$uniqname\Details .\$uniqname\Details.txt 0x6A
	xor .\$uniqname\File_0 .\$uniqname\file.exe 0x6A
	Rename-Item -Path .\$uniqname\Details.txt -NewName "$uniqname-BUP-details.txt"
	Get-Hash .\$uniqname\File.exe | Select-String -pattern "[a-f0-9]{32}" -OutVariable +hash
	Rename-Item -path .\$uniqname\File.exe -newname ".\$uniqname\$hash.ex_"
	Remove-Item .\$uniqname\Details
	Remove-Item .\$uniqname\File_0
	Move-Item $bupname C:\BUPsArchive
	Move-Item .\$uniqname C:\BUPsExtract\$uniqname\
	Remove-Variable -ErrorAction SilentlyContinue -Name Blah
} else{
  write-host "Error, no input file specified"
}