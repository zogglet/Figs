<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    
    <title>Maggy's Halo Action Figure Tracker &raquo; Log In</title>
    
    <link href="favicon.ico" rel="icon" type="image/x-icon" />
    <link href="figs.css" rel="stylesheet" type="text/css" />
    
</head>
<body>
    <form id="form1" runat="server">
        
        <div id="outer_div">
        
            <table id="blank_outer_table">
            
                <tr>
                    <td align="center">
                        <h2>Maggy's Halo Action Figure Tracker</h2>
                        <br /><h3>Log In</h3>
                    </td>
                </tr>
                
                <tr>
                    <td class="General" align="left">
                        <asp:LinkButton ID="menu_lbtn" runat="server" Text="Return to Main Menu" />
                        
                        <br /><span class="BigDivider">&nbsp;</span>
                        <br />
                    </td>
                </tr>
                
                <tr>
                
                    <td align="center">
                        
                        <asp:Login ID="Login1" runat="server" DisplayRememberMe="False" font-size="12px" BackColor="#f3faf2" BorderColor="#e2e9e2"
                         BorderPadding="4" BorderStyle="Solid" BorderWidth="4px" Width="250px" ForeColor="#566666">
                            <InstructionTextStyle Font-Italic="True" ForeColor="#566666" />
                            <TitleTextStyle BackColor="#7c9393" Font-Bold="True" ForeColor="#bdeaac" />
                            <TextBoxStyle CssClass="InputStyle" />
                            <LoginButtonStyle CssClass="ButtonStyle" />
                        </asp:Login>
                        <br />
                        <asp:PasswordRecovery ID="PasswordRecovery1" runat="server" BackColor="#f3faf2" BorderColor="#e2e9e2"
                         BorderPadding="4" BorderStyle="Solid" BorderWidth="4px" Width="250px" Font-Size="12px" ForeColor="#566666">
                            <InstructionTextStyle Font-Italic="True" ForeColor="#566666" />
                            <SuccessTextStyle Font-Bold="True" ForeColor="#566666" />
                            <TitleTextStyle BackColor="#7c9393" Font-Bold="True" ForeColor="#bdeaac" />
                            <TextBoxStyle CssClass="InputStyle" />
                            <SubmitButtonStyle CssClass="ButtonStyle" />
                        </asp:PasswordRecovery>
                        
                        <br /><span class="BigDivider">&nbsp;</span>
                        
                    </td>
                
                </tr>
                
            
            </table>
        
            <p class="copyright">
                Copyright &copy; 2011, <a href="mailto:maggy@zogglet.com?subject=About your awesome Halo Action Figure Tracker">Maggy Maffia</a>
            </p>

        </div>
    </form>
</body>
</html>
