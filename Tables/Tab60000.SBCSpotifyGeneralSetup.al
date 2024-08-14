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
        field(2; "Spotify API URL"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Base API URL';
        }
        field(3; "Client Id"; Text[100])
        {
            Caption = 'Client Id';
        }
        field(4; "Redirect URL"; Text[250])
        {
            Caption = 'Redirect URL';
        }
        field(5; Scope; Text[250])
        {
            Caption = 'Scope';
        }
        field(6; "Authorization URL"; Text[250])
        {
            Caption = 'Authorization URL';
        }
        field(7; "Access Token URL"; Text[250])
        {
            Caption = 'Access Token URL';
        }
        field(8; "Grant Type"; Enum "SBC Grant Type")
        {
            Caption = 'Grant Type';
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
    procedure SetSecret(Secret: SecretText)
    begin
        if IsolatedStorage.Contains(GetClientSecretKey(), DataScope::Company) then
            IsolatedStorage.Delete(GetClientSecretKey(), DataScope::Company);

        IsolatedStorage.set(GetClientSecretKey(), Secret, DataScope::Company);
    end;

    procedure GetSecret(): SecretText
    var
        Secret: SecretText;
    begin
        if IsolatedStorage.Contains(GetClientSecretKey(), DataScope::Company) then begin
            IsolatedStorage.Get(GetClientSecretKey(), DataScope::Company, Secret);
            exit(Secret);
        end;
    end;

    local procedure GetClientSecretKey(): Guid
    begin
        exit('790fa3d4-37db-41f7-8b8c-9ef9523e0898');
    end;
}
