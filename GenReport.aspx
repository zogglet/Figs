<%@ Page Language="VB" AutoEventWireup="false" CodeFile="GenReport.aspx.vb" Inherits="GenReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Maggy's Halo Action Figure Tracker &raquo; Generate Report</title>
    
    <link href="favicon.ico" rel="icon" type="image/x-icon" />
    <link href="figs.css" rel="stylesheet" type="text/css" />
    
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
                    <td align="left">
                        <asp:LinkButton ID="menu_lbtn" runat="server" Text="Return to Main Menu" CausesValidation="false" />
                        <b>&nbsp;/&nbsp;</b>
                        <asp:LinkButton ID="return_lbtn" runat="server" Text="Return to List Generator" CausesValidation="false" />
                        <br /><span class="BigDivider">&nbsp;</span>
                    </td>
                </tr>
                
                <tr>
                    <td align="left">
                    
                        <asp:DropDownList ID="formats_ddl" runat="server" CssClass="DDLStyle">
                            <asp:ListItem Text="-- Select Format --" Value="-1" />
                            <asp:ListItem Text="PDF" Value="PDF" />
                            <asp:ListItem Text="Excel" Value="EXCEL" />
                            <asp:ListItem Text="Image (TIFF)" Value="IMAGE" />
                         </asp:DropDownList>
                         
                         &nbsp;<asp:Button ID="genReport_btn" runat="server" Text="Generate Report &raquo;" CssClass="ButtonStyle" />
                        
                        <asp:CompareValidator ID="format_cVal" runat="server" ControlToValidate="formats_ddl" Operator="NotEqual" ValueToCompare="-1" ErrorMessage="Select a format for export." Display="None" />
                        <asp:ValidatorCalloutExtender id="format_vcExt" runat="server" TargetControlID="format_cVal" 
                            WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" Width="200px" />
                            
                            
                        
                    </td>
                </tr>
                
            </table>
            
        </div>
    </form>
</body>
</html>
