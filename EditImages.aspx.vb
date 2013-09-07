Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO
Imports AjaxControlToolkit

Partial Class EditImages
    Inherits System.Web.UI.Page

    Dim oConn As New SqlConnection(ConfigurationManager.ConnectionStrings.Item("FigsConnectionString").ConnectionString)
    Dim oCmd As New SqlCommand
    Dim oDA As New SqlDataAdapter
    Dim odTbl As New DataTable
    Dim strSQL As String = ""
    Dim oParam As New SqlParameter
    Dim wasResized As Boolean = False
    Dim msgScript As String = ""

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            If Session("SelectedImagesFig") IsNot Nothing Then
                If Not Request.Path.Contains("Login.aspx") Then

                    Session("FullTime") = Session.Timeout * 60
                    Session("TotalSecondsRemaining") = (Session.Timeout - CInt(ConfigurationManager.AppSettings("AppWarnMinutes"))) * 60
                    Session("MinutesRemaining") = Session.Timeout - CInt(ConfigurationManager.AppSettings("AppWarnMinutes"))

                    Session("Visible") = True

                    start_timer.Enabled = User.Identity.IsAuthenticated
                End If

                If imagesForFig(Session("SelectedImagesFig")) = 0 Then
                    images_fv.ChangeMode(FormViewMode.Insert)
                    configElements(False)
                    bindImagesDDL(Session("SelectedImagesFig"), -1)
                Else
                    configElements(True)
                    bindImagesDDL(Session("SelectedImagesFig"))
                End If

                fig_lbl.DataBind()
                prompt_lit.Text = "<span class='FVIndicatorStyle'>Select an image to edit, or add a new one.</span>"

            Else
                Response.Redirect("Figs.aspx")
            End If

        End If

    End Sub

    Private Sub bindImagesDDL(ByVal figID As Integer, Optional ByVal value As Integer = -2)
        Dim tempStrSQL As String = ""
        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            tempStrSQL = "SELECT ID, ImageTitle FROM Images WHERE FigureID = @FigureID UNION SELECT -2 AS ID, '--Select Image--' AS ImageTitle UNION SELECT -1 AS ID, 'ADD NEW' AS ImaegTitle ORDER BY ID"

            oCmd.Parameters.Clear()
            odTbl.Clear()

            oParam = New SqlParameter
            oParam.ParameterName = "FigureID"
            oParam.SqlDbType = SqlDbType.Int
            oParam.Value = figID
            oCmd.Parameters.Add(oParam)

            oCmd.CommandText = tempStrSQL
            oDA.SelectCommand = oCmd

            oDA.Fill(odTbl)

            images_ddl.DataSource = odTbl
            images_ddl.DataBind()

            images_ddl.SelectedValue = value

            viewAll_lBtn.Visible = (imagesForFig(Session("SelectedImagesFig")) > 0)

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub configElements(ByVal showPrompt As Boolean)
        prompt_lit.Visible = showPrompt
        outerCancel_pnl.Visible = showPrompt
        images_fv.Visible = Not showPrompt
    End Sub

    Protected Sub imagesSelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Select Case images_ddl.SelectedValue
            Case -1
                images_fv.ChangeMode(FormViewMode.Insert)
            Case -2
                Session("SelectedImage") = Nothing
            Case Else
                Session("SelectedImage") = images_ddl.SelectedValue
                images_fv.ChangeMode(FormViewMode.ReadOnly)
        End Select
        images_fv.Visible = (images_ddl.SelectedValue <> -2)
        prompt_lit.Visible = (images_ddl.SelectedValue = -2)
        outerCancel_pnl.Visible = (images_ddl.SelectedValue = -2)
        viewImages_pnl.Visible = False

    End Sub

    Protected Sub viewAllClick(ByVal sender As Object, ByVal e As System.EventArgs)
        images_ddl.SelectedValue = -2
        configElements(True)
        bindImagesDList(Session("SelectedImagesFig"))
        viewImages_pnl.Visible = True
    End Sub

    Private Sub bindImagesDList(ByVal figID As Integer)
        Dim tempStrSQL As String = ""

        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            tempStrSQL = "SELECT * FROM Images WHERE FigureID = @FigureID"

            oCmd.Parameters.Clear()
            odTbl.Clear()

            oParam = New SqlParameter
            oParam.ParameterName = "FigureID"
            oParam.Value = figID
            oParam.SqlDbType = SqlDbType.Int
            oCmd.Parameters.Add(oParam)

            oCmd.CommandText = tempStrSQL
            oDA.SelectCommand = oCmd

            oDA.Fill(odTbl)

            images_dList.DataSource = odTbl
            images_dList.DataBind()

        Catch ex As Exception
            Throw ex
        End Try

    End Sub

    Public Function formatImageStats(ByVal resized As Boolean) As String

        Dim imageBytes() As Byte = getBinaryImage(Session("SelectedImage"))
        Dim img As Image = getImageFromBytes(imageBytes)

        Return IIf(resized, "<b>[Resized]</b><br />", "") & "Size in database: <b>" & IIf(imageBytes.Length >= 1048576, Math.Round(imageBytes.Length) & "MB", Math.Round(imageBytes.Length / 1024, 2) & "KB") & "</b><br />Dimensions: <b>" & img.Width & " x " & img.Height & "</b>"

    End Function

    Public Function formatToolTipStats(ByVal id As Object, ByVal title As Object) As String
        Dim imageBytes() As Byte = getBinaryImage(id)
        Dim img As Image = getImageFromBytes(imageBytes)

        Return "<b>" & title & "</b><br />Size in database: <b>" & IIf(imageBytes.Length >= 1048576, Math.Round(imageBytes.Length) & "MB", Math.Round(imageBytes.Length / 1024, 2) & "KB") & "</b><br />Dimensions: <b>" & img.Width & " x " & img.Height & "</b>"
    End Function

    Public Function isResizeAvailable(ByVal id As Object, ByVal maxDim As Integer) As Boolean
        Dim img As Image = getImageFromBytes(getBinaryImage(id))
        Return (img.Width > maxDim Or img.Height > maxDim)
    End Function

    Public Function formatNullField(ByVal f As Object) As String
        Return IIf(f IsNot DBNull.Value, f, "<i>None specified.</i>")
    End Function

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
        setPostbackTriggers()

        Session("FullTime") -= 1

        If Session("FullTime") = (Session.Timeout * 60) - (CInt(ConfigurationManager.AppSettings("AppWarnMinutes")) * 60) Then
            start_timer.Enabled = False

            configCountdown()
            session_timer.Enabled = True

        End If

    End Sub

    Protected Sub session_timer_Tick(ByVal sender As Object, ByVal e As System.EventArgs) Handles session_timer.Tick
        setPostbackTriggers()

        Session("TotalSecondsRemaining") -= 1

        If Session("TotalSecondsRemaining") Mod 60 = 59 Then
            Session("MinutesRemaining") -= 1
        End If

        configCountdown()

    End Sub

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

    Protected Function formatFigHeader() As String
        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT ItemName FROM Figures WHERE ID = @ID"

            oCmd.Parameters.Clear()

            oParam = New SqlParameter
            oParam.ParameterName = "ID"
            oParam.SqlDbType = SqlDbType.Int
            oParam.Value = Session("SelectedImagesFig")
            oCmd.Parameters.Add(oParam)

            oCmd.CommandText = strSQL

            oCmd.Connection.Open()

            Return "<h3>Add/Edit/Delete Images for " & oCmd.ExecuteScalar() & "</h3>"
        Catch ex As Exception
            Throw ex
        Finally

            If oConn.State = ConnectionState.Open Then
                oConn.Close()
            End If

            oCmd.Dispose()
        End Try
    End Function

    Private Sub setPostbackTriggers()
        Dim insert_btn As Button
        Dim update_btn As Button
        If images_fv.CurrentMode = FormViewMode.Edit Then
            update_btn = CType(images_fv.FindControl("update_btn"), Button)
            If update_btn IsNot Nothing Then
                ScriptManager.GetCurrent(Page).RegisterPostBackControl(update_btn)
            End If

        End If

        If images_fv.CurrentMode = FormViewMode.Insert Then
            insert_btn = CType(images_fv.FindControl("insert_btn"), Button)
            If insert_btn IsNot Nothing Then
                ScriptManager.GetCurrent(Page).RegisterPostBackControl(insert_btn)
            End If

        End If
    End Sub

    Protected Sub qlMeth_click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("Methodology.aspx")
    End Sub

    Protected Sub qlOther_click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("EditOthers.aspx")
    End Sub

    Protected Sub listClick(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("Figs.aspx")
    End Sub

    Protected Sub menuClick(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("ItemList") = Nothing
        Response.Redirect("Default.aspx")
    End Sub

    Private Function getBinaryImage(ByVal id As Integer) As Byte()

        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT ImageData FROM Images WHERE ID = @ID"

            oCmd.Parameters.Clear()

            oParam = New SqlParameter
            oParam.ParameterName = "ID"
            oParam.SqlDbType = SqlDbType.Int
            oParam.Value = id
            oCmd.Parameters.Add(oParam)

            oCmd.CommandText = strSQL

            oCmd.Connection.Open()
            Dim reader As SqlDataReader = oCmd.ExecuteReader()
            reader.Read()

            Return CType(reader("ImageData"), Byte())

        Catch ex As Exception
            Throw ex
        Finally
            If oConn.State = ConnectionState.Open Then
                oConn.Close()
            End If

            oCmd.Dispose()
        End Try

    End Function

    Private Function getImageFromBytes(ByVal bytes As Byte()) As Image
        Dim ms As MemoryStream = New MemoryStream(bytes, 0, bytes.Length)
        ms.Write(bytes, 0, bytes.Length)

        Return Image.FromStream(ms)

    End Function

    Private Function resizeImage(ByVal bytes As Byte(), ByVal mimeType As String, ByVal maxDim As Integer) As Byte()
        Dim img As Image = getImageFromBytes(bytes)

        'This check ensures that the resizing will only be done if the width is greater than the max dimension, and
        'that the resized field only gets set if the resize takes place
        If img.Width > maxDim Then

            Dim newSize As Size = getResizedDimensions(img, maxDim)

            Dim newImgRect As Rectangle = New Rectangle(0, 0, newSize.Width, newSize.Height)
            Dim newImgBMP As Bitmap = New Bitmap(newSize.Width, newSize.Height)
            Dim newImgGraphics As Graphics = Graphics.FromImage(newImgBMP)

            newImgGraphics.CompositingQuality = Drawing2D.CompositingQuality.HighQuality
            newImgGraphics.SmoothingMode = Drawing2D.SmoothingMode.HighQuality
            newImgGraphics.InterpolationMode = Drawing2D.InterpolationMode.HighQualityBicubic

            newImgGraphics.DrawImage(img, newImgRect)

            Dim ms As MemoryStream = New MemoryStream()

            Dim saveFormat As Drawing.Imaging.ImageFormat
            Select Case mimeType
                Case "image/gif"
                    saveFormat = Drawing.Imaging.ImageFormat.Gif
                Case "image/jpeg"
                    saveFormat = Drawing.Imaging.ImageFormat.Jpeg
                Case "image/png"
                    saveFormat = Drawing.Imaging.ImageFormat.Png
            End Select

            newImgBMP.Save(ms, saveFormat)

            Dim newBytes(ms.Length) As Byte
            ms.Position = 0
            ms.Read(newBytes, 0, ms.Length)

            newImgBMP.Dispose()
            newImgGraphics.Dispose()
            img.Dispose()

            wasResized = True

            Return newBytes

        End If

        Return bytes

    End Function

    Private Function getResizedDimensions(ByVal img As Image, ByVal maxdim As Integer) As Size
        Dim newDims As Size

        'Originally set to initial dimensions so that if both dimensions don't meet any of the criteria, the sizes will remain as is
        newDims.Height = img.Height
        newDims.Width = img.Width

        If (img.Height > maxdim And img.Width < maxdim) Or (img.Height > maxdim And img.Width > maxdim And img.Height > img.Width) Then
            newDims.Height = maxdim
            newDims.Width = img.Width / img.Height * newDims.Height
        ElseIf (img.Width > maxdim And img.Height < maxdim) Or (img.Height > maxdim And img.Width > maxdim And img.Width > img.Height) Then
            newDims.Width = maxdim
            newDims.Height = img.Height / img.Width * newDims.Width
        ElseIf (img.Width > maxdim And img.Height > maxdim And img.Width = img.Height) Then
            newDims.Height = maxdim
            newDims.Width = maxdim
        End If

        Return newDims
    End Function

    Protected Sub images_fv_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles images_fv.DataBound
        setPostbackTriggers()

        If images_fv.CurrentMode <> FormViewMode.Insert Then
            Dim pnl As Panel = CType(images_fv.FindControl("previewImg_pnl"), Panel)
            Dim newDims As Size = getResizedDimensions(getImageFromBytes(getBinaryImage(Session("SelectedImage"))), 500)

            Dim imgStr As String = "<a href='DisplayImage.aspx?ID=" & Session("SelectedImage") & "' target='_blank'><img src='DisplayImage.aspx?ID=" & Session("SelectedImage") & "' class='ImageStyle' width='" & newDims.Width & "' height='" & newDims.Height & "' /></a>"
            pnl.Controls.Add(New LiteralControl(imgStr))

        End If
    End Sub

    Protected Sub images_fv_ItemCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewCommandEventArgs) Handles images_fv.ItemCommand
        If e.CommandName = "Cancel" Then
            Response.Redirect("Figs.aspx")
        End If
    End Sub

    Protected Sub images_fv_ItemDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewDeletedEventArgs) Handles images_fv.ItemDeleted
        configElements(True)
        bindImagesDDL(Session("SelectedImagesFig"))
    End Sub

    Protected Sub images_fv_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles images_fv.ItemInserted
        images_fv.ChangeMode(FormViewMode.ReadOnly)
        bindImagesDDL(Session("SelectedImagesFig"), Session("SelectedImage"))
    End Sub

    Protected Sub images_fv_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles images_fv.ItemUpdated
        images_fv.ChangeMode(FormViewMode.ReadOnly)
        bindImagesDDL(Session("SelectedImagesFig"), Session("SelectedImage"))
    End Sub

    Protected Sub images_fv_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles images_fv.ItemInserting
        Dim uploader As FileUpload = CType(images_fv.FindControl("img_uploader"), FileUpload)
        Dim resize_cbx As CheckBox = CType(images_fv.FindControl("resize_cbx"), CheckBox)
        Dim MIMEType As String = ""

        Try
            If uploader.HasFile Then

                Dim ext As String = Path.GetExtension(uploader.PostedFile.FileName).ToLower()

                If uploader.PostedFile.ContentLength > 2097152 Then
                    Throw New ArgumentException("The image must be under 2 MB in size.")
                End If

                Select Case ext
                    Case ".gif"
                        MIMEType = "image/gif"
                    Case ".jpg"
                        MIMEType = "image/jpeg"
                    Case ".png"
                        MIMEType = "image/png"
                    Case Else
                        Throw New ArgumentException("Image must be in either GIF, JPG or PNG format.")
                End Select

                Dim imageBytes(uploader.PostedFile.InputStream.Length) As Byte
                uploader.PostedFile.InputStream.Read(imageBytes, 0, imageBytes.Length)

                If resize_cbx.Checked Then
                    e.Values("ImageData") = resizeImage(imageBytes, MIMEType, 640)
                Else
                    e.Values("ImageData") = imageBytes
                End If

                e.Values("MIMEType") = MIMEType
                e.Values("Resized") = wasResized
            Else
                Throw New ArgumentException("Please choose an image to upload.")
            End If
        Catch ex As ArgumentException
            msgScript = "<script language='javascript'>" & _
                       "alert('Error inserting record:\n\n" & ex.Message & "');" & _
                       "</script>"
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "msgScript", msgScript)
            e.Cancel = True

        Catch ex As Exception
            msgScript = "<script language='javascript'>" & _
                        "alert('Uh oh. Error updating record.');" & _
                        "</script>"

            Page.ClientScript.RegisterStartupScript(Me.GetType(), "msgScript", msgScript)
            e.Cancel = True
        End Try
    End Sub

    Protected Sub images_fv_ItemUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdateEventArgs) Handles images_fv.ItemUpdating
        Dim uploader As FileUpload = CType(images_fv.FindControl("img_uploader"), FileUpload)
        Dim resize_cbx As CheckBox = CType(images_fv.FindControl("resize_cbx"), CheckBox)
        Dim MIMEType As String = ""

        Try
            If uploader.HasFile Then

                Dim ext As String = Path.GetExtension(uploader.PostedFile.FileName).ToLower()

                If uploader.PostedFile.ContentLength > 2097152 Then
                    Throw New ArgumentException("The image must be under 2 MB in size.")
                End If

                Select Case ext
                    Case ".gif"
                        MIMEType = "image/gif"
                    Case ".jpg"
                        MIMEType = "image/jpeg"
                    Case ".png"
                        MIMEType = "image/png"
                    Case Else
                        Throw New ArgumentException("Image must be in either GIF, JPG or PNG format.")
                End Select

                Dim imageBytes(uploader.PostedFile.InputStream.Length) As Byte
                uploader.PostedFile.InputStream.Read(imageBytes, 0, imageBytes.Length)

                If resize_cbx.Checked Then
                    e.NewValues("ImageData") = resizeImage(imageBytes, MIMEType, 640)
                Else
                    e.NewValues("ImageData") = imageBytes
                End If

                e.NewValues("MIMEType") = MIMEType

            Else
                If resize_cbx.Checked Then
                    e.NewValues("ImageData") = resizeImage(getBinaryImage(Session("SelectedImage")), e.OldValues("MIMEType"), 640)
                Else
                    e.NewValues("ImageData") = getBinaryImage(Session("SelectedImage"))
                End If

                e.NewValues("MIMEType") = e.OldValues("MIMEType")

            End If

            e.NewValues("Resized") = wasResized

        Catch ex As ArgumentException
            msgScript = "<script language='javascript'>" & _
                       "alert('Error inserting record:\n\n" & ex.Message & "');" & _
                       "</script>"
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "msgScript", msgScript)
            e.Cancel = True

        Catch ex As Exception
            msgScript = "<script language='javascript'>" & _
                        "alert('Uh oh. Error updating record.');" & _
                        "</script>"

            Page.ClientScript.RegisterStartupScript(Me.GetType(), "msgScript", msgScript)
            e.Cancel = True
        End Try
    End Sub

    Protected Sub image_sds_Inserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles image_sds.Inserted
        Session("SelectedImage") = CType(e.Command.Parameters("@NewID").Value, Integer)
    End Sub

    Protected Sub images_dList_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataListItemEventArgs) Handles images_dList.ItemDataBound
        Dim pnl As Panel = CType(e.Item.FindControl("listImg_pnl"), Panel)
        Dim newDims As Size = getResizedDimensions(getImageFromBytes(getBinaryImage(e.Item.DataItem("ID"))), 142)

        Dim imgStr As String = "<a href='DisplayImage.aspx?ID=" & e.Item.DataItem("ID") & "' target='_blank'><img src='DisplayImage.aspx?ID=" & e.Item.DataItem("ID") & "' class='ImageStyle' width='" & newDims.Width & "' height='" & newDims.Height & "' /></a>"
        pnl.Controls.Add(New LiteralControl(imgStr))

    End Sub

    Protected Sub outerCancelClick(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("Figs.aspx")
    End Sub

End Class
