Imports Microsoft.Reporting.WebForms
Imports System
Imports System.Net
Imports System.IO
Imports System.Net.Mail
Imports AjaxControlToolkit
Imports RS2005

Partial Class Figs_ViewReport2
    Inherits System.Web.UI.Page

    Dim gameID As Integer = 0
    Dim manuID As Integer = 0
    Dim typeID As Integer = 0
    Dim obtainedID As Boolean

    'So I only have to change it in one spot if I want to show different reports
    '(FiguresByYearByType is the other one)
    Dim reportName As String = "FiguresByGame"
    Dim reportPath As String = ""

    Dim exportPath As String = ""
    Dim exportFile As String = ""
    Dim exportFilePath As String = ""


    Dim rExecSvc As New RS2005.ReportExecutionService
    Dim rSvc As New RS2005.ReportingService2005


    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        exportPath = Page.MapPath(".") & "\Reports\"
        'rExecSvc.Credentials = System.Net.CredentialCache.DefaultCredentials
        rExecSvc.Credentials = New System.Net.NetworkCredential("zogglet_reportserver", "ajemehIrlwbX", "http://bamboo.arvixe.com/ReportServer_SQLEXPRESS")
        rSvc.Credentials = New System.Net.NetworkCredential("maggy", "ajemehIrlwbX", "http://bamboo.arvixe.com/ReportServer_SQLEXPRESS")
        'rSvc.Credentials = System.Net.CredentialCache.DefaultCredentials
    End Sub



    'Renders a report
    'Protected Function getXMLReport() As String

    '    Dim result As Byte() = Nothing
    '    Dim encoding = "", mimeType = "", ext As String = ""
    '    Dim warnings() As RS2005.Warning = Nothing
    '    Dim streamIDs() As String = Nothing

    '    exportPath = Page.MapPath(".") & "\Reports\"

    '    reportPath = System.Configuration.ConfigurationManager.AppSettings("ReportPath") & reportName


    '    Try
    '        rExecSvc.LoadReport(reportPath, Nothing)

    '        result = rExecSvc.Render("XML", Nothing, ext, encoding, mimeType, warnings, streamIDs)
    '        Return System.Text.Encoding.ASCII.GetString(result)

    '    Catch ex As Exception
    '        Return ex.Message
    '    End Try

    'End Function


    Protected Sub genReport_btn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles genReport_btn.Click

        Dim doc As System.Xml.XmlDocument = New System.Xml.XmlDocument()
        Dim reportDef As Byte() = rSvc.GetReportDefinition(System.Configuration.ConfigurationManager.AppSettings("ReportPath") & reportName)

        Dim stream As MemoryStream = New MemoryStream(reportDef)
        doc.Load(stream)
        doc.Save(exportPath & "FiguresByGame.rdl")

    End Sub
End Class
