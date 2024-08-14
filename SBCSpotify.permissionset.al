permissionset 60000 "SBC Spotify"
{
    Assignable = true;
    Permissions = tabledata "SBC Spotify General Setup" = RIMD,
        tabledata "SBC Spotify Playlist" = RIMD,
        tabledata "SBC Track" = RIMD,
        table "SBC Spotify General Setup" = X,
        table "SBC Spotify Playlist" = X,
        table "SBC Track" = X,
        codeunit "SBC JSON Mgt" = X,
        codeunit "SBC Spotify API Mgt" = X,
        page "SBC Search Tracks" = X,
        page "SBC Spotify General Setup" = X,
        page "SBC Spotify Playlists" = X,
        page "SBC Tracks" = X;
}