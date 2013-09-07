<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="Figs_Default" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <title>Welcome to Maggy's Halo Action Figure Tracker</title>
    
    <link href="favicon.ico" rel="icon" type="image/x-icon" />
    <link href="figs.css" rel="stylesheet" type="text/css" />
    
    <script type="text/javascript" language="javascript">

        //Prevents Timer from snapping to the top of the page on each tick
        function scrollTo() {
            return;
        }
    
    </script>
    
</head>
<body>
    <form id="form1" runat="server">
    
         <%--Required for use of AJAX Control Toolkit (see email validation in Newsletter sign-up area) --%>
        <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />
        
        
        <%--Session timeout modal popup--%>
        <asp:ModalPopupExtender ID="timeout_mpExt" runat="server" TargetControlID="timeout_pnl" PopupControlID="timeout_pnl" 
            OkControlID="preserveSession_btn" OnOkScript="__doPostBack('preserveSession_btn', '')" BehaviorID="timeout_mpExt_behavior" />
         
        <asp:Panel ID="timeout_pnl" runat="server" CssClass="modalStyle">
            <asp:UpdatePanel ID="timeout_updatePnl" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Literal ID="timeout_lit" runat="server" />
                </ContentTemplate>
                <Triggers>
                     <asp:AsyncPostBackTrigger ControlID="session_timer" EventName="Tick" />
                </Triggers>
            </asp:UpdatePanel>
            
            <br />
            <asp:Button ID="preserveSession_btn" runat="server" CssClass="ButtonStyle" CausesValidation="false" Text="Keep session active" />
        </asp:Panel>
        
        <asp:Timer ID="start_timer" runat="server" Interval="1000" Enabled="false" />
        <asp:Timer ID="session_timer" runat="server" Interval="1000" Enabled="false" />
        
        <%--****************************************************--%>
        
        <div id="outer_div">

            <table id="blank_outer_table">
                
                <tr>
                    
                    <td align="right">
                    
                        <table width="100%">
                            <tr>
                                <td class="CountdownCell">
                                
                                    <asp:UpdatePanel ID="inlineTimeout_updatePnl" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:Literal ID="inlineTimeout_lit" runat="server" />
                                        </ContentTemplate>
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger controlID="start_timer" EventName="Tick" />
                                            <asp:AsyncPostBackTrigger ControlID="session_timer" EventName="Tick" />
                                        </Triggers>
                                    </asp:UpdatePanel>
                            
                                </td>
                                <td align="right">
                                
                                    <div class="BlankLoginStatusStyle">
                                        <asp:LoginView ID="loginView" runat="server" >
                                            <AnonymousTemplate>
                                                <i>Currently logged out</i>
                                                <br />
                                                <asp:LoginStatus ID="loginStatus" runat="server" LoginText="[Log In]" LogoutText="[Log Out]" />
                                            </AnonymousTemplate>
                                            <LoggedInTemplate>
                                                <asp:LoginName ID="loginName" runat="server" FormatString="Welcome, <b>{0}</b>!" />
                                                <br />
                                                <asp:LoginStatus ID="loginStatus" runat="server" LoginText="[Log In]" LogoutText="[Log Out]" />
                                            </LoggedInTemplate>
                                        </asp:LoginView>
                                    </div>
                                
                                </td>
                            </tr>
                        </table>
                    
                    </td>
                </tr>
                
                <tr>
                    <td>
                        <h2>Maggy's Halo Action Figure Tracker</h2>
                        <br /><h3>Main Menu</h3>
                    </td>
                </tr>
                
                <tr>
                    <td>
                        <ul class="MainMenuStyle">
                            <li>
                                <asp:LinkButton ID="methodology_lBtn" runat="server" Text="View M.O.A.U.H.A.F.C.M." />
                                
                                <asp:HoverMenuExtender ID="methodology_hmExt" runat="server" TargetControlID="methodology_lBtn" PopupControlID="tooltip_pnl" PopupPosition="Right" 
                                    OffsetX="-20" OffsetY="-3" HoverDelay="0" />
                                    
                                <asp:Panel ID="tooltip_pnl" runat="server" CssClass="tooltipStyle" Width="200px">
                                    <i><b>M</b>aggy's <b>O</b>bsessive <b>a</b>nd <b>U</b>nnecessary <b>H</b>alo <b>A</b>ction <b>F</b>igure <b>C</b>ollecting <b>M</b>ethodology</i>
                                </asp:Panel>
                            </li>
                            <li>
                                <asp:LinkButton ID="genList_btn" runat="server" Text="Filter/Search Figure List" />
                            </li>
                            <asp:loginview ID="something_loginView" runat="server">
                                <AnonymousTemplate>
                                    <li>
                                        <asp:LinkButton ID="login_lbtn" runat="server" Text="Log In" OnClick="on_login_click" />
                                    </li>
                                </AnonymousTemplate>
                                <LoggedInTemplate>
                                    <li>
                                         <asp:LinkButton ID="addNew_lbtn" runat="server" Text="Add New Item" OnClick="on_addNew_click" />
                                    </li>
                                    <li>
                                        <asp:LinkButton ID="others_lbtn" runat="server" Text="Manage Details" OnClick="on_others_click" />
                                    </li>
                                </LoggedInTemplate>
                            </asp:loginview>
                        </ul>
                        
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
