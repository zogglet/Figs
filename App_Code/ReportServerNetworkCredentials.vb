Imports Microsoft.VisualBasic
Imports Microsoft.Reporting.WebForms
Imports Microsoft.Reporting
Imports System.Collections.Generic
Imports System.Security.Principal

Public Class ReportServerNetworkCredentials
    Implements IReportServerCredentials

    Private _userName As String
    Private _pswd As String
    Private _domain As String

    Public Sub New(ByVal userName As String, ByVal password As String, ByVal domain As String)
        _userName = userName
        _pswd = password
        _domain = domain

    End Sub

    Public Function GetFormsCredentials(ByRef authCookie As System.Net.Cookie, ByRef userName As String, ByRef password As String, ByRef authority As String) As Boolean Implements Microsoft.Reporting.WebForms.IReportServerCredentials.GetFormsCredentials
        userName = _userName
        password = _pswd
        authority = _domain

    End Function

    Public ReadOnly Property ImpersonationUser() As System.Security.Principal.WindowsIdentity Implements Microsoft.Reporting.WebForms.IReportServerCredentials.ImpersonationUser
        Get
            Return Nothing
        End Get
    End Property

    'If using these private variables don't work, use references to Configuration.AppSettings 
    '(ref: http://forums.asp.net/t/1573548.aspx/1?How+to+call+MyReport+by+URL)
    Public ReadOnly Property NetworkCredentials() As System.Net.ICredentials Implements Microsoft.Reporting.WebForms.IReportServerCredentials.NetworkCredentials
        Get
            Return New Net.NetworkCredential(_userName, _pswd, _domain)
        End Get
    End Property
End Class
