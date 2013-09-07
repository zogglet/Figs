<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ViewReport.aspx.vb" Inherits="Figs_ViewReport" Async="true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="mag" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    
    <title>Maggy's Halo Action Figure Tracker &raquo; Generate Report</title>
    
    <link href="favicon.ico" rel="icon" type="image/x-icon" />
    <link href="figs.css" rel="stylesheet" type="text/css" />

    <script src="scripts/jquery-1.4.4.js" type="text/javascript"></script>
    
    <script type="text/javascript">

        //Prevents Timer from snapping to the top of the page on each tick
        function scrollTo() {
            return;
        }

        $(document).ready(function() {

            //Clear default text upon click
            $('#email_txt').focus(function() {

                if (this.value == this.defaultValue) {
                    this.value = '';
                } else {
                    this.select();
                }
            });
            //Show default text again when out of focus (if the value wasn't changed)
            $('#email_txt').blur(function() {
                if ($.trim(this.value) == '') {
                    this.value = (this.defaultValue ? this.defaultValue : '');
                }
            });

        });
        
    </script>
    
    
</head>
<body>
    <form id="form1" runat="server">
    
        <%--Required for use of AJAX Control Toolkit --%>
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
            
            <table id="outer_table">
            
                <tr>
                    <td align="center">
                        <h2>Maggy's Halo Action Figure Tracker</h2>
                        <br /><h3>View/Generate Report</h3>
                    </td>
                </tr>
                
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
                                
                                    <div class="LoginStatusStyle">
                                        <asp:LoginView ID="loginView" runat="server">
                                            <AnonymousTemplate>
                                                <i>Currently logged out</i>
                                                <br />
                                                <asp:LoginStatus ID="loginStatus" runat="server" LoginText="[Log In]" LogoutText="[Log Out]" />
                                            </AnonymousTemplate>
                                            <LoggedInTemplate>
                                                <asp:LoginName ID="loginName" runat="server" FormatString="Welcome, <b>{0}</b>!" />
                                                <br />
                                                <asp:LoginStatus ID="loginStatus" runat="server" LoginText="[Log In]" LogoutText="[Log Out]" />
                                                
                                                <asp:CollapsiblePanelExtender ID="quickLinks_cpExt" runat="server" TargetControlID="quickLinks_pnl" CollapsedSize="0" 
                                                    Collapsed="true" CollapsedImage="collapsed.png" ExpandedImage="expanded.png" ExpandControlID="cpControl_pnl" 
                                                    CollapseControlID="cpControl_pnl" TextLabelID="cpControl_lbl" ImageControlID="cpControl_img" CollapsedText="View Quick Links" 
                                                    ExpandedText="Hide Quick Links" />


                                                <asp:Panel ID="cpControl_pnl" runat="server">
                                                    <asp:Image ID="cpControl_img" runat="server" ImageUrl="collapsed.png" />
                                                    <asp:Label ID="cpControl_lbl" runat="server" Text="View Quick Links" CssClass="CollapsePanelText" />
                                                </asp:Panel>
                                                
                                                <asp:Panel ID="quickLinks_pnl" runat="server" CssClass="QLMenuStyle">
                                                    <asp:LinkButton ID="qlMeth_lBtn" runat="server" Text="M.O.A.U.H.A.F.C.M." OnClick="qlMeth_click"  />
                                                    
                                                    <asp:HoverMenuExtender ID="methodology_hmExt" runat="server" TargetControlID="qlMeth_lBtn" PopupControlID="tooltip_pnl" PopupPosition="Left" 
                                                            OffsetX="-20" OffsetY="-3" HoverDelay="0" />
                                                        
                                                    <asp:Panel ID="tooltip_pnl" runat="server" CssClass="QLTooltipStyle" Width="150px">
                                                        <i><b>M</b>aggy's <b>O</b>bsessive <b>a</b>nd <b>U</b>nnecessary <b>H</b>alo <b>A</b>ction <b>F</b>igure <b>C</b>ollecting <b>M</b>ethodology</i>
                                                    </asp:Panel>
                                                        
                                                    <br /><asp:LinkButton ID="qlNewItem_lBtn" runat="server" Text="Add New Item" OnClick="qlAddNew_click" />
                                                    <br /><asp:LinkButton ID="qlList_btn" runat="server" Text="Filter/Search List" OnClick="qlList_Click" />
                                                    <br /><asp:LinkButton ID="qlOthers_lBtn" runat="server" Text="Edit Other Details" OnClick="qlOther_click" />
                                                </asp:Panel>
                                                
                                            </LoggedInTemplate>
                                        </asp:LoginView>
                                    </div>
                                    
                                </td>
                            </tr>
                        </table>

                    </td>
                </tr>
                
                <tr>
                    <td class="General" align="left">
                        <asp:LinkButton ID="menu_lbtn" runat="server" Text="Return to Main Menu" CausesValidation="false" />
                        <b>&nbsp;/&nbsp;</b>
                        <asp:LinkButton ID="return_lbtn" runat="server" Text="Return to List Generator" CausesValidation="false" />
                        <br /><span class="BigDivider">&nbsp;</span>
                    </td>
                </tr>
                
                <tr>
                
                    <td align="left">
                    
                        <p class="detail">- Check a NULL checkbox for any options by which you do not want to filter the data for the report.
                            <br />- Click "View Report" to generate the report
                        </p>
                        
                        <br />
                        <mag:ReportViewer ID="figs_rv" runat="server" Width="100%" Height="100%" BackColor="#7c9393" ForeColor="#bdeaac" BorderColor="#566666" 
                            SizeToReportContent="true" AsyncRendering="false" ProcessingMode="Remote" ShowCredentialPrompts="true" />
                            
                    </td>
                    
                </tr>
                
                <tr>
                    <td>
                        <span class="Divider">&nbsp;</span>
                        <br />
                    </td>
                </tr>
                
                <tr>
                    <td align="right">
                    
                        <%--[e]: To show only when a report is generated--%>
                        <asp:Panel id="sendExport_pnl" runat="server">
                        
                            Email Exported Report: 
                            <asp:TextBox ID="email_txt" runat="server" Text="Email Address" />
                            &nbsp;
                            <asp:DropDownList ID="formats_ddl" runat="server" CssClass="DDLStyle">
                                <asp:ListItem Text="-- Select Format --" Value="-1" />
                                <asp:ListItem Text="PDF" Value="PDF" />
                                <asp:ListItem Text="Excel" Value="EXCEL" />
                                <asp:ListItem Text="Image (TIFF)" Value="IMAGE" />
                            </asp:DropDownList>
                            
                            &nbsp;<asp:Button ID="send_btn" runat="server" Text="Send &raquo;" CssClass="ButtonStyle" />
                            
                            <asp:CompareValidator ID="format_cVal" runat="server" ControlToValidate="formats_ddl" Operator="NotEqual" ValueToCompare="-1" ErrorMessage="Select a format for export." Display="None" />
                            <asp:ValidatorCalloutExtender id="format_vcExt" runat="server" TargetControlID="format_cVal" 
                                WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" Width="200px" />
                                
                            <asp:RequiredFieldValidator ID="email_rVal" runat="server" ControlToValidate="email_txt" ErrorMessage="Email address is required." Display="None" />
                            <asp:ValidatorCalloutExtender ID="email_vcExt" runat="server" TargetControlID="email_rVal" 
                                WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" Width="200px" />
                                
                            <asp:RegularExpressionValidator ID="email_reVal" runat="server" ControlToValidate="email_txt" ErrorMessage="Invalid email address." Display="None" 
                                ValidationExpression="[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)\b" />
                            <asp:ValidatorCalloutExtender ID="email_vcExt2" runat="server" TargetControlID="email_reVal" 
                                WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" Width="200px" />
                        </asp:Panel>
                        
                        <%--Currently does not show, as the panel it targets is not shown until the firing of the sendCompleted event
                        <asp:DropShadowExtender ID="sent_dsExt" runat="server" TargetControlID="sent_pnl" Opacity=".15" Width="4" TrackPosition="true" BehaviorID="sent_dsExt_behavior" />--%>
                        
                        <%--Modal popup to display upon sending the email--%>
                        <asp:ModalPopupExtender ID="sent_mpExt" runat="server" TargetControlID="dummy" PopupControlID="sent_pnl" BehaviorID="sent_mpExt_behavior" />
                        
                        <%-- Hidden button for the initial TargetControlID of the ModalPopupExtender (the modal popup will be triggered dynamically, using the UpdatePanel's 
                        AsynchronousPostbackTrigger)--%>
                        <input type="button" id="dummy" runat="server" style="display: none;" />
                        
                        <asp:Panel ID="sent_pnl" runat="server" CssClass="modalStyle" Width="300px" Visible="false">
                        
                            <asp:UpdatePanel ID="sent_updatePnl" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <div id="sent_innerDiv" runat="server"></div>
                                </ContentTemplate>
                                
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="send_btn" EventName="click" />
                                    <asp:AsyncPostBackTrigger ControlID="ok_btn" EventName="click" />
                                </Triggers>
                            </asp:UpdatePanel>
                            
                            <br />
                            <asp:Button ID="ok_btn" runat="server" Text="Ok" OnClick="onOkClick" CssClass="ButtonStyle" />
                            
                        </asp:Panel>
                        
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
