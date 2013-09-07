Imports Microsoft.Reporting.WebForms
Imports System
Imports System.IO
Imports System.Net.Mail
Imports AjaxControlToolkit
'Imports ReportServerNetworkCredentials

Partial Class Figs_ViewReport
    Inherits System.Web.UI.Page

    Dim gameID As Integer = 0
    Dim manuID As Integer = 0
    Dim typeID As Integer = 0
    Dim obtainedID As Boolean

    'So I only have to change it in one spot if I want to show different reports
    '(FiguresByYearByType is the other one)
    Dim reportName As String = "FiguresByGame"

    Dim exportPath As String = ""
    Dim exportFile As String = ""
    Dim exportFilePath As String = ""

    Dim resultStr As String = ""
    Dim emailResult_lit As New Literal

    Protected WithEvents client As SmtpClient

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        figs_rv.ServerReport.ReportPath = System.Configuration.ConfigurationManager.AppSettings("ReportPath") & reportName
        figs_rv.ServerReport.ReportServerUrl = New Uri(System.Configuration.ConfigurationManager.AppSettings("ReportURL"))

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            If Not Request.Path.Contains("Login.aspx") Then

                Session("FullTime") = Session.Timeout * 60
                Session("TotalSecondsRemaining") = (Session.Timeout - CInt(ConfigurationManager.AppSettings("AppWarnMinutes"))) * 60
                Session("MinutesRemaining") = Session.Timeout - CInt(ConfigurationManager.AppSettings("AppWarnMinutes"))

                Session("Visible") = True

                start_timer.Enabled = User.Identity.IsAuthenticated
            End If
        End If

        exportPath = Page.MapPath(".") & "\Reports\"

        emailResult_lit.ID = "emailResult_lit"

        If Session("ItemList") IsNot Nothing Then
            return_lbtn.Text = "Return to Generated List"
        Else
            return_lbtn.Text = "Return to List Generator"
        End If

        Try
            ' Adding each, to eliminate "0" values generated when adding all of them at once
            If gameID <> Nothing Then
                Dim gameRP() As ReportParameter = {New ReportParameter("Game", gameID, True)}
                If Not IsPostBack Then
                    figs_rv.ServerReport.SetParameters(gameRP)
                End If
            End If

            If manuID <> Nothing Then
                Dim manuRP() As ReportParameter = {New ReportParameter("Manufacturer", manuID, True)}
                If Not IsPostBack Then
                    figs_rv.ServerReport.SetParameters(manuRP)
                End If
            End If

            If typeID <> Nothing Then
                Dim typeRP() As ReportParameter = {New ReportParameter("Type", typeID, True)}
                If Not IsPostBack Then
                    figs_rv.ServerReport.SetParameters(typeRP)
                End If
            End If

            If obtainedID <> Nothing Then
                Dim obtainedRP() As ReportParameter = {New ReportParameter("Obtained", obtainedID, True)}
                If Not IsPostBack Then
                    figs_rv.ServerReport.SetParameters(obtainedRP)
                End If
            End If

        Catch ex As Exception
            Throw ex

        End Try

    End Sub

    Protected Sub configCountdown()

        Dim countdownStr As String = configZeroes(Session("MinutesRemaining")) & ":" & configZeroes(Session("TotalSecondsRemaining") Mod 60) & "</span>"

        Select Case Session("TotalSecondsRemaining")
            Case 0
                session_timer.Enabled = False
                timeout_mpExt.Hide()

                Response.Redirect(ConfigurationManager.AppSettings("AppLogoutURL"))
            Case 1 To 60
                Session("Visible") = IIf(Session("Visible") = False, True, False)
                timeout_lit.Text = "<p class='warningStyle'>Warning</p><p class='largerStyle'>Your session will expire in <span class='CountdownWarningStyle'" & IIf(Session("Visible") = False, " style='visibility:hidden;'>", ">") & countdownStr & "</span> due to inactivity.</p>"
            Case 61 To 119
                timeout_lit.Text = "<p class='warningStyle'>Warning</p><p class='largerStyle'>Your session will expire in <span class='CountdownWarningStyle'>" & countdownStr & "</span> due to inactivity.</p>"
            Case 120
                inlineTimeout_lit.Text = ""
                timeout_lit.Text = "<p class='warningStyle'>Warning</p><p class='largerStyle'>Your session will expire in <span class='CountdownWarningStyle'>" & countdownStr & "</span> due to inactivity.</p>"
                timeout_mpExt.Show()
            Case 121 To 300
                Session("Visible") = IIf(Session("Visible") = False, True, False)
                inlineTimeout_lit.Text = "Session timeout in:<br /><span class='CountdownWarningStyle'" & IIf(Session("Visible") = False, " style='visibility:hidden;'>", ">") & countdownStr
            Case Is > 300
                inlineTimeout_lit.Text = "Session timeout in:<br /><span class='CountdownStyle'>" & countdownStr & "</span>"

        End Select


    End Sub

    Public Function configZeroes(ByVal val As Integer) As String
        Return IIf(val < 10, "0" & val, val)
    End Function


    Protected Sub start_timer_Tick(ByVal sender As Object, ByVal e As System.EventArgs) Handles start_timer.Tick
        Session("FullTime") -= 1

        If Session("FullTime") = (Session.Timeout * 60) - (CInt(ConfigurationManager.AppSettings("AppWarnMinutes")) * 60) Then
            start_timer.Enabled = False

            configCountdown()
            session_timer.Enabled = True


        End If

    End Sub

    Protected Sub session_timer_Tick(ByVal sender As Object, ByVal e As System.EventArgs) Handles session_timer.Tick
        Session("TotalSecondsRemaining") -= 1

        If Session("TotalSecondsRemaining") Mod 60 = 59 Then
            Session("MinutesRemaining") -= 1
        End If

        configCountdown()

    End Sub

    Protected Sub return_lbtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles return_lbtn.Click
        Response.Redirect("Figs.aspx")
    End Sub


    Protected Sub menu_lbtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles menu_lbtn.Click
        Response.Redirect("Default.aspx")
    End Sub

    Protected Sub send_btn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles send_btn.Click

        client = New SmtpClient
        Dim msg As New MailMessage()
        Dim msgContent As String = ""
        Dim attachment As Attachment
        Dim recipient As String = email_txt.Text.Trim

        Try

            renderReport(formats_ddl.SelectedValue)

            msg.From = New MailAddress("maggy@zogglet.com")
            msg.To.Add(New MailAddress(recipient))
            msg.Subject = "Exported Report from Maggy's Halo Action Figure Tracker"

            msgContent = "<p>Hello.</p>" & _
                        "<p>Attached is your exported report: <b>" & exportFile & "</b>.</p> " & _
                        "<p>Sincerely, <br /><a href='http://www.zogglet.com'>Zogglet</a></p>"


            msg.Body = msgContent
            msg.IsBodyHtml = True

            attachment = New Attachment(exportFilePath)
            msg.Attachments.Add(attachment)

            client.SendAsync(msg, "Test")

            AddHandler client.SendCompleted, AddressOf sendComplete

        Catch ex As Exception
            Throw ex
        End Try



    End Sub

    Protected Sub sendComplete(ByVal sender As Object, ByVal e As System.ComponentModel.AsyncCompletedEventArgs) Handles client.SendCompleted

        If IsDBNull(e.Error) Then
            resultStr = "<span class='resultStyle'><p>Uh oh. Failure sending email.</p><p><b>Error details:</b> <br />" & e.Error.Message & "</p></span>"
        Else
            resultStr = "<span class='resultStyle'><p>Congratulations!</p><p>You've successfully sent the exported report, <b>" & exportFile & "</b>, to <b>" & email_txt.Text.Trim & "</b>.</p></span>"
        End If

        emailResult_lit.Text = resultStr
        sent_innerDiv.Controls.Add(emailResult_lit)

        ScriptManager.RegisterStartupScript(Page, Me.GetType(), "id", "function pageLoad(){$find('sent_mpExt_behavior').show();}", True)

    End Sub


    Protected Sub onOkClick(ByVal sender As Object, ByVal e As EventArgs)
        sent_mpExt.Hide()
    End Sub

    Protected Sub renderReport(ByVal format As String)

        Dim warnings As Warning() = Nothing
        Dim streamIDs As String() = Nothing
        Dim mimeType As String = Nothing
        Dim encoding As String = Nothing
        Dim ext As String = Nothing
        Dim bytes As Byte()

        bytes = figs_rv.ServerReport.Render(format, IIf(format = "IMAGE", "<DeviceInfo><OutputFormat>TIFF</OutputFormat></DeviceInfo>", Nothing), mimeType, encoding, ext, streamIDs, warnings)

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

        Dim fileStream As New FileStream(exportFilePath, FileMode.Create)
        fileStream.Write(bytes, 0, bytes.Length)
        fileStream.Close()

    End Sub

    Protected Sub qlMeth_click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("Methodology.aspx")
    End Sub

    Protected Sub qlAddNew_click(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("SelectedFig") = 0
        Response.Redirect("EditFig.aspx")
    End Sub

    Protected Sub qlList_click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("Figs.aspx")
    End Sub

    Protected Sub qlOther_click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("EditOthers.aspx")
    End Sub
End Class
