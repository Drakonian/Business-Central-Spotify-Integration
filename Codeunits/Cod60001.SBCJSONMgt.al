codeunit 60001 "SBC JSON Mgt"
{
    procedure SelectJsonToken(JObject: JsonObject; Path: Text): Text
    var
        JToken: JsonToken;
    begin
        if JObject.SelectToken(Path, JToken) then
            if NOT JToken.AsValue().IsNull() then
                exit(JToken.AsValue().AsText());
    end;

    procedure GetValueAsText(JToken: JsonToken; ParamString: Text): Text
    var
        JObject: JsonObject;
    begin
        JObject := JToken.AsObject();
        exit(SelectJsonToken(JObject, ParamString));
    end;

    local procedure EvaluateUTCDateTime(DataTimeText: Text) EvaluatedDateTime: DateTime;
    var
        TypeHelper: Codeunit "Type Helper";
        ValueVariant: Variant;
    begin
        ValueVariant := EvaluatedDateTime;
        IF TypeHelper.Evaluate(ValueVariant, DataTimeText, '', TypeHelper.GetCultureName()) THEN
            EvaluatedDateTime := ValueVariant;
    end;

    procedure GetNextPageID(Data: Text; PageScope: Text): Integer
    var
        JToken: JsonToken;
        JToken2: JsonToken;
        JObject: JsonObject;
        ExitValue: Integer;
    begin
        if Data = '' then
            exit;

        JToken.ReadFrom(Data);
        JObject := JToken.AsObject();
        if PageScope <> '' then begin
            JObject.SelectToken(PageScope, JToken2);
            JObject := JToken2.AsObject();
        end;
        JObject.Get('next', JToken2);


        if JToken2.AsValue().IsNull() then
            ExitValue := 0
        else begin
            JObject.Get('limit', JToken2);
            ExitValue := JToken2.AsValue().AsInteger();
            JObject.Get('offset', JToken2);
            ExitValue += JToken2.AsValue().AsInteger();
        end;

        exit(ExitValue);
    end;

    procedure UpdateMyPlaylists(Data: Text)
    var
        SBCSpotifyPlaylist: Record "SBC Spotify Playlist";
        JToken: JsonToken;
        JToken2: JsonToken;
        JObject: JsonObject;
        JObject2: JsonObject;
        JArray: JsonArray;
        JArray2: JsonArray;
        PlaylistId: Text;
    begin
        if Data = '' then
            exit;

        JToken.ReadFrom(Data);
        JObject := JToken.AsObject();
        JObject.SelectToken('items', JToken);
        JArray := JToken.AsArray();

        foreach JToken in JArray do begin

            PlaylistId := GetValueAsText(JToken, 'id');
            if SBCSpotifyPlaylist.Get(PlaylistId) then
                SBCSpotifyPlaylist.Delete(true);

            SBCSpotifyPlaylist.Init();
            SBCSpotifyPlaylist.Id := CopyStr(PlaylistId, 1, MaxStrLen(SBCSpotifyPlaylist.Id));
            SBCSpotifyPlaylist.Name := CopyStr(GetValueAsText(JToken, 'name'), 1, MaxStrLen(SBCSpotifyPlaylist.Name));
            SBCSpotifyPlaylist.Description := CopyStr(GetValueAsText(JToken, 'description'), 1, MaxStrLen(SBCSpotifyPlaylist.Description));
            evaluate(SBCSpotifyPlaylist.Collaborative, GetValueAsText(JToken, 'collaborative'));
            evaluate(SBCSpotifyPlaylist.Public, GetValueAsText(JToken, 'public'));
            SBCSpotifyPlaylist.Href := CopyStr(GetValueAsText(JToken, 'href'), 1, MaxStrLen(SBCSpotifyPlaylist.Href));
            SBCSpotifyPlaylist."Owner Id" := CopyStr(GetValueAsText(JToken, 'owner.id'), 1, MaxStrLen(SBCSpotifyPlaylist."Owner Id"));
            SBCSpotifyPlaylist."Owner Name" := CopyStr(GetValueAsText(JToken, 'owner.display_name'), 1, MaxStrLen(SBCSpotifyPlaylist."Owner Name"));
            SBCSpotifyPlaylist."Snapshot Id" := CopyStr(GetValueAsText(JToken, 'snapshot_id'), 1, MaxStrLen(SBCSpotifyPlaylist."Snapshot Id"));
            SBCSpotifyPlaylist."Tracks Href" := CopyStr(GetValueAsText(JToken, 'tracks.href'), 1, MaxStrLen(SBCSpotifyPlaylist."Tracks Href"));
            evaluate(SBCSpotifyPlaylist."Tracks Count", GetValueAsText(JToken, 'tracks.total'));

            JObject2 := JToken.AsObject();
            if JObject2.SelectToken('images', Jtoken2) then begin
                JArray2 := JToken2.AsArray();
                foreach JToken2 in JArray2 do
                    if SBCSpotifyPlaylist."Image Url" = '' then
                        SBCSpotifyPlaylist."Image Url" := CopyStr(GetValueAsText(JToken, 'url'), 1, MaxStrLen(SBCSpotifyPlaylist."Image Url"));
            end;
            SBCSpotifyPlaylist.Insert(true);
        end;
    end;

    procedure UpdateTracks(var SBCTrack: Record "SBC Track"; Data: Text)
    var
        JToken: JsonToken;
        JToken2: JsonToken;
        JObject: JsonObject;
        JObject2: JsonObject;
        JArray: JsonArray;
        JArray2: JsonArray;
        TrackId: Text;
        BaseParamString: Text;
    begin
        if Data = '' then
            exit;

        JToken.ReadFrom(Data);
        JObject := JToken.AsObject();
        if not JObject.SelectToken('items', JToken) then
            JObject.SelectToken('tracks.items', JToken)
        else
            BaseParamString := 'track.';


        JArray := JToken.AsArray();

        foreach JToken in JArray do begin

            TrackId := GetValueAsText(JToken, BaseParamString + 'id');
            if not SBCTrack.Get(TrackId) then begin

                SBCTrack.Init();
                SBCTrack.Id := CopyStr(TrackId, 1, MaxStrLen(SBCTrack.Id));
                SBCTrack.Name := CopyStr(GetValueAsText(JToken, BaseParamString + 'name'), 1, MaxStrLen(SBCTrack.Name));
                evaluate(SBCTrack."Duration ms", GetValueAsText(JToken, BaseParamString + 'duration_ms'));
                SBCTrack."Added At" := DT2Date(EvaluateUTCDateTime(GetValueAsText(JToken, 'added_at')));
                SBCTrack."Added by Id" := CopyStr(GetValueAsText(JToken, 'added_by.id'), 1, MaxStrLen(SBCTrack."Added by Id"));
                SBCTrack."Added by Url" := CopyStr(GetValueAsText(JToken, 'added_by.href'), 1, MaxStrLen(SBCTrack."Added by Url"));
                SBCTrack."Album Id" := CopyStr(GetValueAsText(JToken, BaseParamString + 'album.id'), 1, MaxStrLen(SBCTrack."Album Id"));
                SBCTrack."Album Name" := CopyStr(GetValueAsText(JToken, BaseParamString + 'album.name'), 1, MaxStrLen(SBCTrack."Album Name"));
                SBCTrack."Track uri" := CopyStr(GetValueAsText(JToken, BaseParamString + 'uri'), 1, MaxStrLen(SBCTrack."Track uri"));
                SBCTrack."Album Release Date" := DT2Date(EvaluateUTCDateTime(GetValueAsText(JToken, BaseParamString + 'album.release_date')));
                SBCTrack."Track External URL" := CopyStr(GetValueAsText(JToken, BaseParamString + 'external_urls.spotify'), 1, MaxStrLen(SBCTrack."Track External URL"));
                Evaluate(SBCTrack."Album Total Tracks", GetValueAsText(JToken, BaseParamString + 'album.total_tracks'));

                JObject2 := JToken.AsObject();
                if JObject2.SelectToken(BaseParamString + 'album.images', Jtoken2) then begin
                    JArray2 := JToken2.AsArray();
                    foreach JToken2 in JArray2 do
                        if SBCTrack."Album Image Href" = '' then
                            SBCTrack."Album Image Href" := CopyStr(GetValueAsText(JToken2, 'url'), 1, MaxStrLen(SBCTrack."Album Image Href"));
                end;

                JObject2 := JToken.AsObject();
                if JObject2.SelectToken(BaseParamString + 'artists', Jtoken2) then begin
                    JArray2 := JToken2.AsArray();
                    foreach JToken2 in JArray2 do begin
                        SBCTrack."Artist Id" := CopyStr(GetValueAsText(JToken2, 'id'), 1, MaxStrLen(SBCTrack."Artist Id"));
                        SBCTrack."Artist href" := CopyStr(GetValueAsText(JToken2, 'href'), 1, MaxStrLen(SBCTrack."Artist href"));
                        SBCTrack."Artist Name" := CopyStr(GetValueAsText(JToken2, 'name'), 1, MaxStrLen(SBCTrack."Artist Name"));
                    end;
                end;

                SBCTrack.Insert(true);
                SBCTrack.Mark(true);

            end else
                SBCTrack.Mark(true);
        end;
        SBCTrack.MarkedOnly(true);
    end;

    procedure DeleteTracksFromPlaylist(var SBCTrack: Record "SBC Track"; PlaylistId: Text)
    var
        SBCSpotifyAPIMgt: Codeunit "SBC Spotify API Mgt";
        contentToSend: Text;
        JObject: JsonObject;
        JObject2: JsonObject;
        JArray: JsonArray;
        i: Integer;
    begin
        if SBCTrack.FindSet() then
            repeat
                i += 1;
                Clear(JObject);
                JObject.Add('uri', SBCTrack."Track uri");
                JArray.Add(JObject);
                //50 tracks per request deletion limit
                if (i mod 50 = 0) or (i = SBCTrack.Count()) then begin
                    JObject2.Add('tracks', JArray);
                    JObject2.WriteTo(contentToSend);
                    SBCSpotifyAPIMgt.SendRequest(contentToSend, 'DELETE', StrSubstNo('playlists/%1/tracks', PlaylistId));
                    Clear(JObject2);
                    Clear(JArray);
                end;
            until SBCTrack.Next() = 0;
        SBCTrack.DeleteAll(true);
    end;

    procedure AddTracksToPlaylist(var SBCTrack: Record "SBC Track"; PlaylistId: Text)
    var
        SBCSpotifyAPIMgt: Codeunit "SBC Spotify API Mgt";
        contentToSend: Text;
        JValue: JsonValue;
        JObject2: JsonObject;
        JArray: JsonArray;
        i: Integer;
    begin
        if SBCTrack.FindSet() then
            repeat
                i += 1;
                Clear(JValue);
                JValue.SetValue(SBCTrack."Track uri");
                JArray.Add(JValue);
                //100 tracks per request deletion limit
                if (i mod 100 = 0) or (i = SBCTrack.Count()) then begin
                    JObject2.Add('uris', JArray);
                    JObject2.WriteTo(contentToSend);
                    SBCSpotifyAPIMgt.SendRequest(contentToSend, 'POST', StrSubstNo('playlists/%1/tracks', PlaylistId));
                    Clear(JObject2);
                    Clear(JArray);
                end;
            until SBCTrack.Next() = 0;
    end;

    procedure ModifyPlaylist(EntityName: Text; EntityValue: Text; PlaylistId: Text)
    var
        SBCSpotifyAPIMgt: Codeunit "SBC Spotify API Mgt";
        contentToSend: Text;
        JObject: JsonObject;
    begin
        JObject.Add(EntityName, EntityValue);
        JObject.WriteTo(contentToSend);
        SBCSpotifyAPIMgt.SendRequest(contentToSend, 'PUT', StrSubstNo('playlists/%1', PlaylistId));
    end;

    procedure GetSpotifyUserId(): Text
    var
        SBCSpotifyAPIMgt: Codeunit "SBC Spotify API Mgt";
        JToken: JsonToken;
        NextPageID: Integer;
        AddUrl: Text;
        Data: Text;
        HttpStatusCode: Integer;
    begin
        SBCSpotifyAPIMgt.SetSkipNextPage(true);
        AddUrl := 'me';
        if not SBCSpotifyAPIMgt.GetRequest(AddUrl, Data, HttpStatusCode, 'empty', NextPageID) then
            exit;
        if Data = '' then
            exit;

        JToken.ReadFrom(Data);
        exit(GetValueAsText(JToken, 'id'));
    end;

    procedure CreatePlaylist(EntityName: Text; EntityValue: Text) PlaylistId: Text
    var
        SBCSpotifyAPIMgt: Codeunit "SBC Spotify API Mgt";
        contentToSend: Text;
        JObject: JsonObject;
        JToken: JsonToken;
    begin
        JObject.Add(EntityName, EntityValue);
        JObject.WriteTo(contentToSend);
        JToken.ReadFrom(SBCSpotifyAPIMgt.SendRequest(contentToSend, 'POST', StrSubstNo('users/%1/playlists', GetSpotifyUserId())));
        exit(GetValueAsText(JToken, 'id'));
    end;

}
