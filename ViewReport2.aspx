<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ViewReport2.aspx.vb" Inherits="Figs_ViewReport2" Async="true" %>
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

        <div id="outer_div">
            
            <table id="outer_table">
            
                <tr>
                    <td align="center">
                        <h2>Maggy's Halo Action Figure Tracker</h2>
                        <br /><h3>View/Generate Report</h3>
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
                    
                        <asp:Button ID="genReport_btn" runat="server" Text="Generate the freaking report" CssClass="ButtonStyle" />
                        
                        <br />
                        <asp:Literal ID="result_lit" runat="server" />
                    
                      <%--  <p class="detail">- Check a NULL checkbox for any options by which you do not want to filter the data for the report.
                            <br />- Click "View Report" to generate the report
                        </p>
                        
                        <br />
                        <mag:ReportViewer ID="figs_rv" runat="server" Width="100%" Height="100%" BackColor="#7c9393" ForeColor="#bdeaac" BorderColor="#566666" 
                            SizeToReportContent="true" AsyncRendering="false" ProcessingMode="Remote" ShowCredentialPrompts="true" />
                            
                    --%>
                    </td>
                    
                </tr>
                
                <%--<tr>
                    <td>
                        <span class="Divider">&nbsp;</span>
                        <br />
                    </td>
                </tr>
                
                <tr>
                    <td align="right">
                    
                        <%--[e]: To show only when a report is generated
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
                        
                        <%--Modal popup to display upon sending the email
                        <asp:ModalPopupExtender ID="sent_mpExt" runat="server" TargetControlID="dummy" PopupControlID="sent_pnl" BehaviorID="sent_mpExt_behavior" />
                        
                        <%-- Hidden button for the initial TargetControlID of the ModalPopupExtender (the modal popup will be triggered dynamically, using the UpdatePanel's 
                        AsynchronousPostbackTrigger)
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
                </tr>--%>
            
            </table>
            
            <p class="copyright">
                Copyright &copy; 2011, <a href="mailto:maggy@zogglet.com?subject=About your awesome Halo Action Figure Tracker">Maggy Maffia</a>
            </p>
            
        </div>
        
        
    </form>
</body>
</html>
