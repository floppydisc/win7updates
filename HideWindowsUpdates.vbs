'// Inspired by Colin Bowern: http://serverfault.com/a/341318
If Wscript.Arguments.Count < 1 Then
    WScript.Echo "Syntax: HideWindowsUpdates.vbs [KB1] [KB2] ..." & vbCRLF & _
        " - Example1: HideWindowsUpdates.vbs 3035583" & vbCRLF & _
        " - Example2: HideWindowsUpdates.vbs 3035583 3012973"
    WScript.Quit 1
End If

Dim objArgs
Set objArgs = Wscript.Arguments
Dim updateSession, updateSearcher
Set updateSession = CreateObject("Microsoft.Update.Session")
Set updateSearcher = updateSession.CreateUpdateSearcher()

'Wscript.StdOut.Write "Searching for pending updates..." 
Dim searchResult
Set searchResult = updateSearcher.Search("IsInstalled=0")

Dim update, kbArticleId, index, index2

'WScript.StdOut.Echo CStr(searchResult.Updates.Count) & " found."
For index = 0 To searchResult.Updates.Count - 1
    Set update = searchResult.Updates.Item(index)
    For index2 = 0 To update.KBArticleIDs.Count - 1
        kbArticleId = update.KBArticleIDs(index2)
'		WScript.Echo index2 & " " & kbArticleId
        For Each hotfixId in objArgs
            If kbArticleId = hotfixId Then
                If update.IsHidden = False Then
                    WScript.Echo "Verstecke: " & update.Title
                    update.IsHidden = True
                Else
                    WScript.Echo "Bereits versteckt: " & update.Title
                End If          
            End If
        Next

    Next
Next