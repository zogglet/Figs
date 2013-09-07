Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Diagnostics
Imports AjaxControlToolkit
Imports System.IO
Imports System.Drawing

Partial Class Figs
    Inherits System.Web.UI.Page

    Dim oConn As New SqlConnection(ConfigurationManager.ConnectionStrings("FigsConnectionString").ConnectionString)
    Dim oCmd As New SqlCommand
    Dim oParam As SqlParameter
    Dim oDA As New SqlDataAdapter
    Dim oDTbl As New DataTable
    Dim strSQL As String = ""
    Dim msgScript As String = ""

    Dim indicatorStr As String = ""
    Dim indicator_lit As New Literal
    Dim deleted_lit As New Literal

    Dim dv As DataView
    Private Const ASCENDING As String = " ASC"
    Private Const DESCENDING As String = " DESC"

    Public firstBind As Boolean = True



    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        indicator_lit.ID = "indicator_lit"
        deleted_lit.ID = "change_lit"

        If Not IsPostBack Then

            'Session timeout handling
            If Not Request.Path.Contains("Login.aspx") Then

                Session("FullTime") = Session.Timeout * 60
                Session("TotalSecondsRemaining") = (Session.Timeout - CInt(ConfigurationManager.AppSettings("AppWarnMinutes"))) * 60
                Session("MinutesRemaining") = Session.Timeout - CInt(ConfigurationManager.AppSettings("AppWarnMinutes"))

                Session("Visible") = True

                start_timer.Enabled = User.Identity.IsAuthenticated
            End If

            firstBind = IIf(firstBind = True, (IIf(Session("ItemList") Is Nothing, True, False)), False)

            'Only show a previously-generated list if I'm coming back from editing or adding an item
            If Session("FromList") Then

                If Session("Have") IsNot Nothing Then
                    obtained_ddl.SelectedValue = Session("Have")
                End If
                If Session("Game") IsNot Nothing Then
                    game_ddl.SelectedValue = Session("Game")
                End If
                If Session("Type") IsNot Nothing Then
                    type_ddl.SelectedValue = Session("Type")
                End If
                If Session("Manufacturer") IsNot Nothing Then
                    manu_ddl.SelectedValue = Session("Manufacturer")
                End If

                If Session("PageIndex") IsNot Nothing Then
                    figs_gv.PageIndex = Session("PageIndex")
                End If

                bindGridview(False)

                Session("FromList") = Nothing

                dv = New DataView(oDTbl)
            End If

            If Session("FromSearch") Then
                If Session("SearchTerm") IsNot Nothing Then
                    search_txt.Text = Session("SearchTerm")
                End If

                bindGridviewFromSearch()

            End If

        End If

        If Session("FromDeleted") Then
            showDeletedResult()
            Session("FromDeleted") = Nothing
        End If

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
                'innerSession_timer.Enabled = False
                'outerSession_timer.Enabled = True
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


    Protected Sub startTimerTick(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("FullTime") -= 1

        If Session("FullTime") = (Session.Timeout * 60) - (CInt(ConfigurationManager.AppSettings("AppWarnMinutes")) * 60) Then

            start_timer.Enabled = False

            configCountdown()

            session_timer.Enabled = True

        End If

    End Sub

    Protected Sub sessionTimerTick(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("TotalSecondsRemaining") -= 1

        If Session("TotalSecondsRemaining") Mod 60 = 59 Then
            Session("MinutesRemaining") -= 1
        End If

        configCountdown()

    End Sub


    Protected Sub bindGridview(ByVal all As Boolean)

        Try

            Session("FromSearch") = Nothing

            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT Figures.ID, ItemName, Version, Game.Title, Series, ItemType.TypeName, Variant, DATEADD(day, DATEDIFF(day, 0, ReleaseDate), 0) AS ReleaseDate, Manufacturer.Name, (CASE WHEN Have = 1 THEN 'Yes' ELSE 'Not Yet' END) As Have, Pending, Image, Resized, Description, MyNotes " & _
                    "FROM Figures INNER JOIN Game ON Figures.GameID = Game.ID LEFT JOIN Manufacturer ON Figures.ManufacturerID = Manufacturer.ID INNER JOIN ItemType ON Figures.ItemTypeID = ItemType.ID"

            oCmd.Parameters.Clear()
            oDTbl.Clear()

            'If viewing options are chosen, add the necessary parameters
            If Not all Then

                If Session("Have") IsNot Nothing Then
                    strSQL &= andOrWhere()
                    strSQL &= " Have = @Have"

                    oParam = New SqlParameter
                    oParam.ParameterName = "Have"
                    oParam.SqlDbType = SqlDbType.Int
                    oParam.Value = Session("Have")
                    oCmd.Parameters.Add(oParam)
                End If

                If Session("Game") IsNot Nothing Then
                    strSQL &= andOrWhere()
                    strSQL &= " Figures.GameID = @Game"

                    oParam = New SqlParameter
                    oParam.ParameterName = "Game"
                    oParam.SqlDbType = SqlDbType.Int
                    oParam.Value = Session("Game")
                    oCmd.Parameters.Add(oParam)
                End If

                If Session("Type") IsNot Nothing Then
                    strSQL &= andOrWhere()
                    strSQL &= " Figures.ItemTypeID = @ItemType"

                    oParam = New SqlParameter
                    oParam.ParameterName = "ItemType"
                    oParam.SqlDbType = SqlDbType.Int
                    oParam.Value = Session("Type")
                    oCmd.Parameters.Add(oParam)
                End If

                If Session("Manufacturer") IsNot Nothing Then
                    strSQL &= andOrWhere()
                    strSQL &= " Figures.ManufacturerID = @Manufacturer"

                    oParam = New SqlParameter
                    oParam.ParameterName = "Manufacturer"
                    oParam.SqlDbType = SqlDbType.Int
                    oParam.Value = Session("Manufacturer")
                    oCmd.Parameters.Add(oParam)
                End If

            End If

            strSQL &= " ORDER BY Figures.GameID, Series"

            oCmd.CommandText = strSQL

            oDA.SelectCommand = oCmd
            oDA.Fill(oDTbl)

            rigSubGVStuff(oDTbl, False)

            ' Update the Gridview each time, even if no results return (so that the indicator
            ' will be all that is shown)
            figs_gv.DataSource = oDTbl
            figs_gv.DataBind()

            Session("ItemList") = oDTbl
            Session("FromList") = True

            firstBind = False


        Catch ex As ArgumentException
            msgScript = "<script language='javascript'>" & _
                                           "alert('" & ex.Message & "');" & _
                                           "</script>"
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "msgScript", msgScript)

        Catch ex As Exception
            msgScript = "<script language='javascript'>" & _
                        "alert('Uh oh. Error retrieving data.');" & _
                        "</script>"

            Page.ClientScript.RegisterStartupScript(Me.GetType(), "msgScript", msgScript)

        Finally
            If oConn.State = ConnectionState.Open Then
                oConn.Close()
            End If

            oCmd.Dispose()
            oDA.Dispose()
        End Try


    End Sub

    Protected Sub bindGridviewFromSearch()

        Try

            Session("FromList") = Nothing

            Dim searchStr As String = search_txt.Text.Trim

            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT Figures.ID, ItemName, Version, Game.Title, Series, ItemType.TypeName, Variant, CONVERT(VarChar, ReleaseDate, 101) AS ReleaseDate, Manufacturer.Name, (CASE WHEN Have = 1 THEN 'Yes' ELSE 'Not Yet' END) As Have, Pending, Image, Resized, Description, MyNotes " & _
                        "FROM Figures INNER JOIN Game ON Figures.GameID = Game.ID LEFT JOIN Manufacturer ON Figures.ManufacturerID = Manufacturer.ID INNER JOIN ItemType ON Figures.ItemTypeID = ItemType.ID"

            oCmd.Parameters.Clear()
            oDTbl.Clear()

            'Search for each keyword
            If searchStr.Length > 0 Then
                strSQL &= " WHERE Figures.ItemName LIKE '%" & searchStr.Replace(",", "%' OR Figures.ItemName LIKE '%") & "%' OR Game.Title LIKE '%" & searchStr.Replace(",", "%' OR Game.Title LIKE '%") & "%' OR Manufacturer.Name LIKE '%" & searchStr.Replace(",", "%' OR Manufacturer.Name LIKE '%") & "%'" & _
                          "OR Figures.Description LIKE '%" & searchStr.Replace(",", "%' OR Figures.Description LIKE '%") & "%' OR Figures.Series LIKE '%" & searchStr.Replace(",", "%' OR Figures.Series LIKE '%") & "%' OR Figures.MyNotes LIKE '%" & searchStr.Replace(",", "%' OR Figures.MyNotes LIKE '%") & "%' ORDER BY Figures.GameID, Series"
            End If

            oCmd.CommandText = strSQL

            oDA.SelectCommand = oCmd
            oDA.Fill(oDTbl)

            rigSubGVStuff(oDTbl, True)

            ' Update the Gridview each time, even if no results return (so that the indicator
            ' will be all that is shown)
            figs_gv.DataSource = oDTbl
            figs_gv.DataBind()

            Session("ItemList") = oDTbl
            Session("FromSearch") = True

            firstBind = False

        Catch ex As ArgumentException
            msgScript = "<script language='javascript'>" & _
                                           "alert('" & ex.Message & "');" & _
                                           "</script>"
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "msgScript", msgScript)

        Catch ex As Exception
            msgScript = "<script language='javascript'>" & _
                        "alert('Uh oh. Error retrieving data.');" & _
                        "</script>"

            Page.ClientScript.RegisterStartupScript(Me.GetType(), "msgScript", msgScript)

        Finally
            If oConn.State = ConnectionState.Open Then
                oConn.Close()
            End If

            oCmd.Dispose()
            oDA.Dispose()
        End Try



    End Sub

    Protected Sub rigSubGVStuff(ByVal dt As DataTable, ByVal search As Boolean)


        If dt.Rows.Count = 0 Then
            'report_btn.Visible = False
            indicatorStr = IIf(search, "<span class='IndicatorStyle'>Your search terms returned no items.</span>", "<span class='IndicatorStyle'>Your selected filtering options returned no items.</span>")
        Else
            'report_btn.Visible = True
            indicatorStr = "<div class='ImgIndicatorStyle'>Images marked with <span class='ResizableStyle'>[*]</span> can be resized.</div><div class='TotalStyle'>Drilled-down Items: <span>" & dt.Rows.Count & "</span> <b>|</b> Total Items: <span>" & getTotal() & "</span></div>"
        End If

        indicator_lit.Text = indicatorStr
        indicator_div.Controls.Add(indicator_lit)
    End Sub


    Protected Function getTotal() As String

        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT Count(*) From Figures"
            oCmd.CommandText = strSQL

            oCmd.Parameters.Clear()

            oCmd.Connection.Open()

            Return oCmd.ExecuteScalar().ToString

        Catch ex As Exception
            Throw ex

        Finally
            If oConn.State = ConnectionState.Open Then
                oConn.Close()
            End If

            oCmd.Dispose()
            oDA.Dispose()
        End Try


    End Function

    Protected Function andOrWhere() As String
        Return IIf(InStr(strSQL, "WHERE"), " AND", " WHERE")
    End Function

    Public Function formatImage(ByVal imgName As Object, ByVal resized As Object) As String

        Dim returnStr As String = ""

        If imgName IsNot DBNull.Value Then

            Dim img As Image = getImage(imgName)

            If resized = True Then
                returnStr = imgName & " <span style='color:#657d5c;'>[Resized]</span>"
            ElseIf img.Width > 640 Or img.Height > 640 Then
                returnStr = imgName & " <span class='ResizableStyle'>[*]</span> "
            Else
                returnStr = imgName
            End If

        Else
            returnStr = "<i>None</i>"
        End If
        Return returnStr

    End Function

    Public Function formatHaveText(ByVal have As Object, ByVal pending As Object) As String
        Return IIf(have = "Yes", "<span style='color:#657d5c;'>" & have & "</span>", IIf(pending = True, "<span class='PendingStyle'>Pending</span>", "<span class='NotObtainedStyle'>" & have & "</span>"))
    End Function

    Public Function formatNullField(ByVal f As Object) As String
        Return IIf(f IsNot DBNull.Value, f, "<i>Not specified</i>")
    End Function

    Public Function formatDate(ByVal d As DateTime) As String
        Return d.ToShortDateString()
    End Function

    Public Function formatManageImagesText(ByVal id As Object) As String
        Dim numImages As Integer = imagesForFig(id)
        Return IIf(numImages > 0, "Manage Images (" & numImages & ")", "Add Images")
    End Function

    Private Function imagesForFig(ByVal figID As Integer) As Integer
        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT Count(*) FROM Images WHERE FigureID = @FigureID"

            oCmd.Parameters.Clear()

            oParam = New SqlParameter
            oParam.ParameterName = "FigureID"
            oParam.SqlDbType = SqlDbType.Int
            oParam.Value = figID
            oCmd.Parameters.Add(oParam)

            oCmd.CommandText = strSQL
            oCmd.Connection.Open()

            Return oCmd.ExecuteScalar()

        Catch ex As Exception
            Throw ex
        Finally
            If oConn.State = ConnectionState.Open Then
                oConn.Close()
            End If

            oCmd.Dispose()
        End Try
    End Function

    Public Function tooltipText(ByVal desc As Object, ByVal notes As Object) As String
        Dim str As String = ""

        If desc IsNot DBNull.Value Then
            str = "<i>" & truncateStr(desc, 100) & "</i>"
            If notes IsNot DBNull.Value Then
                str &= "<br /><br /><b>My Notes:</b><br /><i>" & truncateStr(notes, 100) & "</i>"
            End If
        Else
            str = IIf(notes IsNot DBNull.Value, "<b>My Notes:</b><br /><i>" & notes & "</i>", "<i>(No description yet)</i>")
        End If

        Return str

    End Function

    Protected Function getImage(ByVal imgStr As String) As Image
        Dim img As Image = Image.FromFile(Page.MapPath(".") & "\images\" & imgStr)
        Return img
    End Function

    Protected Function truncateStr(ByVal str As String, ByVal maxLength As Integer) As Object

        If str.Length > maxLength Then
            str = str.Substring(0, maxLength - 6) & " [...]"
        End If

        Return str

    End Function


    Protected Sub genList_btn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles genList_btn.Click

        Session("Have") = IIf(obtained_ddl.SelectedValue = -1, Nothing, obtained_ddl.SelectedValue)
        Session("Game") = IIf(game_ddl.SelectedValue = -1, Nothing, game_ddl.SelectedValue)
        Session("Type") = IIf(type_ddl.SelectedValue = -1, Nothing, type_ddl.SelectedValue)
        Session("Manufacturer") = IIf(manu_ddl.SelectedValue = -1, Nothing, manu_ddl.SelectedValue)

        bindGridview(False)

    End Sub

    Protected Sub search_btn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles search_btn.Click

        Session("Have") = Nothing
        Session("Game") = Nothing
        Session("Type") = Nothing
        Session("Manufacturer") = Nothing

        Session("SearchTerm") = IIf(search_txt.Text.Trim.Length > 0, search_txt.Text.Trim, Nothing)

        bindGridviewFromSearch()

    End Sub


    Protected Sub showAll_btn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles showAll_btn.Click

        Session("Have") = Nothing
        Session("Game") = Nothing
        Session("Type") = Nothing
        Session("Manufacturer") = Nothing
        Session("SearchTerm") = Nothing

        game_ddl.SelectedValue = -1
        manu_ddl.SelectedValue = -1
        type_ddl.SelectedValue = -1
        obtained_ddl.SelectedValue = -1
        search_txt.Text = ""

        bindGridview(True)

    End Sub

    Protected Sub figs_gv_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles figs_gv.DataBound
        Session("PageIndex") = figs_gv.PageIndex
    End Sub

    Protected Sub figs_gv_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles figs_gv.PageIndexChanging
        figs_gv.PageIndex = e.NewPageIndex

        If Session("FromList") Then
            bindGridview(False)
        ElseIf Session("FromSearch") Then
            bindGridviewFromSearch()
        End If

    End Sub


    Public Property gvSortDirection() As SortDirection
        Get
            If ViewState("sortDirection") Is DBNull.Value Then
                ViewState("sortDirection") = SortDirection.Ascending
                Return CType(ViewState("sortDirection"), SortDirection)
            End If
        End Get
        Set(ByVal value As SortDirection)
            ViewState("sortDirection") = value
        End Set
    End Property

    Private Sub sortGV(ByVal se As String, ByVal dir As String)
        dv = New DataView(CType(Session("ItemList"), DataTable))
        dv.Sort = se & dir
        figs_gv.DataSource = dv
        figs_gv.DataBind()
    End Sub

    Protected Sub onSorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles figs_gv.Sorting

        Dim sortExp As String = e.SortExpression

        If (gvSortDirection() = SortDirection.Ascending) Then
            gvSortDirection() = SortDirection.Descending
            sortGV(sortExp, DESCENDING)
        Else
            gvSortDirection() = SortDirection.Ascending
            sortGV(sortExp, ASCENDING)
        End If

    End Sub

    Public Function isEnabled(ByVal f As Object) As Boolean
        Return IIf(f IsNot DBNull.Value, True, False)
    End Function

    Public Sub gvSelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles figs_gv.SelectedIndexChanged
        Session("SelectedFig") = figs_gv.SelectedValue
        Response.Redirect("EditFig.aspx")
    End Sub


    Protected Sub gvRowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.DataItem("Have") = "Yes" Then
                For i As Integer = 1 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).BackColor = Drawing.ColorTranslator.FromHtml("#ececec")
                Next
            End If

            If e.Row.DataItem("Pending") = True Then
                For i As Integer = 1 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).BackColor = Drawing.ColorTranslator.FromHtml("#de968c")
                Next
            End If
        End If

    End Sub

    Protected Sub manageImagesClick(ByVal sender As Object, ByVal e As System.EventArgs)

        For i As Integer = 0 To figs_gv.Rows.Count - 1
            If CType(figs_gv.Rows(i).FindControl("images_lBtn"), LinkButton) Is sender Then
                Session("SelectedImagesFig") = figs_gv.DataKeys(i).Values("ID")
                Exit For
            End If
        Next

        Response.Redirect("EditImages.aspx")
    End Sub

    Protected Sub addNew_click(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("SelectedFig") = 0
        Response.Redirect("EditFig.aspx")
    End Sub

    Protected Sub showDeletedResult()
        deleted_lit.Text = "<span class='resultStyle'><p>You've successfully deleted the item, <b>" & Session("RecentItem") & "</b>.</p><p>Be more mindful of your action figures!</p></span>"
        deleted_innerDiv.Controls.Add(deleted_lit)

        deleted_dsExt.Enabled = True
        deleted_mpExt.Show()
    End Sub

    Protected Sub onOkClick(ByVal sender As Object, ByVal e As System.EventArgs)
        deleted_mpExt.Hide()
    End Sub

    'Protected Sub report_btn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles report_btn.Click
    '    Response.Redirect("ViewReport.aspx")
    'End Sub

    Protected Sub menu_lbtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles menu_lbtn.Click
        Session("ItemList") = Nothing
        Response.Redirect("Default.aspx")
    End Sub

    Protected Sub qlMeth_click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("Methodology.aspx")
    End Sub

    Protected Sub qlOther_click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("EditOthers.aspx")
    End Sub

End Class
