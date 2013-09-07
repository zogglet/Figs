<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Figs.aspx.vb" Inherits="Figs" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Maggy's Halo Action Figure Tracker &raquo; Generate List</title>
    
    <link href="favicon.ico" rel="icon" type="image/x-icon" />
    <link href="figs.css" rel="stylesheet" type="text/css" />
    <script src="scripts/jquery-1.4.4.js" type="text/javascript"></script>
    
    <script type="text/javascript" language="javascript">

        var animHappened = false;
        
        //Show the loading animation centered over the faded-out GridView
        function onLoading() {
            var loadingDiv = $get('loading_div');
            var gv = $get('<%= figs_gv.ClientID %>');
            var gvBounds = Sys.UI.DomElement.getBounds(gv);
            var loadingBounds = Sys.UI.DomElement.getBounds(loadingDiv);
            var x = gvBounds.x + Math.round(gvBounds.width / 2) - Math.round(loadingBounds.width);
            var y = gvBounds.y + Math.round(gvBounds.height / 2) - Math.round(loadingBounds.height);
            
            loadingDiv.style.display = '';
            Sys.UI.DomElement.setLocation(loadingDiv, x, y);
        }

        //Hide the loading animation
        function onLoaded() {
            var loadingDiv = $get('loading_div');
            loadingDiv.style.display = 'none';
        }

        //Show the animation upon an initial filter/search
        function showFirstLoadAnim() {

            if (animHappened) {
                return false;
            } else {
                var firstBind = '<%= firstBind %>';
                var div = document.getElementById('loading_container');

                //alert(firstBind);
                div.style.display = (firstBind == 'True') ? '' : 'none';
                var animTimeout = setTimeout(hideAnim, 5000);
            }
        }
        //Hide it after 5 seconds
        function hideAnim() {
            var div = document.getElementById('loading_container');
            div.style.display = 'none';
            animHappened = true;
        }

        //Prevents Timer from snapping to the top of the page on each tick
        function scrollTo() {
            return;
        }

        //jQuery READY function
        $(document).ready(function() {

            //Clear default text upon click
            $('input[type="Text"]').focus(function() {

                if (this.value == this.defaultValue) {
                    this.value = '';
                } else {
                    this.select();
                }
            });
            //Show default text again when out of focus (if the value wasn't changed)
            $('input[type="Text"]').blur(function() {
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

        <asp:Timer ID="start_timer" runat="server" Interval="1000" Enabled="false"/>
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
                                                    <asp:LoginName ID="loginName" runat="server" FormatString="Greetings, <b>{0}</b>!" />
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
                                                        <asp:LinkButton ID="qlMeth_lBtn" runat="server" Text="M.O.A.U.H.A.F.C.M." OnClick="qlMeth_click" />
                                                        
                                                        <asp:HoverMenuExtender ID="methodology_hmExt" runat="server" TargetControlID="qlMeth_lBtn" PopupControlID="tooltip_pnl" PopupPosition="Left" 
                                                            OffsetX="-20" OffsetY="-3" HoverDelay="0" />
                                                            
                                                        <asp:Panel ID="tooltip_pnl" runat="server" CssClass="QLTooltipStyle" Width="150px">
                                                            <i><b>M</b>aggy's <b>O</b>bsessive <b>a</b>nd <b>U</b>nnecessary <b>H</b>alo <b>A</b>ction <b>F</b>igure <b>C</b>ollecting <b>M</b>ethodology</i>
                                                        </asp:Panel>
                                                        
                                                        <br /><asp:LinkButton ID="qlNewItem_lBtn" runat="server" Text="Add New Item" OnClick="addNew_click" />
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
                    <td align="center">
                        <h2>Maggy's Halo Action Figure Tracker</h2>
                        <br /><h3>List Options: Filter or Search List</h3>
                    </td>
                </tr>
                
                <tr>
                    <td align="left">
                        <asp:LinkButton ID="menu_lbtn" runat="server" Text="Return to Main Menu" CommandName="Cancel" CausesValidation="false" />
                        <br /><span class="BigDivider">&nbsp;</span>
                        <br />
                    </td>
                </tr>
                
                <tr>
                    <td align="center">
                        
                        <%--OPTIONS FOR NARROWING DOWN THE LIST--%>
                        <table id="options_table">
                        
                            <tr>
                                <td colspan="4">
                                    <p class="detail">Perform a search to find a specific item, or use the dropdowns to narrow down the list.</p>
                                    <br />
                                </td>
                            </tr>
                            
                            <tr>
                                <td colspan="4">
                                    Search:
                                    <asp:TextBox ID="search_txt" runat="server" Text="keywords" />
                                    &nbsp;<asp:Button ID="search_btn" runat="server" Text="Search &raquo;" CssClass="ButtonStyle" OnClientClick="showFirstLoadAnim();" />
                                </td>
                            </tr>
                            
                            <tr>
                                <td colspan="4">
                                     <span class="Divider">&nbsp;</span>
                                     <br />
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    Obtained: 
                                    <asp:DropDownList ID="obtained_ddl" runat="server" CssClass="DDLStyle">
                                        <asp:ListItem Text="--Select--" Value="-1" />
                                        <asp:ListItem Text="Yes" Value="1" />
                                        <asp:ListItem Text="Not Yet" Value="0" />
                                    </asp:DropDownList>

                                </td>
                                <td>
                                    Game: 
                                    <asp:DropDownList ID="game_ddl" runat="server" DataSourceID="game_sds" DataTextField="Title" DataValueField="ID" CssClass="DDLStyle" />
                                    
                                    <asp:SqlDataSource ID="game_sds" runat="server" ConnectionString="<%$ ConnectionStrings:FigsConnectionString %>" 
                                        SelectCommand="SELECT ID, Title FROM Game UNION SELECT -1 AS ID, '--Select--' AS Title ORDER BY Title" />
                                </td>
                                <td>
                                    Item Type:
                                    <asp:DropDownList ID="type_ddl" runat="server" DataSourceID="type_sds" DataTextField="TypeName" DataValueField="ID" CssClass="DDLStyle"/>
                                    
                                    <asp:SqlDataSource ID="type_sds" runat="server" ConnectionString="<%$ ConnectionStrings:FigsConnectionString %>" 
                                        SelectCommand="SELECT ID, TypeName FROM ItemType UNION SELECT -1 AS ID, '--Select--' AS TypeName ORDER BY ID" />
                                </td>
                                <td>
                                    Manufacturer:
                                    <asp:DropDownList ID="manu_ddl" runat="server" DataSourceID="manu_sds" DataTextField="Name" DataValueField="ID" CssClass="DDLStyle" />
                                    
                                    <asp:SqlDataSource ID="manu_sds" runat="server" ConnectionString="<%$ ConnectionStrings:FigsConnectionString %>" 
                                        SelectCommand="SELECT ID, Name FROM Manufacturer UNION SELECT -1 AS ID, '--Select--' AS Name ORDER BY ID" />
                                </td>
                                
                                
                            </tr>
                            
                            
                            <tr>
                                <td colspan="4">
                                     <span class="Divider">&nbsp;</span>
                                </td>
                            </tr>
                            
                            <tr>

                                <td colspan="3" style="border-right: solid 2px #e2e9e2;">
                                    <br />
                                    <asp:Button ID="genList_btn" runat="server" Text="Generate List From Options &raquo;" CssClass="ButtonStyle" OnClientClick="showFirstLoadAnim();" />
                                     &nbsp;- or -&nbsp;
                                    <asp:Button ID="showAll_btn" runat="server" Text="[Show Full List]" CssClass="ButtonStyle" OnClientClick="showFirstLoadAnim();" />
                                    
                                </td>
                                
                                 <td align="right">
                                    <br />
                                    <asp:Button ID="add_btn" runat="server" Text="Add New Item" CssClass="ButtonStyle" OnClick="addNew_click" />
                                </td>
                                
                            </tr>

                        </table>
                    
                    </td>
                
                </tr>
                
                <tr>
                
                    <td align="center">
                    
                        <div id="loading_container" runat="server" style="display:none;">
                            <img src="figs_loading.gif" alt="Loading..." />
                        </div>
                    
                           <asp:UpdatePanel ID="figs_updatePnl" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
                            
                                <ContentTemplate>
                                
                                    <br />
                                    <asp:GridView ID="figs_gv" OnSelectedIndexChanged="gvSelectedIndexChanged" runat="server" DataKeyNames="ID" 
                                        AutoGenerateColumns="false" GridLines="None" AllowSorting="true" AllowPaging="true" PageSize="20" CssClass="GVStyle" RowStyle-CssClass="GVItemStyle"
                                        OnRowDataBound="gvRowDataBound" OnSorting="onSorting" HeaderStyle-CssClass="GVHeaderStyle" PagerStyle-CssClass="GVPagerStyle">
                                        <Columns>
                                            
                                            <asp:TemplateField HeaderText="Item Name" ItemStyle-CssClass="GVButtonItemStyle" SortExpression="ItemName">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="itemName_lbtn" runat="server" CommandName="Select" Text='<%#Eval("ItemName")%>' />
                                                    
                                                    <%--Description tooltip--%>
                                                    <asp:HoverMenuExtender ID="gvItem_hmExt" runat="server" TargetControlID="itemName_lbtn" PopupControlID="tooltip_pnl" PopupPosition="Right" 
                                                        OffsetX="-7" OffsetY="-3" HoverDelay="0" />
                                                    
                                                    <asp:Panel ID="tooltip_pnl" runat="server" CssClass="tooltipStyle" Width="200px">
                                                        <%#tooltipText(Eval("Description"), Eval("MyNotes"))%>
                                                    </asp:Panel>
                                                    
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            
                                            <asp:BoundField DataField="Title" HeaderText="Game" SortExpression="Title" />
                                            
                                            <asp:BoundField DataField="Series" HeaderText="Series/Wave" />
                                            
                                            <asp:TemplateField HeaderText="Manufacturer" SortExpression="Name">
                                                <ItemTemplate>
                                                    <asp:Label ID="manu_lbl" runat="server" Text='<%#formatNullField(Eval("Name")) %>' />
                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="Release Date" SortExpression="ReleaseDate">
                                                <ItemTemplate>
                                                    <asp:Label ID="releaseDate_lbl" runat="server" Text='<%#formatDate(Eval("ReleaseDate")) %>' />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            
                                            <asp:TemplateField HeaderText="Featured Image">
                                                <ItemTemplate>
                                                    <asp:Label ID="img_lbl" runat="server" Text='<%#formatImage(Eval("Image"), Eval("Resized"))%>' />
                                                    
                                                    <%--Image tooltip--%>
                                                    <asp:HoverMenuExtender ID="img_hmExt" runat="server" TargetControlID="img_lbl" PopupControlID="img_pnl" PopupPosition="Right" 
                                                        OffsetX="-7" OffsetY="-3" HoverDelay="0" />
                                                    
                                                    <asp:Panel ID="img_pnl" runat="server" Visible='<%#isEnabled(Eval("Image")) %>' >
                                                        <asp:Image ID="gv_img" runat="server" ImageUrl='<%# "images/" & Eval("Image") %>' Width="150px" BorderColor="#566666" BorderStyle="Solid" BorderWidth="1px" />
                                                    </asp:Panel>
                                                    
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            
                                            <asp:TemplateField HeaderText="Detail Images">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="images_lBtn" runat="server" Text='<%#formatManageImagesText(eval("ID")) %>' CssClass="ImagesLink" OnClick="manageImagesClick" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            
                                            <asp:TemplateField HeaderText="Obtained" SortExpression="Have">
                                                <ItemTemplate>
                                                    <asp:Literal ID="haveStatus_lit" runat="server" Text='<%#formatHaveText(Eval("Have"), Eval("Pending")) %>' />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            
                                        </Columns>

                                    </asp:GridView>
                                    
                                    <%--If the selected filtering options return no data, an indicator is shown here.--%>
                                    <div id="indicator_div" runat="server"></div>
                                    
                                    <%--*** Comment out [for now] when uploading to zogcom *** 
                                    <br />
                                    <div style="text-align:right;width:650px;">
                                        <asp:Button ID="report_btn" runat="server" Text="Generate Report &raquo;" CssClass="ButtonStyle" Visible="false" />
                                    </div>--%>
                                
                                </ContentTemplate>
                                
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="genList_btn" EventName="click" />
                                    <asp:AsyncPostBackTrigger ControlID="showAll_btn" EventName="click" />
                                    <asp:AsyncPostBackTrigger ControlID="search_btn" EventName="click" />
                                    <asp:AsyncPostBackTrigger ControlID="figs_gv" EventName="PageIndexChanged" />
                                    <asp:AsyncPostBackTrigger ControlID="figs_gv" EventName="Sorted" />
                                </Triggers>
                                
                            </asp:UpdatePanel>
                            
                            <%--Loading animation
                                I've commented this out since, because OnUpdating plays on every partial postback, the timer triggers the 
                                animation. I will leave the Javascript functions in place above. This issue is being tracked: 
                                http://ajaxcontroltoolkit.codeplex.com/workitem/15788
                            --%>
                            <%--<asp:UpdatePanelAnimationExtender ID="loading_upaExt" runat="server" TargetControlID="figs_updatePnl">
                                <Animations>
                                    <OnUpdating>
                                        <Parallel duration=".15">
                                            <ScriptAction Script="onLoading();" />
                                            <FadeOut minimumOpacity=".33" />
                                        </Parallel>
                                    </OnUpdating>
                                    <OnUpdated>
                                        <Parallel duration=".15">
                                            <FadeIn minimumOpacity=".33" />
                                            <ScriptAction Script="onLoaded();" />
                                        </Parallel>
                                    </OnUpdated>
                                </Animations>    
                            </asp:UpdatePanelAnimationExtender>--%>
                            
                            <%--Loading animation--%>
                            <div id="loading_div" runat="server" style="display:none;">
                                <img src="figs_loading.gif" alt="Loading..." />
                            </div>

                            

                            <%--Dropshadow on "Deleted" modal popup--%>
                            <asp:DropShadowExtender ID="deleted_dsExt" runat="server" TargetControlID="deleted_pnl" Opacity=".15" Width="4" TrackPosition="true" Enabled="false" />
                            
                            <%--Modal popup to display upon successfully deleting an item--%>
                            <asp:ModalPopupExtender ID="deleted_mpExt" runat="server" TargetControlID="dummy" PopupControlID="deleted_pnl" />
                                            
                           <%-- Hidden button for the initial TargetControlID of the ModalPopupExtender (the modal popup will be triggered dynamically, using the UpdatePanel's 
                            AsynchronousPostbackTrigger)--%>
                            <input type="button" id="dummy" runat="server" style="display: none;" />
                            
                            <%-- The content displayed as the Modal Popup--%>
                            <asp:Panel ID="deleted_pnl" runat="server" CssClass="modalStyle">
                            
                                <asp:UpdatePanel ID="deleted_updatePnl" runat="server" UpdateMode="Conditional">
                                    
                                    <ContentTemplate>
                                        <div id="deleted_innerDiv" runat="server"></div>
                                    </ContentTemplate>
                                    
                                    <Triggers>
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
