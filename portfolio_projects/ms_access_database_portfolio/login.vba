Private Sub Command18_Click()
    Dim UserLevel As String

    ' Check if username is empty
    If IsNull(Me.txtusername) Or Me.txtusername = "" Then
        MsgBox "Please enter the username.", vbInformation, "Username Required"
        Me.txtusername.SetFocus
        Exit Sub

    ' Check if password is empty
    ElseIf IsNull(Me.txtPassword) Or Me.txtPassword = "" Then
        MsgBox "Please enter the password.", vbInformation, "Password Required"
        Me.txtPassword.SetFocus
        Exit Sub

    Else
        ' Check if both username and password match a record
        If IsNull(DLookup("UserID", "UserAccount", "UserName='" & Replace(Me.txtusername, "'", "''") & "' AND Password='" & Replace(Me.txtPassword, "'", "''") & "'")) Then
            MsgBox "Username or password is incorrect!", vbCritical, "Login Denied"
            Me.txtusername = ""
            Me.txtPassword = ""
            Me.txtusername.SetFocus
            Exit Sub
        Else
            ' Get the user's security level
            UserLevel = DLookup("SecurityLevel", "UserAccount", "UserName='" & Replace(Me.txtusername, "'", "''") & "'")

            ' Handle access based on security level
            If UserLevel = "User" Then
                MsgBox "Access granted. You may proceed!", vbInformation, "Authorization Succeeded"
                DoCmd.OpenTable "EmployeeData"

            ElseIf UserLevel = "Admin" Then
                MsgBox "Admin access granted.", vbInformation, "Admin Login"
                DoCmd.OpenTable "Admin"

            Else
                MsgBox "Unknown access level.", vbExclamation, "Access Level Error"
            End If

            ' Close login form without saving design changes
            DoCmd.Close acForm, Me.Name, acSaveNo
        End If
    End If
End Sub

