table 60001 "SBC Spotify Playlist"
{
    Caption = 'Spotify Playlist';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Id; Text[2048])
        {
            Caption = 'Id';
            DataClassification = CustomerContent;
        }
        field(2; Collaborative; Boolean)
        {
            Caption = 'Collaborative';
            DataClassification = CustomerContent;
        }
        field(3; Description; Text[2048])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                SBCJSONMgt: Codeunit "SBC JSON Mgt";
            begin
                if Rec.Id = '' then begin
                    Rec.Name := Rec.Description;
                    Rec.Id := Copystr(SBCJSONMgt.CreatePlaylist(LowerCase(Rec.FieldName(Name)), Rec.Name), 1, MaxStrLen(Rec.Id));
                end else
                    SBCJSONMgt.ModifyPlaylist(LowerCase(Rec.FieldName(Description)), Rec.Description, Rec.Id);
            end;
        }
        field(4; Href; Text[2048])
        {
            Caption = 'Href';
            DataClassification = CustomerContent;
        }
        field(5; Image; MediaSet)
        {
            Caption = 'Image';
            DataClassification = CustomerContent;
        }
        field(6; Name; Text[2048])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                SBCJSONMgt: Codeunit "SBC JSON Mgt";
            begin
                if Rec.Id = '' then
                    Rec.Id := Copystr(SBCJSONMgt.CreatePlaylist(LowerCase(Rec.FieldName(Name)), Rec.Name), 1, MaxStrLen(Rec.Id))
                else
                    SBCJSONMgt.ModifyPlaylist(LowerCase(Rec.FieldName(Name)), Rec.Name, Rec.Id);
            end;
        }
        field(7; "Owner Name"; Text[2048])
        {
            Caption = 'Owner Name';
            DataClassification = CustomerContent;
        }
        field(8; "Owner Id"; Text[2048])
        {
            Caption = 'Owner Id';
            DataClassification = CustomerContent;
        }
        field(9; Public; Boolean)
        {
            Caption = 'Public';
            DataClassification = CustomerContent;
        }
        field(10; "Snapshot Id"; Text[2048])
        {
            Caption = 'Snapshot Id';
            DataClassification = CustomerContent;
        }
        field(11; "Tracks Href"; Text[2048])
        {
            Caption = 'Tracks Href';
            DataClassification = CustomerContent;
        }
        field(12; "Tracks Count"; Integer)
        {
            Caption = 'Tracks Count';
            DataClassification = CustomerContent;
        }
        field(13; "Image Url"; Text[2048])
        {
            Caption = 'Image Url';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }

}
