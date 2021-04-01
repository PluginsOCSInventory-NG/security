'----------------------------------------------------------
' Plugin for OCS Inventory NG 2.x
' Script :		Retrieve Ms Security Center informations
' Version :		2.01
' Date :		30/08/2012
' Author :		Nicolas DEROUET (nicolas.derouet[gmail]com)
' Contributor :	Stéphane PAUTREL (acb78.com)
'----------------------------------------------------------
' OS checked [X] on	32b	64b	(Professionnal edition)
'	Windows XP	[X]
'	Windows Vista	[X]	[X]
'	Windows 7	[X]	[X]
'	Windows 8.1	[X]	[X]	
'	Windows 10	[X]	[X]
'	Windows 2k8R2		[N]
'	Windows 2k12R2		[N]
'	Windows 2k16		[N]
' ---------------------------------------------------------
' NOTE : No checked on Windows 8
' ---------------------------------------------------------
On Error Resume Next
 
arrCat = Array("AntiVirus","Firewall","AntiSpyware")
arrNbr = Array(0,0,0)
 
Set objWMIService_AV = GetObject("winmgmts:\\.\root\SecurityCenter")
If Not IsNull (objWMIService_AV) Then
  For a = LBound(arrCat, 1) To UBound(arrCat, 1)
    Set colItems = objWMIService_AV.ExecQuery("Select * from " & arrCat(a) & "Product")
 
    For Each objAVP In colItems
        productEnabled = "0"
        If objAVP.onAccessScanningEnabled Then productEnabled = "1"
 
        productUptoDate = "0"
        If objAVP.productUptoDate Then productUptoDate = "1"
 
        writeXML "1", arrCat(a), objAVP.companyName, objAVP.displayName, objAVP.versionNumber, productEnabled, productUptoDate
        arrNbr(a) = arrNbr(a) + 1
    Next
  Next
End If
Set objWMIService_AV = Nothing
 
Set objWMIService_AV = GetObject("winmgmts:\\.\root\SecurityCenter2")
if Not IsNull (objWMIService_AV) Then
  For a = LBound(arrCat, 1) To UBound(arrCat, 1)
    Set colItems2 = objWMIService_AV.ExecQuery("Select * from " & arrCat(a) & "Product")
 
    For Each objAVP In colItems2
      Set WshShell = WScript.CreateObject("WScript.Shell")
      Set WshProcessEnv = WshShell.Environment("Process")
      exe = objAVP.PathToSignedProductExe
      exe = Replace(exe,"%ProgramFiles%",WshProcessEnv("ProgramFiles"))
      If Mid(exe,1,1) = """" Then
        Max = 2
        While (Mid(exe,Max,1) <> """") And (Max <> Len(exe) )
          Max = Max + 1
        Wend
        exe = Mid(exe,2,Max-2)
      End If
      exe = Replace(exe,"\","\\")
      strCompanyName = ""
      strVersionNumber = ""
      Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
      Set colFiles = objWMIService.ExecQuery ("Select * from CIM_Datafile Where name = '" & exe & "'")
      If colFiles.Count = 0 Then
        exe = Replace (exe," (x86)","")
        Set colFiles = objWMIService.ExecQuery ("Select * from CIM_Datafile Where name = '" & exe & "'")  
      End If
 
      For Each itemFile In colFiles
        strCompanyName = (itemFile.Manufacturer)
        strVersionNumber = (itemFile.Version)
      Next
 
      productEnabled = "0"
      If Mid(dec2bin(objAVP.ProductState),12,1) = "1" Then productEnabled = "1"
 
      productUptoDate = "0"
      If Mid(dec2bin(objAVP.ProductState),17,8) = "00000000" Then productUptoDate = "1"
 
      writeXML "2", arrCat(a), strCompanyName, objAVP.displayName, strVersionNumber, productEnabled, productUptoDate
      arrNbr(a) = arrNbr(a) + 1
    Next
  Next
End If
Set objWMIService_AV = Nothing
 
Sub writeXML(scSCV,scCat,scComp,scProd,scVer,scEna,scDate)
	Wscript.Echo _
		"<SECURITYCENTER>" & vbNewLine & _
		"<SCV>" & scSCV & "</SCV>" & vbNewLine & _
		"<CATEGORY>" & scCat & "</CATEGORY>" & vbNewLine & _
		"<COMPANY>" & scComp & "</COMPANY>" & vbNewLine & _
		"<PRODUCT>" & scProd & "</PRODUCT>" & vbNewLine & _
		"<VERSION>" & scVer & "</VERSION>" & vbNewLine & _
		"<ENABLED>" & scEna & "</ENABLED>" & vbNewLine & _
		"<UPTODATE>" & scDate & "</UPTODATE>" & vbNewLine & _
		"</SECURITYCENTER>"
End Sub
 
Function dec2bin (n)
    b = Trim((n Mod 2))
    n = n \ 2
    Do While n <> 0
        b = Trim((n Mod 2)) & b
        n = n \ 2
    Loop
    While Len(b) < 24
      b = "0" & b
    Wend
    dec2bin = b
End Function
