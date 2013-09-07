<%@ Page Language="VB" AutoEventWireup="false" Async="true" CodeFile="EditFig.aspx.vb" Inherits="Figs_EditFig" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Maggy's Halo Action Figure Tracker &raquo; Edit Figure Details</title>
    
    <link href="favicon.ico" rel="icon" type="image/x-icon" />
    <link href="figs.css" rel="stylesheet" type="text/css" />
    
    <%--Core jQuery Library--%>
    <script src="scripts/jquery-1.4.4.js" type="text/javascript"></script>
    
    <script type="text/javascript">

        //Prevents Timer from snapping to the top of the page on each tick
        function scrollTo() {
            return;
        }
    
        // Just in case I need it... 
        $(document).ready(function() {

            
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
                                                    <asp:LinkButton ID="qlMeth_lBtn" runat="server" Text="M.O.A.U.H.A.F.C.M." OnClick="qlMeth_click" CausesValidation="false" />
                                                    
                                                    <asp:HoverMenuExtender ID="methodology_hmExt" runat="server" TargetControlID="qlMeth_lBtn" PopupControlID="tooltip_pnl" PopupPosition="Left" 
                                                            OffsetX="-20" OffsetY="-3" HoverDelay="0" />
                                                        
                                                    <asp:Panel ID="tooltip_pnl" runat="server" CssClass="QLTooltipStyle" Width="150px">
                                                        <i><b>M</b>aggy's <b>O</b>bsessive <b>a</b>nd <b>U</b>nnecessary <b>H</b>alo <b>A</b>ction <b>F</b>igure <b>C</b>ollecting <b>M</b>ethodology</i>
                                                    </asp:Panel>
                                                    
                                                    <br /><asp:LinkButton ID="qlList_btn" runat="server" Text="Filter/Search List" OnClick="listClick" CausesValidation="false"  />
                                                    <br /><asp:LinkButton ID="qlOthers_lBtn" runat="server" Text="Edit Other Details" OnClick="qlOther_click" CausesValidation="false" />
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
                    <td align="center">
                        <h2>Maggy's Halo Action Figure Tracker</h2>
                        <br /><h3>Add/Edit/Delete Figure Details</h3>
                    </td>
                </tr>
                
                <tr>
                    <td align="left">
                        <asp:LinkButton ID="menu_lbtn" runat="server" Text="Return to Main Menu" CommandName="Cancel" CausesValidation="false" />
                        <b>&nbsp;/&nbsp;</b>
                        <asp:LinkButton ID="return_lbtn" runat="server" Text="Return to List Generator" CommandName="Cancel" CausesValidation="false" OnClick="listClick" />
                        <br /><span class="BigDivider">&nbsp;</span>
                    </td>
                </tr>
                
                <tr>
                
                    <td align="center">
                    
                        <asp:FormView ID="figs_formView" runat="server" DataKeyNames="ID" DataSourceID="figs_sds">
                        
                            <HeaderTemplate>
                                <table class="Formview_tbl">
                            </HeaderTemplate>
                            
                            <EditItemTemplate>
                                <tr>
                                    <td>
                                        Item Name:
                                        <br /><asp:TextBox ID="itemName_txt" runat="server" Text='<%#Bind("ItemName") %>' Width="150px" />
                                        
                                        <asp:RequiredFieldValidator ID="itemName_rVal" runat="server" ErrorMessage="Item Name is required." ControlToValidate="itemName_txt" 
                                            Display="None" />
                                        <asp:ValidatorCalloutExtender ID="itemName_vcExt" runat="server" TargetControlID="itemName_rVal" 
                                            WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                        
                                    </td>
                                    
                                    <td>
                                        Item Type:
                                        <br /><asp:DropDownList ID="type_ddl" runat="server" DataSourceID="type_sds" SelectedValue='<%#Bind("ItemTypeID")%>' DataTextField="TypeName" DataValueField="ID" CssClass="DDLStyle" />
                                        
                                        <asp:CompareValidator ID="type_cVal" runat="server" ControlToValidate="type_ddl" Operator="NotEqual" ValueToCompare="-1" ErrorMessage="Item Type is required." Display="None" />
                                        <asp:ValidatorCalloutExtender ID="type_vcExt" runat="server" TargetControlID="type_cVal" 
                                            WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                        
                                    </td>
                                    
                                    <td>
                                        Series/Wave: 
                                        <br /><asp:TextBox ID="series_txt" runat="server" Text='<%#Bind("Series") %>' Width="100px" />
                                        <p class="detail">Separate a series within a series with a semicolon (i.e.: Armory Series 1 would be "Armory;1")</p>
                                        
                                        <asp:RequiredFieldValidator ID="series_rVal" runat="server" ErrorMessage="Series/Wave is required." ControlToValidate="series_txt" 
                                            Display="None" />
                                        <asp:ValidatorCalloutExtender ID="series_vcExt" runat="server" TargetControlID="series_rVal" 
                                            WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                    </td>
                                    
                                    
                                </tr>
                                
                                <tr>
                                    
                                     <td>
                                        Associated Game:
                                        <br /><asp:Dropdownlist ID="game_ddl" runat="server" DataSourceID="game_sds" SelectedValue='<%#Bind("GameID")%>' DataTextField="Title" DataValueField="ID" CssClass="DDLStyle" />
                                        
                                        <asp:CompareValidator ID="game_cVal" runat="server" ControlToValidate="game_ddl" Operator="NotEqual" ValueToCompare="-1" ErrorMessage="Associated Game is required." Display="None" />
                                        <asp:ValidatorCalloutExtender ID="game_vcExt" runat="server" TargetControlID="game_cVal" 
                                            WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                        
                                    </td>
                                    
                                    <td>
                                        Manufacturer:
                                        <br /><asp:DropDownList ID="manu_ddl" runat="server" DataSourceID="manu_sds" SelectedValue='<%#Bind("ManufacturerID")%>' DataTextField="Name" DataValueField="ID" CssClass="DDLStyle" />
                                        
                                    </td>
                                    
                                    <td>
                                        Release Date:
                                        <br /><asp:TextBox ID="releaseDate_txt" runat="server" Text='<%#Bind("ReleaseDate") %>' Width="100px" />
                                        <asp:CalendarExtender ID="releaseDate_calExt" runat="server" TargetControlID="releaseDate_txt" DefaultView="Days" />
                                        
                                        <asp:CompareValidator ID="releaseDate_cVal" runat="server" ErrorMessage="Enter a valid date." Type="Date" 
                                            operator="DataTypeCheck" ControlToValidate="releaseDate_txt" Display="None" />
                                        <asp:ValidatorCalloutExtender ID="releaseDate_vcExt" runat="server" TargetControlID="releaseDate_cVal" WarningIconImageUrl="alertIcon.png"
                                            CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                            
                                        <asp:RequiredFieldValidator ID="releaseDate_rVal" runat="server" ErrorMessage="Release date is required." ControlToValidate="releaseDate_txt" 
                                            Display="None" />
                                        <asp:ValidatorCalloutExtender ID="releaseDate_vcExt2" runat="server" TargetControlID="releaseDate_rVal" 
                                            WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                    </td>
                                    
                                </tr>
                                
                                <tr>
                                
                                    <td colspan="2">
                                                                
                                        <asp:UpdatePanel ID="pending_updatePnl" runat="server" UpdateMode="Conditional">
                                        
                                            <ContentTemplate>
                                                <asp:CheckBox ID="editHave_cbx" runat="server" Checked='<%#Bind("Have")%>' Text="Obtained" AutoPostBack="true" OnCheckedChanged="editHaveCbxChanged" />
                                        
                                                &nbsp;<asp:CheckBox ID="editPending_cbx" runat="server" Checked='<%#Bind("Pending") %>' Text="Pending" Visible='<%#isPendingvisible(Eval("Have")) %>' />
                                            </ContentTemplate>
                                            
                                            <Triggers>
                                                <asp:AsyncPostBackTrigger ControlID="editHave_cbx" EventName="CheckedChanged" />
                                            </Triggers>
                                        </asp:UpdatePanel>
                                        
                                    </td>
                                </tr>
                                
                                <tr>
                                
                                    <td colspan="3">
                                        <span class="Divider">&nbsp;</span>
                                    </td>
                                
                                </tr>
                                
                                <tr>
                                
                                    <td>
                                        Version:
                                        <br /><asp:TextBox ID="version_txt" runat="server" Text='<%#Bind("Version") %>' Width="100px" />
                                    </td>
                                    
                                    <td>
                                        Variant:
                                        <br /><asp:TextBox ID="variant_txt" runat="server" Text='<%#Bind("Variant")%>' Width="150px" />
                                    </td>
                                    
                                    <td>
                                        Exclusivity: 
                                        <br /><asp:TextBox ID="exclusivity_txt" runat="server" Text='<%#Bind("Exclusivity") %>' Width="150px" />
                                        <p class="detail">Use a semicolon to separate multiple venders to which the item is exclusive (i.e.: "GameStop;Wal-Mart")</p>
                                    </td>

                                </tr>
                                
                                <tr>
                                
                                    <td>
                                        Production Limit:
                                        <br /><asp:TextBox ID="prodLimit_txt" runat="server" Text='<%#Bind("ProductionLimit")%>' Width="50px" />
                                    </td>
                                
                                    <td>
                                        Serial Number:
                                        <br /><asp:TextBox id="serial_txt" runat="server" Text='<%#Bind("Serial")%>' Width="100px" />
                                    </td>
                                    
                                    <td>
                                        Featured Image: <asp:Label ID="imgData_lbl" runat="server" CssClass="FormviewLbl" Text='<%#formatImgText(eval("Image"), eval("Resized"))%>' />
                                        <br /><asp:FileUpload ID="img_uploader" runat="server" CssClass="InputStyle" />
                                        <asp:HiddenField ID="img_hField" runat="server" Value='<%#Bind("Image") %>' />

                                        <div ID="resize_div" runat="server" visible='<% #isResizeAvailable(eval("Image"), 640) %>'>
                                            <asp:Literal ID="resize_lit" runat="server" Text='<%#formatResizeText(eval("Image")) %>' />
                                            <asp:CheckBox id="resize_cbx" runat="server" Text="Resize &amp; Optimize" />
                                        </div>
                                        <asp:CheckBox ID="deleteImg_cbx" runat="server" Visible='<%#isVisible(eval("Image")) %>' Text="Delete" />
                      
                                    </td>
                                    
                                </tr>
                                
                                <tr>
                 
                                    <td colspan="3">
                                    
                                        <table>
                                            <tr>
                                                <td>
                                                     Description:
                                                    <br /><asp:TextBox ID="desc_txt" runat="server" Text='<%#Bind("Description")%>' TextMode="Multiline" Wrap="true" CssClass="InputStyle" Width="235px" Height="75px" />
                                                </td>
                                                <td>
                                                     My Notes:
                                                    <br /><asp:TextBox ID="notes_txt" runat="server" Text='<%#Bind("MyNotes")%>' TextMode="MultiLine" Wrap="true" CssClass="InputStyle" Width="235px" Height="75px" />
                                                </td>
                                            </tr>
                                        </table>
                                       
                                    </td>
                                    
                                </tr>
                                
                                <tr>
                                    <td colspan="3">
                                        <span class="BigDivider">&nbsp;</span>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td colspan="3">
                                        <asp:Button ID="update_btn" runat="server" CausesValidation="true" CommandName="Update" Text="Update" CssClass="ButtonStyle" />
                                        &nbsp;&nbsp;
                                        <asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                    </td>
                                
                                </tr>
                            
                            </EditItemTemplate>
                            
                            <InsertItemTemplate>
                            
                                <tr>
                                    <td>
                                        Item Name:
                                        <br /><asp:TextBox ID="itemName_txt" runat="server" Text='<%#Bind("ItemName") %>' Width="150px" />
                                        
                                        <asp:RequiredFieldValidator ID="itemName_rVal" runat="server" ErrorMessage="Item name is required." ControlToValidate="itemName_txt" 
                                            Display="None" />
                                        <asp:ValidatorCalloutExtender ID="itemName_vcExt" runat="server" TargetControlID="itemName_rVal" 
                                            WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                        
                                    </td>
                                    
                                    <td>
                                        Item Type:
                                        <br /><asp:DropDownList ID="type_ddl" runat="server" DataSourceID="type_sds" SelectedValue='<%#Bind("ItemTypeID")%>' DataTextField="TypeName" DataValueField="ID" CssClass="DDLStyle" />
                                        
                                        <asp:CompareValidator ID="type_cVal" runat="server" ControlToValidate="type_ddl" Operator="NotEqual" ValueToCompare="-1" ErrorMessage="Item Type is required." Display="None" />
                                        <asp:ValidatorCalloutExtender ID="type_vcExt" runat="server" TargetControlID="type_cVal" 
                                            WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                    </td>
                                    
                                    <td>
                                        Series/Wave: 
                                        <br /><asp:TextBox ID="series_txt" runat="server" Text='<%#Bind("Series") %>' Width="100px" />
                                        <p class="detail">Separate a series within a series with a semicolon (i.e.: Armory Series 1 would be "Armory;1")</p>
                                        
                                        <asp:RequiredFieldValidator ID="series_rVal" runat="server" ErrorMessage="Series/Wave is required." ControlToValidate="series_txt" 
                                            Display="None" />
                                        <asp:ValidatorCalloutExtender ID="series_vcExt" runat="server" TargetControlID="series_rVal" 
                                            WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                    </td>
                                    
                                    
                                </tr>
                                
                                <tr>
                                    
                                     <td>
                                        Associated Game:
                                        <br /><asp:Dropdownlist ID="game_ddl" runat="server" DataSourceID="game_sds" SelectedValue='<%#Bind("GameID")%>' DataTextField="Title" DataValueField="ID" CssClass="DDLStyle" />
                                        
                                        <asp:CompareValidator ID="game_cVal" runat="server" ControlToValidate="game_ddl" Operator="NotEqual" ValueToCompare="-1" ErrorMessage="Associated Game is required." Display="None" />
                                        <asp:ValidatorCalloutExtender ID="game_vcExt" runat="server" TargetControlID="game_cVal" 
                                            WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                    </td>
                                    
                                    <td>
                                        Manufacturer:
                                        <br /><asp:DropDownList ID="manu_ddl" runat="server" DataSourceID="manu_sds" SelectedValue='<%#Bind("ManufacturerID")%>' DataTextField="Name" DataValueField="ID" CssClass="DDLStyle" />
                                        
                                    </td>
                                    
                                    <td>
                                        Release Date:
                                        <br /><asp:TextBox ID="releaseDate_txt" runat="server" Text='<%#Bind("ReleaseDate") %>' Width="100px" />
                                        <asp:CalendarExtender ID="releaseDate_calExt" runat="server" TargetControlID="releaseDate_txt" DefaultView="Days" />
                                        
                                        <asp:CompareValidator ID="releaseDate_cVal" runat="server" ErrorMessage="Enter a valid date." Type="Date" 
                                            operator="DataTypeCheck" ControlToValidate="releaseDate_txt" Display="None" />
                                        <asp:ValidatorCalloutExtender ID="releaseDate_vcExt" runat="server" TargetControlID="releaseDate_cVal" WarningIconImageUrl="alertIcon.png"
                                            CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                            
                                        <asp:RequiredFieldValidator ID="releaseDate_rVal" runat="server" ErrorMessage="Release date is required." ControlToValidate="releaseDate_txt" 
                                            Display="None" />
                                        <asp:ValidatorCalloutExtender ID="releaseDate_vcExt2" runat="server" TargetControlID="releaseDate_rVal" 
                                            WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                    </td>
                                    
                                </tr>
                                
                                <tr>
                                
                                    <td colspan="2">
                                        
 
                                       <asp:UpdatePanel ID="pending_updatePnl" runat="server" UpdateMode="Conditional">

                                            <ContentTemplate>
                                                <asp:CheckBox ID="insertHave_cbx" runat="server" Checked='<%#Bind("Have")%>' Text="Obtained" AutoPostBack="true" OnCheckedChanged="insertHaveCbxChanged" />
                                            
                                                &nbsp;<asp:CheckBox ID="insertPending_cbx" runat="server" Checked='<%#Bind("Pending") %>' Text="Pending" Visible='<%#isPendingvisible(Eval("Have")) %>' />
                                            </ContentTemplate>
                                            
                                            <Triggers>
                                                <asp:AsyncPostBackTrigger ControlID="insertHave_cbx" EventName="CheckedChanged" />
                                            </Triggers>
                                        </asp:UpdatePanel>

                                    </td>
                                </tr>
                                
                                <tr>
                                
                                    <td colspan="3">
                                        <span class="Divider">&nbsp;</span>
                                    </td>
                                
                                </tr>
                                
                                <tr>
                                
                                    <td>
                                        Version:
                                        <br /><asp:TextBox ID="version_txt" runat="server" Text='<%#Bind("Version") %>' Width="100px" />
                                    </td>
                                    
                                    <td>
                                        Variant:
                                        <br /><asp:TextBox ID="variant_txt" runat="server" Text='<%#Bind("Variant")%>' Width="150px" />
                                    </td>
                                    
                                    <td>
                                        Exclusivity: 
                                        <br /><asp:TextBox ID="exclusivity_txt" runat="server" Text='<%#Bind("Exclusivity") %>' Width="150px" />
                                        <p class="detail">Use a semicolon to separate multiple venders to which the item is exclusive (i.e.: "GameStop;Wal-Mart")</p>
                                    </td>
                                
                                </tr>
                                
                                <tr>
                                
                                    <td>
                                        Production Limit:
                                        <br /><asp:TextBox ID="prodLimit_txt" runat="server" Text='<%#Bind("ProductionLimit")%>' Width="50px" />
                                    </td>
                                
                                    <td>
                                        Serial Number:
                                        <br /><asp:TextBox id="serial_txt" runat="server" Text='<%#Bind("Serial")%>' Width="100px" />
                                    </td>

                                    <td>
                                        Featured Image:
                                        <br /><asp:FileUpload ID="img_uploader" runat="server" CssClass="InputStyle" />
                                        <asp:HiddenField ID="img_hField" runat="server" Value='<%#Bind("Image") %>' />
                                        <div ID="resize_div" runat="server" visible='<% #isResizeAvailable(eval("Image"), 640) %>'>
                                            <p class="detail">If this box is checked, the image will be resized if either dimensions are over 640px.</p>
                                            <asp:CheckBox ID="resize_cbx" runat="server" Text="Resize &amp; Optimize" />
                                        </div>

                                        
                                    </td>
                                    
                                </tr>
                                
                                <tr>
                 
                                    <td colspan="3">
                                    
                                        <table>
                                            <tr>
                                                <td>
                                                     Description:
                                                    <br /><asp:TextBox ID="desc_txt" runat="server" Text='<%#Bind("Description")%>' TextMode="Multiline" Wrap="true" CssClass="InputStyle" Width="235px" Height="75px" />
                                                </td>
                                                <td>
                                                     My Notes:
                                                    <br /><asp:TextBox ID="notes_txt" runat="server" Text='<%#Bind("MyNotes")%>' TextMode="MultiLine" Wrap="true" CssClass="InputStyle" Width="235px" Height="75px" />
                                                </td>
                                            </tr>
                                        </table>
                                       
                                    </td>
                                    
                                </tr>
                                
                                <tr>
                                    <td colspan="3">
                                        <span class="BigDivider">&nbsp;</span>
                                    </td>
                                </tr>
                            
                                <tr>
                                    <td colspan="3">
                                        <asp:Button ID="insert_btn" runat="server" CausesValidation="true" CommandName="Insert" Text="Add" CssClass="ButtonStyle" />
                                        &nbsp;&nbsp;
                                        <asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />

                                    </td>
                                </tr>
                            
                            
                            </InsertItemTemplate>
                            
                            <ItemTemplate>
                            
                                <tr>
                                    <td>
                                        Item Name:
                                        &nbsp;<asp:Label ID="itemName_lbl" runat="server" Text='<%#Bind("ItemName") %>' CssClass="FormviewLbl" />
                                        
                                    </td>
                                    
                                    <td>
                                        Item Type:
                                        &nbsp;<asp:Label ID="itemType_lbl" runat="server" Text='<%#Bind("TypeName") %>' CssClass="FormviewLbl" />
                                    </td>
                                    
                                    <td>
                                        Series/Wave: 
                                        &nbsp;<asp:Label ID="series_lbl" runat="server" Text='<%#Bind("Series") %>' CssClass="FormviewLbl" />
                                    </td>
                                    
                                    
                                </tr>
                                
                                <tr>
                                    
                                     <td>
                                        Associated Game:
                                        &nbsp;<asp:Label ID="game_lbl" runat="server" Text='<%#Bind("Title")%>' CssClass="FormviewLbl" />
                                    </td>
                                    
                                    <td>
                                        Manufacturer:
                                        &nbsp;<asp:Label ID="manu_lbl" runat="server" Text='<%#formatNullField(Eval("Name"))%>' CssClass="FormviewLbl" />
                                        
                                    </td>
                                    
                                    <td>
                                        Release Date:
                                        &nbsp;<asp:Label ID="releaseDate_lbl" runat="server" Text='<%#Bind("ReleaseDate") %>' CssClass="FormviewLbl" />
                                    </td>
                                    
                                </tr>
                                
                                <tr>
                                
                                    <td>
                                        Obtained:
                                        &nbsp;<asp:Label ID="have_lbl" runat="server" Text='<%#formatHaveTxt(Eval("Have"), Eval("Pending")) %>' CssClass="FormviewLbl" />
                                        
                                    </td>
                                </tr>
                                
                                <tr>
                                
                                    <td colspan="3">
                                        <span class="Divider">&nbsp;</span>
                                    </td>
                                
                                </tr>
                                
                                <tr>
                                
                                    <td>
                                        Version:
                                        &nbsp;<asp:Label ID="version_lbl" runat="server" Text='<%#formatNullField(Eval("Version"))%>' CssClass="FormviewLbl" />
                                    </td>
                                    
                                    <td>
                                        Variant:
                                        &nbsp;<asp:Label ID="variant_lbl" runat="server" Text='<%#formatNullField(Eval("Variant"))%>' CssClass="FormviewLbl" />
                                    </td>
                                    
                                    <td>
                                        Exclusivity:
                                        &nbsp;<asp:Label ID="exclusivity_lbl" runat="server" Text='<%#formatNullField(Eval("Exclusivity"))%>' CssClass="FormviewLbl" />
                                    </td>
                                    
                                </tr>
                                
                                <tr>
                                
                                    <td>
                                        Production Limit:
                                        &nbsp;<asp:Label ID="prodLimit_lbl" runat="server" Text='<%#formatNullField(Eval("ProductionLimit"))%>' CssClass="FormviewLbl" />
                                    </td>
                                
                                    <td>
                                        Serial Number:
                                        &nbsp;<asp:Label id="serial_lbl" runat="server" Text='<%#formatNullField(Eval("Serial"))%>' CssClass="FormviewLbl" />
                                    </td>
                                    
                                    <td>
                                        Featured Image:
                                        &nbsp;<asp:Label ID="image_lbl" runat="server" Text='<% #formatImgText(Eval("Image"), Eval("Resized")) %>' CssClass="FormviewLbl" />
                                        
                                        <br />
                                        <asp:LinkButton ID="showImg_lbtn" runat="server" Text="[View]" Visible='<%#isVisible(Eval("Image")) %>' OnClick="showImg" />
                                        
                                        
                                        <asp:DropShadowExtender ID="img_dsExt" runat="server" TargetControlID="img_pnl" Opacity=".15" TrackPosition="true" />
                                        
                                        <asp:ModalPopupExtender ID="img_mpExt" runat="server" TargetControlID="dummy" PopupControlID="img_pnl" />
                                            
                                       <%-- Hidden button for the initial TargetControlID of the ModalPopupExtender (the modal popup will be triggered dynamically, using the UpdatePanel's 
                                        AsynchronousPostbackTrigger)--%>
                                        <input type="button" id="dummy" runat="server" style="display: none;" />
                                        
                                        <%-- The content displayed as the Modal Popup--%>
                                        <asp:Panel ID="img_pnl" runat="server" CssClass="modalStyle">
                                        
                                            <asp:UpdatePanel ID="img_updatePnl" runat="server" UpdateMode="Conditional">
                                                
                                                <ContentTemplate>
                                                
                                                    <p><asp:Image ID="fig_img" runat="server" ImageUrl='<%# "images/" & Eval("Image") %>' BorderColor="#566666" BorderStyle="Solid" BorderWidth="1px" /></p>
                                                    <div id="img_innerDiv" runat="server"></div>
                                                </ContentTemplate>
                                                
                                                <Triggers>
                                                    <asp:AsyncPostBackTrigger ControlID="showImg_lBtn" EventName="click" />
                                                    <asp:AsyncPostBackTrigger ControlID="close_lBtn" EventName="click" />
                                                </Triggers>
                                                
                                            </asp:UpdatePanel>
                            
                                            <br />
                                            <span>
                                                <asp:LinkButton ID="close_lBtn" runat="server" Text="[Close]" OnClick="onCloseClick" />
                                            </span>
                                            
                                        </asp:Panel>
                                        
                                        
                                    </td>
                                    
                                </tr>
                                
                                <tr>
                                
                                    <td colspan="3">
                                    
                                        <table>
                                            <tr>
                                                <td>
                                                    Description:
                                                    &nbsp;<asp:Label ID="desc_lbl" runat="server" Text='<%#formatNullField(Eval("Description"))%>' TextMode="Multiline" Wrap="true" CssClass="FormviewLbl" Font-Italic="true" />
                                                </td>
                                                <td>
                                                     My Notes:
                                                     &nbsp;<asp:Label ID="myNotes_lbl" runat="server" Text='<%#formatNullField(Eval("MyNotes"))%>' TextMode="MultiLine" Wrap="true" CssClass="FormviewLbl" Font-Italic="true" />
                                                </td>
                                            </tr>
                                        
                                        </table>
                                    
                                    </td>

                                </tr>
                                
                                <tr>
                                    <td colspan="3">
                                        <span class="BigDivider">&nbsp;</span>
                                    </td>
                                </tr>
                            
                                <tr>
                                    <td colspan="2" style="border-right: solid 2px #e2e9e2;">
                                        <asp:Button ID="edit_btn" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" CssClass="ButtonStyle" />
                                        &nbsp;&nbsp;
                                        <asp:Button ID="delete_btn" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"
                                            OnClientClick="return confirm('Are you sure you want to delete this item?');" CssClass="ButtonStyle" />
                                        &nbsp;&nbsp;
                                        <asp:Button ID="new_btn" runat="server" CausesValidation="false" CommandName="New" Text="Add New Item" CssClass="ButtonStyle" />
                                    </td>
                                    <td>
                                        <span style="text-align:right; display:block;">
                                            <asp:Button ID="summary_btn" runat="server" CausesValidation="false" Text="Generate Summary" CssClass="ButtonStyle" OnClick="generateSummary" />
                                        </span>

                                        <asp:DropShadowExtender ID="summary_dsExt" runat="server" TargetControlID="summary_pnl" Opacity=".15" TrackPosition="true" />
                                        
                                        <asp:ModalPopupExtender ID="summary_mpExt" runat="server" TargetControlID="dummy2" PopupControlID="summary_pnl" BehaviorID="summary_mpExt_behavior" />
                                            
                                       <%-- Hidden button for the initial TargetControlID of the ModalPopupExtender (the modal popup will be triggered dynamically, using the UpdatePanel's 
                                        AsynchronousPostbackTrigger)--%>
                                        <input type="button" id="dummy2" runat="server" style="display: none;" />
                                        
                                        <%-- *** General Modal Popup for result of summary generation *** --%>
                                        <asp:Panel ID="summary_pnl" runat="server" CssClass="modalStyle" Width="350px">
                                           
                                            <asp:UpdatePanel ID="summary_updatePnl" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <div id="sumResult_innerDiv" runat="server"></div>
                                                </ContentTemplate>
                                                
                                                <Triggers>
                                                    <asp:AsyncPostBackTrigger ControlID="closeSummary_lBtn" EventName="Click" />
                                                    <asp:AsyncPostBackTrigger ControlID="summary_btn" EventName="Click" />
                                                </Triggers>
                                            </asp:UpdatePanel>
                            
                                            <br />
                                            <span>
                                                
                                                <asp:UpdatePanel ID="rbList_updatePanel" runat="server" UpdateMode="Conditional">
                                                
                                                    <ContentTemplate>
                                                        <table style="text-align:center; width:100%;">
                                                            <tr>
                                                                <td align="center">
                                                                    <asp:RadioButtonList ID="summary_rbList" runat="server" Autopostback="true" RepeatDirection="Horizontal" Font-Bold="true" OnSelectedIndexChanged="rbListChanged">
                                                                        <asp:ListItem Text="Open/View" Value="Open" />
                                                                        <asp:ListItem Text="Save" Value="Save" />
                                                                        <asp:ListItem Text="Email" Value="Email" />
                                                                    </asp:RadioButtonList>
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="email_txt" runat="server" Visible='<%#isEmailVisible() %>' CssClass="ModalInputStyle" />
                                                                    
                                                                    <asp:RequiredFieldValidator ID="email_rVal" runat="server" ControlToValidate="email_txt" ErrorMessage="Please provide an email address." Display="None" />
                                                                    <asp:ValidatorCalloutExtender ID="email_vcExt" runat="server" TargetControlID="email_rVal" 
                                                                        WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                                                        
                                                                    <asp:RegularExpressionValidator ID="email_reVal" runat="server" ControlToValidate="email_txt" ErrorMessage="Invalid email address." Display="None" 
                                                                        ValidationExpression="[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)\b" />
                                                                    <asp:ValidatorCalloutExtender ID="email_vcExt2" runat="server" TargetControlID="email_reVal" 
                                                                        WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle"  />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </ContentTemplate>
                                                    
                                                    <Triggers>
                                                        <asp:AsyncPostBackTrigger ControlID="summary_rbList" EventName="selectedIndexChanged" />
                                                    </Triggers>
                                                
                                                </asp:UpdatePanel>

                                                <br />
                                                <asp:Button ID="summaryAction_btn" runat="server" Text="Go &raquo;" CssClass="ButtonStyle" OnClick="summaryActionClick" />
                                                <br /><br />
                                                <asp:LinkButton ID="closeSummary_lBtn" runat="server" Text="[Close]" CausesValidation="false" OnClick="onCloseSummaryClick" />
                                                
                                            </span>
                                            
                                        </asp:Panel>

                                    </td>
                                </tr>
                            
                            </ItemTemplate>
                            
                            
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                        
                        </asp:FormView>
                        
                        
                        <asp:DropShadowExtender ID="changed_dsExt" runat="server" TargetControlID="changed_pnl" Opacity=".15" Width="4" TrackPosition="true" Enabled="false" />
                        
                        <%--Modal popup to display upon successfully updating or inserting an item--%>
                        <asp:ModalPopupExtender ID="changed_mpExt" runat="server" TargetControlID="dummy" PopupControlID="changed_pnl" />
                                        
                       <%-- Hidden button for the initial TargetControlID of the ModalPopupExtender (the modal popup will be triggered dynamically, using the UpdatePanel's 
                        AsynchronousPostbackTrigger)--%>
                        <input type="button" id="dummy" runat="server" style="display: none;" />
                        
                        <%-- The content displayed as the Modal Popup--%>
                        <asp:Panel ID="changed_pnl" runat="server" CssClass="modalStyle" Width="300px">
                        
                            <asp:UpdatePanel ID="changed_updatePnl" runat="server" UpdateMode="Conditional">
                                
                                <ContentTemplate>
                                    <div id="changed_innerDiv" runat="server"></div>
                                </ContentTemplate>
                                
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="ok_btn" EventName="click" />
                                </Triggers>
                                
                            </asp:UpdatePanel>
            
                            <br />
                            <asp:Button ID="ok_btn" runat="server" Text="Ok" OnClick="onOkClick" CssClass="ButtonStyle" CausesValidation="false" />
                            
                        </asp:Panel>
                    
                    </td>
                
                </tr>
                
            </table>
            
            <p class="copyright">
                Copyright &copy; 2011, <a href="mailto:maggy@zogglet.com?subject=About your awesome Halo Action Figure Tracker">Maggy Maffia</a>
            </p>
            
            <asp:SqlDataSource ID="game_sds" runat="server" ConnectionString="<%$ ConnectionStrings:FigsConnectionString %>" 
                 SelectCommand="SELECT ID, Title FROM Game UNION SELECT -1 AS ID, '--Select--' AS Title ORDER BY Title" />
                 
            <asp:SqlDataSource ID="type_sds" runat="server" ConnectionString="<%$ ConnectionStrings:FigsConnectionString %>" 
                 SelectCommand="SELECT ID, TypeName FROM ItemType UNION SELECT -1 AS ID, '--Select--' AS TypeName ORDER BY ID" />
                 
            <asp:SqlDataSource ID="manu_sds" runat="server" ConnectionString="<%$ ConnectionStrings:FigsConnectionString %>" 
                 SelectCommand="SELECT ID, Name FROM Manufacturer UNION SELECT -1 AS ID, '--Select--' AS Name ORDER BY Name" />
        
            <asp:SqlDataSource ID="figs_sds" runat="server" ConnectionString="<%$ ConnectionStrings:FigsConnectionString %>"
                SelectCommand="SELECT Figures.ID, ItemName, Version, GameID, Series, ItemTypeID, Variant, Exclusivity, Serial, Description, MyNotes, ProductionLimit, CONVERT(VarChar, ReleaseDate, 101) AS ReleaseDate, ManufacturerID, Have, Pending, Resized, ItemType.TypeName, Manufacturer.Name, Game.Title, Image FROM Figures INNER JOIN ItemType ON Figures.ItemTypeID = ItemType.ID LEFT JOIN Manufacturer ON Figures.ManufacturerID = Manufacturer.ID INNER JOIN Game on Figures.GameID = Game.ID WHERE Figures.ID = @ID"
                InsertCommand="INSERT INTO Figures (ItemName, Version, GameID, Series, ItemTypeID, Variant, Exclusivity, Serial, Description, MyNotes, ProductionLimit, ReleaseDate, ManufacturerID, Have, Pending, Resized, Image) VALUES (@ItemName, @Version, @GameID, @Series, @ItemTypeID, @Variant, @Exclusivity, @Serial, @Description, @MyNotes, @ProductionLimit, @ReleaseDate, @ManufacturerID, @Have, @Pending, @Resized, @Image);SET @NewID = SCOPE_IDENTITY()"
                DeleteCommand="DELETE FROM Figures WHERE ID = @ID"
                UpdateCommand="UPDATE Figures SET ItemName = @ItemName, Version = @Version, GameID = @GameID, Series = @Series, ItemTypeID = @ItemTypeID, Variant = @Variant, Exclusivity = @Exclusivity, Serial = @Serial, Description = @Description, MyNotes = @MyNotes, ProductionLimit = @ProductionLimit, ReleaseDate = @ReleaseDate, ManufacturerID = @ManufacturerID, Have = @Have, Pending = @Pending, Resized = @Resized, Image = @Image WHERE ID = @ID"
                >
                
                <SelectParameters>
                    <asp:SessionParameter Name="ID" SessionField="SelectedFig" Type="Int32" />
                </SelectParameters>
                
                <DeleteParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                </DeleteParameters>
                
                <UpdateParameters>
                    <asp:Parameter Name="ID" type="Int32" />
                    <asp:Parameter Name="ItemName" Type="String" />
                    <asp:Parameter Name="Version" Type="String" />
                    <asp:Parameter Name="GameID" Type="Int32" />
                    <asp:Parameter Name="Series" Type="String" />
                    <asp:Parameter Name="ItemTypeID" Type="Int32" />
                    <asp:Parameter Name="Variant" Type="String" />
                    <asp:Parameter Name="Exclusivity" Type="String" />
                    <asp:Parameter Name="Serial" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="MyNotes" Type="String" />
                    <asp:Parameter Name="ProductionLimit" Type="String" />
                    <asp:Parameter Name="ReleaseDate" Type="DateTime" />
                    <asp:Parameter Name="ManufacturerID" Type="Int32" />
                    <asp:Parameter Name="Have" Type="Boolean" />
                    <asp:Parameter Name="Pending" Type="Boolean" />
                    <asp:Parameter Name="Resized" Type="Boolean" />
                    <asp:Parameter Name="Image" Type="String" />
                </UpdateParameters>
                
                <InsertParameters>
                    <asp:Parameter Name="ItemName" Type="String" />
                    <asp:Parameter Name="Version" Type="String" />
                    <asp:Parameter Name="GameID" Type="Int32" />
                    <asp:Parameter Name="Series" Type="String" />
                    <asp:Parameter Name="ItemTypeID" Type="Int32" />
                    <asp:Parameter Name="Variant" Type="String" />
                    <asp:Parameter Name="Exclusivity" Type="String" />
                    <asp:Parameter Name="Serial" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="MyNotes" Type="String" />
                    <asp:Parameter Name="ProductionLimit" Type="String" />
                    <asp:Parameter Name="ReleaseDate" Type="DateTime" />
                    <asp:Parameter Name="ManufacturerID" Type="Int32" />
                    <asp:Parameter Name="Have" Type="Boolean" />
                    <asp:Parameter Name="Pending" Type="Boolean" />
                    <asp:Parameter Name="Resized" Type="Boolean" />
                    <asp:Parameter Name="Image" Type="String" />
                    <asp:Parameter Name="NewID" Type="Int32" Size="4" Direction="Output" />
                </InsertParameters>
                
            </asp:SqlDataSource>
        
        </div>
        
    </form>
</body>
</html>
