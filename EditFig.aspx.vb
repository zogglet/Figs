Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports AjaxControlToolkit
Imports System.IO
Imports System.IO.Packaging
Imports System.Net.Mail
Imports System.Net
Imports System.Drawing
Imports System.IO.FileStream



Partial Class Figs_EditFig
    Inherits System.Web.UI.Page

    Dim oConn As New SqlConnection(ConfigurationManager.ConnectionStrings.Item("FigsConnectionString").ConnectionString)
    Dim oCmd As New SqlCommand
    Dim oDA As New SqlDataAdapter
    Dim odTbl As New DataTable
    Dim strSQL As String = ""
    Dim oParam As New SqlParameter

    Dim currentItemName As String = ""
    Dim emailRecip As String = ""

    Dim imgUploader As New FileUpload
    Dim imgDir As String = ""
    Dim imgInfo As FileInfo
    Dim pagePath As String = ""
    Dim summaryDir As String = ""
    Dim summaryGenDir As String = ""
    Dim summaryFilePath As String = ""

    Dim img_lit As New Literal
    Dim changed_lit As New Literal
    Dim summary_lit As New Literal

    Private msgScript As String = ""

    Protected WithEvents client As SmtpClient
    Dim emailResultStr As String = ""

    Dim newName As String = ""
    Dim wasResized As Boolean = False

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        pagePath = Page.MapPath(".")

        imgDir = pagePath & "\images\"
        summaryDir = pagePath & "\Summaries\"
        summaryGenDir = pagePath & "\Summaries\Generated\"

        If Not IsPostBack Then

            If Not Request.Path.Contains("Login.aspx") Then

                Session("FullTime") = Session.Timeout * 60
                Session("TotalSecondsRemaining") = (Session.Timeout - CInt(ConfigurationManager.AppSettings("AppWarnMinutes"))) * 60
                Session("MinutesRemaining") = Session.Timeout - CInt(ConfigurationManager.AppSettings("AppWarnMinutes"))

                Session("Visible") = True

                start_timer.Enabled = User.Identity.IsAuthenticated
            End If


            If Session("SelectedFig") = 0 Then
                figs_formView.ChangeMode(FormViewMode.Insert)
            End If

            Dim dirs() As String = Directory.GetDirectories(summaryGenDir, "*")
            Dim dirFiles() As String = Directory.GetFiles(summaryGenDir, "*")

            For i As Integer = 0 To dirs.Length - 1
                Dim files() As String = Directory.GetFiles(dirs(i), "*")
                For j As Integer = 0 To files.Length - 1
                    File.Delete(files(i))
                Next
            Next

            For j As Integer = 0 To dirFiles.Length - 1
                File.Delete(dirFiles(j))
            Next


        End If

        img_lit.ID = "img_lit"
        changed_lit.ID = "updated_lit"
        summary_lit.ID = "summary_lit"

        If Session("ItemList") IsNot Nothing Then
            return_lbtn.Text = "Return to Generated List"
        Else
            return_lbtn.Text = "Return to List Generator"
        End If

        'Resetting these
        Session("FromInserted") = Nothing
        Session("FromUpdated") = Nothing
        Session("FromDeleted") = Nothing
        Session("RecentItem") = Nothing

        Session("Resized") = Nothing
        Session("ImageDeleted") = Nothing

        imgUploader = CType(figs_formView.FindControl("img_uploader"), FileUpload)

        If Session("SelectedFig") <> 0 Then
            currentItemName = getAllFieldsFor(Session("SelectedFig")).Rows(0)("ItemName")
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

    Protected Sub figs_formView_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles figs_formView.DataBound
        setPostbackTriggers()
    End Sub

    Protected Sub figs_formView_ItemCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewCommandEventArgs) Handles figs_formView.ItemCommand
        If e.CommandName = "Cancel" Then
            Response.Redirect("Figs.aspx")
        End If

        If e.CommandName = "Delete" Then
            Dim img As Object = getAllFieldsFor(Session("SelectedFig")).Rows(0)("Image")

            If File.Exists(imgDir & img) Then
                File.Delete(imgDir & img)
            End If
        End If

    End Sub

    Protected Sub figs_formView_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles figs_formView.ItemInserting

        Try

            If imgUploader.HasFile Then

                Dim ext As String = System.IO.Path.GetExtension(imgUploader.FileName)
                newName = stripBadChars(e.Values("ItemName").ToString.Trim) & ext
                Dim fileCounter As Integer = 0

                If imgUploader.PostedFile.ContentLength > 2097152 Then
                    Throw New ArgumentException("The image must be under 2 MB in size.")
                End If

                If ext <> ".jpg" And ext <> ".gif" And ext <> ".png" Then
                    Throw New ArgumentException("The image must be in either JPG, GIF, or PNG format.")
                End If

                While File.Exists(imgDir & newName)
                    newName = stripBadChars(e.Values("ItemName").ToString.Trim) & "_" & fileCounter.ToString & ext
                    fileCounter += 1
                End While

                imgUploader.SaveAs(imgDir & newName)

                If CType(figs_formView.FindControl("resize_cbx"), CheckBox).Checked Then
                    resizeImg(imgDir & newName, 640)
                End If

                e.Values("Image") = newName

            End If

            If CType(figs_formView.FindControl("manu_ddl"), DropDownList).SelectedValue = "-1" Then
                e.Values("ManufacturerID") = Nothing
            End If

            e.Values("Have") = insertHave_cbx.Checked
            e.Values("Pending") = insertPending_cbx.Checked
            e.Values("Resized") = wasResized

        Catch ex As ArgumentException
            msgScript = "<script language='javascript'>" & _
                                           "alert('Error updating record:\n\n" & ex.Message & "');" & _
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

    Protected Sub figs_formView_ItemUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdateEventArgs) Handles figs_formView.ItemUpdating

        Try
            'Replace old file if new one is specified
            If e.OldValues("Image") <> Nothing Then
                If File.Exists(imgDir & e.OldValues("Image")) And imgUploader.HasFile Then
                    File.Delete(imgDir & e.OldValues("Image"))
                End If
            End If

            ' Only save if delete is not checked
            If CType(figs_formView.FindControl("deleteImg_cbx"), CheckBox).Checked Then
                File.Delete(imgDir & e.OldValues("Image"))
                e.NewValues("Image") = Nothing
                Session("ImageDeleted") = True
            Else

                If imgUploader.HasFile Then

                    Dim ext As String = System.IO.Path.GetExtension(imgUploader.FileName)
                    newName = stripBadChars(e.NewValues("ItemName").ToString.Trim) & ext
                    Dim fileCounter As Integer = 0

                    If imgUploader.PostedFile.ContentLength > 2097152 Then
                        Throw New ArgumentException("The image must be under 2 MB in size.")
                    End If

                    If ext <> ".jpg" And ext <> ".gif" And ext <> ".png" Then
                        Throw New ArgumentException("The image must be in either JPG, GIF, or PNG format.")
                    End If

                    While File.Exists(imgDir & newName)
                        newName = stripBadChars(e.NewValues("ItemName").ToString.Trim) & "_" & fileCounter.ToString & ext
                        fileCounter += 1
                    End While

                    imgUploader.SaveAs(imgDir & newName)

                    If CType(figs_formView.FindControl("resize_cbx"), CheckBox).Checked Then
                        resizeImg(imgDir & newName, 640)
                    End If

                    e.NewValues("Image") = newName

                Else

                    If e.OldValues("Image") <> Nothing Then
                        e.NewValues("Image") = e.OldValues("Image")

                        newName = e.NewValues("Image")

                        If CType(figs_formView.FindControl("resize_cbx"), CheckBox).Checked Then
                            resizeImg(imgDir & e.NewValues("Image"), 640)
                        End If

                    End If

                End If

            End If

            If CType(figs_formView.FindControl("manu_ddl"), DropDownList).SelectedValue = "-1" Then
                e.NewValues("ManufacturerID") = Nothing
            End If

            e.NewValues("Have") = editHave_cbx.Checked
            e.NewValues("Pending") = editPending_cbx.Checked
            e.NewValues("Resized") = wasResized

        Catch ex As ArgumentException
            msgScript = "<script language='javascript'>" & _
                        "alert('Error updating record:\n\n'" & ex.Message & "');" & _
                        "</script>"

            Page.ClientScript.RegisterStartupScript(Me.GetType(), "msgScript", msgScript)
            e.Cancel = True
        Catch ex As Exception
            msgScript = "<script language='javascript'>" & _
                        "alert('Uh oh. Error updating record.'\n\n" & ex.Message & "');" & _
                        "</script>"

            Page.ClientScript.RegisterStartupScript(Me.GetType(), "msgScript", msgScript)
            e.Cancel = True

        End Try

    End Sub


    Protected Function getImage(ByVal imgStr As String) As Image
        Dim fs As FileStream = New FileStream(imgStr, FileMode.Open)
        Dim img As Image = Image.FromStream(fs)
        fs.Close()
    End Function

    Protected Sub resizeImg(ByVal img As String, ByVal maxDim As Integer)

        Dim image As Image = getImage(img)

        ' This conditional, though redundant for the resizing process, ensures that the resized field only gets set when
        ' the image is actually resized (an image under the max dimensions could technically be set to resize, but shouldn't be actually resized)
        If image.Width > maxDim Or image.Height > maxDim Then

            Dim newSize As Size = getResizedDimensions(image, maxDim)

            Dim newImgRect As Rectangle = New Rectangle(0, 0, newSize.Width, newSize.Height)
            Dim newImgBMP As Bitmap = New Bitmap(newSize.Width, newSize.Height)
            Dim newImgGraphics As Graphics = Graphics.FromImage(newImgBMP)

            newImgGraphics.CompositingQuality = Drawing2D.CompositingQuality.HighQuality
            newImgGraphics.SmoothingMode = Drawing2D.SmoothingMode.HighQuality
            newImgGraphics.InterpolationMode = Drawing2D.InterpolationMode.HighQualityBicubic

            newImgGraphics.DrawImage(image, newImgRect)

            Dim toFS As FileStream = New FileStream(img, FileMode.Create)

            newImgBMP.Save(toFS, image.RawFormat)

            toFS.Close()

            newImgBMP.Dispose()
            newImgGraphics.Dispose()
            image.Dispose()

            wasResized = True
            Session("Resized") = True
        End If


    End Sub

    Protected Sub figs_formView_ItemDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewDeletedEventArgs) Handles figs_formView.ItemDeleted
        Session("FromDeleted") = True

        Session("SelectedFig") = 0
        Session("RecentItem") = e.Values("ItemName")

        Response.Redirect("Figs.aspx")
    End Sub

    Protected Sub figs_formView_ModeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles figs_formView.ModeChanged

        If figs_formView.DefaultMode = FormViewMode.ReadOnly Then
            If Session("FromUpdated") Then
                showChangedResult(False)
                Session("FromUpdated") = Nothing
            End If
            If Session("FromInserted") Then
                showChangedResult(True)
                Session("FromInserted") = Nothing
            End If

        End If


    End Sub


    Public Function formatHaveTxt(ByVal have As Boolean, ByVal pending As Boolean) As String
        Return IIf(have, "Yes", IIf(pending, "<span class='PendingStyle'>Pending</span>", "Not yet"))
    End Function

    Public Function formatImgText(ByVal img As Object, ByVal resized As Object) As String
        Return IIf(img IsNot DBNull.Value, img & IIf(resized, " <i>[Resized]</i>", ""), "<i>No image selected.</i>")
    End Function

    Public Function formatNullField(ByVal f As Object) As String
        Return IIf(f IsNot DBNull.Value, f, "<i>Not specified.</i>")
    End Function

    Public Function isVisible(ByVal f As Object) As Boolean
        Return IIf(f IsNot DBNull.Value, True, False)
    End Function

    Public Function isPendingVisible(ByVal have As Object) As Boolean
        Return Not have
    End Function

    Public Function isResizeAvailable(ByVal img As Object, ByVal maxDim As Integer) As Boolean
        ' Allow for an immediate resize if an image hadn't been uploaded yet
        If Not File.Exists(imgDir & img) Then
            Return True
        Else
            ' If an image has been uploaded, allow resize if the image is beyond the max dimensions
            Dim image As System.Drawing.Image = System.Drawing.Image.FromFile(imgDir & img)
            Return (image.Width > maxDim Or image.Height > maxDim)
        End If

    End Function


    Public Function formatResizeText(ByVal img As Object) As String
        Return "<p class='detail'>" & IIf(img IsNot DBNull.Value, "The current image can be resized.", "If this box is checked, the image will be resized if either dimensions are over 640px.") & "</p>"
    End Function

    Protected Sub listClick(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("Figs.aspx")
    End Sub

    Protected Sub showImg(ByVal sender As Object, ByVal e As System.EventArgs)

        Dim img_mpExt As ModalPopupExtender = CType(figs_formView.FindControl("img_mpExt"), ModalPopupExtender)
        Dim theImage As String = ""
        Dim img As Image = Nothing
        Dim sizeStr As String = ""
        Dim newDims As Size

        Try
            strSQL = "SELECT Image FROM Figures WHERE ID = @ID"

            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text
            oCmd.CommandText = strSQL

            oCmd.Parameters.Clear()

            oParam = New SqlParameter
            oParam.ParameterName = "ID"
            oParam.SqlDbType = SqlDbType.Int
            oParam.Value = Session("SelectedFig")
            oCmd.Parameters.Add(oParam)

            oConn.Open()
            theImage = oCmd.ExecuteScalar()

            img = getImage(imgDir & theImage)
            newDims = getResizedDimensions(img, 640)

            fig_img.Height = newDims.Height
            fig_img.Width = newDims.Width

            imgInfo = New FileInfo(imgDir & theImage)

            sizeStr = IIf(imgInfo.Length >= 1048576, Math.Round(imgInfo.Length / 1024, 2) & "MB", Math.Round(imgInfo.Length / 1024, 2) & "KB")

            img_lit.Text = "<p>File Name: <b>" & theImage & "</b><br />File Size: <b>" & sizeStr & "</b><br />Dimensions: <b>" & img.Width & " x " & img.Height & "</b>" & IIf(isResizeAvailable(theImage, 640), "<br /><i>To resize this image for optimization, edit this item.</i>", "") & "</p>"

            img_innerDiv.Controls.Add(img_lit)

            img_mpExt.Show()

        Catch ex As Exception
            Throw ex
        Finally
            If oConn.State = ConnectionState.Open Then
                oConn.Close()
            End If
            oCmd.Dispose()
            oConn.Dispose()
        End Try

    End Sub

    ' Just to retrieve the resized dimensions themselves (used for the preview and the actual resizing)
    Protected Function getResizedDimensions(ByVal img As Image, ByVal maxDim As Integer) As Size

        Dim newDims As Size

        'Originally set to initial dimensions
        newDims.Height = img.Height
        newDims.Width = img.Width

        If (img.Height > maxDim And img.Width < maxDim) Or (img.Height > maxDim And img.Width > maxDim And img.Height > img.Width) Then
            newDims.Height = maxDim
            newDims.Width = img.Width / img.Height * newDims.Height
        ElseIf (img.Width > maxDim And img.Height < maxDim) Or (img.Height > maxDim And img.Width > maxDim And img.Width > img.Height) Then
            newDims.Width = maxDim
            newDims.Height = img.Height / img.Width * newDims.Width
        ElseIf img.Width > maxDim And img.Height > maxDim And img.Width = img.Height Then
            newDims.Width = maxDim
            newDims.Height = maxDim
        End If

        Return newDims

    End Function

    Public Function isEmailVisible() As Boolean
        Return (summary_rbList.SelectedValue = "Email")
    End Function

    Protected Sub rbListChanged(ByVal sender As Object, ByVal e As EventArgs)
        email_txt.Visible = (summary_rbList.SelectedValue = "Email")
    End Sub

    Protected Sub generateSummary(ByVal sender As Object, ByVal e As System.EventArgs)

        Dim summary_mpExt As ModalPopupExtender = CType(figs_formView.FindControl("summary_mpExt"), ModalPopupExtender)
        Dim figsTbl As New DataTable
        Try

            figsTbl = getAllFieldsFor(Session("SelectedFig"))

            configDirs(figsTbl.Rows(0)("ItemName"))

            Dim defaultReader As New StreamReader(summaryFilePath)
            Dim defaultWriter As New StreamWriter(Path.ChangeExtension(summaryFilePath, "tmp"))

            Dim newImgPath As String = ""

            If figsTbl.Rows(0)("Image") IsNot DBNull.Value And File.Exists(imgDir & figsTbl.Rows(0)("Image")) Then

                newImgPath = summaryGenDir & figsTbl.Rows(0)("Image")

                File.Copy(imgDir & figsTbl.Rows(0)("Image"), newImgPath)

                If isResizeAvailable(IO.Path.GetFileName(newImgPath), 250) Then
                    resizeImg(newImgPath, 250)
                End If

            End If

            Using defaultReader
                Dim currentLine = defaultReader.ReadLine()
                Do While currentLine IsNot Nothing
                    If currentLine.Contains("[FigName]") Then
                        currentLine = IIf(currentLine.Contains("<h2>") Or currentLine.Contains("<title>"), currentLine.Replace("[FigName]", figsTbl.Rows(0)("ItemName")), currentLine.Replace("[FigName]", "<span class='ItemStyle'>" & figsTbl.Rows(0)("ItemName") & "</span>"))
                    End If
                    If currentLine.Contains("[ItemType]") Then
                        currentLine = currentLine.Replace("[ItemType]", "<span class='ItemStyle'>" & figsTbl.Rows(0)("TypeName") & "</span>")
                    End If
                    If currentLine.Contains("[Game]") Then
                        currentLine = currentLine.Replace("[Game]", "<span class='ItemStyle'>" & figsTbl.Rows(0)("Title") & "</span>")
                    End If
                    If currentLine.Contains("[Series]") Then
                        currentLine = currentLine.Replace("[Series]", "<span class='ItemStyle'>" & figsTbl.Rows(0)("Series") & "</span>")
                    End If
                    If currentLine.Contains("[ReleaseDate]") Then
                        currentLine = currentLine.Replace("[ReleaseDate]", "<span class='ItemStyle'>" & figsTbl.Rows(0)("ReleaseDate") & "</span>")
                    End If
                    If currentLine.Contains("[Manufacturer]") Then
                        currentLine = currentLine.Replace("[Manufacturer]", "<span class='ItemStyle'>" & formatNullField(figsTbl.Rows(0)("Name")) & "</span>")
                    End If
                    If currentLine.Contains("[Obtained]") Then
                        currentLine = currentLine.Replace("[Obtained]", "<span class='ItemStyle'>" & figsTbl.Rows(0)("Have") & "</span>")
                    End If
                    If currentLine.Contains("[Version]") Then
                        currentLine = currentLine.Replace("[Version]", "<span class='ItemStyle'>" & formatNullField(figsTbl.Rows(0)("Version")) & "</span>")
                    End If
                    If currentLine.Contains("[Variant]") Then
                        currentLine = currentLine.Replace("[Variant]", "<span class='ItemStyle'>" & formatNullField(figsTbl.Rows(0)("Variant")) & "</span>")
                    End If
                    If currentLine.Contains("[Exclusivity]") Then
                        currentLine = currentLine.Replace("[Exclusivity]", "<span class='ItemStyle'>" & formatNullField(figsTbl.Rows(0)("Exclusivity")) & "</span>")
                    End If
                    If currentLine.Contains("[ProdLimit]") Then
                        currentLine = currentLine.Replace("[ProdLimit]", "<span class='ItemStyle'>" & formatNullField(figsTbl.Rows(0)("ProductionLimit")) & "</span>")
                    End If
                    If currentLine.Contains("[Serial]") Then
                        currentLine = currentLine.Replace("[Serial]", "<span class='ItemStyle'>" & formatNullField(figsTbl.Rows(0)("Serial")) & "</span>")
                    End If
                    If currentLine.Contains("[Image]") Then
                        currentLine = currentLine.Replace("[Image]", IIf(figsTbl.Rows(0)("Image") IsNot DBNull.Value, "<br /><img src='" & figsTbl.Rows(0)("Image") & "' alt='" & odTbl.Rows(0)("ItemName") & "' class='InlineImage' />", "<span class='ItemStyle'><i>No Image Specified</i></span>"))
                    End If
                    If currentLine.Contains("[Description]") Then
                        currentLine = currentLine.Replace("[Description]", "<span class='ItemStyle'>" & formatNullField(figsTbl.Rows(0)("Description")) & "</span>")
                    End If
                    If currentLine.Contains("[MyNotes]") Then
                        currentLine = currentLine.Replace("[MyNotes]", "<span class='ItemStyle'>" & formatNullField(figsTbl.Rows(0)("MyNotes")) & "</span>")
                    End If
                    defaultWriter.WriteLine(currentLine)
                    currentLine = defaultReader.ReadLine()

                Loop
                defaultReader.Close()
                defaultWriter.Close()
                File.Copy(Path.ChangeExtension(summaryFilePath, "tmp"), summaryFilePath, True)
                File.Delete(Path.ChangeExtension(summaryFilePath, "tmp"))

            End Using


            '*** Zip process ***
            Dim newZipPath As String = summaryGenDir & "\Zips\" & stripBadChars(currentItemName) & ".zip"


            Session("ZipFile") = newZipPath

            Dim zip As Package = ZipPackage.Open(newZipPath, FileMode.Create, FileAccess.ReadWrite)

            addToZip(zip, summaryFilePath)

            If newImgPath.Length > 0 Then
                addToZip(zip, newImgPath)
            End If

            zip.Close()


            summary_lit.Text = "<span class='resultStyle'><p>A summary page for the item, <b>" & figsTbl.Rows(0)("ItemName") & "</b>, has been created.<p>Would you like to view the file, save it to disk, or email it to yourself/your mom/your dog?</p></span> "
            sumResult_innerDiv.Controls.Add(summary_lit)

            summary_mpExt.Show()

        Catch ex As Exception
            Throw ex
        Finally
            If oConn.State = ConnectionState.Open Then
                oConn.Close()
            End If
            oCmd.Dispose()
            oConn.Dispose()
        End Try


    End Sub


    '(ref: http://www.codeproject.com/KB/vb/ZipDemo.aspx?display=Print)
    Protected Sub addToZip(ByVal zip As Package, ByVal fileToAdd As String)

        Try
            Dim zipUri As String = String.Concat("/", IO.Path.GetFileName(fileToAdd))
            Dim partUri As New Uri(zipUri, UriKind.Relative)

            'Where to extract it, the type of content stream, and the type of compression
            Dim pkgPart As PackagePart = zip.CreatePart(partUri, Net.Mime.MediaTypeNames.Application.Zip, CompressionOption.Normal)

            Dim bytes As Byte() = File.ReadAllBytes(fileToAdd)
            'Compress and write the bytes to the zip file
            pkgPart.GetStream().Write(bytes, 0, bytes.Length)

        Catch ex As Exception
            Throw ex
        End Try

    End Sub


    Protected Function getAllFieldsFor(ByVal id As Object) As DataTable
        oCmd.Connection = oConn
        oCmd.CommandType = CommandType.Text

        strSQL = "SELECT Figures.ID, ItemName, Version, Game.Title, Series, ItemType.TypeName, Variant, CONVERT(VarChar, ReleaseDate, 101) AS ReleaseDate, Manufacturer.Name, (CASE WHEN Have = 1 THEN 'Yes' ELSE 'Not Yet' END) As Have, Pending, Serial, Exclusivity, ProductionLimit, Image, Description, MyNotes " & _
                        "FROM Figures INNER JOIN Game ON Figures.GameID = Game.ID LEFT JOIN Manufacturer ON Figures.ManufacturerID = Manufacturer.ID INNER JOIN ItemType ON Figures.ItemTypeID = ItemType.ID WHERE Figures.ID = @ID"

        oCmd.Parameters.Clear()
        odTbl.Clear()

        oParam = New SqlParameter
        oParam.ParameterName = "ID"
        oParam.SqlDbType = SqlDbType.Int
        oParam.Value = id
        oCmd.Parameters.Add(oParam)

        oCmd.CommandText = strSQL

        oDA.SelectCommand = oCmd
        oDA.Fill(odTbl)

        Return odTbl
    End Function

    Protected Sub configDirs(ByVal fileName As String)

        Dim dirs() As String = Directory.GetDirectories(summaryGenDir, "*")
        Dim dirFiles() As String = Directory.GetFiles(summaryGenDir, "*")

        For i As Integer = 0 To dirs.Length - 1
            Dim files() As String = Directory.GetFiles(dirs(i), "*")
            For j As Integer = 0 To files.Length - 1
                File.Delete(files(i))
            Next
        Next
        For j As Integer = 0 To dirFiles.Length - 1
            File.Delete(dirFiles(j))
        Next



        'Saving this reference so that I can reference the file itself in other contexts (like opening it in a new window)
        Session("SummaryFile") = stripBadChars(fileName) & ".htm"

        summaryFilePath = summaryGenDir & Session("SummaryFile")

        File.Copy(summaryDir & "Fig.htm", summaryFilePath)

    End Sub

    Protected Function stripBadChars(ByVal str As String) As String
        Dim badChars() As Char = {":", "/", "\", """", "*", "?", "<", ">", " ", "."}

        For i As Integer = 0 To badChars.Length - 1
            If str.Contains(badChars(i)) Then
                str = str.Replace(badChars(i), "_")
            End If
        Next
        Return str
    End Function

    Protected Sub summaryActionClick(ByVal sender As Object, ByVal e As System.EventArgs)

        Select Case summary_rbList.SelectedValue
            Case "Open"
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), "newWindow", "window.open('Summaries/Generated/" & Session("SummaryFile") & "','_blank');", True)

            Case "Save"
                Response.ContentType = "application/x-zip-compressed"
                Response.AppendHeader("Content-Disposition", "attachment; filename=" & stripBadChars(currentItemName) & ".zip")
                Response.TransmitFile("Summaries/Generated/Zips/" & stripBadChars(currentItemName) & ".zip")
                Response.End()

            Case "Email"
                client = New SmtpClient
                Dim msg As New MailMessage()
                Dim msgContent As String = ""
                Dim attachment As Attachment
                emailRecip = email_txt.Text.Trim

                msg.From = New MailAddress("maggy@zogglet.com")
                msg.To.Add(New MailAddress(emailRecip))

                msg.Subject = currentItemName & " - Summary from Maggy's Halo Action Figure Tracker"

                msgContent = "<p>Greetings from Maggy's Halo Action Figure Tracker.</p>" & _
                            "<p>Attached is your generated summary for the item, <b>" & currentItemName & "</b>." & _
                            "<p>Sincerely,<br /><a href='http://www.zogglet.com'>Zogglet</a></p>"
                msg.Body = msgContent
                msg.IsBodyHtml = True

                attachment = New Attachment(Session("ZipFile"))
                msg.Attachments.Add(attachment)

                client.SendAsync(msg, "Test")
                AddHandler client.SendCompleted, AddressOf sendComplete

        End Select
    End Sub

    Protected Sub sendComplete(ByVal sender As Object, ByVal e As System.ComponentModel.AsyncCompletedEventArgs) Handles client.SendCompleted
        If IsDBNull(e.Error) Then
            emailResultStr = "<span class='resultStyle'><p>Uh oh. Failure sending email.</p><p><b>Error details:</b> <br />" & e.Error.Message & "</p></span>"
        Else
            emailResultStr = "<span class='resultStyle'><p>Congratulations!</p><p>You've successfully sent a summary of the item, <b>" & currentItemName & "</b>, to <b>" & emailRecip & "</b>.</p></span>"
        End If

        summary_lit.Text = emailResultStr
        sumResult_innerDiv.Controls.Add(summary_lit)

        summary_rbList.SelectedValue = "Open"
        email_txt.Visible = False
        email_txt.Text = ""

        ScriptManager.RegisterStartupScript(Page, Me.GetType(), "id", "function pageLoad(){$find('summary_mpExt_behavior').show();}", True)
    End Sub


    Protected Sub onCloseSummaryClick(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim summary_mpExt As ModalPopupExtender = CType(figs_formView.FindControl("summary_mpExt"), ModalPopupExtender)
        summary_mpExt.Hide()
    End Sub

    Protected Sub onCloseClick(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim img_mpExt As ModalPopupExtender = CType(figs_formView.FindControl("img_mpExt"), ModalPopupExtender)
        img_mpExt.Hide()
    End Sub

    Protected Sub figs_sds_Inserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles figs_sds.Inserted
        Session("SelectedFig") = CType(e.Command.Parameters("@NewID").Value, Integer)
    End Sub

    Protected Sub menu_lbtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles menu_lbtn.Click
        Session("ItemList") = Nothing
        Response.Redirect("Default.aspx")
    End Sub


    Protected Sub figs_formView_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles figs_formView.ItemInserted
        Session("FromInserted") = True
        Session("RecentItem") = e.Values("ItemName")

        figs_formView.ChangeMode(FormViewMode.ReadOnly)

    End Sub

    Protected Sub figs_formView_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles figs_formView.ItemUpdated
        Session("FromUpdated") = True
        Session("RecentItem") = e.NewValues("ItemName")
    End Sub

    Protected Sub insertHaveCbxChanged(ByVal sender As Object, ByVal e As EventArgs)
        insertPending_cbx.Visible = Not insertHave_cbx.Checked

        If insertHave_cbx.Checked Then
            insertPending_cbx.Checked = False
        End If

    End Sub

    Protected Sub editHaveCbxChanged(ByVal sender As Object, ByVal e As EventArgs)
        editPending_cbx.Visible = Not editHave_cbx.Checked

        If editHave_cbx.Checked Then
            editPending_cbx.Checked = False
        End If

    End Sub

    Protected Sub showChangedResult(ByVal inserted As Boolean)
        changed_lit.Text = IIf(inserted, "<span class='resultStyle'><p>Congratulations!</p><p>You've successfully added the item, <b>" & Session("RecentItem") & "</b>, to the database.</p>" & IIf(Session("Resized") = True, "<p>The image has been resized.</p>", "") & "</span>", "<span class='resultStyle'><p>Congratulations!</p><p>You've successfully updated the item, <b>" & Session("RecentItem") & "</b>.</p>" & IIf(Session("Resized") = True, "<p>The image has been resized.</p>", "") & IIf(Session("ImageDeleted") = True, "<p>The image has been deleted.</p>", "") & "</span>")
        changed_innerDiv.Controls.Add(changed_lit)

        changed_dsExt.Enabled = True
        changed_updatePnl.Update()
        changed_mpExt.Show()

    End Sub

    Protected Sub onOkClick(ByVal Sender As Object, ByVal e As System.EventArgs)
        changed_mpExt.Hide()

    End Sub

    Protected Sub qlMeth_click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("Methodology.aspx")
    End Sub

    Protected Sub qlOther_click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("EditOthers.aspx")
    End Sub

    Protected Sub figs_formView_ItemDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewDeleteEventArgs) Handles figs_formView.ItemDeleting
        If e.Values("Image") IsNot Nothing And File.Exists(imgDir & e.Values("Images")) Then
            File.Delete(imgDir & e.Values("Images"))
        End If
    End Sub

    Public Sub validateDate(ByVal sender As Object, ByVal args As ServerValidateEventArgs)
        Dim dt As DateTime
        args.IsValid = DateTime.TryParse(args.Value, dt)
    End Sub

    Private Sub setPostbackTriggers()
        Dim insert_btn As Button
        Dim update_btn As Button
        If figs_formView.CurrentMode = FormViewMode.Edit Then
            update_btn = CType(figs_formView.FindControl("update_btn"), Button)
            ScriptManager.GetCurrent(Page).RegisterPostBackControl(update_btn)
        End If

        If figs_formView.CurrentMode = FormViewMode.Insert Then
            insert_btn = CType(figs_formView.FindControl("insert_btn"), Button)
            ScriptManager.GetCurrent(Page).RegisterPostBackControl(insert_btn)
        End If
    End Sub
End Class
