page 60002 "SBC Tracks"
{
    Caption = 'Tracks';
    PageType = List;
    SourceTable = "SBC Track";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
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
    actions
    {
        area(Processing)
        {
            action("SBC Delete Track From Playlist")
            {
                ApplicationArea = All;
                Image = DeleteRow;
                Caption = 'Delete Track from Playlist';
                ToolTip = 'Delete Track from Playlist';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = RunnedFromPlayList;
                trigger OnAction()
                var
                    SBCTrack: Record "SBC Track";
                    SBCJSONMgt: Codeunit "SBC JSON Mgt";
                begin
                    if not Confirm(DeletionQst) then
                        exit;
                    CurrPage.SetSelectionFilter(SBCTrack);
                    SBCJSONMgt.DeleteTracksFromPlaylist(SBCTrack, PlaylistId);
                end;
            }
        }
    }
    var
        RunnedFromPlayList: Boolean;
        PlaylistId: Text;

    procedure SetRunnedFromPlaylist(inPlaylistId: Text; FromPlaylist: Boolean)
    begin
        RunnedFromPlayList := FromPlaylist;
        PlaylistId := inPlaylistId;
    end;

    var
        DeletionQst: Label 'Are you sure you want to remove tracks from the playlist?';
}
