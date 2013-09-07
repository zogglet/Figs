Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class AutoComplete
    Inherits System.Web.Services.WebService

    <WebMethod()> _
    Public Function GetCompletionList(ByVal prefixText As String, ByVal count As Integer) As String()

        'List of possible names
        Dim names() As String = {"Alex", "Chris", "Bob", "Oliver", "Neal", "Carl", "Buck", "Dan", "Andrew", "Frank", "Ike", "Jim", "Louey", "Matt", "Randy", "Stu", "Vinny", "Will", "Tim", "Sean", "Patrick", "Harry", "Henry", "Ryan", "Dave", "Chris", "Ed", "Marc", "Johnny", "Eric", "Geoff", "Paul"}

        'Return name match
        Return (From n In names Where n.StartsWith(prefixText, StringComparison.CurrentCultureIgnoreCase) Select n).Take(count).ToArray()

    End Function

End Class
