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
                field("Client Id"; Rec."Client Id")
                {
                    ToolTip = 'Specifies the value of the Client Id field.', Comment = '%';
                }
                field("ClientSecretField"; ClientSecret)
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                    ToolTip = 'Specifies the Client Secret.';
                    Caption = 'Client Secret';
                    trigger OnValidate()
                    begin
                        Rec.SetSecret(ClientSecret);
                    end;
                }
                field("Grant Type"; Rec."Grant Type")
                {
                    ToolTip = 'Specifies the value of the Grant Type field.', Comment = '%';
                }
                field("Redirect URL"; Rec."Redirect URL")
                {
                    ToolTip = 'Specifies the value of the Redirect URL field.', Comment = '%';
                }
                field(Scope; Rec.Scope)
                {
                    ToolTip = 'Specifies the value of the Scope field.', Comment = '%';
                }
                field("Authorization URL"; Rec."Authorization URL")
                {
                    ToolTip = 'Specifies the value of the Authorization URL field.', Comment = '%';
                }
                field("Access Token URL"; Rec."Access Token URL")
                {
                    ToolTip = 'Specifies the value of the Access Token URL field.', Comment = '%';
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

        if not Rec.GetSecret().IsEmpty() then
            ClientSecret := '****'
        else
            ClientSecret := '';
    end;

    var
        ClientSecret: Text;
}
