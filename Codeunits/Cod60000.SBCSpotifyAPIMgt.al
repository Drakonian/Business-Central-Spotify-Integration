codeunit 60000 "SBC Spotify API Mgt"
{
    procedure GetRequest(AdditionalURL: Text; var Data: Text; var httpStatusCode: Integer; PageScope: Text; var NextPageID: Integer): Boolean
    var
        SpotifyGeneralSetup: Record "SBC Spotify General Setup";
        JSONMgt: Codeunit "SBC JSON Mgt";
        httpClient: HttpClient;
        httpResponseMessage: HttpResponseMessage;
        requestUri: Text;
    begin
        SpotifyGeneralSetup.get();
        SpotifyGeneralSetup.TestField("Spotify API URL");
        NextPageID := 0;

        requestUri := SpotifyGeneralSetup."Spotify API URL" + AdditionalURL;

        httpClient.DefaultRequestHeaders().Add(
                    'Authorization',
                    SecretStrSubstNo('Bearer %1', GetSpotifyAccessToken()));

        if httpClient.Get(requestUri, httpResponseMessage) then begin
            httpResponseMessage.Content().ReadAs(Data);
            httpStatusCode := httpResponseMessage.HttpStatusCode();
            if not httpResponseMessage.IsSuccessStatusCode() then
                Error(RequestErr, httpStatusCode, Data);
            if not SkipNextPage then
                NextPageID := JSONMgt.GetNextPageID(Data, PageScope);
            exit(true);
        end else
            Error(RequestErr, httpStatusCode, Data);
    end;

    procedure SendRequest(contentToSend: Text; RequestMethod: Text; AdditionalURL: Text): text
    var
        SBCSpotifyGeneralSetup: Record "SBC Spotify General Setup";
        client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        contentHeaders: HttpHeaders;
        content: HttpContent;
        requestUri: Text;
        responseText: Text;
        errorBodyContent: Text;
    begin
        SBCSpotifyGeneralSetup.get();
        SBCSpotifyGeneralSetup.TestField("Spotify API URL");

        requestUri := SBCSpotifyGeneralSetup."Spotify API URL" + AdditionalURL;

        content.WriteFrom(contentToSend);

        content.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');

        request.Content := content;

        request.SetRequestUri(requestUri);
        request.Method := RequestMethod;

        client.DefaultRequestHeaders().Add(
                'Authorization',
                SecretStrSubstNo('Bearer %1', GetSpotifyAccessToken()));
        client.Send(request, response);

        response.Content().ReadAs(responseText);
        if not response.IsSuccessStatusCode() then begin
            response.Content().ReadAs(errorBodyContent);
            Error(RequestErr, response.HttpStatusCode(), errorBodyContent);
        end;

        exit(responseText);
    end;

    procedure GetSpotifyAccessToken(): SecretText
    var
        SBCSpotifyGeneralSetup: Record "SBC Spotify General Setup";
        OAuth2: Codeunit OAuth2;
        MessageText: Text;
        AccessToken: SecretText;
        ErrorContent: Text;
        IsSuccess: Boolean;
        ListOfScopes: List of [Text];
    begin
        SBCSpotifyGeneralSetup.Get();
        SBCSpotifyGeneralSetup.TestField("Client Id");
        ListOfScopes.Add(SBCSpotifyGeneralSetup.Scope);
        ClearLastError();

        case SBCSpotifyGeneralSetup."Grant Type" of
            SBCSpotifyGeneralSetup."Grant Type"::"Authorization Code":
                IsSuccess := OAuth2.AcquireTokenByAuthorizationCode(SBCSpotifyGeneralSetup."Client ID",
                     SBCSpotifyGeneralSetup.GetSecret(), SBCSpotifyGeneralSetup."Authorization URL",
                     SBCSpotifyGeneralSetup."Redirect URL", ListOfScopes, Enum::"Prompt Interaction"::None, AccessToken, ErrorContent);
            SBCSpotifyGeneralSetup."Grant Type"::"Client Credentials":
                IsSuccess := OAuth2.AcquireTokenWithClientCredentials(SBCSpotifyGeneralSetup."Client ID",
                   SBCSpotifyGeneralSetup.GetSecret(), SBCSpotifyGeneralSetup."Authorization URL",
                   SBCSpotifyGeneralSetup."Redirect URL", ListOfScopes, AccessToken);
        end;

        if not IsSuccess then
            Error('Error: \%1', GetLastErrorText());

        exit(AccessToken);
    end;

    procedure GetMyPlaylists()
    var
        SBCJSONMgt: Codeunit "SBC JSON Mgt";
        NextPageID: Integer;
        NextPageExist: Boolean;
        AddUrl: Text;
        Data: Text;
        HttpStatusCode: Integer;
    begin
        NextPageExist := true;
        while NextPageExist do begin
            AddUrl := StrSubstNo('me/playlists?limit=50&offset=%1', NextPageID);
            if GetRequest(AddUrl, Data, HttpStatusCode, '', NextPageID) then
                SBCJSONMgt.UpdateMyPlaylists(Data);
            NextPageExist := NextPageID <> 0;
        end;
    end;

    procedure GetPlaylistTracks(var SBCTrack: Record "SBC Track"; PlaylistId: Text)
    var
        SBCJSONMgt: Codeunit "SBC JSON Mgt";
        NextPageID: Integer;
        NextPageExist: Boolean;
        AddUrl: Text;
        Data: Text;
        HttpStatusCode: Integer;
    begin
        NextPageExist := true;
        while NextPageExist do begin
            AddUrl := StrSubstNo('playlists/%2/tracks?limit=100&offset=%1', NextPageID, PlaylistId);
            if GetRequest(AddUrl, Data, HttpStatusCode, '', NextPageID) then
                SBCJSONMgt.UpdateTracks(SBCTrack, Data);
            NextPageExist := NextPageID <> 0;
        end;
    end;

    procedure SearchItems(var SBCTrack: Record "SBC Track"; SearchString: Text; SearchType: Enum "SBC Search Type")
    var
        SBCJSONMgt: Codeunit "SBC JSON Mgt";
        DialogW: Dialog;
        NextInt: Integer;
        NextPageID: Integer;
        NextPageExist: Boolean;
        AddUrl: Text;
        Data: Text;
        HttpStatusCode: Integer;
    begin
        //For now just only tracks search supported
        if SearchType <> SearchType::track then
            exit;
        NextPageExist := true;
        DialogW.Open('Continue... #1########', NextInt);
        while NextPageExist do begin
            AddUrl := StrSubstNo('search?q=%1&type=%2&limit=50&offset=%3', SearchString, SearchType, NextPageID);
            if GetRequest(AddUrl, Data, HttpStatusCode, 'tracks', NextPageID) then
                SBCJSONMgt.UpdateTracks(SBCTrack, Data);
            NextPageExist := NextPageID <> 0;
        end;
        DialogW.Close();
    end;

    procedure SetSkipNextPage(BooleanValue: Boolean)
    begin
        SkipNextPage := BooleanValue;
    end;

    var
        SkipNextPage: Boolean;
        RequestErr: Label 'Request failed with HTTP Code:: %1 Request Body:: %2', Comment = '%1 = HttpCode, %2 = RequestBody';
}
