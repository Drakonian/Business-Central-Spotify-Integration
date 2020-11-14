table 60002 "SBC Track"
{
    Caption = 'Track';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Id; Text[2048])
        {
            Caption = 'Id';
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[2048])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; "Duration ms"; Integer)
        {
            Caption = 'Duration ms';
            DataClassification = CustomerContent;
        }
        field(4; "Added At"; Date)
        {
            Caption = 'Added At';
            DataClassification = CustomerContent;
        }
        field(5; "Added by Id"; Text[2048])
        {
            Caption = 'Added by Id';
            DataClassification = CustomerContent;
        }
        field(6; "Added by Url"; Text[2048])
        {
            Caption = 'Added by Url';
            DataClassification = CustomerContent;
        }
        field(7; "Artist Name"; Text[2048])
        {
            Caption = 'Artist Name';
            DataClassification = CustomerContent;
        }
        field(8; "Artist Id"; Text[2048])
        {
            Caption = 'Artist Id';
            DataClassification = CustomerContent;
        }
        field(9; "Artist Href"; Text[2048])
        {
            Caption = 'Artist Href';
            DataClassification = CustomerContent;
        }
        field(10; "Album Id"; Text[2048])
        {
            Caption = 'Album Id';
            DataClassification = CustomerContent;
        }
        field(11; "Album Name"; Text[2048])
        {
            Caption = 'Album Name';
            DataClassification = CustomerContent;
        }
        field(12; "Album Release Date"; Date)
        {
            Caption = 'Album Release Date';
            DataClassification = CustomerContent;
        }
        field(13; "Album Total Tracks"; Integer)
        {
            Caption = 'Album Total Tracks';
            DataClassification = CustomerContent;
        }
        field(14; "Album Image Href"; Text[2048])
        {
            Caption = 'Album Image Href';
            DataClassification = CustomerContent;
        }
        field(15; "Album Image"; MediaSet)
        {
            Caption = 'Album Image';
            DataClassification = CustomerContent;
        }
        field(16; "Track uri"; Text[2048])
        {
            Caption = 'Track uri';
            DataClassification = CustomerContent;
        }
        field(17; "Track External URL"; Text[2048])
        {
            Caption = 'Track External URL';
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
