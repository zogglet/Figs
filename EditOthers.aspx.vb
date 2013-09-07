Imports System.Data
Imports System.Data.SqlClient


Partial Class EditOthers
    Inherits System.Web.UI.Page

    Dim oConn As New SqlConnection(ConfigurationManager.ConnectionStrings("FigsConnectionString").ConnectionString)
    Dim oCmd As New SqlCommand
    Dim oParam As SqlParameter
    Dim oDA As New SqlDataAdapter
    Dim oDTbl As New DataTable
    Dim strSQL As String = ""
    Dim msgScript As String = ""

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            If Not Request.Path.Contains("Login.aspx") Then
                Session("FullTime") = Session.Timeout * 60
                Session("TotalSecondsRemaining") = (Session.Timeout - CInt(ConfigurationManager.AppSettings("AppWarnMinutes"))) * 60
                Session("MinutesRemaining") = Session.Timeout - CInt(ConfigurationManager.AppSettings("AppWarnMinutes"))

                Session("Visible") = True

                start_timer.Enabled = User.Identity.IsAuthenticated
            End If


            bindDDL(manu_ddl)
            bindDDL(type_ddl)
            bindDDL(game_ddl)

            configElements(manuPrompt_lit, manu_formView, True)
            configElements(typePrompt_lit, type_formView, True)
            configElements(gamePrompt_lit, game_formView, True)

            manuPrompt_lit.Text = "<span class='FVIndicatorStyle'>Select a manufacturer to edit, or add a new one.</span>"
            typePrompt_lit.Text = "<span class='FVIndicatorStyle'>Select an item type to edit, or add a new one.</span>"
            gamePrompt_lit.Text = "<span class='FVIndicatorStyle'>Select a game to edit, or add a new one.</span>"

        End If

        Session("FromInserted") = Nothing
        Session("FromUpdated") = Nothing
        Session("FromDeleted") = Nothing
        Session("RecentItem") = Nothing

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

    Protected Sub bindDDL(ByVal ddl As DropDownList, Optional ByVal value As Integer = -2)

        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text


            Select Case ddl.ID
                Case "manu_ddl"
                    strSQL = "SELECT ID, Name FROM Manufacturer UNION SELECT -2 AS ID, '--Select Manufacturer--' AS Name UNION SELECT -1 AS ID, 'ADD NEW' AS Name"
                Case "type_ddl"
                    strSQL = "SELECT ID, TypeName FROM ItemType UNION SELECT -2 AS ID, '--Select Item Type--' AS TypeName UNION SELECT -1 AS ID, 'ADD NEW' AS TypeName"
                Case "game_ddl"
                    strSQL = "SELECT ID, Title FROM Game UNION SELECT -2 AS ID, '--Select Game--' AS Title UNION SELECT -1 AS ID, 'ADD NEW' AS Title"
            End Select
            strSQL &= " ORDER BY ID"

            oCmd.Parameters.Clear()
            oDTbl.Clear()

            oCmd.CommandText = strSQL
            oDA.SelectCommand = oCmd

            oDA.Fill(oDTbl)

            ddl.DataSource = oDTbl
            ddl.DataBind()

            ddl.SelectedValue = value

        Catch ex As Exception
            Throw ex
        Finally
            If oConn.State = ConnectionState.Open Then
                oConn.Close()
            End If
            oCmd.Dispose()
        End Try

    End Sub


    Protected Sub configElements(ByVal lit As Literal, ByVal fv As FormView, ByVal promptShown As Boolean)
        lit.Visible = promptShown
        fv.Visible = Not promptShown
    End Sub


    Protected Sub game_formView_ItemCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewCommandEventArgs) Handles game_formView.ItemCommand
        If e.CommandName = "Cancel" Then
            configElements(gamePrompt_lit, game_formView, True)
            bindDDL(game_ddl)
        End If
    End Sub

    Protected Sub type_formView_ItemCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewCommandEventArgs) Handles type_formView.ItemCommand
        If e.CommandName = "Cancel" Then
            configElements(typePrompt_lit, type_formView, True)
            bindDDL(type_ddl)
        End If
    End Sub


    Protected Sub game_formView_ItemDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewDeletedEventArgs) Handles game_formView.ItemDeleted
        Session("FromDeleted") = True
        Session("RecentItem") = e.Values("Title")

        configElements(gamePrompt_lit, game_formView, True)

        Session("SelectedGame") = Nothing

        bindDDL(game_ddl)

        showChangedResult("game", "deleted")
    End Sub


    Protected Sub game_formView_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles game_formView.ItemInserted
        Session("FromInserted") = True
        Session("RecentItem") = e.Values("Title")

        game_formView.ChangeMode(FormViewMode.ReadOnly)

        bindDDL(game_ddl, Session("SelectedGame"))
    End Sub

    Protected Sub game_formView_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles game_formView.ItemUpdated
        Session("FromUpdated") = True
        Session("RecentItem") = e.NewValues("Title")

        game_formView.ChangeMode(FormViewMode.ReadOnly)

        bindDDL(game_ddl, Session("SelectedGame"))
    End Sub


    Protected Sub game_sds_Inserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles game_sds.Inserted
        Session("SelectedGame") = CType(e.Command.Parameters("@NewID").Value, Integer)
    End Sub

    Protected Sub type_formView_ItemDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewDeletedEventArgs) Handles type_formView.ItemDeleted
        Session("FromDeleted") = True
        Session("RecentItem") = e.Values("TypeName")

        configElements(typePrompt_lit, type_formView, True)

        Session("SelectedType") = Nothing

        bindDDL(type_ddl)

        showChangedResult("item type", "deleted")
    End Sub


    Protected Sub type_formView_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles type_formView.ItemInserted
        Session("FromInserted") = True
        Session("RecentItem") = e.Values("TypeName")

        type_formView.ChangeMode(FormViewMode.ReadOnly)

        bindDDL(type_ddl, Session("SelectedType"))
    End Sub


    Protected Sub type_formView_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles type_formView.ItemUpdated
        Session("FromUpdated") = True
        Session("RecentItem") = e.NewValues("TypeName")

        type_formView.ChangeMode(FormViewMode.ReadOnly)

        bindDDL(type_ddl, Session("SelectedType"))
    End Sub


    Protected Sub type_sds_Inserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles type_sds.Inserted
        Session("SelectedType") = CType(e.Command.Parameters("@NewID").Value, Integer)
    End Sub


    Protected Sub manu_formView_ItemCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewCommandEventArgs) Handles manu_formView.ItemCommand
        If e.CommandName = "Cancel" Then
            configElements(manuPrompt_lit, manu_formView, True)
            bindDDL(manu_ddl)
        End If
    End Sub


    Protected Sub manu_formView_ItemDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewDeletedEventArgs) Handles manu_formView.ItemDeleted
        'In case I want to implement a modal popup
        Session("FromDeleted") = True
        Session("RecentItem") = e.Values("Name")

        configElements(manuPrompt_lit, manu_formView, True)

        Session("SelectedManufacturer") = Nothing

        bindDDL(manu_ddl)

        showChangedResult("manufacturer", "deleted")

    End Sub


    Protected Sub manu_formView_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles manu_formView.ItemInserted
        Session("FromInserted") = True
        Session("RecentItem") = e.Values("Name")

        manu_formView.ChangeMode(FormViewMode.ReadOnly)

        bindDDL(manu_ddl, Session("SelectedManufacturer"))

    End Sub

    Protected Sub manu_formView_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles manu_formView.ItemUpdated
        Session("FromUpdated") = True
        Session("RecentItem") = e.NewValues("Name")

        manu_formView.ChangeMode(FormViewMode.ReadOnly)

        bindDDL(manu_ddl, Session("SelectedManufacturer"))
    End Sub

    Protected Sub manu_sds_Inserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles manu_sds.Inserted
        Session("SelectedManufacturer") = CType(e.Command.Parameters("@NewID").Value, Integer)
    End Sub



    Protected Sub type_ddl_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles type_ddl.SelectedIndexChanged
        Select Case type_ddl.SelectedValue
            Case -1
                type_formView.ChangeMode(FormViewMode.Insert)
            Case -2
                Session("SelectedType") = Nothing
            Case Else
                Session("SelectedType") = type_ddl.SelectedValue
                type_formView.ChangeMode(FormViewMode.ReadOnly)
        End Select
        type_formView.Visible = (type_ddl.SelectedValue <> -2)
        typePrompt_lit.Visible = (type_ddl.SelectedValue = -2)
    End Sub

    Protected Sub manu_ddl_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles manu_ddl.SelectedIndexChanged
        Select Case manu_ddl.SelectedValue
            Case -1
                manu_formView.ChangeMode(FormViewMode.Insert)
            Case -2
                Session("SelectedManufacturer") = Nothing
            Case Else
                Session("SelectedManufacturer") = manu_ddl.SelectedValue
                manu_formView.ChangeMode(FormViewMode.ReadOnly)
        End Select
        manu_formView.Visible = (manu_ddl.SelectedValue <> -2)
        manuPrompt_lit.Visible = (manu_ddl.SelectedValue = -2)
    End Sub


    Protected Sub game_ddl_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles game_ddl.SelectedIndexChanged
        Select Case game_ddl.SelectedValue
            Case -1
                game_formView.ChangeMode(FormViewMode.Insert)
            Case -2
                Session("SelectedGame") = Nothing
            Case Else
                Session("SelectedGame") = game_ddl.SelectedValue
                game_formView.ChangeMode(FormViewMode.ReadOnly)
        End Select
        game_formView.Visible = (game_ddl.SelectedValue <> -2)
        gamePrompt_lit.Visible = (game_ddl.SelectedValue = -2)
    End Sub


    Protected Sub manu_formView_ModeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles manu_formView.ModeChanged

        If manu_formView.DefaultMode = FormViewMode.ReadOnly Then
            If Session("FromUpdated") Then
                showChangedResult("manufacturer", "updated")
                Session("FromUpdated") = Nothing
            ElseIf Session("FromInserted") Then
                showChangedResult("manufacturer", "inserted")
                Session("FromInserted") = Nothing
            End If
        End If
    End Sub

    Protected Sub type_formView_ModeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles type_formView.ModeChanged
        If type_formView.DefaultMode = FormViewMode.ReadOnly Then
            If Session("FromUpdated") Then
                showChangedResult("item type", "updated")
                Session("FromUpdated") = Nothing
            ElseIf Session("FromInserted") Then
                showChangedResult("item type", "inserted")
                Session("FromInserted") = Nothing
            End If
        End If
    End Sub

    Protected Sub game_formView_ModeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles game_formView.ModeChanged
        If game_formView.DefaultMode = FormViewMode.ReadOnly Then
            If Session("FromUpdated") Then
                showChangedResult("game", "updated")
                Session("FromUpdated") = Nothing
            ElseIf Session("FromInserted") Then
                showChangedResult("game", "inserted")
                Session("FromInserted") = Nothing
            End If
        End If
    End Sub

    Protected Sub showChangedResult(ByVal item As String, ByVal change As String)
        changed_lit.Text = "<h4>Success</h4><span class='resultStyle'><p>You've " & change & " the " & item & ", <b>" & Session("RecentItem") & "</b>" & IIf(change = "deleted", ", from the database", IIf(change = "inserted", ", into the database", "")) & ".</p></span>"

        changed_updatePnl.Update()
        changed_mpExt.Show()
    End Sub

    Protected Sub onOkClick(ByVal sender As Object, ByVal e As System.EventArgs)
        changed_mpExt.Hide()

    End Sub

    Protected Sub menu_lbtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles menu_lbtn.Click
        Session("ItemList") = Nothing
        Response.Redirect("Default.aspx")
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

End Class
