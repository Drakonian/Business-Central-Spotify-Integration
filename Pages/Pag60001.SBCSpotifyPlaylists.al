page 60001 "SBC Spotify Playlists"
{

    ApplicationArea = All;
    Caption = 'Spotify Playlists';
    PageType = List;
    SourceTable = "SBC Spotify Playlist";
    UsageCategory = Lists;

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
                    ToolTip = 'Specifies the Name';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field(Href; Rec.Href)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Href';
                    Editable = false;
                }
                field("Tracks Count"; Rec."Tracks Count")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Tracks Count';
                    Editable = false;
                }
                field("Tracks Href"; Rec."Tracks Href")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Tracks Href';
                    Visible = false;
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Owner Name';
                    Editable = false;
                }
                field("Owner Id"; Rec."Owner Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Owner Id';
                    Visible = false;
                }
                field("Snapshot Id"; Rec."Snapshot Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Snapshot Id';
                    Visible = false;
                }
                field(Collaborative; Rec.Collaborative)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Collaborative';
                    Editable = false;
                }
                field(Public; Rec.Public)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Public';
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("SBC Load My Playlists")
            {
                ApplicationArea = All;
                Image = RefreshLines;
                Caption = 'Load My Playlists';
                ToolTip = 'Load My Playlists';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    SpotifyApiMgt: Codeunit "SBC Spotify API Mgt";
                begin
                    SpotifyApiMgt.GetMyPlaylists();
                    CurrPage.Update(false);
                end;
            }
            action("SBC Show Tracks")
            {
                ApplicationArea = All;
                Image = ShowList;
                Caption = 'Show Tracks';
                ToolTip = 'Show Tracks';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    SBCTrack: Record "SBC Track";
                    SBCSpotifyApiMgt: Codeunit "SBC Spotify API Mgt";
                    SBCTracksPage: Page "SBC Tracks";
                begin
                    SBCSpotifyApiMgt.GetPlaylistTracks(SBCTrack, Rec.Id);
                    SBCTracksPage.SetTableView(SBCTrack);
                    SBCTracksPage.SetRunnedFromPlaylist(Rec.Id, true);
                    Commit();
                    SBCTracksPage.RunModal();
                    SBCSpotifyApiMgt.GetMyPlaylists();
                end;
            }
            action("SBC Add Tracks to Playlist")
            {
                ApplicationArea = All;
                Image = Find;
                Caption = 'Add Tracks to Playlist';
                ToolTip = 'Add Tracks to Playlist';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    SBCTrack: Record "SBC Track";
                    SBCSpotifyApiMgt: Codeunit "SBC Spotify API Mgt";
                    SBCJSONMgt: Codeunit "SBC JSON Mgt";
                    SBCSearchTracksPage: Page "SBC Search Tracks";
                begin
                    SBCSearchTracksPage.LookupMode(true);
                    if SBCSearchTracksPage.RunModal() <> Action::LookupOK then
                        exit;
                    SBCSearchTracksPage.SetSelectionFilter(SBCTrack);
                    SBCJSONMgt.AddTracksToPlaylist(SBCTrack, Rec.Id);
                    SBCSpotifyApiMgt.GetMyPlaylists();
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
