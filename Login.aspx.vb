
Partial Class Login
    Inherits System.Web.UI.Page

    Protected Sub menu_lbtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles menu_lbtn.Click
        Response.Redirect("Default.aspx")
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        SetFocus(CType(Login1.FindControl("UserName"), TextBox))
    End Sub
End Class
