page 60000 "SBC Spotify General Setup"
{

    Caption = 'Spotify General Setup';
    PageType = Card;
    SourceTable = "SBC Spotify General Setup";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Spotify API URL"; Rec."Spotify API URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base Spotify URL';
                }
                field("Spotify OAuth settings"; Rec."Spotify OAuth settings")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Spotify OAuth settings';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
