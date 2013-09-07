<%@ Page Language="VB" AutoEventWireup="false" CodeFile="EditOthers.aspx.vb" Inherits="EditOthers" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Maggy's Halo Action Figure Tracker &raquo; Edit Other Details</title>
    
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
                                                        
                                                    <br /><asp:LinkButton ID="qlNewItem_lBtn" runat="server" Text="Add New Item" OnClick="qlAddNew_click" CausesValidation="false" />
                                                    <br /><asp:LinkButton ID="qlList_btn" runat="server" Text="Filter/Search List" OnClick="qlList_Click" CausesValidation="false"  />
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
                        <br /><h3>Add/Edit/Delete Other Details</h3>
                    </td>
                </tr>
                
                <tr>
                    <td align="left">
                        <asp:LinkButton ID="menu_lbtn" runat="server" Text="Return to Main Menu" CommandName="Cancel" CausesValidation="false" />
                        <br /><span class="BigDivider">&nbsp;</span>
                    </td>
                </tr>
                
                <tr>
                
                
                    <td align="left">
 
                        <%--Inner table for the FormViews--%>
                        <table width="100%">
                        
                            <tr align="center">
                                <td><h4>Item Type</h4></td>
                                <td><h4>Manufacturer</h4></td>
                                <td><h4>Game</h4></td>
                            </tr>

                            <tr>
                                
                                <%--Item Type--%>
                                <td align="left" class="InnerFV_tbl">
                                
                                    <asp:UpdatePanel ID="typeFV_updatePnl" runat="server" UpdateMode="Conditional">
                                    
                                        <ContentTemplate>
                                            <asp:DropdownList ID="type_ddl" runat="server" DataTextField="TypeName" DataValueField="ID" AutoPostBack="true" CssClass="DDLStyle" />
                                            
                                            <span class="Divider">&nbsp;</span>
                                            
                                            <asp:FormView ID="type_formView" runat="server" DataKeyNames="ID" DataSourceID="type_sds" Width="100%">
                                            
                                                <HeaderTemplate>
                                                    <table width="100%">
                                                </HeaderTemplate>
                                                
                                                <EditItemTemplate>
                                                        <tr>
                                                            <td>
                                                                Type Name:
                                                                <br />
                                                                <asp:TextBox id="type_txt" runat="server" Text='<%#Bind("TypeName") %>' />
                                                                
                                                                <asp:RequiredFieldValidator ID="typeName_rVal" runat="server" ValidationGroup="ItemTypeVGroup" ErrorMessage="Type Name is required." ControlToValidate="type_txt" 
                                                                    Display="None" />
                                                                <asp:ValidatorCalloutExtender ID="typeName_vcExt" runat="server" TargetControlID="typeName_rVal" 
                                                                    WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                                            </td>
                                                        <tr>
                                                            <td colspan="2">
                                                                <span class="Divider">&nbsp;</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <asp:Button ID="update_btn" runat="server" CausesValidation="true" ValidationGroup="ItemTypeVGroup" CommandName="Update" Text="Update" CssClass="ButtonStyle" />
                                                                &nbsp;&nbsp;
                                                                <asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                                            </td>
                                                            
                                                        </tr>
                                                </EditItemTemplate>
                                                
                                                <InsertItemTemplate>
                                                        <tr>
                                                            <td>
                                                                Type Name:
                                                                <br />
                                                                <asp:TextBox id="type_txt" runat="server" Text='<%#Bind("TypeName") %>' />
                                                                
                                                                <asp:RequiredFieldValidator ID="typeName_rVal" runat="server" ValidationGroup="ItemTypeVGroup" ErrorMessage="Type Name is required." ControlToValidate="type_txt" 
                                                                    Display="None" />
                                                                <asp:ValidatorCalloutExtender ID="typeName_vcExt" runat="server" TargetControlID="typeName_rVal" 
                                                                    WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                                            </td>
                                                        <tr>
                                                            <td colspan="2">
                                                                <span class="Divider">&nbsp;</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <asp:Button ID="insert_btn" runat="server" CausesValidation="true" ValidationGroup="ItemTypeVGroup" CommandName="Insert" Text="Add" CssClass="ButtonStyle" />
                                                                &nbsp;&nbsp;
                                                                <asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                                            </td>
                                                        </tr>
                                                </InsertItemTemplate>
                                                
                                                <ItemTemplate>
                                                
                                                    <tr>
                                                        <td>
                                                            Type Name:
                                                            <br />
                                                            <asp:Label id="type_lbl" runat="server" Text='<%#Bind("TypeName") %>' CssClass="FormviewLbl" />
                                                        </td>
                                                    </tr>
                                                    
                                                    <tr>
                                                        <td colspan="3">
                                                            <span class="Divider">&nbsp;</span>
                                                        </td>
                                                    </tr>
                                                    
                                                    <tr>
                                                        <td colspan="2">
                                                            <asp:Button ID="edit_btn" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" CssClass="ButtonStyle" />
                                                            &nbsp;&nbsp;
                                                            <asp:Button ID="delete_btn" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"
                                                                OnClientClick="return confirm('Are you sure you want to delete this type?');" CssClass="ButtonStyle" />
                                                        </td>
                                                    </tr>
                                                
                                                </ItemTemplate>
                                            </asp:FormView>
                                            
                                            <asp:Literal ID="typePrompt_lit" runat="server" />
                                            
                                        </ContentTemplate>
                                        
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="type_ddl" EventName="SelectedIndexChanged" />
                                            <asp:AsyncPostBackTrigger ControlID="type_formView" EventName="ModeChanged" />
                                            <asp:AsyncPostBackTrigger ControlID="type_formView" EventName="ItemUpdated" />
                                            <asp:AsyncPostBackTrigger ControlID="type_formView" EventName="ItemInserted" />
                                            <asp:AsyncPostBackTrigger ControlID="type_formView" EventName="ItemDeleted" />
                                            <asp:AsyncPostBackTrigger ControlID="type_formView" EventName="ItemCommand" />
                                        </Triggers>
                                    
                                    </asp:UpdatePanel>
                                    
                                </td>
                            
                                <%--Manufacturer--%>
                                <td align="left" class="InnerFV_tbl">
                                    <asp:UpdatePanel ID="manuFV_updatePnl" runat="server" UpdateMode="Conditional">
                                        
                                        <ContentTemplate>
                                            <asp:DropDownList ID="manu_ddl" runat="server" DataTextField="Name" DataValueField="ID" AutoPostBack="true" CssClass="DDLStyle" />
                                            
                                            <span class="Divider">&nbsp;</span>
                                            
                                            <asp:FormView ID="manu_formView" runat="server" DataKeyNames="ID" DataSourceID="manu_sds" Width="100%">
                                            
                                                <HeaderTemplate>
                                                    <table width="100%">
                                                </HeaderTemplate>
                                                
                                                <EditItemTemplate>
                                                        <tr>
                                                            <td>
                                                                Manufacturer Name:
                                                                <br />
                                                                <asp:Textbox ID="manuName_txt" runat="server" Text='<%#Bind("Name") %>' Width="150px" />
                                                                
                                                                <asp:RequiredFieldValidator ID="manuName_rVal" runat="server" ValidationGroup="ManufacturerVGroup" ErrorMessage="Manufacturer Name is required." ControlToValidate="manuName_txt" 
                                                                    Display="None" />
                                                                <asp:ValidatorCalloutExtender ID="manuName_vcExt" runat="server" TargetControlID="manuName_rVal" 
                                                                    WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <span class="Divider">&nbsp;</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <asp:Button ID="update_btn" runat="server" CausesValidation="true" ValidationGroup="ManufacturerVGroup" CommandName="Update" Text="Update" CssClass="ButtonStyle" />
                                                                &nbsp;&nbsp;
                                                                <asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                                            </td>
                                                        
                                                        </tr>
                                                
                                                </EditItemTemplate>
                                                
                                                <InsertItemTemplate>
                                                        <tr>
                                                            <td>
                                                                Manufacturer Name:
                                                                <br />
                                                                <asp:Textbox ID="manuName_txt" runat="server" Text='<%#Bind("Name") %>' Width="150px" />
                                                                
                                                                <asp:RequiredFieldValidator ID="manuName_rVal" runat="server" ValidationGroup="ManufacturerVGroup" ErrorMessage="Manufacturer Name is required." ControlToValidate="manuName_txt" 
                                                                    Display="None" />
                                                                <asp:ValidatorCalloutExtender ID="manuName_vcExt" runat="server" TargetControlID="manuName_rVal" 
                                                                    WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <span class="Divider">&nbsp;</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <asp:Button ID="insert_btn" runat="server" CausesValidation="true" ValidationGroup="ManufacturerVGroup" CommandName="Insert" Text="Add" CssClass="ButtonStyle" />
                                                                &nbsp;&nbsp;
                                                                <asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                                            </td>
                                                        </tr>
                                                        
                                                </InsertItemTemplate>
                                                
                                                <ItemTemplate>
                                                
                                                        <tr>
                                                            <td>
                                                                Manufacturer Name:
                                                                <br />
                                                                <asp:Label ID="manu_lbl" runat="server" Text='<%#Bind("Name") %>' CssClass="FormviewLbl" />
                                                            </td>
                                                        
                                                        </tr>
                                                        
                                                        <tr>
                                                            <td colspan="3">
                                                                <span class="Divider">&nbsp;</span>
                                                            </td>
                                                        </tr>
                                                        
                                                        <tr>
                                                            <td colspan="2">
                                                                <asp:Button ID="edit_btn" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" CssClass="ButtonStyle" />
                                                                &nbsp;&nbsp;
                                                                <asp:Button ID="delete_btn" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"
                                                                    OnClientClick="return confirm('Are you sure you want to delete this manufacturer?');" CssClass="ButtonStyle" />
                                                            </td>
                                                        </tr>
                                                </ItemTemplate>
                                                
                                                <FooterTemplate>
                                                    </table>
                                                </FooterTemplate>
                                            
                                            </asp:FormView>
                                            
                                            <asp:Literal ID="manuPrompt_lit" runat="server" />
                                        </ContentTemplate>
                                        
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="manu_ddl" EventName="SelectedIndexChanged" />
                                            <asp:AsyncPostBackTrigger ControlID="manu_formView" EventName="ModeChanged" />
                                            <asp:AsyncPostBackTrigger ControlID="manu_formView" EventName="ItemUpdated" />
                                            <asp:AsyncPostBackTrigger ControlID="manu_formView" EventName="ItemInserted" />
                                            <asp:AsyncPostBackTrigger ControlID="manu_formView" EventName="ItemDeleted" />
                                            <asp:AsyncPostBackTrigger ControlID="manu_formView" EventName="ItemCommand" />
                                        </Triggers>
                                    
                                    </asp:UpdatePanel>
                                
                                </td>
                                
                                <%--Game--%>
                                <td align="left" class="InnerFV_tbl">
                                    
                                    <asp:UpdatePanel ID="game_updatePanel" runat="server" UpdateMode="Conditional">
                                    
                                        <ContentTemplate>
                                            <asp:DropdownList ID="game_ddl" runat="server" DataTextField="Title" DataValueField="ID" AutoPostBack="true" CssClass="DDLStyle" />
                                            
                                            <span class="Divider">&nbsp;</span>
                                            
                                            <asp:FormView ID="game_formView" runat="server" DataKeyNames="ID" DataSourceID="game_sds" Width="100%">
                                            
                                                <HeaderTemplate>
                                                    <table width="100%">
                                                </HeaderTemplate>
                                                
                                                <EditItemTemplate>
                                                        <tr>
                                                            <td>
                                                                Game Title:
                                                                <br />
                                                                <asp:Textbox ID="gameTitle_txt" runat="server" Text='<%#Bind("Title") %>' Width="150px" />
                                                                
                                                                <asp:RequiredFieldValidator ID="gameTitle_rVal" runat="server" ValidationGroup="GameVGroup" ErrorMessage="Game Title is required." ControlToValidate="gameTitle_txt" 
                                                                    Display="None" />
                                                                <asp:ValidatorCalloutExtender ID="gameTitle_vcExt" runat="server" TargetControlID="gameTitle_rVal" 
                                                                    WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <span class="Divider">&nbsp;</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <asp:Button ID="update_btn" runat="server" CausesValidation="true" ValidationGroup="GameVGroup" CommandName="Update" Text="Update" CssClass="ButtonStyle" />
                                                                &nbsp;&nbsp;
                                                                <asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                                            </td>
                                                        
                                                        </tr>
                                                </EditItemTemplate>
                                                
                                                <InsertItemTemplate>
                                                        <tr>
                                                            <td>
                                                                Game Title:
                                                                <br />
                                                                <asp:TextBox ID="gameTitle_txt" runat="server" Text='<%#Bind("Title") %>' Width="150px" />
                                                                
                                                                <asp:RequiredFieldValidator ID="gameTitle_rVal" runat="server" ValidationGroup="GameVGroup" ErrorMessage="Game Title is required." ControlToValidate="gameTitle_txt" 
                                                                    Display="None" />
                                                                <asp:ValidatorCalloutExtender ID="gameTitle_vcExt" runat="server" TargetControlID="gameTitle_rVal" 
                                                                    WarningIconImageUrl="alertIcon.png" CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <span class="Divider">&nbsp;</span>
                                                            </td>
                                                        </tr>
                                                         <tr>
                                                            <td colspan="2">
                                                                <asp:Button ID="insert_btn" runat="server" CausesValidation="true" ValidationGroup="GameVGroup" CommandName="Insert" Text="Add" CssClass="ButtonStyle" />
                                                                &nbsp;&nbsp;
                                                                <asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                                            </td>
                                                        </tr>
                                                </InsertItemTemplate>
                                                
                                                <ItemTemplate>
                                                        
                                                        <tr>
                                                            <td>
                                                                Game Title:
                                                                <br />
                                                                <asp:Label ID="gameTitle_lbl" runat="server" Text='<%#Bind("Title") %>' CssClass="FormviewLbl" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <span class="Divider">&nbsp;</span>
                                                            </td>
                                                        </tr>
                                                        <td colspan="2">
                                                            <asp:Button ID="edit_btn" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" CssClass="ButtonStyle" />
                                                            &nbsp;&nbsp;
                                                            <asp:Button ID="delete_btn" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"
                                                                OnClientClick="return confirm('Are you sure you want to delete this game?');" CssClass="ButtonStyle" />
                                                        </td>
                                                </ItemTemplate>
                                                
                                                
                                                <FooterTemplate>
                                                    </table>
                                                </FooterTemplate>
                                            
                                            </asp:FormView>
                                            
                                            <asp:Literal ID="gamePrompt_lit" runat="server" />
                                        
                                        </ContentTemplate>
                                        
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="game_ddl" EventName="SelectedIndexChanged" />
                                            <asp:AsyncPostBackTrigger ControlID="game_formView" EventName="ModeChanged" />
                                            <asp:AsyncPostBackTrigger ControlID="game_formView" EventName="ItemUpdated" />
                                            <asp:AsyncPostBackTrigger ControlID="game_formView" EventName="ItemInserted" />
                                            <asp:AsyncPostBackTrigger ControlID="game_formView" EventName="ItemDeleted" />
                                            <asp:AsyncPostBackTrigger ControlID="game_formView" EventName="ItemCommand" />
                                        </Triggers>
                                    
                                    </asp:UpdatePanel>
                                    
                                    
                                </td>
                            </tr>
                        
                        </table>
                        <%--/Inner table for the FormViews--%>
                        
                    </td>
                
                </tr>
                
            </table>
            
            <%--General Modal Popup--%>
            <asp:ModalPopupExtender ID="changed_mpExt" runat="server" TargetControlID="dummy" PopupControlID="changed_pnl" />
                <input type="button" id="dummy" runat="server" style="display: none;" />
                        
                <%-- The content displayed as the Modal Popup--%>
                <asp:Panel ID="changed_pnl" runat="server" CssClass="modalStyle" Width="375px">
                
                    <asp:UpdatePanel ID="changed_updatePnl" runat="server" UpdateMode="Conditional">
                        
                        <ContentTemplate>
                            <asp:Literal ID="changed_lit" runat="server" />
                        </ContentTemplate>
                        
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="ok_btn" EventName="click" />
                        </Triggers>
                        
                    </asp:UpdatePanel>
    
                    <br />
                    <asp:Button ID="ok_btn" runat="server" Text="Ok" OnClick="onOkClick" CssClass="ButtonStyle" CausesValidation="false" />
                </asp:Panel>
                
            
            <asp:SqlDataSource ID="game_sds" runat="server" ConnectionString="<%$ ConnectionStrings:FigsConnectionString %>"
                SelectCommand="SELECT ID, Title FROM Game WHERE ID = @ID"
                InsertCommand="INSERT INTO Game (Title) VALUES (@Title);SET @NewID = SCOPE_IDENTITY()"
                DeleteCommand="DELETE FROM Game WHERE ID = @ID"
                UpdateCommand="UPDATE Game SET Title = @Title WHERE ID = @ID"
                >
                
                <SelectParameters>
                    <asp:SessionParameter Name="ID" SessionField="SelectedGame" Type="Int32" />
                </SelectParameters>
                
                <DeleteParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                </DeleteParameters>
                
                <UpdateParameters>
                    <asp:Parameter Name="Title" Type="String" />
                </UpdateParameters>
                
                <InsertParameters>
                    <asp:Parameter Name="Title" Type="String" />
                    <asp:Parameter Name="NewID" Type="Int32" Size="4" Direction="Output" />
                </InsertParameters>
            </asp:SqlDataSource>
            
            
            <asp:SqlDataSource ID="type_sds" runat="server" ConnectionString="<%$ ConnectionStrings:FigsConnectionString %>"
                SelectCommand="SELECT ID, TypeName FROM ItemType WHERE ID = @ID"
                InsertCommand="INSERT INTO ItemType (TypeName) VALUES (@TypeName);SET @NewID = SCOPE_IDENTITY()"
                DeleteCommand="DELETE FROM ItemType WHERE ID = @ID"
                UpdateCommand="UPDATE ItemType SET TypeName = @TypeName WHERE ID = @ID"
                >
            
                <SelectParameters>
                    <asp:SessionParameter Name="ID" SessionField="SelectedType" Type="Int32" />
                </SelectParameters>
                
                <DeleteParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                </DeleteParameters>
                
                <UpdateParameters>
                    <asp:Parameter Name="TypeName" Type="String" />
                </UpdateParameters>
                
                <InsertParameters>
                    <asp:Parameter Name="TypeName" Type="String" />
                    <asp:Parameter Name="NewID" Type="Int32" Size="4" Direction="Output" />
                </InsertParameters>
                
            </asp:SqlDataSource>
            
            
            <asp:SqlDataSource ID="manu_sds" runat="server" ConnectionString="<%$ ConnectionStrings:FigsConnectionString %>" 
                SelectCommand="SELECT ID, Name FROM Manufacturer WHERE ID = @ID" 
                InsertCommand="INSERT INTO Manufacturer (Name) VALUES (@Name);SET @NewID = SCOPE_IDENTITY()" 
                DeleteCommand="DELETE FROM Manufacturer WHERE ID = @ID"
                UpdateCommand="UPDATE Manufacturer SET Name = @Name WHERE ID = @ID"
                >
                
                <SelectParameters>
                    <asp:SessionParameter Name="ID" SessionField="SelectedManufacturer" Type="Int32" />
                </SelectParameters>
                
                <DeleteParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                </DeleteParameters>
                
                <UpdateParameters>
                    <asp:Parameter Name="Name" Type="String" />
                </UpdateParameters>
                
                <InsertParameters>
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="NewID" Type="Int32" Size="4" Direction="Output" />
                </InsertParameters>
                
            </asp:SqlDataSource>
            
                           
            <p class="copyright">
                Copyright &copy; 2011, <a href="mailto:maggy@zogglet.com?subject=About your awesome Halo Action Figure Tracker">Maggy Maffia</a>
            </p>
               
                
        </div>
        
        
    </form>
</body>
</html>
