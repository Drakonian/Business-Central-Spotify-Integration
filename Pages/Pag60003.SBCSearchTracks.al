page 60003 "SBC Search Tracks"
{
    Caption = 'Search Tracks';
    PageType = Worksheet;
    SourceTable = "SBC Track";
    UsageCategory = None;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                ShowCaption = false;
                field(SearchStringName; SearchString)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Search String';
                    Caption = 'Search String';
                    trigger OnValidate()
                    var
                        SBCTrack: Record "SBC Track";
                        SBCSpotifyAPIMgt: Codeunit "SBC Spotify API Mgt";
                        TypeHelper: Codeunit "Type Helper";
                    begin
                        SBCSpotifyAPIMgt.SearchItems(SBCTrack, TypeHelper.UriEscapeDataString(SearchString), Enum::"SBC Search Type"::track);
                        SBCTrack.MarkedOnly(true);
                        if SBCTrack.FindSet() then
                            repeat
                                Rec.Init();
                                Rec := SBCTrack;
                                Rec.Insert();
                            until SBCTrack.Next() = 0;
                    end;
                }
            }
            repeater(Repeater)
            {
                field(Id; Rec.Id)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Id';
                    Visible = false;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Id';
                }
                field("Artist Id"; Rec."Artist Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Artist Id';
                    Visible = false;
                }
                field("Artist Name"; Rec."Artist Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Artist Name';
                }
                field("Artist Href"; Rec."Artist Href")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Artist Href';
                }
                field("Duration ms"; Rec."Duration ms")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Duration ms';
                }
                field("Album Name"; Rec."Album Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Album Name';
                }
                field("Album Id"; Rec."Album Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Album Id';
                    Visible = false;
                }
                field("Album Image Href"; Rec."Album Image Href")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Album Image Href';
                    Visible = false;
                }
                field("Album Release Date"; Rec."Album Release Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Album Release Date';
                }
                field("Album Total Tracks"; Rec."Album Total Tracks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Album Total Tracks';
                }
                field("Added At"; Rec."Added At")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Added At';
                }
                field("Added by Id"; Rec."Added by Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Added by Id';
                    Visible = false;
                }
                field("Added by Url"; Rec."Added by Url")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Added by Url';
                    Visible = false;
                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        //Magic to avoid variable links to record
        SearchString := SearchString;
    end;

    var
        SearchString: Text;
}
