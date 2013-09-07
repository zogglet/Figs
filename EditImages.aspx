<%@ Page Language="VB" AutoEventWireup="false" CodeFile="EditImages.aspx.vb" Inherits="EditImages" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Maggy's Halo Action Figure Tracker &raquo; Edit Detail Images</title>
    
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
    <form id="form1" runat="server" enctype="multipart/form-data">
    
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
                        <br /><asp:Label ID="fig_lbl" runat="server" Text='<%#formatFigHeader() %>' />
                    </td>
                </tr>
                
                <tr>
                    <td align="left">
                        <asp:LinkButton ID="menu_lbtn" runat="server" Text="Return to Main Menu" CommandName="Cancel" CausesValidation="false" OnClick="menuClick" />
                        <b>&nbsp;/&nbsp;</b>
                        <asp:LinkButton ID="return_lbtn" runat="server" Text="Return to List Generator" CommandName="Cancel" CausesValidation="false" OnClick="listClick" />
                        <br /><span class="BigDivider">&nbsp;</span>
                    </td>
                </tr>
                
                
                <tr>
                
                    <td align="center">
                    
                        <br />
                        <asp:UpdatePanel ID="images_updatePnl" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table class="shadedOptions_area">
                                    <tr>
                                        <td>
                                            <asp:DropDownList ID="images_ddl" runat="server" DataTextField="ImageTitle" DataValueField="ID" AutoPostBack="true" CssClass="DDLStyle"
                                                OnSelectedIndexChanged="imagesSelectedIndexChanged" />
                                        </td>
                                        <td>
                                            <asp:LinkButton ID="viewAll_lBtn" runat="server" Text="[View All Images]" CausesValidation="false" CssClass="ImagesLink" OnClick="viewAllClick" />
                                        </td>
                                        <td>
                                            <asp:Literal ID="prompt_lit" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                                
                                <asp:FormView ID="images_fv" runat="server" DataKeyNames="ID" DataSourceID="image_sds">
                                    
                                    <HeaderTemplate>
                                        <table class="Formview_tbl">
                                    </HeaderTemplate>
                                    
                                    <EditItemTemplate>
                                            <tr>
                                                <td>
                                                    Image Title: 
                                                    &nbsp;<asp:TextBox id="imgTitle_txt" runat="server" Text='<%#Bind("ImageTitle") %>' width="150px" CssClass="InputStyle" />
                                                    
                                                    <asp:RequiredFieldValidator ID="imgTitle_rVal" runat="server" ControlToValidate="imgTitle_txt" ErrorMessage="Image title is required." Display="None" />
                                                    <asp:ValidatorCalloutExtender ID="imgTitle_vcExt" runat="server" TargetControlID="imgTitle_rVal" WarningIconImageUrl="alertIcon.png"
                                                          CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                                </td>
                                                <td>
                                                    New Image:
                                                    <asp:HiddenField ID="image_hField" runat="server" Value='<%#Bind("ImageData") %>' />
                                                    &nbsp;<asp:FileUpload ID="img_uploader" runat="server" CssClass="InputStyle" Width="150px" />
                                                    
                                                    <%--So I can bind to e.oldValues--%>
                                                    <asp:HiddenField ID="mimeType_hField" runat="server" Value='<%#Bind("MIMEType") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Description: 
                                                    <br /><asp:TextBox ID="description_txt" runat="server" Text='<%#Bind("Description") %>' TextMode="Multiline" Wrap="true" CssClass="InputStyle" Width="300px" Height="75px" />
                                                </td>
                                                <td>
                                                    <asp:Panel ID="resize_pnl" runat="server" Visible='<%#isResizeAvailable(eval("ID"), 640) %>'>
                                                        <asp:CheckBox ID="resize_cbx" runat="server" Text="Resize &amp; Optimize" />
                                                    </asp:Panel> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" style="text-align: center;">
                                                    <span class="Divider">&nbsp;</span>
                                                    <br />
                                                    <asp:Panel ID="previewImg_pnl" runat="server"></asp:Panel>
                                                    <br /><asp:Literal ID="imageStats_lit" runat="server" text='<%#formatImageStats(eval("Resized")) %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <span class="BigDivider">&nbsp;</span>
                                                </td>
                                            </tr>
                                            
                                            <tr>
                                                <td colspan="2">
                                                    <asp:Button ID="update_btn" runat="server" CausesValidation="true" CommandName="Update" Text="Update" CssClass="ButtonStyle" />
                                                    &nbsp;&nbsp;
                                                    <asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                                </td>
                                            
                                            </tr>
                                    </EditItemTemplate>
                                    
                                    <InsertItemTemplate>
                                            <tr>
                                                <td>
                                                    Image Title: 
                                                    &nbsp;<asp:TextBox id="imgTitle_txt" runat="server" Text='<%#Bind("ImageTitle") %>' width="150px" CssClass="InputStyle" />
                                                    
                                                    <asp:RequiredFieldValidator ID="imgTitle_rVal" runat="server" ControlToValidate="imgTitle_txt" ErrorMessage="Image title is required." Display="None" />
                                                    <asp:ValidatorCalloutExtender ID="imgTitle_vcExt" runat="server" TargetControlID="imgTitle_rVal" WarningIconImageUrl="alertIcon.png"
                                                          CloseImageUrl="closeButton.png" CssClass="ValidatorCalloutStyle" />
                                                </td>
                                                <td>
                                                    Image:
                                                    <asp:HiddenField ID="image_hField" runat="server" Value='<%#Bind("ImageData") %>' />
                                                    &nbsp;<asp:FileUpload ID="img_uploader" runat="server" CssClass="InputStyle" Width="150px" />
                                                    
                                                    <%--So I can bind to e.oldValues--%>
                                                    <asp:HiddenField ID="mimeType_hField" runat="server" Value='<%#Bind("MIMEType") %>' />
                                                </td>
   
                                            </tr>
                                            <tr>
                                                <td>
                                                    Description: 
                                                    <br /><asp:TextBox ID="description_txt" runat="server" Text='<%#Bind("Description") %>' TextMode="Multiline" Wrap="true" CssClass="InputStyle" Width="300px" Height="75px" />
                                                </td>
                                                <td>
                                                    <asp:Panel ID="resize_pnl" runat="server">
                                                        <asp:CheckBox ID="resize_cbx" runat="server" Text="Resize &amp; Optimize" />
                                                    </asp:Panel> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <span class="BigDivider">&nbsp;</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <asp:Button ID="insert_btn" runat="server" CausesValidation="true" CommandName="Insert" Text="Add" CssClass="ButtonStyle" />
                                                    &nbsp;&nbsp;
                                                    <asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                                </td>
                                            </tr>
                                    </InsertItemTemplate>
                                    
                                    <ItemTemplate>
                                            <tr>
                                                <td>
                                                    Image Title:
                                                    &nbsp;<asp:Label ID="imageData_lbl" runat="server" Text='<%#Bind("ImageTitle") %>' CssClass="FormviewLbl" />
                                                </td>
                                                <td>
                                                    MIME Type:
                                                    &nbsp;<asp:Label id="mimeType_lbl" runat="server" Text='<%#Bind("MIMEType") %>' CssClass="FormviewLbl" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3">
                                                    Description:
                                                    &nbsp;<asp:Label ID="description_lbl" runat="server" Text='<%#formatNullField(eval("Description"))%>' CssClass="FormviewLbl" Font-Italic="true" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" style="text-align: center;">
                                                    <span class="Divider">&nbsp;</span>
                                                    <br />
                                                    <asp:Panel ID="previewImg_pnl" runat="server"></asp:Panel>
                                                    <br /><asp:Literal ID="imageStats_lit" runat="server" text='<%#formatImageStats(eval("Resized")) %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3">
                                                    <span class="BigDivider">&nbsp;</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3">
                                                    <asp:Button ID="edit_btn" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" CssClass="ButtonStyle" />
                                                    &nbsp;&nbsp;
                                                    <asp:Button ID="delete_btn" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"
                                                        OnClientClick="return confirm('Are you sure you want to delete this image?');" CssClass="ButtonStyle" />
                                                    &nbsp;&nbsp;
                                                    <asp:Button ID="new_btn" runat="server" CausesValidation="false" CommandName="New" Text="Add New Image" CssClass="ButtonStyle" />
                                                </td>
                                            </tr>
                                    </ItemTemplate>
                                    
                                    <FooterTemplate>
                                        </table>
                                    </FooterTemplate>
                                    
                                </asp:FormView>
                                
                                <%--To list all images--%>
                                <asp:Panel ID="viewImages_pnl" runat="server" Visible="false">
                                    <br />
                                    <asp:DataList ID="images_dList" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" HorizontalAlign="Center" ItemStyle-VerticalAlign="Top">
                                        <ItemTemplate>
                                            <%--Image tags are rendered here.--%>
                                            <asp:Panel ID="listImg_pnl" runat="server" CssClass="ListImagePnlStyle"></asp:Panel>
                                            
                                            <asp:HoverMenuExtender ID="imgStats_hmExt" runat="server" TargetControlID="listImg_pnl" PopupControlID="imgStats_pnl"
                                                    Popupposition="Right" HoverDelay="0" />
                                            <asp:Panel ID="imgStats_pnl" runat="server" CssClass="tooltipStyle">
                                                <asp:Literal ID="imgStats_lit" runat="server" Text='<%#formatToolTipStats(eval("ID"), eval("ImageTitle")) %>' />
                                            </asp:Panel>
                                            
                                        </ItemTemplate>
                                    </asp:DataList>
                                    
                                </asp:Panel>
                                
                                <asp:Panel ID="outerCancel_pnl" runat="server">
                                    <br />
                                    <span style="text-align:right;display:block;">
                                        <asp:Button ID="outerCancel_btn" runat="server" CssClass="ButtonStyle" Text="&laquo; Back" OnClick="outerCancelClick" />
                                    </span>
                                </asp:Panel>
                                
                                
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="images_fv" EventName="ItemInserted" />
                                <asp:AsyncPostBackTrigger ControlID="images_fv" EventName="ItemUpdated" />
                                <asp:AsyncPostBackTrigger ControlID="images_fv" EventName="ModeChanged" />
                                <asp:AsyncPostBackTrigger ControlID="images_fv" EventName="ItemCommand" />
                            </Triggers>
                        </asp:UpdatePanel>
                        
                    </td>
                
                </tr>
                
            </table>
            
            <asp:SqlDataSource ID="image_sds" runat="server" ConnectionString="<%$ ConnectionStrings:FigsConnectionString %>"
                SelectCommand="SELECT Images.ID, ImageTitle, MIMEType, ImageData, Images.Description, FigureID, Images.Resized FROM Images INNER JOIN Figures ON Images.FigureID = Figures.ID WHERE Images.ID = @ID"
                InsertCommand="INSERT INTO Images (ImageTitle, MIMEType, ImageData, Description, FigureID, Resized) VALUES (@ImageTitle, @MIMEType, @ImageData, @Description, @FigureID, @Resized);SET @NewID = SCOPE_IDENTITY()"
                UpdateCommand="UPDATE Images SET ImageTitle = @ImageTitle, MIMEType = @MIMEType, ImageData = @ImageData, Description = @Description, Resized = @Resized WHERE ID = @ID"
                DeleteCommand="DELETE FROM Images WHERE ID = @ID"
                >
                
                <SelectParameters>
                    <asp:SessionParameter Name="ID" SessionField="SelectedImage" Type="Int32" />
                </SelectParameters>
                
                <DeleteParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                </DeleteParameters>
                
                <InsertParameters>
                    <asp:Parameter Name="ImageTitle" Type="String" />
                    <asp:Parameter Name="MIMEType" Type="String" />
                    <asp:Parameter Name="ImageData" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:SessionParameter Name="FigureID" SessionField="SelectedImagesFig" Type="Int32" />
                    <asp:Parameter Name="Resized" Type="Boolean" />
                    <asp:Parameter Name="NewID" Type="Int32" Size="4" Direction="Output" />
                </InsertParameters>
                
                <UpdateParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                    <asp:Parameter Name="ImageTitle" Type="String" />
                    <asp:Parameter Name="MIMEType" Type="String" />
                    <asp:Parameter Name="ImageData" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="Resized" Type="Boolean" />
                </UpdateParameters>
            </asp:SqlDataSource>
        
        </div>
        
    </form>
</body>
</html>
