'Imports ReportExecution2005_VS2005
'Imports ReportService2005_VS2005
Imports System.IO
Imports Microsoft.Reporting.WebForms


Partial Class GenReport
    Inherits System.Web.UI.Page

    'Dim rExecSvc As New ReportExecution2005_VS2005.ReportExecutionService
    'Dim rSvc As New ReportService2005_VS2005.ReportingService2005

    Dim gameID As Integer = 0
    Dim manuID As Integer = 0
    Dim typeID As Integer = 0
    Dim obtainedID As Boolean

    Dim reportPath As String = ""
    Dim reportUrl As String = ""
    Dim reportName As String = "FiguresByYearByType"
    Dim exportPath As String = ""
    Dim exportFile As String = ""
    Dim exportFilePath As String = ""

    Dim rv As ReportViewer


    'Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
    '    reportPath = System.Configuration.ConfigurationManager.AppSettings("ReportPath") & reportName
    '    reportUrl = System.Configuration.ConfigurationManager.AppSettings("ReportURL")

    '    exportPath = Page.MapPath(".") & "\Reports\"



    'End Sub

    'Protected Sub genReport_btn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles genReport_btn.Click


    '    renderReport(formats_ddl.SelectedValue)

    'End Sub

    'Protected Sub renderReport(ByVal format As String)
    '    Dim warnings As ReportExecution2005_VS2005.Warning() = Nothing
    '    Dim streamIDs As String() = Nothing
    '    Dim mimeType As String = Nothing
    '    Dim encoding As String = Nothing
    '    Dim ext As String = Nothing
    '    Dim bytes As Byte()

    '    rSvc.Credentials = System.Net.CredentialCache.DefaultCredentials
    '    rExecSvc.Credentials = System.Net.CredentialCache.DefaultCredentials

    '    rSvc.Url = "http://reporting:666/ReportService2005.asmx"
    '    rExecSvc.Url = "http://reporting:666/ReportExecution2005.asmx"

    '    Dim info As ReportExecution2005_VS2005.ExecutionInfo = rExecSvc.LoadReport(reportUrl & reportPath, Nothing)

    '    'Dim reportDef As Byte() = rSvc.GetReportDefinition(System.Configuration.ConfigurationManager.AppSettings("ReportPath") & reportName)

    '    bytes = rExecSvc.Render(format, IIf(format = "IMAGE", "<DeviceInfo><OutputFormat>TIFF</OutputFormat></DeviceInfo>", Nothing), ext, mimeType, encoding, warnings, streamIDs)

    '    Select Case format
    '        Case "EXCEL"
    '            exportFile = reportName & ".xls"
    '        Case "PDF"
    '            exportFile = reportName & ".pdf"
    '        Case "IMAGE"
    '            exportFile = reportName & ".tif"
    '    End Select

    '    exportFilePath = exportPath & exportFile

    '    If File.Exists(exportFilePath) Then
    '        File.Delete(exportFilePath)
    '    End If

    '    Dim fstream As New FileStream(exportFilePath, FileMode.Create)
    '    fstream.Write(bytes, 0, bytes.Length)
    '    fstream.Close()
    'End Sub

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        rv = New ReportViewer()

        rv.ServerReport.ReportPath = System.Configuration.ConfigurationManager.AppSettings("ReportPath") & reportName
        rv.ServerReport.ReportServerUrl = New Uri(System.Configuration.ConfigurationManager.AppSettings("ReportURL"))

        exportPath = Page.MapPath(".") & "\Reports\"

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            ' Adding each, to eliminate "0" values generated when adding all of them at once
            If gameID <> Nothing Then
                Dim gameRP() As ReportParameter = {New ReportParameter("Game", gameID, True)}
                If Not IsPostBack Then
                    rv.ServerReport.SetParameters(gameRP)
                End If
            End If

            If manuID <> Nothing Then
                Dim manuRP() As ReportParameter = {New ReportParameter("Manufacturer", manuID, True)}
                If Not IsPostBack Then
                    rv.ServerReport.SetParameters(manuRP)
                End If
            End If

            If typeID <> Nothing Then
                Dim typeRP() As ReportParameter = {New ReportParameter("Type", typeID, True)}
                If Not IsPostBack Then
                    rv.ServerReport.SetParameters(typeRP)
                End If
            End If

            If obtainedID <> Nothing Then
                Dim obtainedRP() As ReportParameter = {New ReportParameter("Obtained", obtainedID, True)}
                If Not IsPostBack Then
                    rv.ServerReport.SetParameters(obtainedRP)
                End If
            End If
        Catch ex As Exception

        End Try

    End Sub

    Protected Sub return_lbtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles return_lbtn.Click
        Response.Redirect("Figs.aspx")
    End Sub

    Protected Sub menu_lbtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles menu_lbtn.Click
        Response.Redirect("Default.aspx")
    End Sub

    Protected Sub renderReport(ByVal format As String)
        Dim warnings As Warning() = Nothing
        Dim streamIDs As String() = Nothing
        Dim mimeType As String = Nothing
        Dim encoding As String = Nothing
        Dim ext As String = Nothing
        Dim bytes As Byte()

        bytes = rv.ServerReport.Render(format, IIf(format = "IMAGE", "<DeviceInfo><OutputFormat>TIFF</OutputFormat></DeviceInfo>", Nothing), mimeType, encoding, ext, streamIDs, warnings)

        Select Case format
            Case "EXCEL"
                exportFile = reportName & ".xls"
            Case "PDF"
                exportFile = reportName & ".pdf"
            Case "IMAGE"
                exportFile = reportName & ".tif"
        End Select

        exportFilePath = exportPath & exportFile

        If File.Exists(exportFilePath) Then
            File.Delete(exportFilePath)
        End If

        Dim filestream As New FileStream(exportFilePath, FileMode.Create)
        filestream.Write(bytes, 0, bytes.Length)
        filestream.Close()
    End Sub

    Protected Sub genReport_btn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles genReport_btn.Click
        renderReport(formats_ddl.SelectedValue)
    End Sub
End Class
