<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Methodology.aspx.vb" Inherits="Methodology" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Maggy's Halo Action Figure Tracker &raquo; The Obsessive and Unnecessary Action Figure Collecting Methodology</title>
    
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
                                            <asp:Literal id="inlineTimeout_lit" runat="server" />
                                        </ContentTemplate>
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="start_timer" EventName="Tick" />
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
                                                    <asp:LinkButton ID="qlList_btn" runat="server" Text="Filter/Search List" OnClick="qlList_click" />
                                                    <br /><asp:LinkButton ID="qlNewItem_lBtn" runat="server" Text="Add New Item" OnClick="qlAddNew_click" />
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
                        <br /><h3>Maggy's Obsessive and Unnecessary Halo Action Figure Collecting Methodology</h3>
                    </td>
                </tr>
                
                <tr>
                    <td align="left">
                        <asp:LinkButton ID="menu_lbtn" runat="server" Text="Return to Main Menu" CommandName="Cancel" CausesValidation="false" />
                        <br /><span class="BigDivider">&nbsp;</span>
                    </td>
                </tr>
                
                <tr>
                
                    <td align="left" id="top">
                        <br />
                        
                        <ol class="TOCListStyle">
                            <li><a href="#Rules">General Rules</a></li>
                            <li><a href="#Footnotes">Footnotes</a></li>
                            <li><a href="#OtherNotes">Other Notes</a></li>
                            <li><a href="#Memo">Memo on Collection Approach</a></li>
                        </ol>
                        
                        <span class="Divider">&nbsp;</span>
                        
                        <h3 id="Rules" align="center">I. General Rules</h3>
                        
                        <p class="detail">The following rules are non-negotiable. Last revision: 10/17/2011</p>
                        
                        <ol class="OrderedListStyle">
                            <li>All figures must be mint-in-box, no exceptions. Condition of box itself does not matter unless it affects the figure;</li>
                            <li>Once I purchase and open a figure, its value<sup id="note1_1"><a href="#note1">1</a></sup> remains the same. (i.e.: The Jackal Minor figure who 'exploded' and had to be glued back together is still just as valuable<sup><a href="#note1">1</a></sup> to me as when I first took him out of the package)</li>
                            <li>The completion of my Joyride Studios collection is always the primary goal;</li>
                            <li>Campaign-related figures always have higher precedence within their context; (Example: to this, a Halo 1 campaign figure would have highest precedence);</li>
                            <li>
                                Joyride figures take precedence over McFarlane figures and other Halo collectibles (this, however, does not prohibit me from purchasing later/other figures should I find one that I may have trouble finding later, etc.)
                                <ol>
                                    <li>The earlier the series, the higher the precedence;</li>
                                    <li>
                                        Halo 1 figures take precedence over Halo 2 figures with the following exceptions:
                                        <ol>
                                            <li>Banshee</li>
                                            <li>Ghost</li>
                                            <li>Warthog</li>
                                            <li>NON-limited/exclusive remakes of same figure<sup id="note2_1"><a href="#note2">2</a></sup> (i.e.: Master Chief v.2,3,4,etc.)</li>
                                            <li>Slayer mini-sets</li>
                                            <li>MC color variants<sup id="note3_1"><a href="#note3">3</a></sup></li>
                                        </ol>  
                                    </li>
                                    <li>Limited/exclusive figures take precedence</li>
                                </ol>    
                            </li>
                            <li>My fondness for certain characters (i.e.: grunts) is a big factor within the scope of these 'rules'. (Example: If I find a reasonable McFarlane Halo 3 Grunt, I may consider getting it before getting a rarer yet much more expensive Halo 1 Red Elite); </li>
                            <li>The price of the figure in question is the critical factor in determining whether or not to put off its purchase and wait until I find a cheaper offer; </li>
                            <li>Time left in auction is a factor;</li>
                            <li>5 and 6 will always be considered conjointly with all other rules;</li>
                            <li>The contribution the figure would make to the completeness of my collection or a certain part thereof (i.e.: the addition of a third mini Marine to complete a Warthog setup;) gives the figure more precedence;</li>
                            <li>
                                A figure found locally/in-store gets automatic higher consideration with respect to the other rules, namely regarding rarity, price, and how much I want/like it. Upon finding a figure in-store, I will take the following additional criteria into consideration:
                                <ol>
                                    <li>Price of figure (including tax) compared to typical auction prices (including shipping);</li>
                                    <li>Expected future rarity and public value (thus affecting future price);</li>
                                    <li>Current rarity of figure in combination with current price;</li>
                                </ol>
                            </li>
                            <li>
                                Setup and Placement of figures: All JoyRide figures will always be set up in the following <a href="http://www.showcase-express.com" target="_blank">Showcase</a>'s windowed display shelves<sup><a href="#note4">4</a></sup> as follows:
                                <ol>
                                    <li>
                                        Part #5000-2 (10" Display Case, Set of 2):
                                        <ol>
                                            <li>All 8" figures; </li>
                                            <li>All figures to scale with the 8" figures (i.e.: Cortana, Grunts, human-based figures, etc.);</li>
                                        </ol>
                                    </li>
                                </ol>    
                            </li>
                        </ol>
                
                        <span class="BigDivider">&nbsp;</span>
                        
                    </td>
                </tr>
                <tr>
                
                    <td align="left">
                    
                        <h3 id="Footnotes" align="center">II. Notes</h3>
                        
                        <sup id="note1"><a href="#note1_1">1</a></sup> Halo Action Figure Value for Maggy depends on the following factors, considered conjointly:
                        <ol class="OrderedListStyle">
                            <li>
                                My personal fondness for the character or figure itself;
                                <ol>
                                    <li>Campaign-related figures have higher value;</li>
                                </ol>
                            </li>
                            <li>Rarity of the figure;</li>
                            <li>Age/release date of the figure;</li>
                            <li>The price at which I am able to purchase the figure at the time found;</li>
                        </ol>
                        
                        <br />
                        <span class="Divider">&nbsp;</span>
                        
                        <br />
                        <sup id="note2"><a href="#note2_1">2</a></sup> Note on Non-limited/exclusives remakes of same figure: When seeking an not-yet-obtained figure that has since been released more than once, the only other factors besides those outlined in the general rules capable of weighing in on a decision among different versions are: weapons/accessories included.
                        <br />
                            <ul>
                                <li>Subnote to this: The Halo 1 Series 1 Master Chief is given special and separate precedence from this note.</li>
                            </ul>
                            
                        <br />
                        <span class="Divider">&nbsp;</span>
                        
                        <br />
                        <sup id="note3"><a href="#note3_1">3</a></sup> Note on Spartan/MC color- and type-variants (most emphasis being on the non-limited/exclusive ones): 
                        <ol class="OrderedListStyle">
                            <li>This is up to my final discretion at the time it comes up (i.e.: If the figure comes with a specifically-sought-after weapon, or is at a ridiculously good price and/or part of a lot containing other needed figures, or is found in-store when it otherwise would be harder/more expensive to find);</li>
                            <li>Again, the earlier the series, the higher the precedence (even more so in this case, since the personal fondness factor contributing to the item's value does not weigh in as much);</li>
                            <li>Since many of the Halo 2 Spartan figure versions were released with varying armor detail colors (discovered via <a href="http://www.halofigures.net" target="_blank">halofigures.net</a>), this will only be a contributing factor to my decision when ALL all other rules can no longer be applied to the figure in question (i.e.: My obtaining another figure does not outweigh it, and personal preference is all that remains to be taken into account). My obtaining each armor detail variant has lowest precedence in my collecting.
                                <ul>
                                    <li>Subnote to this: Subnote to this: This rule also applies to the variance in the Series 6 Red Elite, with the following ammendment: Since my obtaining that particular figure has a much higher precedence than that of any Spartan variant, the aforementioned rule will apply at that figure's precedence level, but at its static weight, and in conjunction with personal preference.</li>
                                </ul>
                            </li>
                        </ol>

                        <br />
                        <span class="Divider">&nbsp;</span>

                        <p>
                            <sup id="note4"><a href="#note4_1">4</a></sup> I may get Showcase's "optional" Push pin felt board Background for these shelves, for either hanging of various weapons/accessories, etc., or setting up backgrounds scenes for battle poses; (<a href="http://www.spawn.com" target="_blank">McFarlane</a> has fairly hi-resolution "printable" backdrops). Endcaps should be aquired at some point as well, although may not at all times be in place (as I may want to frequently change the figures' poses.
                        </p>
                        
                        
                        <br />
                        [<a href="#top">Back to top</a>]
                        
                        <span class="BigDivider">&nbsp;</span>
                        
                        
                        <h3 id="OtherNotes" align="center">III. Other Notes</h3>
                        
                        <ul>
                            <li>
                                Note on Exclusivity of figures: The exclusivity of an item specified by the figure's official manufacturer (McFarlane's <a href="http://www.spawn.com/halo" target="_blank">official site</a>, and&#8212;for figures no longer in production&#8212;<a href="http://www.halofigures.net" target="_blank">halofigures.net</a>) will always take precedence if said exclusivity is specified differently on another source (such as <a href="http://halo.wikia.com" target="_blank">halo.wikia.com</a>).
                            </li>
                            <li>
                                Note on Mini Vehicles: Since mini vehicles&#8212;such as the Halo 3 mini vehicle series&#8212;could fall under either the "Mini" or "Vehicle" item type, they shall be designated as the "Other" item type.
                            </li>
                        </ul>

                        <br />
                        [<a href="#top">Back to top</a>]
                        <span class="Divider">&nbsp;</span>

                        <h3 id="Memo" align="center">IV. Memo on decision to collect outside of&#8212;and after the end of&#8212;the Halo 1 and 2 Joyride Studios figures</h3>
                        <div class="IndentedMemo">
                            <p>
                                Upon Joyride Studios giving up their rights to the Halo franchise, and McFarlane Toys picking it up with the release of Halo 3, I initially got all huffy and decided to continue collecting only within what was released by Joyride. I found the Joyride figures to be of better quality and more desirable because of their greater scale. I wanted to keep my collection consistent, and not "mess it up" with figures of a completely different design. They wouldn't "go."
                            </p>
                            <p>
                                However, this was a pretty stupid decision, since it was based only on my discomfort with the fact that all new and future figures were going to be of a completely different design than that of everything I'd collected up until then. If you know me, you might know my discomfort with change in general (especially at first); my typical initial reaction being to declare my refusal to embrace the thing/situation in question.
                            </p>
                            <p>
                                That said, I have decided to release the restriction I put on my action figure collecting ways; my new goal is to collect <i>all</i> Halo action figures. To stop doing something I enjoy (and about which I am very avid) simply out of protest is pointless, and only keeping me from more awesome Halo goodness.
                            </p>
                            <p>
                                I have come to respect and admire the McFarlane figures, different as they may be from the Joyride figures. Although smaller and more delicate, the McFarlane figures are meticulously detailed&#8212;in sculpt, paint and articulation&#8212;and authentic to the game. They also feature much more in terms of positioning/posing/interchangeability (with the pegs, weapon holsters, removable armor, etc.) The Joyride figures had a more toy-like quality and favored size and sturdiness over fine detail with their simpler design, while the McFarlane figures have a more collectible/realistic quality and favor the inclusion of every detail, even if that may make the figures more delicate. Both are good things in their own ways.
                            </p>
                            <p>
                                So, I shall no longer discriminate when gathering my plastic minions. I shall rule them all.
                            </p>
                        </div>
                        
                        <br />
                        [<a href="#top">Back to top</a>]
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
