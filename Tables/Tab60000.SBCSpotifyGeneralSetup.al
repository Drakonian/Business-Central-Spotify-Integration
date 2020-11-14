table 60000 "SBC Spotify General Setup"
{
    Caption = 'SBC Spotify General Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Spotify OAuth settings"; Code[20])
        {
            Caption = 'Spotify OAuth settings';
            DataClassification = CustomerContent;
            TableRelation = "OAuth 2.0 Application".Code;
        }
        field(3; "Spotify API URL"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Base API URL';
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}
